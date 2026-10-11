-- ZanNext schema (Firestore -> PostgreSQL migration)
-- Run: psql -U ibrahim -h localhost -d zannext -f schema.sql

BEGIN;

-- 1. users (from Firestore: users lowercase)
CREATE TABLE users (
  id              TEXT PRIMARY KEY,
  email           TEXT UNIQUE NOT NULL,
  display_name    TEXT,
  phone_number    TEXT,
  photo_url       TEXT,
  gender          TEXT,
  birthday        TIMESTAMPTZ,
  city            TEXT,
  district        TEXT,
  is_admin        BOOLEAN DEFAULT FALSE,
  is_online       BOOLEAN DEFAULT FALSE,
  last_active     TIMESTAMPTZ,
  fcm_token       TEXT,
  liked_products  TEXT[] DEFAULT '{}',
  created_at      TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone_number);

-- 2. category_config (from Firestore: category_config)
CREATE TABLE category_config (
  category_key  TEXT PRIMARY KEY,
  label         TEXT,
  image_url     TEXT,
  route_name    TEXT,
  updated_at    TIMESTAMPTZ DEFAULT now()
);

-- 3. products (from Firestore: Inventory)
CREATE TABLE products (
  id                  TEXT PRIMARY KEY,
  seller_id           TEXT NOT NULL REFERENCES users(id),
  seller_name         TEXT,
  seller_number       TEXT,
  seller_whatsapp     TEXT,
  name                TEXT NOT NULL,
  description         TEXT,
  price               NUMERIC(12,2) NOT NULL,
  category            TEXT,
  main_category       TEXT,
  brand               TEXT,
  condition           TEXT,
  gender              TEXT,
  materials           TEXT[],
  available_colors    TEXT[],
  available_alphasize TEXT[],
  stock               INTEGER DEFAULT 0,
  shipping_days       TEXT,
  images              TEXT[],
  location            TEXT,
  rating              NUMERIC(2,1) DEFAULT 0,
  reviews_count       INTEGER DEFAULT 0,
  view_count          INTEGER DEFAULT 0,
  all_products        BOOLEAN DEFAULT TRUE,
  boosted             BOOLEAN DEFAULT FALSE,
  new_in              BOOLEAN DEFAULT FALSE,
  top_selling         BOOLEAN DEFAULT FALSE,
  is_online           BOOLEAN DEFAULT TRUE,
  status              TEXT DEFAULT 'pending',
  created_at          TIMESTAMPTZ DEFAULT now(),
  last_active         TIMESTAMPTZ
);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_seller ON products(seller_id);
CREATE INDEX idx_products_created ON products(created_at DESC);
CREATE INDEX idx_products_flags ON products(boosted, new_in, top_selling, all_products);
CREATE INDEX idx_products_rating ON products(rating DESC);

-- 4. addresses (from Firestore: address)
CREATE TABLE addresses (
  id             TEXT PRIMARY KEY,
  user_id        TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  label          TEXT,
  city           TEXT,
  district       TEXT,
  street_address TEXT,
  house_no       TEXT,
  landmark       TEXT,
  phone          TEXT,
  notes          TEXT,
  created_at     TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_addresses_user ON addresses(user_id);

-- 5. orders (from Firestore: orders)
CREATE TABLE orders (
  id                TEXT PRIMARY KEY,
  buyer_id          TEXT NOT NULL REFERENCES users(id),
  seller_id         TEXT NOT NULL REFERENCES users(id),
  product_id        TEXT REFERENCES products(id),
  buyer_name        TEXT,
  buyer_phone       TEXT,
  buyer_notes       TEXT,
  seller_name       TEXT,
  product_name      TEXT,
  item_images       TEXT[],
  price             NUMERIC(12,2),
  address           TEXT,
  status            TEXT DEFAULT 'pending',
  status_history    JSONB DEFAULT '[]'::jsonb,
  hidden_for_buyer  BOOLEAN DEFAULT FALSE,
  hidden_for_seller BOOLEAN DEFAULT FALSE,
  created_at        TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_orders_buyer  ON orders(buyer_id, created_at DESC);
CREATE INDEX idx_orders_seller ON orders(seller_id, created_at DESC);
CREATE INDEX idx_orders_status ON orders(status);

-- 6. chats (from Firestore: Chats)
CREATE TABLE chats (
  id                    TEXT PRIMARY KEY,
  buyer_id              TEXT NOT NULL REFERENCES users(id),
  seller_id             TEXT NOT NULL REFERENCES users(id),
  product_id            TEXT REFERENCES products(id),
  product_name          TEXT,
  price                 NUMERIC(12,2),
  item_images           TEXT[],
  last_message          TEXT,
  last_message_time     TIMESTAMPTZ,
  last_message_seen_by  TEXT[],
  created_at            TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_chats_buyer  ON chats(buyer_id,  last_message_time DESC);
CREATE INDEX idx_chats_seller ON chats(seller_id, last_message_time DESC);

-- 7. chat_messages (from Chats/{id}/messages subcollection)
CREATE TABLE chat_messages (
  id           TEXT PRIMARY KEY,
  chat_id      TEXT NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  sender_id    TEXT NOT NULL REFERENCES users(id),
  sender_name  TEXT,
  text         TEXT NOT NULL,
  image_url    TEXT,
  created_at   TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_chat_messages_chat ON chat_messages(chat_id, created_at DESC);

-- 8. reviews (from Firestore: reviews)
CREATE TABLE reviews (
  id               TEXT PRIMARY KEY,
  product_id       TEXT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  seller_id        TEXT REFERENCES users(id),
  reviewer_id      TEXT NOT NULL REFERENCES users(id),
  reviewers_name   TEXT,
  reviewers_image  TEXT,
  rating           INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  message          TEXT,
  created_at       TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_reviews_product ON reviews(product_id, created_at DESC);
CREATE INDEX idx_reviews_seller  ON reviews(seller_id);

-- 9. wishlist (from Firestore: Wishlist)
CREATE TABLE wishlist (
  id          TEXT PRIMARY KEY,
  user_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id  TEXT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, product_id)
);
CREATE INDEX idx_wishlist_user ON wishlist(user_id);

-- 10. notifications (from Firestore: notifications)
CREATE TABLE notifications (
  id          TEXT PRIMARY KEY,
  user_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  body        TEXT NOT NULL,
  image_url   TEXT,
  product_id  TEXT,
  type        TEXT,
  is_read     BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);

-- 11. support_chats (from Firestore: support_chats)
CREATE TABLE support_chats (
  id                TEXT PRIMARY KEY,
  user_id           TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  is_active         BOOLEAN DEFAULT TRUE,
  last_message      TEXT,
  last_chat_time    TIMESTAMPTZ,
  unread_for_admin  INTEGER DEFAULT 0,
  unread_for_user   INTEGER DEFAULT 0,
  created_at        TIMESTAMPTZ DEFAULT now()
);

-- 12. support_messages (from support_chats/{id}/messages subcollection)
CREATE TABLE support_messages (
  id           TEXT PRIMARY KEY,
  thread_id    TEXT NOT NULL REFERENCES support_chats(id) ON DELETE CASCADE,
  sender_type  TEXT NOT NULL,
  sender_id    TEXT REFERENCES users(id),
  sender_name  TEXT,
  text         TEXT NOT NULL,
  created_at   TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_support_messages_thread ON support_messages(thread_id, created_at DESC);

-- 13. search_history (from Firestore: search_history)
CREATE TABLE search_history (
  id           TEXT PRIMARY KEY,
  user_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  search_term  TEXT NOT NULL,
  created_at   TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_search_history_user ON search_history(user_id, created_at DESC);

-- 14. product_views (from Firestore: last_seen + Inventory/{id}/viewers)
CREATE TABLE product_views (
  id          TEXT PRIMARY KEY,
  product_id  TEXT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  user_id     TEXT NOT NULL REFERENCES users(id)    ON DELETE CASCADE,
  viewed_at   TIMESTAMPTZ DEFAULT now(),
  UNIQUE(product_id, user_id)
);
CREATE INDEX idx_product_views_product ON product_views(product_id);

COMMIT;
