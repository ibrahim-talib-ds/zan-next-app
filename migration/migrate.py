#!/usr/bin/env python3
"""
ZanNext: Firestore -> PostgreSQL migration.
READ-ONLY on Firestore. Writes to Postgres only in --commit mode.
Usage:
    python migrate.py            # dry run (no Postgres writes)
    python migrate.py --commit   # actually insert
"""
import sys, os
from datetime import datetime, timezone
import firebase_admin
from firebase_admin import credentials, firestore
import psycopg

SA = "/home/ibrahim/Projects/ZanNext.app/firebase-keys/service-account.json"
PG = "host=localhost port=5432 dbname=zannext user=ibrahim password=1542004ibrahim"
DRY = "--commit" not in sys.argv

cred = credentials.Certificate(SA)
firebase_admin.initialize_app(cred)
db = firestore.client()
conn = psycopg.connect(PG, autocommit=False)
cur = conn.cursor()

log_lines = []
skipped = []

def log(msg):
    print(msg)
    log_lines.append(msg)

def skip(table, doc_id, reason):
    skipped.append((table, doc_id, reason))

def ts(v):
    if v is None: return None
    if isinstance(v, datetime): return v
    return None

def ref_id(v):
    if v is None: return None
    if hasattr(v, "id"): return v.id
    if isinstance(v, str): return v
    return None

def s(v):
    if v is None: return None
    return str(v)

def arr(v):
    if v is None: return None
    if isinstance(v, list): return [str(x) for x in v]
    return None

def ins(table, cols, vals, conflict_col="id"):
    if DRY:
        return
    ph = ",".join(["%s"] * len(vals))
    sql = f"INSERT INTO {table} ({','.join(cols)}) VALUES ({ph}) ON CONFLICT ({conflict_col}) DO NOTHING"
    try:
        cur.execute(sql, vals)
    except Exception as e:
        conn.rollback()
        raise

# ---- FK caches (populated from Firestore, pre-flight) ----
VALID_USER_IDS = set()
VALID_PRODUCT_IDS = set()
PLACEHOLDER_USERS = set()
PLACEHOLDER_PRODUCTS = set()

def load_fk_caches():
    print("Loading FK caches from Firestore...")
    for u in db.collection("users").stream():
        VALID_USER_IDS.add(u.id)
    for p in db.collection("Inventory").stream():
        VALID_PRODUCT_IDS.add(p.id)
    print(f"  users:    {len(VALID_USER_IDS)}")
    print(f"  products: {len(VALID_PRODUCT_IDS)}")

def make_user_placeholder(uid):
    if DRY: return
    cur.execute(
        """INSERT INTO users (id, email, display_name, is_admin, is_online, created_at)
           VALUES (%s, %s, %s, FALSE, FALSE, now())
           ON CONFLICT (id) DO NOTHING""",
        (uid, f"deleted_{uid}@placeholder.local", "[deleted user]"))

def fk_user(uid, table, doc_id, field, required=True):
    if not uid:
        if required:
            skip(table, doc_id, f"no {field}"); return False
        return True
    if uid not in VALID_USER_IDS:
        if uid not in PLACEHOLDER_USERS:
            log(f"  + placeholder user {uid} (ref'd by {table}/{doc_id})")
            PLACEHOLDER_USERS.add(uid)
            make_user_placeholder(uid)
        return True
    return True

def make_product_placeholder(pid):
    if DRY: return
    cur.execute("SELECT id FROM users WHERE is_admin = TRUE LIMIT 1")
    row = cur.fetchone()
    seller = row[0] if row else "SYSTEM"
    cur.execute(
        """INSERT INTO products (id, seller_id, name, price, status, created_at)
           VALUES (%s, %s, %s, 0, 'deleted', now())
           ON CONFLICT (id) DO NOTHING""",
        (pid, seller, "[deleted product]"))

def fk_product(pid, table, doc_id, field, required=True):
    if not pid:
        if required:
            skip(table, doc_id, f"no {field}"); return False
        return True
    if pid not in VALID_PRODUCT_IDS:
        if pid not in PLACEHOLDER_PRODUCTS:
            log(f"  + placeholder product {pid} (ref'd by {table}/{doc_id})")
            PLACEHOLDER_PRODUCTS.add(pid)
            make_product_placeholder(pid)
        return True
    return True

# ---- Run the pre-flight cache load now that helpers exist ----
load_fk_caches()


# ============================================================
# 1. users
# ============================================================
log("=== users -> users ===")
for d in db.collection("users").stream():
    f = d.to_dict() or {}
    email = s(f.get("email"))
    if not email:
        skip("users", d.id, "no email"); continue
    ins("users",
        ["id","email","display_name","phone_number","photo_url","gender",
         "birthday","city","district","is_admin","is_online","last_active",
         "fcm_token","liked_products","created_at"],
        [d.id, email, s(f.get("display_name")), s(f.get("phone_number")),
         s(f.get("photo_url")), s(f.get("gender")), ts(f.get("Birthday")),
         s(f.get("city")), s(f.get("district")), bool(f.get("isAdmin", False)),
         bool(f.get("is_online", False)), ts(f.get("last_active")),
         s(f.get("fcm_token")), arr(f.get("Liked_products")),
         ts(f.get("created_time")) or datetime.now(timezone.utc)])
log(f"  inserted: {len(db.collection('users').get())}")

# ============================================================
# 2. category_config
# ============================================================
log("=== category_config -> category_config ===")
for d in db.collection("category_config").stream():
    f = d.to_dict() or {}
    ins("category_config",
        ["category_key","label","image_url","route_name","updated_at"],
        [d.id, s(f.get("label")), s(f.get("image_url")),
         s(f.get("route_name")), ts(f.get("updated_at"))],
        conflict_col="category_key")
log("  done")

# ============================================================
# 3. Inventory -> products
# ============================================================
log("=== Inventory -> products ===")
for d in db.collection("Inventory").stream():
    f = d.to_dict() or {}
    seller_id = ref_id(f.get("sellers_ref"))
    name = s(f.get("inventory_name"))
    price = f.get("inventory_price")
    if not fk_user(seller_id, "products", d.id, "sellers_ref"): continue
    if not name:
        skip("products", d.id, "no inventory_name"); continue
    if price is None:
        skip("products", d.id, "no inventory_price"); continue
    ins("products",
        ["id","seller_id","seller_name","seller_number","seller_whatsapp",
         "name","description","price","category","main_category","brand",
         "condition","gender","materials","available_colors","available_alphasize",
         "stock","shipping_days","images","location","rating","reviews_count",
         "view_count","all_products","boosted","new_in","top_selling",
         "is_online","status","created_at","last_active"],
        [d.id, seller_id, s(f.get("seller_name")), s(f.get("seller_number")),
         s(f.get("seller_whatsap")), name, s(f.get("inventory_description")),
         price, s(f.get("categories")), s(f.get("main_category")), s(f.get("brand")),
         s(f.get("condition")), s(f.get("gender")), arr(f.get("materials")),
         arr(f.get("available_colors")), arr(f.get("available_alphasize")),
         int(f.get("stock") or 0), s(f.get("shipping_days")),
         arr(f.get("inventory_images")), s(f.get("location")),
         float(f.get("rating") or 0), int(f.get("reviews") or 0),
         int(f.get("view_count") or 0), bool(f.get("all_products", True)),
         bool(f.get("boosted", False)), bool(f.get("new_in", False)),
         bool(f.get("top_selling", False)), bool(f.get("is_online", True)),
         s(f.get("status")) or "pending",
         ts(f.get("created_at")) or datetime.now(timezone.utc),
         ts(f.get("last_active"))])
log("  done")

# ============================================================
# 4. address -> addresses
# ============================================================
log("=== address -> addresses ===")
for d in db.collection("address").stream():
    f = d.to_dict() or {}
    uid = ref_id(f.get("user"))
    if not fk_user(uid, "addresses", d.id, "user"): continue
    ins("addresses",
        ["id","user_id","label","city","district","street_address","house_no",
         "landmark","phone","notes","created_at"],
        [d.id, uid, s(f.get("label")), s(f.get("city")), s(f.get("district")),
         s(f.get("street_address")), s(f.get("house_no")), s(f.get("landmark")),
         s(f.get("phone")), s(f.get("notes")),
         ts(f.get("created_time")) or datetime.now(timezone.utc)])
log("  done")

# ============================================================
# 5. orders -> orders
# ============================================================
log("=== orders -> orders ===")
for d in db.collection("orders").stream():
    f = d.to_dict() or {}
    buyer_id = ref_id(f.get("buyer"))
    seller_id = ref_id(f.get("seller"))
    if not fk_user(buyer_id, "orders", d.id, "buyer"): continue
    if not fk_user(seller_id, "orders", d.id, "seller"): continue
    if not fk_product(ref_id(f.get("product_ref")), "orders", d.id, "product_ref", required=False): continue
    ins("orders",
        ["id","buyer_id","seller_id","product_id","buyer_name","buyer_phone",
         "buyer_notes","seller_name","product_name","item_images","price",
         "address","status","status_history","created_at"],
        [d.id, buyer_id, seller_id, ref_id(f.get("product_ref")),
         s(f.get("buyer_name")), s(f.get("buyer_phone")), s(f.get("buyer_notes")),
         s(f.get("seller_name")), s(f.get("product_name")),
         arr(f.get("Item_images")), f.get("price"), s(f.get("address")),
         s(f.get("status")) or "pending",
         psycopg.types.json.Jsonb(f.get("status_history") or []),
         ts(f.get("date")) or datetime.now(timezone.utc)])
log("  done")

# ============================================================
# 6. Chats -> chats
# ============================================================
log("=== Chats -> chats ===")
chat_ids = []
for d in db.collection("Chats").stream():
    f = d.to_dict() or {}
    buyer_id = ref_id(f.get("buyer_ref"))
    seller_id = ref_id(f.get("seller_ref"))
    if not fk_user(buyer_id, "chats", d.id, "buyer_ref"): continue
    if not fk_user(seller_id, "chats", d.id, "seller_ref"): continue
    if not fk_product(ref_id(f.get("product_ref")), "chats", d.id, "product_ref", required=False): continue
    ins("chats",
        ["id","buyer_id","seller_id","product_id","product_name","price",
         "item_images","last_message","last_message_time","created_at"],
        [d.id, buyer_id, seller_id, ref_id(f.get("product_ref")),
         s(f.get("product_name")), f.get("Price"), arr(f.get("items_images")),
         s(f.get("last_message")), ts(f.get("last_message_time")),
         datetime.now(timezone.utc)])
    chat_ids.append(d.id)
log(f"  done ({len(chat_ids)} chats)")

# ============================================================
# 7. Chats/{id}/chat_messages  AND  messages (both names checked)
# ============================================================
log("=== Chats/{id}/chat_messages -> chat_messages ===")
for ch_id in chat_ids:
    for subname in ("chat_messages", "messages"):
        for m in db.collection("Chats").document(ch_id).collection(subname).stream():
            mf = m.to_dict() or {}
            sender_id = ref_id(mf.get("sender_ref") or mf.get("sender"))
            if not fk_user(sender_id, "chat_messages", m.id, "sender_ref"): continue
            txt = s(mf.get("text") or mf.get("message"))
            if not txt:
                skip("chat_messages", m.id, "no text"); continue
            ins("chat_messages",
                ["id","chat_id","sender_id","sender_name","text","image_url","created_at"],
                [m.id, ch_id, sender_id, s(mf.get("sender_name")), txt,
                 s(mf.get("image_url") or mf.get("image")),
                 ts(mf.get("created_at") or mf.get("timestamp")) or datetime.now(timezone.utc)])
log("  done")

# ============================================================
# 8. reviews -> reviews
# ============================================================
log("=== reviews -> reviews ===")
for d in db.collection("reviews").stream():
    f = d.to_dict() or {}
    pid = ref_id(f.get("product_ref"))
    rid = ref_id(f.get("reviewer_ref"))
    if not fk_product(pid, "reviews", d.id, "product_ref"): continue
    if not fk_user(rid, "reviews", d.id, "reviewer_ref"): continue
    if not fk_user(ref_id(f.get("seller")), "reviews", d.id, "seller", required=False): continue
    rating = f.get("rating")
    if rating is None or not (1 <= int(rating) <= 5):
        skip("reviews", d.id, f"rating out of range: {rating}"); continue
    ins("reviews",
        ["id","product_id","seller_id","reviewer_id","reviewers_name",
         "reviewers_image","rating","message","created_at"],
        [d.id, pid, ref_id(f.get("seller")), rid, s(f.get("reviewers_name")),
         s(f.get("reviewers_image")), int(rating),
         s(f.get("reviews_message")),
         ts(f.get("date")) or datetime.now(timezone.utc)])
log("  done")

# ============================================================
# 9. Wishlist -> wishlist
# ============================================================
log("=== Wishlist -> wishlist ===")
seen_wish = set()
for d in db.collection("Wishlist").stream():
    f = d.to_dict() or {}
    uid = ref_id(f.get("user"))
    pid = ref_id(f.get("product_ref"))
    if not fk_user(uid, "wishlist", d.id, "user"): continue
    if not fk_product(pid, "wishlist", d.id, "product_ref"): continue
    key = (uid, pid)
    if key in seen_wish:
        skip("wishlist", d.id, f"duplicate user/product ({uid}, {pid})"); continue
    seen_wish.add(key)
    ins("wishlist", ["id","user_id","product_id","created_at"],
        [d.id, uid, pid, datetime.now(timezone.utc)])
log("  done")

# ============================================================
# 10. notifications -> notifications
# ============================================================
log("=== notifications -> notifications ===")
for d in db.collection("notifications").stream():
    f = d.to_dict() or {}
    uid = ref_id(f.get("user_ref"))
    title = s(f.get("title"))
    body = s(f.get("notification_text"))
    if not fk_user(uid, "notifications", d.id, "user_ref"): continue
    if not title or not body:
        skip("notifications", d.id, "missing title/body"); continue
    ins("notifications",
        ["id","user_id","title","body","image_url","product_id","type","is_read","created_at"],
        [d.id, uid, title, body, s(f.get("avater")), s(f.get("productId")),
         None, bool(f.get("is_read", False)),
         ts(f.get("date") or f.get("created_time")) or datetime.now(timezone.utc)])
log("  done")

# ============================================================
# 11. support_chats -> support_chats
# ============================================================
log("=== support_chats -> support_chats ===")
sp_ids = []
for d in db.collection("support_chats").stream():
    f = d.to_dict() or {}
    uid = ref_id(f.get("user_ref"))
    if not fk_user(uid, "support_chats", d.id, "user_ref"): continue
    ins("support_chats",
        ["id","user_id","is_active","last_message","last_chat_time","created_at"],
        [d.id, uid, bool(f.get("is_active", True)), s(f.get("last_message")),
         ts(f.get("last_chat_time")), datetime.now(timezone.utc)])
    sp_ids.append(d.id)
log(f"  done ({len(sp_ids)} threads)")

# ============================================================
# 12. support_messages: check BOTH subcollection names
# ============================================================
log("=== support_messages (sub: 'support_messages' + 'messages') ===")
for sp_id in sp_ids:
    for subname in ("support_messages", "messages"):
        for m in db.collection("support_chats").document(sp_id).collection(subname).stream():
            mf = m.to_dict() or {}
            txt = s(mf.get("text") or mf.get("message"))
            if not txt:
                skip("support_messages", m.id, "no text"); continue
            st = s(mf.get("sender_type")) or ("user" if mf.get("sender_ref") else "admin")
            sid = ref_id(mf.get("sender_ref"))
            if sid and sid not in VALID_USER_IDS:
                sid = None  # admin or unknown — keep row, null the sender
            ins("support_messages",
                ["id","thread_id","sender_type","sender_id","sender_name","text","created_at"],
                [m.id, sp_id, st, sid,
                 s(mf.get("sender_name")), txt,
                 ts(mf.get("created_at") or mf.get("timestamp")) or datetime.now(timezone.utc)])
log("  done")

# ============================================================
# 13. search_history -> search_history
# ============================================================
log("=== search_history -> search_history ===")
for d in db.collection("search_history").stream():
    f = d.to_dict() or {}
    uid = ref_id(f.get("user_ref"))
    term = s(f.get("search_term"))
    if not fk_user(uid, "search_history", d.id, "user_ref"): continue
    if not term:
        skip("search_history", d.id, "no term"); continue
    ins("search_history", ["id","user_id","search_term","created_at"],
        [d.id, uid, term, ts(f.get("timestamp")) or datetime.now(timezone.utc)])
log("  done")

# ============================================================
# 14. last_seen + Inventory/{id}/viewers -> product_views
# ============================================================
log("=== last_seen + Inventory/{id}/viewers -> product_views ===")
seen_keys = set()
for d in db.collection("last_seen").stream():
    f = d.to_dict() or {}
    pid = ref_id(f.get("product_ref"))
    uid = ref_id(f.get("user_ref"))
    if not fk_product(pid, "product_views", d.id, "product_ref"): continue
    if not fk_user(uid, "product_views", d.id, "user_ref"): continue
    key = (pid, uid)
    if key in seen_keys:
        skip("product_views", d.id, "duplicate product/user"); continue
    seen_keys.add(key)
    ins("product_views", ["id","product_id","user_id","viewed_at"],
        [d.id, pid, uid, ts(f.get("viewed_at")) or datetime.now(timezone.utc)])

for prod in db.collection("Inventory").stream():
    for v in prod.reference.collection("viewers").stream():
        vf = v.to_dict() or {}
        uid = ref_id(vf.get("user_ref") or vf.get("user"))
        if not fk_user(uid, "product_views", v.id, "viewer.user_ref"): continue
        if not fk_product(prod.id, "product_views", v.id, "product_ref"): continue
        key = (prod.id, uid)
        if key in seen_keys:
            continue
        seen_keys.add(key)
        ins("product_views", ["id","product_id","user_id","viewed_at"],
            [v.id, prod.id, uid,
             ts(vf.get("viewed_at")) or datetime.now(timezone.utc)])
log("  done")

# ============================================================
# Finalize
# ============================================================
if not DRY:
    conn.commit()
    log("\n=== COMMITTED ===")
else:
    conn.rollback()
    log("\n=== DRY RUN -- rolled back, nothing written ===")

log("\n=== SKIPPED ROWS ===")
if not skipped:
    log("  (none)")
else:
    for table, doc_id, reason in skipped:
        log(f"  {table:20s} {doc_id:30s} {reason}")

# Row count summary
log("\n=== CURRENT ROW COUNTS IN POSTGRES ===")
tables = ["users","products","orders","chats","chat_messages","reviews",
          "addresses","wishlist","notifications","support_chats",
          "support_messages","search_history","product_views","category_config"]
for t in tables:
    cur.execute(f"SELECT count(*) FROM {t}")
    log(f"  {t:20s} {cur.fetchone()[0]}")

with open(os.path.expanduser("~/Projects/ZanNext.app/zan_next/migration/report.txt"), "w") as fh:
    fh.write("\n".join(log_lines))
print("\nReport written to migration/report.txt")
