
---

## 🆕 UPDATES — 2026-09-27 (FULL DAY SESSION)

### ✅ Internationalization — Complete Rewrite

**Why:** FlutterFlow had accumulated ~4,500 keys, most tied to dead pages. Rebuilt cleanly.

**What was done:**
1. **Backup + fresh `internationalization.dart`** — wiped all old keys, rebuilt from scratch with only live strings.
2. **Translated 25+ pages** (English + Swahili):
   - Welcome, Sign Up, Log In
   - Home, Search, Wishlist, Messages List, Profile
   - All Categories, Specific Categories, Trending Products, New Products, Boosted Products
   - Product Details, Chat Detail, Order Details
   - Rate Page, Reviews Page, Profile Edit
   - Add New Address, About the App
   - Support Chat, Admin Dashboard
   - Admin Broadcast, Admin Category Editor
   - Admin Orders, Admin Products, Admin Reports, Admin Sellers, Admin Users
3. **Translated live components:**
   - `language_modal_widget.dart`
   - `logout_widget.dart`
   - `buy_now_sheet_widget.dart`
   - `ordersuccessfulpopul_widget.dart`
   - `report_sheet_widget.dart`
   - `write_review_sheet.dart`
   - `location_modal_widget.dart`
   - `admin_category_editor.dart`

### ✅ Dead Code Cleanup

**Deleted 12 dead components (24 files):**
- `sortby_size`, `sortby_price`, `sortby_gender`, `sortby_colour`
- `search_bar`, `share_model`, `pymentgateways`
- `ordersuccessfulpopul` (kept — was needed)
- `uploadphoto`, `recent_searchcard`
- `hometop_nav`, `preoduct_bottom_nav`

**Rule used:** Only delete if referenced **only inside its own folder**.

### ✅ Bugs Fixed

1. **Profile language picker broken** — was a fake placeholder that closed without changing language. Now uses the same `LanguageModalWidget` as login (with `AppLanguage` notifier).
2. **`select_ad_widget.dart` precedence bug** — `overrideLabel ?? getText(...).isEmpty ? ... : ...` didn't parse. Fixed with parens.
3. **3 files with `\$` interpolation bug** (from a heredoc escaping error) — fixed back to `$varName`.

### ✅ Responsive Product Grids

All product grids now use `Responsive.productCols(context)`:
- **Phone:** 2 columns
- **Tablet:** 3 columns
- **Desktop:** 4 columns

Files updated:
- `lib/home/home_widget.dart` (already had it)
- `lib/trending_product/trending_product_widget.dart`
- `lib/new_products/new_products_widget.dart`
- `lib/specific_categories/specific_categories_widget.dart`
- `lib/seller_dashbord/seller_dashbord_widget.dart`
- `lib/wishlist/wishlist_widget.dart`
- `lib/boosted_products/boosted_products_widget.dart`

Also removed `const` from `SliverGridDelegateWithFixedCrossAxisCount(...)` where `Responsive.productCols(context)` is now called.

Aspect ratio tightened from `0.62`/`0.68` → `0.72` for smaller cards on wider screens.

### ✅ Login Page Enhancements

- Google Sign-In button **hidden** (was failing with `deleted_client` — will re-enable later)
- "Forgot password?" link **hidden** (not yet functional on live)
- "Or continue with" divider **removed**
- Cleaned up unused imports + orphaned widgets

### ✅ About the App Page

Full i18n + `DateTime.now().year` now safely in string interpolation.

### ✅ Add New Address Page

Translated to EN + SW. All the address-form hints (Wilaya, Mtaa, Namba ya nyumba, etc.) now go through `getText(...)`.

### ✅ Admin Category Editor

Translated + shown in same bottom sheet style. Category edits apply live via `category_config` collection.

### ✅ Admin Broadcast

Broadcast sends Firestore `notifications` docs to first 500 users per batch. All UI translated including template previews.

### ✅ Home Page — Banner + Location

- Banner slider shows **4 slides peeking** (`viewportFraction: 0.27`), full-bleed.
- Header clearance bumped from 150 → 178px so banner doesn't overlap the search pill.
- Notification bell shows **real unread count** (red badge) or hidden if 0.
- Location modal (`location_modal_widget.dart`) fully translated — had only 8 strings that were the last untranslated piece of the home header.

### 🆕 Files Created This Session

- `lib/services/app_language.dart` — global `ValueNotifier<String>` for live locale changes
- `lib/components/write_review_sheet.dart` (rewritten earlier, still live)
- `lib/seller_reviews/seller_reviews_widget.dart` — seller reply page
- `lib/seller_reviews/seller_reviews_model.dart`

### 📁 Key Files Modified

- `lib/flutter_flow/internationalization.dart` — rewritten from scratch
- `lib/index.dart` — removed 7 dead exports
- `lib/flutter_flow/nav/nav.dart` — removed 7 dead routes
- All `_widget.dart` files listed above — added i18n + Responsive

### 🚨 Pending Before Push

1. Run `flutter analyze` — confirm **0 errors**
2. Screenshot 1-2 pages at desktop width to confirm grid looks right
3. Test on phone (Chrome) — 2 cols
4. Test on tablet width — 3 cols
5. Test on desktop — 4 cols
6. Then push

### 📊 Metrics

| Item | Before | After |
|---|---|---|
| Translation keys | ~4,500 (mostly dead) | ~500 (all live) |
| Translated pages | 5 | 25+ |
| Dead components | 31 in `lib/components/` | 19 |
| Product grids fixed for tablet/desktop | 1 (home) | 7 |
| Total analyze errors | varies | **0 target** |

### 🔐 Security (from earlier — still true)

- Firebase service account key rotated ✅
- Leaked key deleted ✅
- Cloudflare Worker secret rotated + deployed ✅
