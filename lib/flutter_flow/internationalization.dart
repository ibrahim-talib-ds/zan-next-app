import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'sw'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  /// Look up a translation by key.
  /// Returns empty string if key not found — callers should fallback.
  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? swText = '',
  }) =>
      [enText, swText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar', 'az', 'ca', 'cs', 'da', 'de', 'dv', 'en', 'es', 'et',
    'fi', 'fr', 'gr', 'he', 'hi', 'hu', 'it', 'km', 'ku', 'mn',
    'ms', 'no', 'pt', 'ro', 'ru', 'rw', 'sv', 'th', 'uk', 'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

/// ═══════════════════════════════════════════════════════════
/// TRANSLATIONS
///
/// Structure:
///   'unique_key': { 'en': 'English text', 'sw': 'Swahili text' },
///
/// To add a new translation:
///   1. Generate a random 8-char key (e.g. 'a1b2c3d4')
///   2. Add an entry below
///   3. Use it in code:
///        FFLocalizations.of(context).getText('a1b2c3d4')
///
/// Keys are grouped by page/feature with comment headers.
/// ═══════════════════════════════════════════════════════════
final kTranslationsMap = <Map<String, Map<String, String>>>[
  // ═══════════════════════════════════════════════════════════
  // COMMON / GLOBAL
  // ═══════════════════════════════════════════════════════════
  {
    'common_home': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
    'common_cancel': {
      'en': 'Cancel',
      'sw': 'Ghairi',
    },
    'common_save': {
      'en': 'Save',
      'sw': 'Hifadhi',
    },
    'common_delete': {
      'en': 'Delete',
      'sw': 'Futa',
    },
    'common_edit': {
      'en': 'Edit',
      'sw': 'Badilisha',
    },
    'common_yes': {
      'en': 'Yes',
      'sw': 'Ndio',
    },
    'common_no': {
      'en': 'No',
      'sw': 'Hapana',
    },
    'common_ok': {
      'en': 'OK',
      'sw': 'Sawa',
    },
    'common_close': {
      'en': 'Close',
      'sw': 'Funga',
    },
    'common_back': {
      'en': 'Back',
      'sw': 'Rudi',
    },
    'common_next': {
      'en': 'Next',
      'sw': 'Endelea',
    },
    'common_done': {
      'en': 'Done',
      'sw': 'Imekamilika',
    },
    'common_search': {
      'en': 'Search',
      'sw': 'Tafuta',
    },
    'common_language': {
      'en': 'Language',
      'sw': 'Lugha',
    },
    'common_english': {
      'en': 'English',
      'sw': 'Kiingereza',
    },
    'common_swahili': {
      'en': 'Swahili',
      'sw': 'Kiswahili',
    },
    'common_logout': {
      'en': 'Logout',
      'sw': 'Ondoka',
    },
    'common_profile': {
      'en': 'Profile',
      'sw': 'Wasifu',
    },
    'common_settings': {
      'en': 'Settings',
      'sw': 'Mipangilio',
    },
    'common_error': {
      'en': 'Error',
      'sw': 'Kosa',
    },
    'common_success': {
      'en': 'Success',
      'sw': 'Imefanikiwa',
    },
    'common_loading': {
      'en': 'Loading...',
      'sw': 'Inapakia...',
    },
    'common_no_data': {
      'en': 'No data',
      'sw': 'Hakuna taarifa',
    },
    'common_retry': {
      'en': 'Retry',
      'sw': 'Jaribu tena',
    },
    'common_send': {
      'en': 'Send',
      'sw': 'Tuma',
    },
    'common_call': {
      'en': 'Call',
      'sw': 'Piga simu',
    },
    'common_chat': {
      'en': 'Chat',
      'sw': 'Ongea',
    },
    'common_share': {
      'en': 'Share',
      'sw': 'Shiriki',
    },
    'common_delete_confirm': {
      'en': 'Delete this item?',
      'sw': 'Futa kitu hiki?',
    },
    'common_delete_warning': {
      'en': 'This action cannot be undone.',
      'sw': 'Kitendo hiki hakiwezi kutenduliwa.',
    },
    'common_all': {
      'en': 'All',
      'sw': 'Zote',
    },
    'common_more': {
      'en': 'More',
      'sw': 'Zaidi',
    },
    'common_see_all': {
      'en': 'See all',
      'sw': 'Ona zote',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // SPLASH
  // ═══════════════════════════════════════════════════════════
  {
    'splash_app_name': {
      'en': 'ZanNext',
      'sw': 'ZanNext',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // LOGIN
  // ═══════════════════════════════════════════════════════════
  {
    'login_welcome_back': {
      'en': 'Welcome back!',
      'sw': 'Karibu tena!',
    },
    'login_subtitle': {
      'en': 'Hello! Let\'s start your journey',
      'sw': 'Habari! Tuuanze safari yako',
    },
    'login_email': {
      'en': 'Email',
      'sw': 'Barua pepe',
    },
    'login_email_hint': {
      'en': 'Enter your email',
      'sw': 'Weka barua pepe yako',
    },
    'login_password': {
      'en': 'Password',
      'sw': 'Nenosiri',
    },
    'login_password_hint': {
      'en': 'Enter your password',
      'sw': 'Weka nenosiri lako',
    },
    'login_remember_me': {
      'en': 'Remember me',
      'sw': 'Nikumbuke',
    },
    'login_button': {
      'en': 'Log In',
      'sw': 'Ingia',
    },
    'login_no_account': {
      'en': 'Don\'t have an account?',
      'sw': 'Huna akaunti?',
    },
    'login_signup_link': {
      'en': 'Sign up here',
      'sw': 'Jisajili hapa',
    },
    'login_email_required': {
      'en': 'Please enter your email',
      'sw': 'Tafadhali weka barua pepe yako',
    },
    'login_password_required': {
      'en': 'Please enter your password',
      'sw': 'Tafadhali weka nenosiri lako',
    },
    'login_invalid_email': {
      'en': 'Please enter a valid email',
      'sw': 'Tafadhali weka barua pepe sahihi',
    },
    'login_failed': {
      'en': 'Login failed. Check your email and password.',
      'sw': 'Kuingia kumeshindikana. Angalia barua pepe na nenosiri lako.',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // SIGN UP
  // ═══════════════════════════════════════════════════════════
  {
    'signup_title': {
      'en': 'Create New Account',
      'sw': 'Fungua Akaunti Mpya',
    },
    'signup_subtitle': {
      'en': 'Create your account in seconds',
      'sw': 'Fungua akaunti yako kwa sekunde chache',
    },
    'signup_name': {
      'en': 'Full Name',
      'sw': 'Jina Kamili',
    },
    'signup_name_hint': {
      'en': 'Enter your name',
      'sw': 'Weka jina lako',
    },
    'signup_phone': {
      'en': 'Phone Number',
      'sw': 'Namba ya Simu',
    },
    'signup_phone_hint': {
      'en': 'Enter your phone number',
      'sw': 'Weka namba yako ya simu',
    },
    'signup_email': {
      'en': 'Email',
      'sw': 'Barua pepe',
    },
    'signup_email_hint': {
      'en': 'Enter your email',
      'sw': 'Weka barua pepe yako',
    },
    'signup_password': {
      'en': 'Password',
      'sw': 'Nenosiri',
    },
    'signup_password_hint': {
      'en': 'Enter your password',
      'sw': 'Weka nenosiri lako',
    },
    'signup_button': {
      'en': 'Sign Up',
      'sw': 'Jisajili',
    },
    'signup_have_account': {
      'en': 'Already have an account?',
      'sw': 'Una akaunti tayari?',
    },
    'signup_login_link': {
      'en': 'Log in here',
      'sw': 'Ingia hapa',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // FORGOT PASSWORD
  // ═══════════════════════════════════════════════════════════
  {
    'forgot_title': {
      'en': 'Forgot Password',
      'sw': 'Umesahau Nenosiri',
    },
    'forgot_subtitle': {
      'en': 'Enter your email and we will send you a reset link',
      'sw': 'Weka barua pepe yako tutakutumia kiungo cha kuweka upya nenosiri',
    },
    'forgot_email': {
      'en': 'Email',
      'sw': 'Barua pepe',
    },
    'forgot_button': {
      'en': 'Send Reset Link',
      'sw': 'Tuma Kiungo',
    },
    'forgot_success': {
      'en': 'Password reset email sent!',
      'sw': 'Barua pepe ya kubadili nenosiri imetumwa!',
    },
  },
  // ═══════════════════════════════════════════════════════════
  // WELCOME PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'welcome_app_name': {
      'en': 'ZanNext',
      'sw': 'ZanNext',
    },
    'welcome_tagline': {
      'en': 'Buy. Sell. Connect.',
      'sw': 'Nunua. Uza. Ungana.',
    },
    'welcome_title': {
      'en': 'Welcome',
      'sw': 'Karibu',
    },
    'welcome_subtitle': {
      'en': 'Sign in or create a new account to get started',
      'sw': 'Ingia au fungua akaunti mpya ili kuanza',
    },
    'welcome_sign_in': {
      'en': 'Sign In',
      'sw': 'Ingia',
    },
    'welcome_create_account': {
      'en': 'Create New Account',
      'sw': 'Fungua Akaunti Mpya',
    },
    'welcome_privacy_policy': {
      'en': 'Privacy Policy',
      'sw': 'Sera ya Faragha',
    },
    'welcome_terms': {
      'en': 'Terms of Service',
      'sw': 'Masharti ya Huduma',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // SIGN UP PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'signup_title': {
      'en': 'Create Account',
      'sw': 'Fungua Akaunti',
    },
    'signup_subtitle': {
      'en': 'Join ZanNext in a few seconds',
      'sw': 'Jiunge na ZanNext kwa sekunde chache',
    },
    'signup_label_full_name': {
      'en': 'Full name',
      'sw': 'Jina kamili',
    },
    'signup_hint_name': {
      'en': 'Your name',
      'sw': 'Jina lako',
    },
    'signup_label_phone': {
      'en': 'Phone',
      'sw': 'Simu',
    },
    'signup_hint_phone': {
      'en': '+255 ...',
      'sw': '+255 ...',
    },
    'signup_label_email': {
      'en': 'Email',
      'sw': 'Barua pepe',
    },
    'signup_hint_email': {
      'en': 'you@example.com',
      'sw': 'wewe@mfano.com',
    },
    'signup_label_password': {
      'en': 'Password',
      'sw': 'Nenosiri',
    },
    'signup_agree_prefix': {
      'en': 'I agree to the ',
      'sw': 'Nakubali ',
    },
    'signup_terms': {
      'en': 'Terms of Service',
      'sw': 'Masharti ya Huduma',
    },
    'signup_and': {
      'en': ' and ',
      'sw': ' na ',
    },
    'signup_privacy': {
      'en': 'Privacy Policy',
      'sw': 'Sera ya Faragha',
    },
    'signup_button': {
      'en': 'Create Account',
      'sw': 'Fungua Akaunti',
    },
    'signup_have_account': {
      'en': 'Already have an account?  ',
      'sw': 'Una akaunti tayari?  ',
    },
    'signup_sign_in_link': {
      'en': 'Sign In',
      'sw': 'Ingia',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // LOGIN PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'login_language': {
      'en': 'Language',
      'sw': 'Lugha',
    },
    'login_welcome_back': {
      'en': 'Welcome back',
      'sw': 'Karibu tena',
    },
    'login_subtitle': {
      'en': 'Sign in to continue to ZanNext',
      'sw': 'Ingia ili kuendelea na ZanNext',
    },
    'login_label_email': {
      'en': 'Email',
      'sw': 'Barua pepe',
    },
    'login_hint_email': {
      'en': 'you@example.com',
      'sw': 'wewe@mfano.com',
    },
    'login_label_password': {
      'en': 'Password',
      'sw': 'Nenosiri',
    },
    'login_remember_me': {
      'en': 'Remember me',
      'sw': 'Nikumbuke',
    },
    'login_button': {
      'en': 'Sign In',
      'sw': 'Ingia',
    },
    'login_no_account': {
      'en': "Don't have an account?  ",
      'sw': 'Huna akaunti?  ',
    },
    'login_sign_up_link': {
      'en': 'Sign Up',
      'sw': 'Jisajili',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // HOME PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'home_deliver_to': {
      'en': 'Deliver to',
      'sw': 'Inatumiwa kwenda',
    },
    'home_default_location': {
      'en': 'Zanzibar',
      'sw': 'Zanzibar',
    },
    'home_search_hint': {
      'en': 'Search for products...',
      'sw': 'Tafuta bidhaa...',
    },
    'home_seller_cta_title': {
      'en': 'Start selling and achieve your goals',
      'sw': 'Anza kuuza na utimize malengo yako',
    },
    'home_seller_cta_button': {
      'en': 'New Products',
      'sw': 'Bidhaa Mpya',
    },
    'home_no_products': {
      'en': 'No products available',
      'sw': 'Hakuna bidhaa zinazopatikana',
    },
    'home_see_all': {
      'en': 'See All',
      'sw': 'Ona Zote',
    },
    'home_more': {
      'en': 'More',
      'sw': 'Zaidi',
    },
    'home_boosted': {
      'en': 'Boosted',
      'sw': 'Zilizoimarishwa',
    },
    'home_trending': {
      'en': 'Trending',
      'sw': 'Zinazovuma',
    },
    'home_new_arrivals': {
      'en': 'New Arrivals',
      'sw': 'Mpya',
    },
    'home_badge_new': {
      'en': 'NEW',
      'sw': 'MPYA',
    },
    'home_badge_boosted': {
      'en': 'BOOSTED',
      'sw': 'IMARISHA',
    },
    'home_product_fallback': {
      'en': 'Product',
      'sw': 'Bidhaa',
    },
    'home_seller_verified': {
      'en': 'Verified',
      'sw': 'Imethibitishwa',
    },
    'home_admin_menu_title': {
      'en': 'What do you want to do?',
      'sw': 'Unataka kufanya nini?',
    },
    'home_admin_edit_category': {
      'en': 'Edit this category',
      'sw': 'Badilisha kundi hili',
    },
    'home_admin_continue': {
      'en': 'Continue to page',
      'sw': 'Endelea kwenye ukurasa',
    },
    // ── Categories ──
    'cat_computers': {
      'en': 'Computers & Laptops',
      'sw': 'Kompyuta na Laptops',
    },
    'cat_mens_wear': {
      'en': 'Men\u2019s Wear',
      'sw': 'Mavazi ya Wanaume',
    },
    'cat_womens_wear': {
      'en': 'Women\u2019s Wear',
      'sw': 'Mavazi ya Wanawake',
    },
    'cat_furniture': {
      'en': 'Furniture',
      'sw': 'Samani',
    },
    'cat_wearables': {
      'en': 'Wearables',
      'sw': 'Vifaa vya Kuvaa',
    },
    'cat_luxury_watches': {
      'en': 'Luxury Watches',
      'sw': 'Saa za Kifahari',
    },
    'cat_bracelets': {
      'en': 'Bracelets & Earrings',
      'sw': 'Vikuku na Heleni',
    },
    'cat_laundry': {
      'en': 'Laundry',
      'sw': 'Dobi',
    },
    'cat_women': {
      'en': 'Women',
      'sw': 'Wanawake',
    },
    'cat_beauty': {
      'en': 'Beauty',
      'sw': 'Urembo',
    },
    'cat_phones': {
      'en': 'Phones',
      'sw': 'Simu',
    },
    'cat_home_decor': {
      'en': 'Home Decor',
      'sw': 'Mapambo ya Nyumbani',
    },
    'cat_sports': {
      'en': 'Sports',
      'sw': 'Michezo',
    },
    'cat_shoes': {
      'en': 'Shoes',
      'sw': 'Viatu',
    },
    'cat_handbags': {
      'en': 'Handbags',
      'sw': 'Mikoba',
    },
    'cat_audio': {
      'en': 'Audio',
      'sw': 'Sauti',
    },
    'cat_bedding': {
      'en': 'Bedding',
      'sw': 'Vitanda',
    },
    'cat_kitchen': {
      'en': 'Kitchen',
      'sw': 'Jikoni',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // SEARCH PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'search_title': {
      'en': 'Search',
      'sw': 'Tafuta',
    },
    'search_hint': {
      'en': 'Search products...',
      'sw': 'Tafuta bidhaa...',
    },
    'search_filter_category': {
      'en': 'CATEGORY',
      'sw': 'KUNDI',
    },
    'search_filter_price': {
      'en': 'PRICE',
      'sw': 'BEI',
    },
    'search_filter_sort_by': {
      'en': 'SORT BY',
      'sw': 'PANGA KWA',
    },
    'search_sort_relevance': {
      'en': 'Relevance',
      'sw': 'Umuhimu',
    },
    'search_sort_newest': {
      'en': 'Newest',
      'sw': 'Mpya Zaidi',
    },
    'search_sort_price_up': {
      'en': 'Price ↑',
      'sw': 'Bei ↑',
    },
    'search_sort_price_down': {
      'en': 'Price ↓',
      'sw': 'Bei ↓',
    },
    'search_recent': {
      'en': 'RECENT',
      'sw': 'HIVI KARIBUNI',
    },
    'search_clear': {
      'en': 'Clear',
      'sw': 'Futa',
    },
    'search_trending': {
      'en': 'TRENDING',
      'sw': 'ZINAZOVUMA',
    },
    'search_browse_category': {
      'en': 'BROWSE BY CATEGORY',
      'sw': 'TAFUTA KWA KUNDI',
    },
    'search_no_results_for': {
      'en': 'No results for',
      'sw': 'Hakuna matokeo ya',
    },
    'search_try_different': {
      'en': 'Try a different keyword or check the spelling.',
      'sw': 'Jaribu neno lingine au angalia tahajia.',
    },
    'search_clear_search': {
      'en': 'Clear search',
      'sw': 'Futa utafutaji',
    },
    'search_failed': {
      'en': 'Search failed',
      'sw': 'Utafutaji umeshindikana',
    },
    'search_product_fallback': {
      'en': 'Product',
      'sw': 'Bidhaa',
    },
    'search_category_all': {
      'en': 'All',
      'sw': 'Zote',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // WISHLIST PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'wishlist_title': {
      'en': 'Saved Products',
      'sw': 'Bidhaa Zilizohifadhiwa',
    },
    'wishlist_subtitle': {
      'en': 'Your favourites',
      'sw': 'Vipendwa vyako',
    },
    'wishlist_count_one': {
      'en': '1 saved item',
      'sw': 'Kitu 1 kilichohifadhiwa',
    },
    'wishlist_count_many': {
      'en': 'saved items',
      'sw': 'vitu vilivyohifadhiwa',
    },
    'wishlist_product_fallback': {
      'en': 'Product',
      'sw': 'Bidhaa',
    },
    'wishlist_empty_title': {
      'en': 'No saved products yet',
      'sw': 'Hakuna bidhaa zilizohifadhiwa bado',
    },
    'wishlist_empty_subtitle': {
      'en': 'Tap the heart on any product and it will show up here.',
      'sw': 'Gusa moyo kwenye bidhaa yoyote na itaonekana hapa.',
    },
    'wishlist_browse_products': {
      'en': 'Browse Products',
      'sw': 'Vinjari Bidhaa',
    },
    'wishlist_error_title': {
      'en': 'Could not load saved products',
      'sw': 'Imeshindwa kupakia bidhaa zilizohifadhiwa',
    },
    'wishlist_not_logged_in_title': {
      'en': 'Please sign in',
      'sw': 'Tafadhali ingia',
    },
    'wishlist_not_logged_in_subtitle': {
      'en': 'You need to be signed in to see your saved products.',
      'sw': 'Unahitaji kuingia ili kuona bidhaa zako zilizohifadhiwa.',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // MESSAGES LIST PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'msg_title': {
      'en': 'Messages',
      'sw': 'Ujumbe',
    },
    'msg_subtitle': {
      'en': 'Chat with buyers & sellers',
      'sw': 'Ongea na wanunuzi na wauzaji',
    },
    'msg_clear_all': {
      'en': 'Clear all',
      'sw': 'Futa zote',
    },
    'msg_delete': {
      'en': 'Delete',
      'sw': 'Futa',
    },
    'msg_please_sign_in': {
      'en': 'Please sign in',
      'sw': 'Tafadhali ingia',
    },
    'msg_product_fallback': {
      'en': 'Product',
      'sw': 'Bidhaa',
    },
    'msg_chat_fallback': {
      'en': 'Chat',
      'sw': 'Mazungumzo',
    },
    'msg_delete_title': {
      'en': 'Delete conversation?',
      'sw': 'Futa mazungumzo?',
    },
    'msg_delete_body_prefix': {
      'en': 'Chat with ',
      'sw': 'Mazungumzo na ',
    },
    'msg_delete_body_suffix': {
      'en': ' and all its messages will be removed permanently.',
      'sw': ' na ujumbe wake wote utaondolewa kabisa.',
    },
    'msg_cancel': {
      'en': 'Cancel',
      'sw': 'Ghairi',
    },
    'msg_deleted_success': {
      'en': 'Conversation deleted',
      'sw': 'Mazungumzo yamefutwa',
    },
    'msg_delete_failed': {
      'en': 'Could not delete: ',
      'sw': 'Imeshindwa kufuta: ',
    },
    'msg_clear_all_title': {
      'en': 'Clear all conversations?',
      'sw': 'Futa mazungumzo yote?',
    },
    'msg_clear_all_body': {
      'en': 'Every chat and its messages will be permanently deleted.',
      'sw': 'Kila mazungumzo na ujumbe wake utaondolewa kabisa.',
    },
    'msg_clear_all_button': {
      'en': 'Clear All',
      'sw': 'Futa Zote',
    },
    'msg_no_conversations': {
      'en': 'No conversations to clear',
      'sw': 'Hakuna mazungumzo ya kufuta',
    },
    'msg_cleared_prefix': {
      'en': 'Cleared ',
      'sw': 'Imefuta ',
    },
    'msg_cleared_suffix': {
      'en': ' conversation(s)',
      'sw': ' mazungumzo',
    },
    'msg_clear_failed': {
      'en': 'Could not clear: ',
      'sw': 'Imeshindwa kufuta: ',
    },
    'msg_empty_title': {
      'en': 'No messages yet',
      'sw': 'Hakuna ujumbe bado',
    },
    'msg_empty_subtitle': {
      'en': 'Chats with buyers and sellers will appear here.',
      'sw': 'Mazungumzo na wanunuzi na wauzaji yataonekana hapa.',
    },
    'msg_error_title': {
      'en': 'Could not load messages',
      'sw': 'Imeshindwa kupakia ujumbe',
    },
    'msg_time_just_now': {
      'en': 'Just now',
      'sw': 'Sasa hivi',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // PROFILE PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'profile_title': {
      'en': 'Profile',
      'sw': 'Wasifu',
    },
    'profile_user_fallback': {
      'en': 'User',
      'sw': 'Mtumiaji',
    },
    'profile_no_email': {
      'en': 'no email',
      'sw': 'hakuna barua pepe',
    },
    'profile_quick_add_product': {
      'en': 'Add Product',
      'sw': 'Ongeza Bidhaa',
    },
    'profile_quick_my_products': {
      'en': 'My Products',
      'sw': 'Bidhaa Zangu',
    },
    'profile_quick_orders': {
      'en': 'Orders',
      'sw': 'Oda',
    },
    'profile_no_active_orders': {
      'en': 'No active orders',
      'sw': 'Hakuna oda inayoendelea',
    },
    'profile_orders_appear_here': {
      'en': 'Your orders will appear here',
      'sw': 'Oda zako zitaonekana hapa',
    },
    'profile_order_fallback': {
      'en': 'Order',
      'sw': 'Oda',
    },
    'profile_section_general': {
      'en': 'GENERAL',
      'sw': 'JUMLA',
    },
    'profile_section_account': {
      'en': 'ACCOUNT SETTINGS',
      'sw': 'MIPANGILIO YA AKAUNTI',
    },
    'profile_section_other': {
      'en': 'OTHER',
      'sw': 'NYINGINE',
    },
    'profile_section_app_legal': {
      'en': 'APP & LEGAL',
      'sw': 'APP NA SHERIA',
    },
    'profile_section_admin': {
      'en': 'ADMIN TOOLS',
      'sw': 'ZANA ZA ADMIN',
    },
    'profile_edit_profile': {
      'en': 'Edit Profile',
      'sw': 'Hariri Wasifu',
    },
    'profile_my_orders': {
      'en': 'My Orders',
      'sw': 'Oda Zangu',
    },
    'profile_my_favorites': {
      'en': 'My Favorites',
      'sw': 'Vipendwa Vyangu',
    },
    'profile_addresses': {
      'en': 'Addresses',
      'sw': 'Anwani',
    },
    'profile_notifications': {
      'en': 'Notifications',
      'sw': 'Taarifa',
    },
    'profile_language': {
      'en': 'Language',
      'sw': 'Lugha',
    },
    'profile_language_kiswahili': {
      'en': 'Kiswahili',
      'sw': 'Kiswahili',
    },
    'profile_language_english': {
      'en': 'English',
      'sw': 'Kiingereza',
    },
    'profile_rate_app': {
      'en': 'Rate the App',
      'sw': 'Kadiria App',
    },
    'profile_invite_friends': {
      'en': 'Invite Friends',
      'sw': 'Alika Marafiki',
    },
    'profile_help_center': {
      'en': 'Help Center',
      'sw': 'Kituo cha Msaada',
    },
    'profile_about_app': {
      'en': 'About the App',
      'sw': 'Kuhusu App',
    },
    'profile_support_inbox': {
      'en': 'Support Inbox',
      'sw': 'Sanduku la Msaada',
    },
    'profile_admin_dashboard': {
      'en': 'Admin Dashboard',
      'sw': 'Dashibodi ya Admin',
    },
    'profile_admin_badge': {
      'en': 'Admin',
      'sw': 'Admin',
    },
    'profile_logout': {
      'en': 'Logout',
      'sw': 'Ondoka',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // ALL CATEGORIES PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'catz_title': {
      'en': 'All Categories',
      'sw': 'Kundi Zote',
    },
    'catz_search_hint': {
      'en': 'Search Products...',
      'sw': 'Tafuta Bidhaa...',
    },
    'catz_tab_categories': {
      'en': 'Category',
      'sw': 'Kundi',
    },
    'catz_tab_trending': {
      'en': 'Trending',
      'sw': 'Zinazovuma',
    },
    'catz_tab_new': {
      'en': 'New',
      'sw': 'Mpya',
    },
    'catz_no_trending': {
      'en': 'No trending products yet',
      'sw': 'Hakuna bidhaa zinazovuma bado',
    },
    'catz_no_new': {
      'en': 'No new products yet',
      'sw': 'Hakuna bidhaa mpya bado',
    },
    'catz_error_prefix': {
      'en': 'Could not load products',
      'sw': 'Imeshindwa kupakia bidhaa',
    },
    'catz_product_fallback': {
      'en': 'Product',
      'sw': 'Bidhaa',
    },
    'catz_seller_fallback': {
      'en': 'Verified',
      'sw': 'Imethibitishwa',
    },
    'catz_badge_new': {
      'en': 'NEW',
      'sw': 'MPYA',
    },
    'catz_admin_menu_title': {
      'en': 'What do you want to do?',
      'sw': 'Unataka kufanya nini?',
    },
    'catz_admin_edit': {
      'en': 'Edit this category',
      'sw': 'Badilisha kundi hili',
    },
    'catz_admin_edit_sub': {
      'en': 'Change image or name',
      'sw': 'Badilisha picha au jina',
    },
    'catz_admin_continue': {
      'en': 'Continue to page',
      'sw': 'Endelea kwenye ukurasa',
    },
    'catz_admin_continue_sub': {
      'en': 'Open category normally',
      'sw': 'Fungua kundi kawaida',
    },
    // ── Category short labels (used in grid) ──
    'cz_mens_wear':          { 'en': "Men's Wear",          'sw': 'Mavazi ya Wanaume' },
    'cz_womens_wear':        { 'en': "Women's Wear",        'sw': 'Mavazi ya Wanawake' },
    'cz_kids_clothing':      { 'en': "Kids' Clothing",      'sw': 'Mavazi ya Watoto' },
    'cz_shorts_sporty':      { 'en': 'Shorts Sporty',       'sw': 'Kaptura za Michezo' },
    'cz_shorts_casual':      { 'en': 'Shorts Casual',       'sw': 'Kaptura za Kawaida' },
    'cz_underwear':          { 'en': 'Underwear',           'sw': 'Chupi' },
    'cz_socks':              { 'en': 'Socks',               'sw': 'Soksi' },
    'cz_sneakers':           { 'en': 'Sneakers',            'sw': 'Viatu vya Michezo' },
    'cz_formal_shoes':       { 'en': 'Formal Shoes',        'sw': 'Viatu vya Rasmi' },
    'cz_sandals':            { 'en': 'Sandals',             'sw': 'Viatu vya Kamba' },
    'cz_heels':              { 'en': 'Heels',               'sw': 'Viatu vya Kike' },
    'cz_computers':          { 'en': 'Computers',           'sw': 'Kompyuta' },
    'cz_smart_phone':        { 'en': 'Smart Phone',         'sw': 'Simu Janja' },
    'cz_audio':              { 'en': 'Audio',               'sw': 'Sauti' },
    'cz_skincare':           { 'en': 'Skincare',            'sw': 'Utunzaji wa Ngozi' },
    'cz_fragrances':         { 'en': 'Fragrances',          'sw': 'Manukato' },
    'cz_hair_care':          { 'en': 'Hair Care',           'sw': 'Utunzaji wa Nywele' },
    'cz_makeup':             { 'en': 'Makeup',              'sw': 'Mapodo' },
    'cz_lighting':           { 'en': 'Lighting',            'sw': 'Taa' },
    'cz_wall_art':           { 'en': 'Wall Art',            'sw': 'Sanaa ya Ukuta' },
    'cz_furniture':          { 'en': 'Furniture',           'sw': 'Samani' },
    'cz_bedding':            { 'en': 'Bedding',             'sw': 'Vitanda' },
    'cz_fresh_produce':      { 'en': 'Fresh Produce',       'sw': 'Mazao Mapya' },
    'cz_grains':             { 'en': 'Grains',              'sw': 'Nafaka' },
    'cz_beverages':          { 'en': 'Beverages',           'sw': 'Vinywaji' },
    'cz_snacks':             { 'en': 'Snacks',              'sw': 'Vitafunio' },
    'cz_wearables':          { 'en': 'Wearables',           'sw': 'Vifaa vya Kuvaa' },
    'cz_mobile_accessories': { 'en': 'Mobile Accessories',  'sw': 'Vifaa vya Simu' },
    'cz_smart_home':         { 'en': 'Smart Home',          'sw': 'Nyumba Smart' },
    'cz_team_sports':        { 'en': 'Team Sports',         'sw': 'Michezo ya Timu' },
    'cz_gym_fitness':        { 'en': 'Gym & Fitness',       'sw': 'Gym na Mazoezi' },
    'cz_outdoor':            { 'en': 'Outdoor',             'sw': 'Nje' },
    'cz_luxury_watches':     { 'en': 'Luxury Watches',      'sw': 'Saa za Kifahari' },
    'cz_digital_watches':    { 'en': 'Digital Watches',     'sw': 'Saa za Kidijitali' },
    'cz_wall_clocks':        { 'en': 'Wall Clocks',         'sw': 'Saa za Ukuta' },
    'cz_educational_toys':   { 'en': 'Educational Toys',    'sw': 'Vichezeo vya Kuelimisha' },
    'cz_baby_gear':          { 'en': 'Baby Gear',           'sw': 'Vifaa vya Watoto' },
    'cz_electronic_toys':    { 'en': 'Electronic Toys',     'sw': 'Vichezeo vya Kielektroniki' },
    'cz_supplements':        { 'en': 'Supplements',         'sw': 'Virutubisho' },
    'cz_medical_equipment':  { 'en': 'Medical Equipment',   'sw': 'Vifaa vya Matibabu' },
    'cz_personal_hygiene':   { 'en': 'Personal Hygiene',    'sw': 'Usafi wa Kibinafsi' },
    'cz_stationery':         { 'en': 'Stationery',          'sw': 'Vifaa vya Kuandikia' },
    'cz_office_tech':        { 'en': 'Office Tech',         'sw': 'Vifaa vya Ofisi' },
    'cz_organization':       { 'en': 'Organization',        'sw': 'Upangaji' },
    'cz_car_parts':          { 'en': 'Car Parts',           'sw': 'Vipuri vya Gari' },
    'cz_interior_access':    { 'en': 'Interior Accessories','sw': 'Vifaa vya Ndani' },
    'cz_tires_rims':         { 'en': 'Tires & Rims',        'sw': 'Matairi na Rims' },
    'cz_kitchen':            { 'en': 'Kitchen',             'sw': 'Jikoni' },
    'cz_laundry':            { 'en': 'Laundry',             'sw': 'Dobi' },
    'cz_cooling':            { 'en': 'Cooling',             'sw': 'Kupoza' },
    'cz_rings_wedding':      { 'en': 'Rings & Wedding',     'sw': 'Pete na Harusi' },
    'cz_necklaces':          { 'en': 'Necklaces',           'sw': 'Vikuku vya Shingoni' },
    'cz_bracelets':          { 'en': 'Bracelets',           'sw': 'Vikuku' },
    'cz_digital_cards':      { 'en': 'Digital Cards',       'sw': 'Kadi za Kidijitali' },
    'cz_physical_gifts':     { 'en': 'Physical Gifts',      'sw': 'Zawadi za Kimwili' },
  },

  // ═══════════════════════════════════════════════════════════
  // TRENDING PRODUCTS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'trending_title': {
      'en': 'Trending Now',
      'sw': 'Zinazovuma Sasa',
    },
    'trending_subtitle': {
      'en': 'Most viewed products this week',
      'sw': 'Bidhaa zinazotazamwa zaidi wiki hii',
    },
    'trending_sort_popular': {
      'en': 'Most Viewed',
      'sw': 'Zinazotazamwa Zaidi',
    },
    'trending_sort_newest': {
      'en': 'Newest',
      'sw': 'Mpya Zaidi',
    },
    'trending_sort_price_up': {
      'en': 'Price ↑',
      'sw': 'Bei ↑',
    },
    'trending_sort_price_down': {
      'en': 'Price ↓',
      'sw': 'Bei ↓',
    },
    'trending_product_fallback': {
      'en': 'Product',
      'sw': 'Bidhaa',
    },
    'trending_views': {
      'en': 'views',
      'sw': 'mionekano',
    },
    'trending_empty_title': {
      'en': 'No trending products yet',
      'sw': 'Hakuna bidhaa zinazovuma bado',
    },
    'trending_empty_subtitle': {
      'en': 'Come back soon — popular items show up here.',
      'sw': 'Rudi hivi karibuni — bidhaa maarufu zitaonekana hapa.',
    },
    'trending_error_title': {
      'en': 'Something went wrong',
      'sw': 'Kuna kitu kimeenda vibaya',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // NEW ARRIVALS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'newarrivals_title': {
      'en': 'New Arrivals',
      'sw': 'Bidhaa Mpya',
    },
    'newarrivals_subtitle': {
      'en': 'Fresh drops & latest items',
      'sw': 'Bidhaa mpya na za hivi karibuni',
    },
    'newarrivals_sort_newest': {
      'en': 'Newest First',
      'sw': 'Mpya Kwanza',
    },
    'newarrivals_sort_price_up': {
      'en': 'Price ↑',
      'sw': 'Bei ↑',
    },
    'newarrivals_sort_price_down': {
      'en': 'Price ↓',
      'sw': 'Bei ↓',
    },
    'newarrivals_sort_popular': {
      'en': 'Most Viewed',
      'sw': 'Zinazotazamwa Zaidi',
    },
    'newarrivals_badge': {
      'en': 'NEW',
      'sw': 'MPYA',
    },
    'newarrivals_product_fallback': {
      'en': 'Product',
      'sw': 'Bidhaa',
    },
    'newarrivals_just_arrived': {
      'en': 'Just arrived',
      'sw': 'Imetoka hivi punde',
    },
    'newarrivals_empty_title': {
      'en': 'No new products yet',
      'sw': 'Hakuna bidhaa mpya bado',
    },
    'newarrivals_empty_subtitle': {
      'en': 'Fresh items will appear here as sellers add them.',
      'sw': 'Bidhaa mpya zitaonekana hapa kadri wauzaji wanapoongeza.',
    },
    'newarrivals_error_title': {
      'en': 'Something went wrong',
      'sw': 'Kuna kitu kimeenda vibaya',
    },
  },

  // ═══════════════════════════════════════════════════════════
  // SELLER DASHBOARD
  // ═══════════════════════════════════════════════════════════
  {
    'sd_no_seller': { 'en': 'No seller', 'sw': 'Hakuna muuzaji' },
    'sd_no_seller_sub': { 'en': 'This seller could not be found.', 'sw': 'Muuzaji huyu hakupatikana.' },
    'sd_my_shop': { 'en': 'My Shop', 'sw': 'Duka Langu' },
    'sd_seller': { 'en': 'Seller', 'sw': 'Muuzaji' },
    'sd_shop_fallback': { 'en': 'My Shop', 'sw': 'Duka Langu' },
    'sd_zanzibar': { 'en': 'Zanzibar', 'sw': 'Zanzibar' },
    'sd_reviews_suffix': { 'en': 'reviews', 'sw': 'maoni' },
    'sd_revenue': { 'en': 'Revenue', 'sw': 'Mapato' },
    'sd_orders': { 'en': 'Orders', 'sw': 'Oda' },
    'sd_products': { 'en': 'Products', 'sw': 'Bidhaa' },
    'sd_views': { 'en': 'Views', 'sw': 'Mionekano' },
    'sd_this_month': { 'en': 'This month', 'sw': 'Mwezi huu' },
    'sd_all_time': { 'en': 'All time', 'sw': 'Muda wote' },
    'sd_listed_by_you': { 'en': 'Listed by you', 'sw': 'Uliyoorodhesha' },
    'sd_all_products': { 'en': 'All products', 'sw': 'Bidhaa zote' },
    'sd_add_product': { 'en': 'Add Product', 'sw': 'Ongeza Bidhaa' },
    'sd_my_products': { 'en': 'My Products', 'sw': 'Bidhaa Zangu' },
    'sd_scroll_hint': { 'en': 'Scroll down to see your products', 'sw': 'Sogeza chini kuona bidhaa zako' },
    'sd_orders_btn': { 'en': 'Orders', 'sw': 'Oda' },
    'sd_shop_location': { 'en': 'Shop location', 'sw': 'Mahali pa duka' },
    'sd_joined': { 'en': 'Joined ZanNext', 'sw': 'Alijiunga ZanNext' },
    'sd_recently': { 'en': 'Recently', 'sw': 'Hivi Karibuni' },
    'sd_active_listings': { 'en': 'Active listings', 'sw': 'Bidhaa zinazopatikana' },
    'sd_products_count': { 'en': 'products', 'sw': 'bidhaa' },
    'sd_shop': { 'en': 'Shop', 'sw': 'Duka' },
    'sd_items': { 'en': 'items', 'sw': 'vitu' },
    'sd_all': { 'en': 'All', 'sw': 'Zote' },
    'sd_customer_reviews': { 'en': 'Customer Reviews', 'sw': 'Maoni ya Wateja' },
    'sd_all_answered': { 'en': 'All reviews answered', 'sw': 'Maoni yote yamejibiwa' },
    'sd_keep_up': { 'en': 'Keep it up — customers love responses', 'sw': 'Endelea hivyo — wateja wanapenda majibu' },
    'sd_reviews_need_reply': { 'en': 'need a reply', 'sw': 'yanahitaji jibu' },
    'sd_review_singular': { 'en': 'review', 'sw': 'maoni' },
    'sd_review_plural': { 'en': 'reviews', 'sw': 'maoni' },
    'sd_tap_to_reply': { 'en': 'Tap to reply and boost your seller score', 'sw': 'Gusa kujibu na kuongeza alama zako' },
    'sd_total_reviews': { 'en': 'Total reviews:', 'sw': 'Maoni yote:' },
    'sd_unreplied': { 'en': 'Unreplied:', 'sw': 'Yasiyojibiwa:' },
    'sd_you_no_products': { 'en': "You haven't posted any products yet", 'sw': 'Bado hujaweka bidhaa yoyote' },
    'sd_seller_no_products': { 'en': "This seller hasn't posted any products yet", 'sw': 'Muuzaji huyu bado hajaweka bidhaa yoyote' },
    'sd_add_first': { 'en': 'Add your first product', 'sw': 'Ongeza bidhaa yako ya kwanza' },
    'sd_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'sd_live': { 'en': 'LIVE', 'sw': 'IPO' },
    'sd_sold': { 'en': 'SOLD', 'sw': 'IMEUZWA' },
    'sd_sold_out': { 'en': 'SOLD OUT', 'sw': 'IMEUZWA' },
    'sd_in_stock': { 'en': 'IN STOCK', 'sw': 'IPO STOO' },
    'sd_edit': { 'en': 'Edit', 'sw': 'Hariri' },
    'sd_del': { 'en': 'Del', 'sw': 'Futa' },
    'sd_marked_available': { 'en': 'marked as available', 'sw': 'imewekwa kama inapatikana' },
    'sd_marked_sold': { 'en': 'marked as sold out', 'sw': 'imewekwa kama imeuzwa' },
    'sd_delete_product': { 'en': 'Delete product?', 'sw': 'Futa bidhaa?' },
    'sd_delete_body_prefix': { 'en': 'This will permanently remove "', 'sw': 'Hii itaondoa kabisa "' },
    'sd_delete_body_suffix': { 'en': '" from your shop.', 'sw': '" kutoka dukani kwako.' },
    'sd_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'sd_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'sd_product_deleted': { 'en': 'Product deleted', 'sw': 'Bidhaa imefutwa' },
    'sd_chat': { 'en': 'Chat', 'sw': 'Ongea' },
    'sd_zanzibar_tanzania': { 'en': 'Zanzibar, Tanzania', 'sw': 'Zanzibar, Tanzania' },
    'sd_shop_inquiry': { 'en': 'Shop inquiry', 'sw': 'Swali la duka' },
    'sd_share_shop': { 'en': 'Share shop', 'sw': 'Shiriki duka' },
    'sd_hide_feed': { 'en': 'Hide from feed', 'sw': 'Ficha kutoka kwenye feed' },
    'sd_report': { 'en': 'Report', 'sw': 'Ripoti' },
    'sd_already_reported': { 'en': 'You already reported this seller. Our team is reviewing it.', 'sw': 'Umeshammripoti muuzaji huyu. Timu yetu inakagua.' },
    'sd_hide_seller': { 'en': 'Hide this seller?', 'sw': 'Ficha muuzaji huyu?' },
    'sd_hide_seller_body': { 'en': "You won't see their products in your feed anymore.", 'sw': 'Hutaona bidhaa zao kwenye feed yako tena.' },
    'sd_hide': { 'en': 'Hide', 'sw': 'Ficha' },
    'sd_seller_hidden': { 'en': 'Seller hidden', 'sw': 'Muuzaji amefichwa' },
    'sd_report_shop': { 'en': 'Check out this shop on ZanNext!', 'sw': 'Angalia duka hili kwenye ZanNext!' },
  },

  // ═══════════════════════════════════════════════════════════
  // SELECT AD (POST AD) PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'sa_title': { 'en': 'Post Your Ad', 'sw': 'Weka Tangazo Lako' },
    'sa_choose_category': { 'en': 'Choose a category', 'sw': 'Chagua kundi' },
    'sa_choose_hint': { 'en': 'Pick where your product belongs — buyers will find it faster.', 'sw': 'Chagua kundi la bidhaa yako — wanunuzi wataipata haraka.' },
    'sa_tap_sub': { 'en': 'Tap to choose subcategory', 'sw': 'Gusa kuchagua kundi dogo' },
    'sa_cannot_open': { 'en': 'Cannot open ', 'sw': 'Imeshindwa kufungua ' },

    'sa_cat_fashion': { 'en': 'Fashion & Clothing', 'sw': 'Mitindo na Mavazi' },
    'sa_cat_shoes': { 'en': 'Shoes & Footwear', 'sw': 'Viatu' },
    'sa_cat_electronics': { 'en': 'Electronics', 'sw': 'Kielektroniki' },
    'sa_cat_beauty': { 'en': 'Beauty & Care', 'sw': 'Urembo na Utunzaji' },
    'sa_cat_home': { 'en': 'Home Decor', 'sw': 'Mapambo ya Nyumbani' },
    'sa_cat_groceries': { 'en': 'Groceries', 'sw': 'Vyakula' },
    'sa_cat_smart': { 'en': 'Smart Tech', 'sw': 'Teknolojia' },
    'sa_cat_sports': { 'en': 'Sports Gear', 'sw': 'Vifaa vya Michezo' },
    'sa_cat_watches': { 'en': 'Watches', 'sw': 'Saa' },
    'sa_cat_kids': { 'en': 'Kids & Toys', 'sw': 'Watoto na Vichezeo' },
    'sa_cat_health': { 'en': 'Health', 'sw': 'Afya' },
    'sa_cat_office': { 'en': 'Office Supply', 'sw': 'Vifaa vya Ofisi' },
    'sa_cat_automotive': { 'en': 'Automotive', 'sw': 'Magari' },
    'sa_cat_appliances': { 'en': 'Appliances', 'sw': 'Vyombo vya Nyumbani' },
    'sa_cat_jewelry': { 'en': 'Jewelry', 'sw': 'Vito' },

    'sa_admin_menu_title': { 'en': 'What do you want to do?', 'sw': 'Unataka kufanya nini?' },
    'sa_admin_edit': { 'en': 'Edit this category', 'sw': 'Badilisha kundi hili' },
    'sa_admin_edit_sub': { 'en': 'Change image or name', 'sw': 'Badilisha picha au jina' },
    'sa_admin_continue': { 'en': 'Continue to page', 'sw': 'Endelea kwenye ukurasa' },
    'sa_admin_continue_sub': { 'en': 'Open category normally', 'sw': 'Fungua kundi kawaida' },
  },

  // ═══════════════════════════════════════════════════════════
  // SPECIFIC CATEGORIES PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'sc_tagline': { 'en': 'Browse · Compare · Buy', 'sw': 'Vinjari · Linganisha · Nunua' },
    'sc_sort_popular': { 'en': 'Popular', 'sw': 'Maarufu' },
    'sc_sort_newest': { 'en': 'Newest', 'sw': 'Mpya Zaidi' },
    'sc_sort_price_up': { 'en': 'Price ↑', 'sw': 'Bei ↑' },
    'sc_sort_price_down': { 'en': 'Price ↓', 'sw': 'Bei ↓' },
    'sc_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'sc_seller_fallback': { 'en': 'Verified', 'sw': 'Imethibitishwa' },
    'sc_empty_title_prefix': { 'en': 'Nothing in ', 'sw': 'Hakuna kitu kwenye ' },
    'sc_empty_title_suffix': { 'en': ' yet', 'sw': ' bado' },
    'sc_empty_subtitle': { 'en': 'Try another category or check back later.', 'sw': 'Jaribu kundi lingine au angalia tena baadaye.' },
  },

  // ═══════════════════════════════════════════════════════════
  // PRODUCT DETAILS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'pd_product_not_found': { 'en': 'Product not found', 'sw': 'Bidhaa haipatikani' },
    'pd_could_not_load': { 'en': 'Could not load product', 'sw': 'Imeshindwa kupakia bidhaa' },
    'pd_share_check': { 'en': 'Check out ', 'sw': 'Angalia ' },
    'pd_share_on_zannext': { 'en': ' on ZanNext', 'sw': ' kwenye ZanNext' },
    'pd_this_product': { 'en': 'this product', 'sw': 'bidhaa hii' },
    'pd_already_reported': { 'en': 'You already reported this. Our team is reviewing it.', 'sw': 'Umesharipoti hii. Timu yetu inakagua.' },
    'pd_tap_to_zoom': { 'en': 'Tap to zoom', 'sw': 'Gusa kukuza' },
    'pd_general': { 'en': 'General', 'sw': 'Jumla' },
    'pd_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'pd_in_stock': { 'en': 'In Stock', 'sw': 'Ipo Stoo' },
    'pd_free_delivery': { 'en': 'Free delivery in Zanzibar', 'sw': 'Usafirishaji bure Zanzibar' },
    'pd_reviews_suffix': { 'en': 'reviews', 'sw': 'maoni' },
    'pd_section_product_details': { 'en': 'Product Details', 'sw': 'Maelezo ya Bidhaa' },
    'pd_no_description': { 'en': 'No description available.', 'sw': 'Hakuna maelezo yanayopatikana.' },
    'pd_section_quick_messages': { 'en': 'Quick Messages', 'sw': 'Ujumbe wa Haraka' },
    'pd_section_seller': { 'en': 'Seller', 'sw': 'Muuzaji' },
    'pd_section_reviews': { 'en': 'Reviews', 'sw': 'Maoni' },
    'pd_section_recommended': { 'en': 'You may also like', 'sw': 'Unaweza pia kupenda' },
    'pd_quick_available': { 'en': 'Is it available?', 'sw': 'Bado ipo?' },
    'pd_quick_last_price': { 'en': 'Last price?', 'sw': 'Bei ya mwisho?' },
    'pd_quick_deliver_today': { 'en': 'Can you deliver today?', 'sw': 'Unaweza kuwasilisha leo?' },
    'pd_quick_negotiable': { 'en': 'Is it negotiable?', 'sw': 'Bei inajadiliwa?' },
    'pd_seller_zanzibar': { 'en': 'Zanzibar', 'sw': 'Zanzibar' },
    'pd_chat': { 'en': 'Chat', 'sw': 'Ongea' },
    'pd_cannot_message_self': { 'en': "You can't message yourself on your own product.", 'sw': 'Huwezi kujituma ujumbe kwenye bidhaa yako mwenyewe.' },
    'pd_could_not_send': { 'en': 'Could not send: ', 'sw': 'Imeshindwa kutuma: ' },
    'pd_write_review': { 'en': 'Write Review', 'sw': 'Andika Maoni' },
    'pd_sign_in_to_review': { 'en': 'Please sign in to write a review', 'sw': 'Tafadhali ingia ili kuandika maoni' },
    'pd_no_reviews': { 'en': 'No reviews yet', 'sw': 'Hakuna maoni bado' },
    'pd_be_first_review': { 'en': 'Be the first to review!', 'sw': 'Kuwa wa kwanza kuandika maoni!' },
    'pd_delete_review': { 'en': 'Delete review?', 'sw': 'Futa maoni?' },
    'pd_delete_review_body': { 'en': 'This review will be permanently removed.', 'sw': 'Maoni haya yataondolewa kabisa.' },
    'pd_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'pd_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'pd_review_deleted': { 'en': 'Review deleted', 'sw': 'Maoni yamefutwa' },
    'pd_delete_failed': { 'en': 'Failed to delete: ', 'sw': 'Imeshindwa kufuta: ' },
    'pd_you_suffix': { 'en': ' (You)', 'sw': ' (Wewe)' },
    'pd_admin_view': { 'en': 'ADMIN VIEW', 'sw': 'MWONEKANO WA ADMIN' },
    'pd_buy_now': { 'en': 'Buy Now', 'sw': 'Nunua Sasa' },
    'pd_time_just_now': { 'en': 'Just now', 'sw': 'Sasa hivi' },
    'pd_cant_buy_own': { 'en': "You can't buy your own product — this is yours.", 'sw': 'Huwezi kununua bidhaa yako mwenyewe — hii ni yako.' },
    'pd_cant_chat_self': { 'en': "This is your product — you can't chat with yourself.", 'sw': 'Hii ni bidhaa yako — huwezi kujiongelesha.' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADMIN DASHBOARD
  // ═══════════════════════════════════════════════════════════
  {
    'ad_access_denied': { 'en': 'Access denied', 'sw': 'Ufikiaji umekataliwa' },
    'ad_access_denied_sub': { 'en': 'You need admin privileges to view this page.', 'sw': 'Unahitaji ruhusa za admin kuona ukurasa huu.' },
    'ad_go_back': { 'en': 'Go back', 'sw': 'Rudi nyuma' },
    'ad_header_title': { 'en': 'Admin Dashboard', 'sw': 'Dashibodi ya Admin' },
    'ad_header_sub': { 'en': 'Full control panel', 'sw': 'Paneli kamili ya udhibiti' },
    'ad_badge_admin': { 'en': 'ADMIN', 'sw': 'ADMIN' },
    'ad_reports_label': { 'en': 'reports', 'sw': 'ripoti' },
    'ad_total_users': { 'en': 'Total Users', 'sw': 'Watumiaji Wote' },
    'ad_products': { 'en': 'Products', 'sw': 'Bidhaa' },
    'ad_orders': { 'en': 'Orders', 'sw': 'Oda' },
    'ad_support_chats': { 'en': 'Support Chats', 'sw': 'Mazungumzo ya Msaada' },
    'ad_support_new': { 'en': 'Support', 'sw': 'Msaada' },
    'ad_support_new_suffix': { 'en': ' new', 'sw': ' mpya' },
    'ad_section_admin_tools': { 'en': 'Admin Tools', 'sw': 'Zana za Admin' },
    'ad_action_support_inbox': { 'en': 'Support Inbox', 'sw': 'Sanduku la Msaada' },
    'ad_action_sellers': { 'en': 'Sellers', 'sw': 'Wauzaji' },
    'ad_action_reports': { 'en': 'Reports', 'sw': 'Ripoti' },
    'ad_action_broadcast': { 'en': 'Broadcast', 'sw': 'Tangazo' },
    'ad_section_latest_orders': { 'en': 'Latest Orders', 'sw': 'Oda za Hivi Karibuni' },
    'ad_section_recent_users': { 'en': 'Recently Joined Users', 'sw': 'Watumiaji Waliojiunga Hivi Karibuni' },
    'ad_section_top_products': { 'en': 'Top Products', 'sw': 'Bidhaa Bora' },
    'ad_view_all': { 'en': 'View all', 'sw': 'Ona zote' },
    'ad_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'ad_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'ad_delete_order': { 'en': 'Delete order?', 'sw': 'Futa oda?' },
    'ad_delete_user': { 'en': 'Delete user?', 'sw': 'Futa mtumiaji?' },
    'ad_delete_suffix': { 'en': ' will be permanently removed.', 'sw': ' itaondolewa kabisa.' },
    'ad_order_deleted': { 'en': 'Order deleted', 'sw': 'Oda imefutwa' },
    'ad_user_deleted': { 'en': 'User deleted', 'sw': 'Mtumiaji amefutwa' },
    'ad_delete_failed': { 'en': 'Could not delete: ', 'sw': 'Imeshindwa kufuta: ' },
    'ad_no_orders': { 'en': 'No orders yet', 'sw': 'Hakuna oda bado' },
    'ad_no_users': { 'en': 'No users yet', 'sw': 'Hakuna watumiaji bado' },
    'ad_no_products': { 'en': 'No products yet', 'sw': 'Hakuna bidhaa bado' },
    'ad_order_fallback': { 'en': 'Order', 'sw': 'Oda' },
    'ad_user_fallback': { 'en': 'User', 'sw': 'Mtumiaji' },
    'ad_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'ad_views': { 'en': 'views', 'sw': 'mionekano' },
  },

  // ═══════════════════════════════════════════════════════════
  // CHAT DETAIL PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'cd_chat_not_found': { 'en': 'Chat not found', 'sw': 'Mazungumzo hayapatikani' },
    'cd_chat_fallback': { 'en': 'Chat', 'sw': 'Mazungumzo' },
    'cd_online': { 'en': 'Online', 'sw': 'Mtandaoni' },
    'cd_discussing': { 'en': 'DISCUSSING', 'sw': 'TUNAJADILI' },
    'cd_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'cd_say_hi': { 'en': 'Say hi 👋', 'sw': 'Sema habari 👋' },
    'cd_start_conversation': { 'en': 'Start the conversation about this product', 'sw': 'Anza mazungumzo kuhusu bidhaa hii' },
    'cd_type_message': { 'en': 'Type a message...', 'sw': 'Andika ujumbe...' },
    'cd_send_failed': { 'en': 'Send failed: ', 'sw': 'Imeshindwa kutuma: ' },
    'cd_could_not_load': { 'en': 'Could not load chat', 'sw': 'Imeshindwa kupakia mazungumzo' },
  },

  // ═══════════════════════════════════════════════════════════
  // ORDER DETAILS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'od_please_sign_in': { 'en': 'Please sign in', 'sw': 'Tafadhali ingia' },
    'od_sign_in_sub': { 'en': 'You need to sign in to see your orders.', 'sw': 'Unahitaji kuingia ili kuona oda zako.' },
    'od_could_not_load': { 'en': 'Could not load orders', 'sw': 'Imeshindwa kupakia oda' },
    'od_header_title': { 'en': 'Orders', 'sw': 'Oda' },
    'od_header_sub': { 'en': 'Buyer & Seller', 'sw': 'Mnunuzi na Muuzaji' },
    'od_menu_clear_delivered': { 'en': 'Clear delivered', 'sw': 'Futa zilizofikishwa' },
    'od_menu_clear_cancelled': { 'en': 'Clear cancelled', 'sw': 'Futa zilizoghairiwa' },
    'od_menu_clear_all': { 'en': 'Clear all', 'sw': 'Futa zote' },
    'od_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'od_delete_order_title': { 'en': 'Delete order?', 'sw': 'Futa oda?' },
    'od_delete_order_body_prefix': { 'en': '"', 'sw': '"' },
    'od_delete_order_body_mid': { 'en': '" will be removed from your list. The other party still sees it.', 'sw': '" itaondolewa kwenye orodha yako. Mwenzako bado anaiona.' },
    'od_this_order': { 'en': 'This order', 'sw': 'Oda hii' },
    'od_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'od_clear': { 'en': 'Clear', 'sw': 'Futa' },
    'od_order_removed': { 'en': 'Order removed from your list', 'sw': 'Oda imeondolewa kwenye orodha yako' },
    'od_could_not_delete': { 'en': 'Could not delete: ', 'sw': 'Imeshindwa kufuta: ' },
    'od_clear_delivered_title': { 'en': 'Clear delivered orders?', 'sw': 'Futa oda zilizofikishwa?' },
    'od_clear_delivered_body': { 'en': 'All delivered orders will be removed from your list.', 'sw': 'Oda zote zilizofikishwa zitaondolewa kwenye orodha yako.' },
    'od_clear_cancelled_title': { 'en': 'Clear cancelled orders?', 'sw': 'Futa oda zilizoghairiwa?' },
    'od_clear_cancelled_body': { 'en': 'All cancelled orders will be removed from your list.', 'sw': 'Oda zote zilizoghairiwa zitaondolewa kwenye orodha yako.' },
    'od_clear_all_title': { 'en': 'Clear all orders?', 'sw': 'Futa oda zote?' },
    'od_clear_all_body': { 'en': 'Every order in this tab will be removed from your list. The other party still sees them.', 'sw': 'Kila oda kwenye kichupo hiki itaondolewa kwenye orodha yako. Mwenzako bado anaziona.' },
    'od_cleared_prefix': { 'en': 'Cleared ', 'sw': 'Imefuta ' },
    'od_cleared_suffix': { 'en': ' order(s)', 'sw': ' oda' },
    'od_could_not_clear': { 'en': 'Could not clear: ', 'sw': 'Imeshindwa kufuta: ' },
    'od_tab_my_orders': { 'en': 'My Orders', 'sw': 'Oda Zangu' },
    'od_tab_received': { 'en': 'Received', 'sw': 'Zilizopokelewa' },
    'od_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'od_seller_prefix': { 'en': 'Seller: ', 'sw': 'Muuzaji: ' },
    'od_buyer_prefix': { 'en': 'Buyer: ', 'sw': 'Mnunuzi: ' },
    'od_status_delivered': { 'en': 'Delivered', 'sw': 'Imefikishwa' },
    'od_status_on_way': { 'en': 'On the way', 'sw': 'Njiani' },
    'od_status_cancelled': { 'en': 'Cancelled', 'sw': 'Imeghairiwa' },
    'od_status_returned': { 'en': 'Returned', 'sw': 'Imerudishwa' },
    'od_status_pending': { 'en': 'Pending', 'sw': 'Inasubiri' },
    'od_contact_seller': { 'en': 'Contact Seller', 'sw': 'Wasiliana na Muuzaji' },
    'od_message_buyer': { 'en': 'Message Buyer', 'sw': 'Mtumie Mnunuzi Ujumbe' },
    'od_order_completed': { 'en': 'Order completed', 'sw': 'Oda imekamilika' },
    'od_status_updated_prefix': { 'en': 'Status updated to "', 'sw': 'Hali imesasishwa kuwa "' },
    'od_status_updated_suffix': { 'en': '"', 'sw': '"' },
    'od_update_failed': { 'en': 'Update failed: ', 'sw': 'Imeshindwa kusasisha: ' },
    'od_could_not_open_chat': { 'en': 'Could not open chat: ', 'sw': 'Imeshindwa kufungua mazungumzo: ' },
    'od_chat_about_order': { 'en': 'Hi, about your order', 'sw': 'Habari, kuhusu oda yako' },
    'od_empty_buyer_title': { 'en': 'No orders yet', 'sw': 'Hakuna oda bado' },
    'od_empty_seller_title': { 'en': 'No incoming orders yet', 'sw': 'Hakuna oda zinazoingia bado' },
    'od_empty_buyer_sub': { 'en': 'Start your first order — browse products and shop with trusted sellers.', 'sw': 'Anza oda yako ya kwanza — vinjari bidhaa na nunua kwa wauzaji wa kuaminika.' },
    'od_empty_seller_sub': { 'en': 'When buyers order your products, they will show up here.', 'sw': 'Wanunuzi wanapoagiza bidhaa zako, zitaonekana hapa.' },
    'od_start_shopping': { 'en': 'Start Shopping', 'sw': 'Anza Kununua' },
    'od_add_product': { 'en': 'Add a Product', 'sw': 'Ongeza Bidhaa' },

    // ─── Tracking sheet ───
    'ts_title': { 'en': 'Track Order', 'sw': 'Fuatilia Oda' },
    'ts_current_status': { 'en': 'CURRENT STATUS', 'sw': 'HALI YA SASA' },
    'ts_eta': { 'en': 'ESTIMATED ARRIVAL', 'sw': 'MAKADIRIO YA KUFIKA' },
    'ts_eta_pending': { 'en': 'Within 1–2 hours', 'sw': 'Ndani ya saa 1–2' },
    'ts_eta_confirmed': { 'en': 'Within 45 minutes', 'sw': 'Ndani ya dakika 45' },
    'ts_eta_way': { 'en': '15–30 minutes', 'sw': 'Dakika 15–30' },
    'ts_eta_delivered': { 'en': 'Delivered', 'sw': 'Imefikishwa' },
    'ts_eta_cancelled': { 'en': 'Cancelled', 'sw': 'Imeghairiwa' },
    'ts_timeline': { 'en': 'Order Timeline', 'sw': 'Mfululizo wa Oda' },
    'ts_step_pending': { 'en': 'Pending', 'sw': 'Inasubiri' },
    'ts_step_confirmed': { 'en': 'Confirmed', 'sw': 'Imethibitishwa' },
    'ts_step_on_way': { 'en': 'On the way', 'sw': 'Njiani' },
    'ts_step_delivered': { 'en': 'Delivered', 'sw': 'Imefikishwa' },
    'ts_now': { 'en': 'NOW', 'sw': 'SASA' },
    'ts_in_progress': { 'en': 'In progress', 'sw': 'Inaendelea' },
    'ts_completed': { 'en': 'Completed', 'sw': 'Imekamilika' },
    'ts_pending_step': { 'en': 'Pending', 'sw': 'Inasubiri' },
    'ts_delivering_to': { 'en': 'DELIVERING TO', 'sw': 'INAFIKISHA KWA' },
    'ts_done': { 'en': 'Done', 'sw': 'Imekamilika' },
    'ts_sub_confirmed': { 'en': 'Seller confirmed your order', 'sw': 'Muuzaji amethibitisha oda yako' },
    'ts_sub_on_way': { 'en': 'Your order is on the way', 'sw': 'Oda yako iko njiani' },
    'ts_sub_delivered': { 'en': 'Delivered — enjoy!', 'sw': 'Imefikishwa — furahia!' },
    'ts_sub_cancelled': { 'en': 'This order was cancelled', 'sw': 'Oda hii ilighairiwa' },
    'ts_sub_pending': { 'en': 'Waiting for seller confirmation', 'sw': 'Inasubiri uthibitisho wa muuzaji' },
  },

  // ═══════════════════════════════════════════════════════════
  // CART PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'cart_title': { 'en': 'Cart', 'sw': 'Sanduku' },
    'cart_clear_all': { 'en': 'Clear', 'sw': 'Futa' },
    'cart_size_label': { 'en': 'Size: ', 'sw': 'Ukubwa: ' },
    'cart_color_label': { 'en': 'Color: ', 'sw': 'Rangi: ' },
    'cart_shipping': { 'en': 'Shipping Cost', 'sw': 'Gharama ya Usafirishaji' },
    'cart_tax': { 'en': 'Tax', 'sw': 'Kodi' },
    'cart_total': { 'en': 'Total', 'sw': 'Jumla' },
    'cart_promo_hint': { 'en': 'Enter Promo Code', 'sw': 'Ingiza Namba ya Punguzo' },
    'cart_checkout': { 'en': 'Checkout', 'sw': 'Kukagua Malipo' },
  },

  // ═══════════════════════════════════════════════════════════
  // COMPONENTS
  // ═══════════════════════════════════════════════════════════
  {
    // ── Order Successful Popup ──
    'osp_title': { 'en': 'Order Successful', 'sw': 'Oda Imefanikiwa' },
    'osp_message': { 'en': 'You will receive a confirmation email.', 'sw': 'Utapokea barua pepe ya uthibitisho.' },
    'osp_view_order': { 'en': 'View Order Details', 'sw': 'Ona Maelezo ya Oda' },

    // ── Language Modal ──
    'lm_choose_title': { 'en': 'Choose your language', 'sw': 'Chagua lugha yako' },
    'lm_choose_sub': { 'en': 'Select your preferred language', 'sw': 'Chagua lugha unayopendelea' },
    'lm_swahili': { 'en': 'Swahili', 'sw': 'Kiswahili' },
    'lm_english': { 'en': 'English', 'sw': 'Kiingereza' },
    'lm_done': { 'en': 'Done', 'sw': 'Imekamilika' },
    'lm_native_en': { 'en': 'English', 'sw': 'English' },
    'lm_native_sw': { 'en': 'Kiswahili', 'sw': 'Kiswahili' },

    // ── Report Sheet ──
    'rs_title': { 'en': 'Report', 'sw': 'Ripoti' },
    'rs_reason_prompt': { 'en': 'Why are you reporting this?', 'sw': 'Kwa nini unaripoti hii?' },
    'rs_reason_spam': { 'en': 'Spam or misleading', 'sw': 'Uchafuzi au upotoshaji' },
    'rs_reason_inappropriate': { 'en': 'Inappropriate content', 'sw': 'Maudhui yasiyofaa' },
    'rs_reason_scam': { 'en': 'Scam or fraud', 'sw': 'Utapeli au udanganyifu' },
    'rs_reason_counterfeit': { 'en': 'Counterfeit product', 'sw': 'Bidhaa ghushi' },
    'rs_reason_offensive': { 'en': 'Offensive or hateful', 'sw': 'Maudhui ya kukera au chuki' },
    'rs_reason_other': { 'en': 'Other', 'sw': 'Nyingine' },
    'rs_details_hint': { 'en': 'Add details (optional)', 'sw': 'Ongeza maelezo (si lazima)' },
    'rs_submit': { 'en': 'Submit Report', 'sw': 'Tuma Ripoti' },
    'rs_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'rs_please_pick': { 'en': 'Please choose a reason', 'sw': 'Tafadhali chagua sababu' },
    'rs_thanks': { 'en': 'Thank you. Our team will review it.', 'sw': 'Asante. Timu yetu itaipitia.' },
    'rs_failed': { 'en': 'Could not submit: ', 'sw': 'Imeshindwa kutuma: ' },
    'rs_already': { 'en': 'You already reported this.', 'sw': 'Umesharipoti hii.' },

    // ── Buy Now Sheet ──
    'bn_title': { 'en': 'Buy Now', 'sw': 'Nunua Sasa' },
    'bn_product': { 'en': 'Product', 'sw': 'Bidhaa' },
    'bn_total': { 'en': 'Total', 'sw': 'Jumla' },
    'bn_address': { 'en': 'Delivery address', 'sw': 'Anwani ya uwasilishaji' },
    'bn_phone': { 'en': 'Phone number', 'sw': 'Namba ya simu' },
    'bn_full_name': { 'en': 'Full name', 'sw': 'Jina kamili' },
    'bn_note': { 'en': 'Note (optional)', 'sw': 'Maelezo (si lazima)' },
    'bn_place_order': { 'en': 'Place Order', 'sw': 'Weka Oda' },
    'bn_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'bn_please_fill': { 'en': 'Please fill all required fields', 'sw': 'Tafadhali jaza sehemu zote muhimu' },
    'bn_order_placed': { 'en': 'Order placed!', 'sw': 'Oda imewekwa!' },
    'bn_order_failed': { 'en': 'Order failed: ', 'sw': 'Oda imeshindikana: ' },
    'bn_sign_in_first': { 'en': 'Please sign in first', 'sw': 'Tafadhali ingia kwanza' },
    'bn_quantity': { 'en': 'Quantity', 'sw': 'Idadi' },
    'bn_price': { 'en': 'Price', 'sw': 'Bei' },
    'bn_confirm_order': { 'en': 'Confirm Order', 'sw': 'Thibitisha Oda' },
    'bn_your_order': { 'en': 'Your Order', 'sw': 'Oda Yako' },
    'bn_delivery': { 'en': 'Delivery Details', 'sw': 'Maelezo ya Uwasilishaji' },
    'bn_contact': { 'en': 'Contact Info', 'sw': 'Taarifa za Mawasiliano' },
  },

  // ═══════════════════════════════════════════════════════════
  // COMPONENTS — BATCH 1
  // ═══════════════════════════════════════════════════════════
  {
    // ── Language Modal ──
    'lm_title': { 'en': 'Language', 'sw': 'Lugha' },
    'lm_subtitle': { 'en': 'Choose your preferred language', 'sw': 'Chagua lugha unayopendelea' },
    'lm_english': { 'en': 'English', 'sw': 'Kiingereza' },
    'lm_swahili': { 'en': 'Swahili', 'sw': 'Kiswahili' },
    'lm_native_en': { 'en': 'English', 'sw': 'English' },
    'lm_native_sw': { 'en': 'Kiswahili', 'sw': 'Kiswahili' },
    'lm_done': { 'en': 'Done', 'sw': 'Imekamilika' },

    // ── Logout ──
    'logout_title': { 'en': 'Log out?', 'sw': 'Ondoka?' },
    'logout_body': { 'en': 'Are you sure you want to log out of your account?', 'sw': 'Una uhakika unataka kuondoka kwenye akaunti yako?' },
    'logout_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'logout_confirm': { 'en': 'Log out', 'sw': 'Ondoka' },

    // ── Order Successful Popup ──
    'osp_title': { 'en': 'Order Successful', 'sw': 'Oda Imefanikiwa' },
    'osp_message': { 'en': 'You will receive a confirmation email.', 'sw': 'Utapokea barua pepe ya uthibitisho.' },
    'osp_view_order': { 'en': 'View Order Details', 'sw': 'Ona Maelezo ya Oda' },

    // ── Buy Now Sheet ──
    'bn_confirm_title': { 'en': 'Confirm Order', 'sw': 'Thibitisha Oda' },
    'bn_confirm_sub': { 'en': 'Review before placing', 'sw': 'Angalia kabla ya kuweka' },
    'bn_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'bn_delivery_address': { 'en': 'Delivery Address', 'sw': 'Anwani ya Uwasilishaji' },
    'bn_no_address': { 'en': 'No address yet', 'sw': 'Hakuna anwani bado' },
    'bn_add_one': { 'en': 'Add one to continue', 'sw': 'Ongeza moja ili kuendelea' },
    'bn_add': { 'en': 'Add', 'sw': 'Ongeza' },
    'bn_address_fallback': { 'en': 'Address', 'sw': 'Anwani' },
    'bn_contact_phone': { 'en': 'Contact Phone', 'sw': 'Simu ya Mawasiliano' },
    'bn_delivery_notes': { 'en': 'Delivery Notes (optional)', 'sw': 'Maelezo ya Uwasilishaji (si lazima)' },
    'bn_notes_hint': { 'en': 'e.g. Blue house near the mosque', 'sw': 'mfano: Nyumba ya bluu karibu na msikiti' },
    'bn_phone_hint': { 'en': '712 345 678', 'sw': '712 345 678' },
    'bn_product_price': { 'en': 'Product price', 'sw': 'Bei ya bidhaa' },
    'bn_delivery': { 'en': 'Delivery', 'sw': 'Uwasilishaji' },
    'bn_free': { 'en': 'Free', 'sw': 'Bure' },
    'bn_total': { 'en': 'Total', 'sw': 'Jumla' },
    'bn_cash_delivery': { 'en': 'Cash on Delivery', 'sw': 'Malipo Ukipokea' },
    'bn_place_order': { 'en': 'Place Order', 'sw': 'Weka Oda' },
    'bn_cant_buy_own': { 'en': "You can't buy your own product.", 'sw': 'Huwezi kununua bidhaa yako mwenyewe.' },
    'bn_invalid_phone': { 'en': 'Enter a valid phone number', 'sw': 'Weka namba sahihi ya simu' },
    'bn_failed': { 'en': 'Failed to place order: ', 'sw': 'Imeshindwa kuweka oda: ' },
    'bn_new_order_title': { 'en': 'New Order Received', 'sw': 'Oda Mpya Imepokelewa' },
    'bn_order_placed_title': { 'en': 'Order Placed', 'sw': 'Oda Imewekwa' },
    'bn_order_placed_body_prefix': { 'en': 'Your order for "', 'sw': 'Oda yako ya "' },
    'bn_order_placed_body_suffix': { 'en': '" was placed successfully.', 'sw': '" imewekwa kikamilifu.' },
    'bn_ordered_prefix': { 'en': ' ordered "', 'sw': ' ameagiza "' },
    'bn_ordered_suffix': { 'en': '"', 'sw': '"' },

    // ── Write Review Sheet (bonus — was already on old keys) ──
    'wr_edit_title': { 'en': 'Edit your review', 'sw': 'Hariri maoni yako' },
    'wr_write_title': { 'en': 'Write a review', 'sw': 'Andika maoni' },
    'wr_your_rating': { 'en': 'YOUR RATING', 'sw': 'KADIRIO LAKO' },
    'wr_your_review': { 'en': 'YOUR REVIEW', 'sw': 'MAONI YAKO' },
    'wr_review_hint': { 'en': 'Share your experience with this product...', 'sw': 'Shiriki uzoefu wako na bidhaa hii...' },
    'wr_update': { 'en': 'Update Review', 'sw': 'Sasisha Maoni' },
    'wr_post': { 'en': 'Post Review', 'sw': 'Tuma Maoni' },
    'wr_empty': { 'en': 'Please write your review', 'sw': 'Tafadhali andika maoni yako' },
    'wr_saved': { 'en': 'Review saved!', 'sw': 'Maoni yamehifadhiwa!' },
    'wr_failed': { 'en': 'Failed: ', 'sw': 'Imeshindwa: ' },
  },

  // ═══════════════════════════════════════════════════════════
  // PROFILE EDIT PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'pe_header_title': { 'en': 'Edit Profile', 'sw': 'Hariri Wasifu' },
    'pe_header_sub': { 'en': 'Update your info', 'sw': 'Sasisha taarifa zako' },
    'pe_uploading': { 'en': 'Uploading...', 'sw': 'Inapakia...' },
    'pe_change_photo': { 'en': 'Change Photo', 'sw': 'Badilisha Picha' },
    'pe_upload_failed': { 'en': 'Upload failed — check your connection and try again.', 'sw': 'Kupakia kumeshindikana — angalia muunganisho wako na ujaribu tena.' },
    'pe_upload_failed_short': { 'en': 'Upload failed: ', 'sw': 'Kupakia kumeshindikana: ' },
    'pe_label_full_name': { 'en': 'Full Name', 'sw': 'Jina Kamili' },
    'pe_label_email': { 'en': 'Email Address', 'sw': 'Anwani ya Barua Pepe' },
    'pe_label_phone': { 'en': 'Phone Number', 'sw': 'Namba ya Simu' },
    'pe_label_gender': { 'en': 'Gender', 'sw': 'Jinsia' },
    'pe_label_birthday': { 'en': 'Birthday', 'sw': 'Siku ya Kuzaliwa' },
    'pe_name_hint': { 'en': 'Enter your name', 'sw': 'Weka jina lako' },
    'pe_email_hint': { 'en': 'Enter your email', 'sw': 'Weka barua pepe yako' },
    'pe_phone_hint': { 'en': '712 345 678', 'sw': '712 345 678' },
    'pe_birthday_hint': { 'en': 'Select your birthday', 'sw': 'Chagua siku ya kuzaliwa' },
    'pe_error_name_required': { 'en': 'Name is required', 'sw': 'Jina linahitajika' },
    'pe_error_name_short': { 'en': 'Name is too short', 'sw': 'Jina ni fupi sana' },
    'pe_error_email_required': { 'en': 'Email is required', 'sw': 'Barua pepe inahitajika' },
    'pe_error_email_invalid': { 'en': 'Enter a valid email', 'sw': 'Weka barua pepe sahihi' },
    'pe_error_phone_required': { 'en': 'Phone is required', 'sw': 'Namba ya simu inahitajika' },
    'pe_error_phone_invalid': { 'en': 'Enter a valid phone (10-13 digits)', 'sw': 'Weka namba sahihi (tarakimu 10-13)' },
    'pe_gender_male': { 'en': 'Male', 'sw': 'Mwanaume' },
    'pe_gender_female': { 'en': 'Female', 'sw': 'Mwanamke' },
    'pe_gender_other': { 'en': 'Other', 'sw': 'Nyingine' },
    'pe_save_changes': { 'en': 'Save Changes', 'sw': 'Hifadhi Mabadiliko' },
    'pe_fix_errors': { 'en': 'Please fix the errors above', 'sw': 'Tafadhali rekebisha makosa hapo juu' },
    'pe_updated': { 'en': 'Profile updated successfully', 'sw': 'Wasifu umesasishwa kikamilifu' },
    'pe_save_failed': { 'en': 'Save failed: ', 'sw': 'Kuhifadhi kumeshindikana: ' },
  },

  // ═══════════════════════════════════════════════════════════
  // RATE PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'rate_title': { 'en': 'Rate your experience', 'sw': 'Kadiria uzoefu wako' },
    'rate_subtitle': { 'en': 'Your feedback helps us improve', 'sw': 'Maoni yako yanatusaidia kuboresha' },
    'rate_how_rate': { 'en': 'How would you rate us?', 'sw': 'Unatukadiriaje?' },
    'rate_terrible': { 'en': 'Terrible', 'sw': 'Mbaya Sana' },
    'rate_amazing': { 'en': 'Amazing', 'sw': 'Nzuri Sana' },
    'rate_good': { 'en': 'Good', 'sw': 'Nzuri' },
    'rate_out_of_5': { 'en': ' out of 5', 'sw': ' kati ya 5' },
    'rate_write_review': { 'en': 'Write a review', 'sw': 'Andika maoni' },
    'rate_review_hint': { 'en': 'Tell us what you think... (optional)', 'sw': 'Tuambie unafikiria nini... (si lazima)' },
    'rate_quick_tags': { 'en': 'Quick tags', 'sw': 'Lebo za Haraka' },
    'rate_tag_easy': { 'en': 'Easy to use', 'sw': 'Rahisi kutumia' },
    'rate_tag_design': { 'en': 'Great design', 'sw': 'Muundo mzuri' },
    'rate_tag_fast': { 'en': 'Fast & reliable', 'sw': 'Haraka na ya kuaminika' },
    'rate_tag_needs_work': { 'en': 'Needs work', 'sw': 'Inahitaji kuboreshwa' },
    'rate_tag_love': { 'en': 'Love it!', 'sw': 'Naipenda!' },
    'rate_review_details': { 'en': 'Review details', 'sw': 'Maelezo ya maoni' },
    'rate_app_version': { 'en': 'App version', 'sw': 'Toleo la App' },
    'rate_source': { 'en': 'Source', 'sw': 'Chanzo' },
    'rate_post_purchase': { 'en': 'Post-purchase', 'sw': 'Baada ya Ununuzi' },
    'rate_submitted': { 'en': 'Submitted', 'sw': 'Imetumwa' },
    'rate_today': { 'en': 'Today', 'sw': 'Leo' },
    'rate_submit': { 'en': 'Submit Review', 'sw': 'Tuma Maoni' },
    'rate_private': { 'en': 'Your review is private and secure', 'sw': 'Maoni yako ni ya faragha na salama' },
    'rate_thanks': { 'en': 'Asante! Your review has been submitted successfully', 'sw': 'Asante! Maoni yako yametumwa kikamilifu' },
  },

  // ═══════════════════════════════════════════════════════════
  // REVIEWS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'rev_title': { 'en': 'Reviews', 'sw': 'Maoni' },
    'rev_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'rev_search_hint': { 'en': 'Search reviews...', 'sw': 'Tafuta maoni...' },
    'rev_all_reviews': { 'en': 'All reviews', 'sw': 'Maoni yote' },
    'rev_no_reviews': { 'en': 'No reviews yet', 'sw': 'Hakuna maoni bado' },
    'rev_count_one': { 'en': '1 review', 'sw': 'Maoni 1' },
    'rev_count_many': { 'en': ' reviews', 'sw': ' maoni' },
    'rev_delete_title': { 'en': 'Delete review?', 'sw': 'Futa maoni?' },
    'rev_delete_body': { 'en': 'This review will be permanently removed. Product rating will be recalculated.', 'sw': 'Maoni haya yataondolewa kabisa. Kadirio la bidhaa litahesabiwa upya.' },
    'rev_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'rev_deleted': { 'en': 'Review deleted', 'sw': 'Maoni yamefutwa' },
    'rev_delete_failed': { 'en': 'Failed to delete: ', 'sw': 'Imeshindwa kufuta: ' },
    'rev_you_suffix': { 'en': ' (You)', 'sw': ' (Wewe)' },
    'rev_seller_replied': { 'en': 'Seller replied', 'sw': 'Muuzaji amejibu' },
    'rev_time_just_now': { 'en': 'Just now', 'sw': 'Sasa hivi' },
    'rev_time_m_ago': { 'en': 'm ago', 'sw': 'dakika zilizopita' },
    'rev_time_h_ago': { 'en': 'h ago', 'sw': 'saa zilizopita' },
    'rev_time_d_ago': { 'en': 'd ago', 'sw': 'siku zilizopita' },
  },

  // ═══════════════════════════════════════════════════════════
  // SUPPORT CHAT
  // ═══════════════════════════════════════════════════════════
  {
    'sc_sign_in_first': { 'en': 'Please sign in first', 'sw': 'Tafadhali ingia kwanza' },
    'sc_user_fallback': { 'en': 'User', 'sw': 'Mtumiaji' },
    'sc_admin_view_sub': { 'en': 'Admin view', 'sw': 'Mwonekano wa Admin' },
    'sc_replies_minutes': { 'en': 'Usually replies in minutes', 'sw': 'Hujibu kwa dakika chache' },
    'sc_support_name': { 'en': 'ZanNext Support', 'sw': 'Msaada wa ZanNext' },
    'sc_admin_badge': { 'en': 'ADMIN', 'sw': 'ADMIN' },

    // ── Menu ──
    'sc_menu_view_profile': { 'en': 'View user profile', 'sw': 'Ona wasifu wa mtumiaji' },
    'sc_menu_mark_resolved': { 'en': 'Mark resolved', 'sw': 'Weka kama imetatuliwa' },
    'sc_menu_refresh': { 'en': 'Refresh', 'sw': 'Sasisha' },
    'sc_marked_resolved': { 'en': 'Marked as resolved', 'sw': 'Imewekwa kama imetatuliwa' },
    'sc_profile_soon': { 'en': 'User profile coming soon', 'sw': 'Wasifu wa mtumiaji unakuja hivi karibuni' },

    // ── Messages area ──
    'sc_could_not_load': { 'en': 'Could not load messages', 'sw': 'Imeshindwa kupakia ujumbe' },
    'sc_no_messages_admin': { 'en': 'No messages yet', 'sw': 'Hakuna ujumbe bado' },
    'sc_no_messages_user': { 'en': 'How can we help you?', 'sw': 'Tunawezaje kukusaidia?' },
    'sc_no_messages_admin_sub': { 'en': "The user hasn't sent any messages yet.", 'sw': 'Mtumiaji hajatuma ujumbe wowote bado.' },
    'sc_no_messages_user_sub': { 'en': 'Pick a topic below or type your own message.', 'sw': 'Chagua mada hapa chini au andika ujumbe wako.' },

    // ── Input ──
    'sc_input_admin': { 'en': 'Reply as Support...', 'sw': 'Jibu kama Msaada...' },
    'sc_input_user': { 'en': 'Type your message...', 'sw': 'Andika ujumbe wako...' },
    'sc_send_failed': { 'en': 'Send failed: ', 'sw': 'Imeshindwa kutuma: ' },

    // ── User quick replies ──
    'sc_qr_user_help': { 'en': 'I need help with my order', 'sw': 'Nahitaji msaada na oda yangu' },
    'sc_qr_user_arrive': { 'en': 'When will my product arrive?', 'sw': 'Bidhaa yangu itafika lini?' },
    'sc_qr_user_seller': { 'en': 'How do I become a seller?', 'sw': 'Nawezaje kuwa muuzaji?' },
    'sc_qr_user_refund': { 'en': 'How do I request a refund?', 'sw': 'Nawezaje kuomba kurudishiwa pesa?' },
    'sc_qr_user_payment': { 'en': 'Payment issue', 'sw': 'Tatizo la malipo' },

    // ── Admin quick replies ──
    'sc_qr_admin_hello': { 'en': 'Hello! How can I help you today?', 'sw': 'Habari! Nawezaje kukusaidia leo?' },
    'sc_qr_admin_eta': { 'en': 'Your order is on the way. ETA: 1-2 days.', 'sw': 'Oda yako iko njiani. Inakadiriwa kufika: siku 1-2.' },
    'sc_qr_admin_ordernum': { 'en': 'Please share your order number.', 'sw': 'Tafadhali toa namba yako ya oda.' },
    'sc_qr_admin_check': { 'en': 'Let me check that for you.', 'sw': 'Ngoja niangalie hilo kwa ajili yako.' },
    'sc_qr_admin_sorry': { 'en': 'Sorry for the inconvenience.', 'sw': 'Samahani kwa usumbufu.' },
    'sc_qr_admin_thanks': { 'en': 'Thanks for reaching out!', 'sw': 'Asante kwa kuwasiliana nasi!' },
    'sc_qr_admin_resolved': { 'en': 'Your issue has been resolved. ✅', 'sw': 'Tatizo lako limetatuliwa. ✅' },

    // ── Push notifications ──
    'sc_push_new_message': { 'en': 'New Support Message', 'sw': 'Ujumbe Mpya wa Msaada' },
  },

  // ═══════════════════════════════════════════════════════════
  // ABOUT APP PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'about_title': { 'en': 'About the App', 'sw': 'Kuhusu App' },
    'about_version_prefix': { 'en': 'Version ', 'sw': 'Toleo ' },
    'about_section_about': { 'en': 'ABOUT', 'sw': 'KUHUSU' },
    'about_desc': { 'en': 'ZanNext is a modern marketplace built for Tanzania. Buy and sell with confidence — chat with sellers, save your favourite products, and get updates the moment something changes.', 'sw': 'ZanNext ni soko la kisasa lililoundwa kwa Tanzania. Nunua na uza kwa ujasiri — ongea na wauzaji, hifadhi bidhaa unazopenda, na upate taarifa mara moja kitu kinapobadilika.' },
    'about_section_app_info': { 'en': 'APP INFO', 'sw': 'TAARIFA ZA APP' },
    'about_info_version': { 'en': 'Version', 'sw': 'Toleo' },
    'about_info_build': { 'en': 'Build', 'sw': 'Muundo' },
    'about_info_platform': { 'en': 'Platform', 'sw': 'Jukwaa' },
    'about_info_region': { 'en': 'Region', 'sw': 'Eneo' },
    'about_region_value': { 'en': 'Tanzania', 'sw': 'Tanzania' },
    'about_section_legal': { 'en': 'LEGAL', 'sw': 'SHERIA' },
    'about_terms': { 'en': 'Terms of Service', 'sw': 'Masharti ya Huduma' },
    'about_privacy': { 'en': 'Privacy Policy', 'sw': 'Sera ya Faragha' },
    'about_licenses': { 'en': 'Licenses', 'sw': 'Leseni' },
    'about_coming_soon': { 'en': ' — coming soon', 'sw': ' — inakuja hivi karibuni' },
    'about_footer_made': { 'en': 'Made with ❤️ in Tanzania', 'sw': 'Imetengenezwa kwa ❤️ Tanzania' },
    'about_footer_copyright_prefix': { 'en': '© ', 'sw': '© ' },
    'about_footer_copyright_suffix': { 'en': ' ZanNext. All rights reserved.', 'sw': ' ZanNext. Haki zote zimehifadhiwa.' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADD NEW ADDRESS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'ana_header_title': { 'en': 'Add New Address', 'sw': 'Ongeza Anwani Mpya' },
    'ana_header_sub': { 'en': 'Where should we deliver?', 'sw': 'Tuwasilishe wapi?' },
    'ana_section_location': { 'en': 'Location', 'sw': 'Mahali' },
    'ana_section_details': { 'en': 'Address Details', 'sw': 'Maelezo ya Anwani' },
    'ana_section_contact': { 'en': 'Contact & Building', 'sw': 'Mawasiliano na Jengo' },
    'ana_section_instructions': { 'en': 'Delivery Instructions', 'sw': 'Maelekezo ya Uwasilishaji' },
    'ana_label_type': { 'en': 'Address Type', 'sw': 'Aina ya Anwani' },
    'ana_label_home': { 'en': 'Home', 'sw': 'Nyumbani' },
    'ana_label_office': { 'en': 'Office', 'sw': 'Ofisi' },
    'ana_label_other': { 'en': 'Other', 'sw': 'Nyingine' },
    'ana_select_city': { 'en': 'Select city or region', 'sw': 'Chagua mji au mkoa' },
    'ana_hint_district': { 'en': 'Wilaya au Kata', 'sw': 'Wilaya au Kata' },
    'ana_hint_street': { 'en': 'Jina la mtaa', 'sw': 'Jina la mtaa' },
    'ana_hint_landmark': { 'en': 'Sehemu maarufu iliyo karibu', 'sw': 'Sehemu maarufu iliyo karibu' },
    'ana_hint_phone': { 'en': 'Namba ya simu', 'sw': 'Namba ya simu' },
    'ana_hint_house': { 'en': 'Namba ya nyumba', 'sw': 'Namba ya nyumba' },
    'ana_hint_notes': { 'en': 'Maelekezo zaidi ya kufika (mfano: nyumba ya rangi ya bluu)', 'sw': 'Maelekezo zaidi ya kufika (mfano: nyumba ya rangi ya bluu)' },
    'ana_save': { 'en': 'Save Address', 'sw': 'Hifadhi Anwani' },
    'ana_error_pick_type': { 'en': 'Chagua aina ya anwani', 'sw': 'Chagua aina ya anwani' },
    'ana_error_pick_city': { 'en': 'Chagua mji / mkoa', 'sw': 'Chagua mji / mkoa' },
    'ana_saved': { 'en': 'Anwani imehifadhiwa kikamilifu!', 'sw': 'Anwani imehifadhiwa kikamilifu!' },
    'ana_save_failed': { 'en': 'Imeshindwa kuhifadhi: ', 'sw': 'Imeshindwa kuhifadhi: ' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADMIN BROADCAST PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'ab_header_title': { 'en': 'Broadcast', 'sw': 'Tangazo' },
    'ab_header_sub': { 'en': 'Send to all users', 'sw': 'Tuma kwa watumiaji wote' },
    'ab_badge_all': { 'en': 'ALL', 'sw': 'WOTE' },
    'ab_section_templates': { 'en': 'Quick Templates', 'sw': 'Violezo vya Haraka' },
    'ab_section_type': { 'en': 'Notification Type', 'sw': 'Aina ya Taarifa' },
    'ab_section_title': { 'en': 'Title', 'sw': 'Kichwa' },
    'ab_section_message': { 'en': 'Message', 'sw': 'Ujumbe' },
    'ab_section_preview': { 'en': 'Preview', 'sw': 'Onyesho' },

    // ── Templates ──
    'ab_tpl_promo_title': { 'en': '🔥 Flash Sale — 30% OFF', 'sw': '🔥 Ofa ya Papo Hapo — 30% PUNGUFU' },
    'ab_tpl_promo_body': { 'en': 'For the next 24 hours, enjoy 30% off on all electronics. Shop now before it ends!', 'sw': 'Kwa masaa 24 yajayo, furahia punguzo la 30% kwenye vifaa vyote vya kielektroniki. Nunua sasa kabla isiishe!' },
    'ab_tpl_info_title': { 'en': 'New Feature Available', 'sw': 'Kipengele Kipya Kinapatikana' },
    'ab_tpl_info_body': { 'en': 'You can now save multiple delivery addresses. Update yours from your profile!', 'sw': 'Sasa unaweza kuhifadhi anwani nyingi za uwasilishaji. Sasisha yako kwenye wasifu wako!' },
    'ab_tpl_alert_title': { 'en': 'Scheduled Maintenance', 'sw': 'Matengenezo Yaliyopangwa' },
    'ab_tpl_alert_body': { 'en': 'The app will be under maintenance tonight from 2–3 AM. Thanks for your patience.', 'sw': 'App itafanyiwa matengenezo usiku wa leo kuanzia saa 8–9 usiku. Asante kwa uvumilivu wako.' },
    'ab_tpl_welcome_title': { 'en': 'Welcome to ZanNext!', 'sw': 'Karibu ZanNext!' },
    'ab_tpl_welcome_body': { 'en': 'Get 20% off your first order. Use code WELCOME20 at checkout.', 'sw': 'Pata punguzo la 20% kwenye oda yako ya kwanza. Tumia namba WELCOME20 wakati wa kulipa.' },

    // ── Type chips ──
    'ab_type_info': { 'en': 'Info', 'sw': 'Taarifa' },
    'ab_type_promo': { 'en': 'Promo', 'sw': 'Ofa' },
    'ab_type_alert': { 'en': 'Alert', 'sw': 'Tahadhari' },

    // ── Fields ──
    'ab_title_hint': { 'en': 'e.g. New arrivals this week', 'sw': 'mfano: Bidhaa mpya wiki hii' },
    'ab_body_hint': { 'en': 'Type the message users will receive...', 'sw': 'Andika ujumbe ambao watumiaji watapokea...' },
    'ab_preview_no_title': { 'en': '(No title)', 'sw': '(Hakuna kichwa)' },
    'ab_preview_just_now': { 'en': 'Just now · ZanNext', 'sw': 'Sasa hivi · ZanNext' },

    // ── Send bar ──
    'ab_send_all': { 'en': 'Send to All Users', 'sw': 'Tuma kwa Watumiaji Wote' },

    // ── Dialog + snackbars ──
    'ab_confirm_title': { 'en': 'Send to all users?', 'sw': 'Tuma kwa watumiaji wote?' },
    'ab_confirm_body': { 'en': 'This will send a notification to every user in the app. Continue?', 'sw': 'Hii itatuma taarifa kwa kila mtumiaji kwenye app. Endelea?' },
    'ab_confirm_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'ab_confirm_send': { 'en': 'Send', 'sw': 'Tuma' },
    'ab_error_title': { 'en': 'Please enter a title', 'sw': 'Tafadhali weka kichwa' },
    'ab_error_body': { 'en': 'Please enter a message', 'sw': 'Tafadhali weka ujumbe' },
    'ab_no_users': { 'en': 'No users found', 'sw': 'Hakuna watumiaji waliopatikana' },
    'ab_sent_prefix': { 'en': 'Broadcast sent to ', 'sw': 'Tangazo limetumwa kwa ' },
    'ab_sent_suffix': { 'en': ' users!', 'sw': ' watumiaji!' },
    'ab_failed': { 'en': 'Failed: ', 'sw': 'Imeshindwa: ' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADMIN CATEGORY EDITOR (bottom sheet)
  // ═══════════════════════════════════════════════════════════
  {
    'ace_title_prefix': { 'en': 'Edit "', 'sw': 'Hariri "' },
    'ace_title_suffix': { 'en': '"', 'sw': '"' },
    'ace_admin_only': { 'en': 'Admin only', 'sw': 'Admin pekee' },
    'ace_label_image_url': { 'en': 'IMAGE URL', 'sw': 'URL YA PICHA' },
    'ace_hint_image_url': { 'en': 'https://...', 'sw': 'https://...' },
    'ace_label_name': { 'en': 'LABEL', 'sw': 'JINA' },
    'ace_hint_name': { 'en': 'Category name', 'sw': 'Jina la kundi' },
    'ace_label_route': { 'en': 'ROUTE NAME', 'sw': 'JINA LA NJIA' },
    'ace_hint_route': { 'en': 'e.g. Specific_categories', 'sw': 'mfano: Specific_categories' },
    'ace_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'ace_save': { 'en': 'Save', 'sw': 'Hifadhi' },
    'ace_error_url': { 'en': 'Image URL must start with http:// or https://', 'sw': 'URL ya picha lazima ianze na http:// au https://' },
    'ace_saved': { 'en': 'Category updated', 'sw': 'Kundi limesasishwa' },
    'ace_failed': { 'en': 'Failed: ', 'sw': 'Imeshindwa: ' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADMIN ORDERS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'ao_header_title': { 'en': 'All Orders', 'sw': 'Oda Zote' },
    'ao_header_sub': { 'en': 'Swipe left to delete', 'sw': 'Sogeza kushoto kufuta' },
    'ao_search_hint': { 'en': 'Search by product, status, or address...', 'sw': 'Tafuta kwa bidhaa, hali, au anwani...' },
    'ao_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'ao_order_fallback': { 'en': 'Order', 'sw': 'Oda' },
    'ao_status_pending': { 'en': 'Pending', 'sw': 'Inasubiri' },
    'ao_delete_title': { 'en': 'Delete order?', 'sw': 'Futa oda?' },
    'ao_delete_body_prefix': { 'en': '"', 'sw': '"' },
    'ao_delete_body_suffix': { 'en': '" will be permanently removed from Firestore.', 'sw': '" itaondolewa kabisa kutoka Firestore.' },
    'ao_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'ao_deleted': { 'en': 'Order deleted', 'sw': 'Oda imefutwa' },
    'ao_delete_failed': { 'en': 'Could not delete: ', 'sw': 'Imeshindwa kufuta: ' },
    'ao_empty': { 'en': 'No orders yet', 'sw': 'Hakuna oda bado' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADMIN PRODUCTS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'ap_header_title': { 'en': 'All Products', 'sw': 'Bidhaa Zote' },
    'ap_header_sub': { 'en': 'Tap chips to toggle · swipe to delete', 'sw': 'Gusa chips kubadilisha · sogeza kufuta' },
    'ap_search_hint': { 'en': 'Search by product or seller...', 'sw': 'Tafuta kwa bidhaa au muuzaji...' },
    'ap_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'ap_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'ap_unknown_seller': { 'en': 'Unknown seller', 'sw': 'Muuzaji asiyefahamika' },
    'ap_by_prefix': { 'en': 'By ', 'sw': 'Na ' },
    'ap_chip_catalog': { 'en': 'Catalog', 'sw': 'Katalogi' },
    'ap_chip_new': { 'en': 'New', 'sw': 'Mpya' },
    'ap_chip_trending': { 'en': 'Trending', 'sw': 'Zinazovuma' },
    'ap_chip_boosted': { 'en': 'Boosted', 'sw': 'Imarishwa' },
    'ap_delete_title': { 'en': 'Delete product?', 'sw': 'Futa bidhaa?' },
    'ap_delete_body_prefix': { 'en': '"', 'sw': '"' },
    'ap_delete_body_suffix': { 'en': '" will be permanently removed.', 'sw': '" itaondolewa kabisa.' },
    'ap_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'ap_deleted': { 'en': 'Product deleted', 'sw': 'Bidhaa imefutwa' },
    'ap_delete_failed': { 'en': 'Could not delete: ', 'sw': 'Imeshindwa kufuta: ' },
    'ap_empty': { 'en': 'No products yet', 'sw': 'Hakuna bidhaa bado' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADMIN REPORTS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'ar_header_title': { 'en': 'Reports', 'sw': 'Ripoti' },
    'ar_header_sub': { 'en': 'Moderation queue', 'sw': 'Foleni ya Ukaguzi' },
    'ar_pending_suffix': { 'en': ' pending', 'sw': ' zinasubiri' },
    'ar_tab_pending': { 'en': 'Pending', 'sw': 'Zinasubiri' },
    'ar_tab_resolved': { 'en': 'Resolved', 'sw': 'Zimetatuliwa' },
    'ar_tab_dismissed': { 'en': 'Dismissed', 'sw': 'Zimekataliwa' },
    'ar_tab_all': { 'en': 'All', 'sw': 'Zote' },
    'ar_could_not_load': { 'en': 'Could not load reports', 'sw': 'Imeshindwa kupakia ripoti' },
    'ar_empty_pending_title': { 'en': 'No pending reports', 'sw': 'Hakuna ripoti zinazosubiri' },
    'ar_empty_other_title': { 'en': 'Nothing here', 'sw': 'Hakuna kitu hapa' },
    'ar_empty_pending_sub': { 'en': 'All caught up! Great job.', 'sw': 'Zote zimeshughulikiwa! Kazi nzuri.' },
    'ar_empty_other_sub': { 'en': 'Try a different filter above.', 'sw': 'Jaribu kichujio tofauti hapo juu.' },
    'ar_unknown': { 'en': 'Unknown', 'sw': 'Haijulikani' },
    'ar_anonymous': { 'en': 'Anonymous', 'sw': 'Bila jina' },
    'ar_target_prefix': { 'en': 'Target: ', 'sw': 'Lengo: ' },
    'ar_reported_by_prefix': { 'en': 'Reported by ', 'sw': 'Imeripotiwa na ' },
    'ar_action_resolve': { 'en': 'Resolve', 'sw': 'Tatua' },
    'ar_action_dismiss': { 'en': 'Dismiss', 'sw': 'Kataa' },
    'ar_marked_prefix': { 'en': 'Marked as ', 'sw': 'Imewekwa kama ' },
    'ar_resolved': { 'en': 'Report resolved', 'sw': 'Ripoti imetatuliwa' },
    'ar_dismissed': { 'en': 'Report dismissed', 'sw': 'Ripoti imekataliwa' },
    'ar_failed': { 'en': 'Failed: ', 'sw': 'Imeshindwa: ' },
    'ar_target_missing': { 'en': 'Target reference missing', 'sw': 'Rejeleo la lengo halipo' },
    'ar_delete_title_prefix': { 'en': 'Delete ', 'sw': 'Futa ' },
    'ar_delete_title_suffix': { 'en': '?', 'sw': '?' },
    'ar_delete_body_prefix': { 'en': 'This will permanently remove the ', 'sw': 'Hii itaondoa kabisa ' },
    'ar_delete_body_suffix': { 'en': ' from the app. The reporter will be notified.', 'sw': ' kutoka kwenye app. Aliyeripoti atajulishwa.' },
    'ar_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'ar_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'ar_deleted_suffix': { 'en': ' deleted and report resolved', 'sw': ' imefutwa na ripoti imetatuliwa' },
    'ar_type_product': { 'en': 'product', 'sw': 'bidhaa' },
    'ar_type_user': { 'en': 'user', 'sw': 'mtumiaji' },
    'ar_badge_fake': { 'en': 'FAKE', 'sw': 'GHUSHI' },
    'ar_time_now': { 'en': 'now', 'sw': 'sasa' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADMIN SELLERS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'as_header_title': { 'en': 'Sellers', 'sw': 'Wauzaji' },
    'as_header_sub': { 'en': 'Verify & manage', 'sw': 'Thibitisha na simamia' },
    'as_search_hint': { 'en': 'Search by name or email', 'sw': 'Tafuta kwa jina au barua pepe' },
    'as_could_not_load': { 'en': 'Could not load sellers', 'sw': 'Imeshindwa kupakia wauzaji' },
    'as_empty_title': { 'en': 'No sellers yet', 'sw': 'Hakuna wauzaji bado' },
    'as_empty_sub': { 'en': 'When users list products, they will appear here.', 'sw': 'Watumiaji wanapoorodhesha bidhaa, wataonekana hapa.' },
    'as_count_suffix': { 'en': ' sellers', 'sw': ' wauzaji' },
    'as_user_fallback': { 'en': 'User', 'sw': 'Mtumiaji' },
    'as_pill_admin': { 'en': 'ADMIN', 'sw': 'ADMIN' },
    'as_pill_verified': { 'en': 'VERIFIED', 'sw': 'IMETHIBITISHWA' },
    'as_pill_suspended': { 'en': 'SUSPENDED', 'sw': 'IMESIMAMISHWA' },
    'as_btn_verified': { 'en': 'Verified', 'sw': 'Imethibitishwa' },
    'as_btn_verify': { 'en': 'Verify', 'sw': 'Thibitisha' },
    'as_btn_unsuspend': { 'en': 'Unsuspend', 'sw': 'Ondoa Kusimamishwa' },
    'as_btn_suspend': { 'en': 'Suspend', 'sw': 'Simamisha' },
    'as_snack_verified': { 'en': 'Seller verified', 'sw': 'Muuzaji amethibitishwa' },
    'as_snack_verify_removed': { 'en': 'Verification removed', 'sw': 'Uthibitisho umeondolewa' },
    'as_snack_suspended': { 'en': 'Seller suspended', 'sw': 'Muuzaji amesimamishwa' },
    'as_snack_unsuspended': { 'en': 'Seller unsuspended', 'sw': 'Muuzaji ameondolewa kusimamishwa' },
    'as_failed': { 'en': 'Failed: ', 'sw': 'Imeshindwa: ' },
    'as_suspend_title': { 'en': 'Suspend seller?', 'sw': 'Simamisha muuzaji?' },
    'as_suspend_body': { 'en': 'This seller will no longer be able to list new products.', 'sw': 'Muuzaji huyu hataweza kuorodhesha bidhaa mpya tena.' },
    'as_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'as_suspend': { 'en': 'Suspend', 'sw': 'Simamisha' },
  },

  // ═══════════════════════════════════════════════════════════
  // ADMIN USERS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'au_header_title': { 'en': 'All Users', 'sw': 'Watumiaji Wote' },
    'au_header_sub': { 'en': 'Swipe left to delete', 'sw': 'Sogeza kushoto kufuta' },
    'au_search_hint': { 'en': 'Search by name or email...', 'sw': 'Tafuta kwa jina au barua pepe...' },
    'au_delete': { 'en': 'Delete', 'sw': 'Futa' },
    'au_user_fallback': { 'en': 'User', 'sw': 'Mtumiaji' },
    'au_badge_admin': { 'en': 'ADMIN', 'sw': 'ADMIN' },
    'au_delete_title_prefix': { 'en': 'Delete ', 'sw': 'Futa ' },
    'au_delete_title_suffix': { 'en': '?', 'sw': '?' },
    'au_delete_body_prefix': { 'en': '"', 'sw': '"' },
    'au_delete_body_suffix': { 'en': '" will be permanently removed from Firestore.', 'sw': '" itaondolewa kabisa kutoka Firestore.' },
    'au_cancel': { 'en': 'Cancel', 'sw': 'Ghairi' },
    'au_deleted': { 'en': 'User deleted', 'sw': 'Mtumiaji amefutwa' },
    'au_delete_failed': { 'en': 'Could not delete: ', 'sw': 'Imeshindwa kufuta: ' },
    'au_empty': { 'en': 'No users yet', 'sw': 'Hakuna watumiaji bado' },
    'au_kind_user': { 'en': 'user', 'sw': 'mtumiaji' },
  },

  // ═══════════════════════════════════════════════════════════
  // BOOSTED PRODUCTS PAGE
  // ═══════════════════════════════════════════════════════════
  {
    'bp_header_title': { 'en': '⭐ Boosted', 'sw': '⭐ Zilizoimarishwa' },
    'bp_header_sub': { 'en': 'Featured products', 'sw': 'Bidhaa zilizoangaziwa' },
    'bp_badge': { 'en': 'BOOSTED', 'sw': 'IMARISHA' },
    'bp_product_fallback': { 'en': 'Product', 'sw': 'Bidhaa' },
    'bp_empty': { 'en': 'No boosted products', 'sw': 'Hakuna bidhaa zilizoimarishwa' },
  },

  // ═══════════════════════════════════════════════════════════
  // LOCATION MODAL (bottom sheet from Home)
  // ═══════════════════════════════════════════════════════════
  {
    'loc_header_title': { 'en': 'Deliver to', 'sw': 'Inatumiwa kwenda' },
    'loc_header_sub': { 'en': 'Pick your region, district and ward', 'sw': 'Chagua mkoa, wilaya na kata yako' },
    'loc_section_region': { 'en': 'Region', 'sw': 'Mkoa' },
    'loc_section_district': { 'en': 'District', 'sw': 'Wilaya' },
    'loc_section_ward': { 'en': 'Ward / Area', 'sw': 'Kata / Eneo' },
    'loc_hint_select_region': { 'en': 'Select region', 'sw': 'Chagua mkoa' },
    'loc_hint_select_district': { 'en': 'Select district', 'sw': 'Chagua wilaya' },
    'loc_hint_select_district_first': { 'en': 'Select district first', 'sw': 'Chagua wilaya kwanza' },
    'loc_hint_select_ward': { 'en': 'Select ward', 'sw': 'Chagua kata' },
    'loc_save_button': { 'en': 'Save Location', 'sw': 'Hifadhi Mahali' },
    'loc_saved_prefix': { 'en': 'Location set to ', 'sw': 'Mahali pa kuwasilisha: ' },
    'loc_save_failed': { 'en': 'Save failed: ', 'sw': 'Imeshindwa kuhifadhi: ' },
  },

].reduce((a, b) => a..addAll(b));
