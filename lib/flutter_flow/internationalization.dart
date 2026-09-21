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

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? swText = '',
  }) =>
      [enText, swText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
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

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // ForgotPassword
  {
    'tnuptnog': {
      'en': 'Forgot Password',
      'sw': 'Umesahau Nenosiri',
    },
    'qxghhxm3': {
      'en': 'Enter your email and we will send you a reset link',
      'sw': 'Weka barua pepe yako tutakutumia kiungo cha kuweka upya nenosiri',
    },
    'bhek862l': {
      'en': 'Enter Email',
      'sw': 'Ingiza Barua Pepe',
    },
    'aqnejtkp': {
      'en': 'LOGIN',
      'sw': 'INGIA',
    },
    '0626g6d1': {
      'en': 'resetpasswordnotification',
      'sw': 'Taarifa ya kuweka upya nenosiri',
    },
    'sppsppzx': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // resetpasswordnotification
  {
    'pkc7znc1': {
      'en':
          'Please use the link sent to your email to set a new password for your account.',
      'sw':
          'Tafadhali tumia kiungo kilichotumwa kwenye barua pepe yako ili kuweka nenosiri jipya kwa akaunti yako.',
    },
    'wn2uzlor': {
      'en': 'Back to Sign in',
      'sw': 'Rudi Kwenye Sign in',
    },
    'q30lrctc': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // notifications_splash
  {
    'eoc7lj4s': {
      'en': 'No notifications yet',
      'sw': 'Bado hakuna taarifa',
    },
    'pnk2khdx': {
      'en': 'Discover categories',
      'sw': 'Gundua kategoria',
    },
    'jfhu04tc': {
      'en': 'Notifications',
      'sw': 'Taarifa',
    },
    '6050rkoh': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // order_splash
  {
    'jwyg6y0x': {
      'en': 'No orders yet',
      'sw': 'Huna oda bado',
    },
    'gl6ni56r': {
      'en': 'Discover categories',
      'sw': 'Gundua kategoria',
    },
    '7wvbz85h': {
      'en': 'Order notifications',
      'sw': 'Taarifa za oda',
    },
    '7n9abaci': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // notification_details
  {
    'e6jhk6lc': {
      'en': 'Notifications',
      'sw': 'Taarifa',
    },
    'rjwmo79k': {
      'en': 'Today',
      'sw':
          'brahim,umeweka agizo. Angalia historia ya maagizo yako kwa maelezo kamili.',
    },
    's0y1u2ce': {
      'en': 'No notifications yet',
      'sw': 'Bado hakuna taarifa',
    },
    '3xc36p8o': {
      'en': 'Discover categories',
      'sw': 'Gundua kategoria',
    },
    'z2w8rdkw': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Order_details
  {
    'hhyedn1h': {
      'en': 'Order',
      'sw': 'Oda',
    },
    'd49lakh1': {
      'en': 'Order',
      'sw': 'Nyumbani',
    },
  },
  // emptycart
  {
    '0n6l1afi': {
      'en': 'Your cart is empty',
      'sw': 'Sanduku ni tupu',
    },
    'gqmbownm': {
      'en': 'Discover categories',
      'sw': 'Gundua kategoria',
    },
    'caiptff6': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Cart
  {
    'kdg4y44p': {
      'en': 'Futa',
      'sw': '',
    },
    'g34xq6uq': {
      'en': 'Saizi ',
      'sw': '',
    },
    '5x6nlbj1': {
      'en': '- ',
      'sw': '',
    },
    '2fgxv0cp': {
      'en': '   ',
      'sw': '',
    },
    'v5478j0p': {
      'en': 'Color',
      'sw': 'Rangi',
    },
    '8dvc6kuv': {
      'en': ' - ',
      'sw': '',
    },
    'lv31o219': {
      'en': 'Shipping Cost',
      'sw': 'Gharama ya Usafirishaji',
    },
    'je835csc': {
      'en': 'Tax',
      'sw': 'Kodi',
    },
    'rbwn07sz': {
      'en': 'Total',
      'sw': 'Jumla',
    },
    'ztw6r6h7': {
      'en': 'Enter Promo Code',
      'sw': 'Ingiza Namba ya Punguzo',
    },
    'zf6nc7ok': {
      'en': 'Checkout',
      'sw': 'Kukagua Malipo',
    },
    'vuec2yj9': {
      'en': 'cart',
      'sw': 'Sanduku',
    },
    'mrom0wbg': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Checkout
  {
    's1ahv8r0': {
      'en': 'Toa zote',
      'sw': '',
    },
    '7ohr8nyx': {
      'en': 'Anuwani ya Usafirishaji',
      'sw': '',
    },
    'z7175q1z': {
      'en': 'Weka Anuwani ya Usafirishaji',
      'sw': '',
    },
    'o0m6cyk3': {
      'en': 'Njia ya malipo',
      'sw': '',
    },
    'slmuh1op': {
      'en': 'Ongeza njia ya malipo',
      'sw': '',
    },
    'ohv2ezmu': {
      'en': 'Gharama ya Usafirishaji',
      'sw': 'Gharama ya Usafirishaji',
    },
    'blck8gru': {
      'en': 'Jumla',
      'sw': 'Jumla',
    },
    'a24ga8il': {
      'en': 'Weka Agizo Lako',
      'sw': '',
    },
    'apgrf27c': {
      'en': 'Kukagua malipo',
      'sw': '',
    },
    'i9hqhoec': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // order_successiful
  {
    'o77h31o3': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Wishlist
  {
    'b1jlncob': {
      'en': 'My Preferences',
      'sw': 'Mapendeleo yangu',
    },
    'ibwkiavl': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Wishlistfovorite
  {
    'rztemc4r': {
      'en': 'My Preferences',
      'sw': 'Mapendeleo Yangu',
    },
    'uytce9v4': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // splash
  {
    'dn452uks': {
      'en': 'ZanNext',
      'sw': 'ZanNext',
    },
  },
  // signinIngia
  {
    'rsqpumaf': {
      'en': 'Login to Your Account',
      'sw': 'Ingia kwenye Akaunti Yako',
    },
    'jltt1m0y': {
      'en': 'Email Address',
      'sw': 'Barua Pepe',
    },
    'w2ao7wuf': {
      'en': 'Password',
      'sw': 'Nenosiri',
    },
    'uywnjo33': {
      'en': 'Forgot Password?',
      'sw': 'Umesahau Nenosiri?',
    },
    '2b08b7bd': {
      'en': 'Log In',
      'sw': 'Ingia',
    },
    'syo5mb3j': {
      'en': 'Don\'t have an account?',
      'sw': 'Huna Akaunti?',
    },
    'hc072vh1': {
      'en': 'Sign Up',
      'sw': 'Jisajili',
    },
  },
  // signinContinueKaribu
  {
    'c2ntmbc7': {
      'en': 'Welcome Ibrahim!',
      'sw': 'Karibu Ibrahim!',
    },
    'ai6vtd19': {
      'en': 'We have great products for you!',
      'sw': 'Tuna bidhaa nzuri kwa ajili yako!',
    },
    '2db05ecw': {
      'en': 'Continue Shopping',
      'sw': 'Endelea Kununua',
    },
  },
  // Home
  {
    '1wz8c5sn': {
      'en': 'Welcome to ZanNext!',
      'sw': 'Karibu ZanNext!',
    },
    'dt0ok2fd': {
      'en': 'Get 20% OFF your first order',
      'sw': 'Pata punguzo la 20% oda ya kwanza',
    },
    'yvxkacxb': {
      'en': 'Claim Offer',
      'sw': 'Chukua Ofa',
    },
    '5k326wof': {
      'en': 'Fresh Today',
      'sw': 'Bidhaa Mpya Leo',
    },
    '81780010': {
      'en': 'Shop the latest trends in town.',
      'sw': 'Nunua mitindo ya kisasa zaidi mjini',
    },
    'gbybdpey': {
      'en': 'Shop Newest',
      'sw': 'Nunua Bidhaa Mpya',
    },
    'b61p4m4v': {
      'en': 'Fast & Secure Delivery',
      'sw': 'Usafirishaji wa Haraka na Salama',
    },
    'co903htq': {
      'en': 'From our store to your door.',
      'sw': 'Kutoka dukani mpaka mlangoni kwako',
    },
    'ysez5unl': {
      'en': 'Order Now',
      'sw': 'Agiza Sasa',
    },
    'rpat62r2': {
      'en': 'Quality You Can Trust',
      'sw': 'Ubora Unaoweza Kuamini',
    },
    'nciy97mk': {
      'en': 'Premium products at the best prices',
      'sw': 'Bidhaa bora kwa bei nafuu',
    },
    '7c0d83pg': {
      'en': 'Shop Quality',
      'sw': 'Nunua Bidhaa Bora',
    },
    'sewcjbvf': {
      'en': 'We’re Here for You',
      'sw': 'Tupo hapa kwa ajili yako',
    },
    't010gnx0': {
      'en': '24/7 Dedicated Customer Support.',
      'sw': 'Huduma kwa Wateja Saa 24',
    },
    'sleka31c': {
      'en': 'Chat With Us',
      'sw': 'Ongea nasi',
    },
    'c7gxdsxp': {
      'en': 'Shop Category',
      'sw': 'Nunua kwa Jamii',
    },
    'pmhmguyd': {
      'en': 'See all',
      'sw': 'Ona zote',
    },
    'hi3oa9pn': {
      'en': 'Computers & Laptops',
      'sw': 'Kompyuta na Mpito',
    },
    'ckkjz6bw': {
      'en': 'Men’s Wear',
      'sw': 'Mavazi ya Wanaume',
    },
    '4gctyhxj': {
      'en': 'Furniture',
      'sw': 'Samani',
    },
    'pv0ughiu': {
      'en': 'Wearables',
      'sw': 'Vifaa vya Kuvaa',
    },
    'bbomrrnb': {
      'en': 'Luxury Watches',
      'sw': 'Saa za Kifahari',
    },
    'w9tkhbbf': {
      'en': 'Bracelets & Earrings',
      'sw': 'Vikuku na Heleni',
    },
    'ywg5460f': {
      'en': 'Laundry',
      'sw': 'Dobi',
    },
    'hhkgn4p5': {
      'en': 'More',
      'sw': 'Zaidi',
    },
    '4n96ea24': {
      'en': 'Trending Products',
      'sw': 'Bidhaa Zinazovuma',
    },
    'jvt45nus': {
      'en': 'See All',
      'sw': 'Ona zote',
    },
    'nysb51jq': {
      'en': 'New Arrivals',
      'sw': 'Bidhaa Mpya',
    },
    '1s49pc9s': {
      'en': 'See All',
      'sw': 'Ona zote',
    },
    'npwssap5': {
      'en': 'Start selling and achieve\nyour business goals.',
      'sw': 'Anza kuuza na utimize malengo yako ya biashara.',
    },
    '1ks3t7d1': {
      'en': 'New Products',
      'sw': 'Jiunge na Soko letu',
    },
    '4gyar5ix': {
      'en': 'Full Catalog',
      'sw': 'Katalogi Kamili',
    },
    '2y629v6r': {
      'en': 'Delivered to',
      'sw': 'Inatumiwa kwenda',
    },
    'gxo9j66r': {
      'en': 'ZanNext',
      'sw': 'ZanNext',
    },
    'gdj7z02c': {
      'en': 'Search for products...',
      'sw': 'Tafuta bidhaa...',
    },
    '6oj2l8wh': {
      'en': 'Sell Now',
      'sw': 'Uza Sasa',
    },
    '10v0tqve': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Search
  {
    'xygtttf4': {
      'en': 'Recent Search',
      'sw': 'Utafutaji wa Hivi Karibuni',
    },
    'kmodey01': {
      'en': 'Clear all',
      'sw': 'Futa zote',
    },
    'pu1bepj6': {
      'en': 'Last Seen',
      'sw': 'Zilizotazamwa Mwisho',
    },
    'fksp85zk': {
      'en': 'Search',
      'sw': 'Tafuta',
    },
    'vj09zg28': {
      'en': 'tafuta bidhaa...',
      'sw': 'tafuta bidhaa...',
    },
    '7zr98z4w': {
      'en': 'Option 1',
      'sw': 'Chaguo la 1',
    },
    'ckumm3vh': {
      'en': 'Search',
      'sw': 'Tafuta',
    },
  },
  // signin
  {
    'q6go2ltd': {
      'en': 'ZanNext',
      'sw': 'ZanNext',
    },
    '923rxozh': {
      'en': 'Welcome back! Log into your account',
      'sw': 'Karibu tena! Ingia kwenye akaunti yako',
    },
    'niu8f9k6': {
      'en': 'Email',
      'sw': 'Barua Pepe',
    },
    '7uwf19oq': {
      'en': 'Email or phone number',
      'sw': 'Barua pepe au namba ya simu',
    },
    'l49mcwng': {
      'en': 'Password',
      'sw': 'Nenosiri',
    },
    '4x2mlr10': {
      'en': 'Enter your password',
      'sw': 'Weka nenosiri lako',
    },
    's77z9kaa': {
      'en': 'Forgot password?',
      'sw': 'Umesahau nenosiri?',
    },
    'k27igpak': {
      'en': 'Log In',
      'sw': 'Ingia',
    },
    'ndzjngs7': {
      'en': 'or',
      'sw': 'au',
    },
    'vf7faqry': {
      'en': 'Continue with Google',
      'sw': 'Endelea na Google',
    },
    '6a88wqxz': {
      'en': 'Continue with Apple',
      'sw': 'Endelea na Apple',
    },
    'tzbppw2d': {
      'en': 'Don\'t have an account?',
      'sw': 'Je, huna akaunti?',
    },
    'qq3xmrk9': {
      'en': 'Sign up here',
      'sw': 'Jisajili hapa',
    },
  },
  // Setting_payment
  {
    'q773ujm5': {
      'en': 'Ongeza Njia ya Malipo',
      'sw': '',
    },
    'jde93z6n': {
      'en': 'Njia ya Malipo',
      'sw': '',
    },
    'j6mg3kvp': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // settingAddPyment
  {
    '47gmh3lc': {
      'en': 'Jina Kwenye Kadi',
      'sw': '',
    },
    'd51k43wu': {
      'en': 'Namba ya kadi',
      'sw': '',
    },
    'i9y4zlyc': {
      'en': 'namba 3 za siri',
      'sw': '',
    },
    'kl8m450z': {
      'en': 'Tarehe ya kuisha',
      'sw': '',
    },
    'jzznyn9f': {
      'en': 'Unaweza kulipa kwa Fedha Za Siimu',
      'sw': '',
    },
    'jb9ez0wy': {
      'en': 'Jina la mmiliki',
      'sw': '',
    },
    '3u663zzl': {
      'en': 'Jina la laini',
      'sw': '',
    },
    'wm7wk6o0': {
      'en': 'Namba ya simu',
      'sw': '',
    },
    'lbg2stu0': {
      'en': 'Hifadhi',
      'sw': '',
    },
    'bk46ye6c': {
      'en': 'Taarifa za Malipo',
      'sw': '',
    },
    'lytvckx9': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // shopByCategoriesSearchFilterDeals
  {
    'vkjxx576': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Product_Details
  {
    '1veiu9f9': {
      'en': 'Free Shipping in Zanzibar',
      'sw': 'Usafirishaji Bure Zanzibar',
    },
    '822oj3nv': {
      'en': 'Product Details',
      'sw': 'Maelezo ya Bidhaa',
    },
    'yyned7kx': {
      'en': 'Call Now',
      'sw': 'Piga Simu Sasa',
    },
    'or7q3ngf': {
      'en': 'Message Seller',
      'sw': 'Mtumie Muuzaji Ujumbe',
    },
    'munbd5dl': {
      'en': 'Chat with Seller',
      'sw': 'Zungumza na Muuzaji',
    },
    'bcm5blb6': {
      'en': 'Is it available?',
      'sw': 'Bado ipo?',
    },
    'alfz35hy': {
      'en': 'Last price?',
      'sw': 'Bei ya mwisho?',
    },
    '0j1hyomk': {
      'en': 'Make an offer',
      'sw': 'Toa ofa yako',
    },
    'glpsdac2': {
      'en': 'Recommended',
      'sw': 'Mapendekezo',
    },
    'v1ndpjsw': {
      'en': 'Details',
      'sw': 'Maelezo',
    },
    '0u7el7mq': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // paymnet_method
  {
    'dckd02so': {
      'en': 'Njia za Malipo',
      'sw': '',
    },
    'vmqx9b0i': {
      'en': 'Phone Number',
      'sw': '',
    },
    '1b16m0au': {
      'en': 'Enter phone number',
      'sw': '',
    },
    'r14gjj6k': {
      'en': 'Malipo ya Benki',
      'sw': '',
    },
    '4n5f58zd': {
      'en': 'CRDB Bank',
      'sw': '',
    },
    'h6z360co': {
      'en': 'Online Banking',
      'sw': '',
    },
    'a1a7g3rl': {
      'en': 'NMB Bank',
      'sw': '',
    },
    'fuidhswp': {
      'en': 'Online Banking',
      'sw': '',
    },
    'obxkqgxe': {
      'en': 'PBZ Bank',
      'sw': '',
    },
    'bsu9xa9e': {
      'en': 'Online Banking',
      'sw': '',
    },
    'vb7edw4h': {
      'en': 'Chaguo Jengine',
      'sw': '',
    },
    'rw22xajg': {
      'en': 'Malipo Wakati wa Kufikishwa',
      'sw': '',
    },
    'arjljbeh': {
      'en': 'Zanzibar ',
      'sw': '',
    },
    '2tvmpnar': {
      'en': 'Malipo kwa Kadi',
      'sw': '',
    },
    'h16zhx38': {
      'en': 'Visa/Mastercard',
      'sw': '',
    },
    'xj5pwyip': {
      'en': 'Ongeza Njia Mpya ya Malipo',
      'sw': '',
    },
    'w10eayft': {
      'en': 'Taarifa yako ya malipo imesimbwa na iko salama.',
      'sw': '',
    },
  },
  // trendingProduct
  {
    'ju8ldh4l': {
      'en': 'Trending Products',
      'sw': 'Bidhaa Zinazovuma',
    },
    'us0owi0u': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // newProducts
  {
    'v83fk43m': {
      'en': 'New Products',
      'sw': 'Bidhaa Mpya',
    },
    'rgcgmo7z': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // zannextSignIn
  {
    'uckps513': {
      'en': 'ZanNext',
      'sw': '',
    },
    'siscl9ye': {
      'en': 'Karibu tena ZanNext!  ',
      'sw': '',
    },
    'edw0qfh6': {
      'en': 'Tafadhali anza kwa kujaza fomu hapa chini.',
      'sw': '',
    },
    'agul8k4n': {
      'en': 'Email',
      'sw': '',
    },
    'tpiyx0tm': {
      'en': 'Password',
      'sw': '',
    },
    'laak6ky5': {
      'en': 'Ingia',
      'sw': '',
    },
    'z6pxucp5': {
      'en': 'OR',
      'sw': '',
    },
    'jt0vyxma': {
      'en': 'Continue with Google',
      'sw': '',
    },
    'w3rpz3wd': {
      'en': 'Continue with Apple',
      'sw': '',
    },
    'z3ggwsgw': {
      'en': 'Hauna akaunti? ',
      'sw': '',
    },
    '06z8noht': {
      'en': 'Jisajili hapa',
      'sw': '',
    },
    'ypqqcyh4': {
      'en': 'UserName',
      'sw': '',
    },
    'zhegbnh0': {
      'en': 'Overall',
      'sw': '',
    },
    'j38ekgbz': {
      'en': '5',
      'sw': '',
    },
    '4j0vp2dq': {
      'en':
          'Nice outdoor courts, solid concrete and good hoops for the neighborhood.',
      'sw': '',
    },
    'krnev8xs': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // LogIn
  {
    'oy9jftp8': {
      'en': 'ZanNext',
      'sw': 'ZanNext',
    },
    'd6khyhuo': {
      'en': 'Welcome back!',
      'sw': 'Karibu tena ZanNext!',
    },
    'qot9oidp': {
      'en': 'Hello! Let’s start your journey to ZanNext!',
      'sw': 'Habari! Tuuanze safari yako ya ZanNext!',
    },
    'tbti71qe': {
      'en': 'Email',
      'sw': 'Barua pepe',
    },
    'v4sl9ovs': {
      'en': 'Password',
      'sw': 'Nenosiri',
    },
    '5xww6t1m': {
      'en': 'Remember me',
      'sw': 'Nikumbuke',
    },
    'gn7b0s1y': {
      'en': 'Hello World',
      'sw': 'Habari Duniani',
    },
    'rtyx1cyb': {
      'en': 'Forget Password',
      'sw': 'Umesahau Nenosiri?',
    },
    'och1thde': {
      'en': 'Hello World',
      'sw': 'Habari Duniani',
    },
    'wkojjo95': {
      'en': 'Sign In',
      'sw': 'Ingia',
    },
    'g1nwqy20': {
      'en': 'Or sign in with',
      'sw': 'Au ingia kwa',
    },
    'j6y4hfyg': {
      'en': 'Continue with Google',
      'sw': 'Endelea na Google',
    },
    '4co5kf3q': {
      'en': 'Continue with Apple',
      'sw': 'Endelea na Apple',
    },
    'abyfdpel': {
      'en': 'Don\'t have an account?  ',
      'sw': 'Huna akaunti?',
    },
    '1fnixxse': {
      'en': 'Sign Up here',
      'sw': 'Jisajili hapa',
    },
    'mykyuj8q': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // audiocall
  {
    'uxhmhq23': {
      'en': 'Barbarella Inova',
      'sw': 'Barbarella Inova',
    },
    '6kxhrtch': {
      'en': '01:38 minutes',
      'sw': 'Dakika 01:38',
    },
    '276qf7np': {
      'en': 'Keypad',
      'sw': 'Kibonyezo',
    },
    'fe6ev83n': {
      'en': 'Mute',
      'sw': 'Nyamazisha',
    },
    'ntydx5vc': {
      'en': 'Speaker',
      'sw': 'Spika',
    },
    'd885wddq': {
      'en': 'More',
      'sw': 'Zaidi',
    },
    'meo4crrb': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Profile
  {
    'yy8nppe0': {
      'en': 'Profile',
      'sw': 'Wasifu',
    },
    'a6r56755': {
      'en': 'Add Product',
      'sw': 'Ongeza Bidhaa',
    },
    'wy5fat62': {
      'en': 'My Products',
      'sw': 'Bidhaa Zangu',
    },
    'nxxbn6so': {
      'en': 'Orders',
      'sw': 'Oda',
    },
    'avlyz9lq': {
      'en': 'Analytics',
      'sw': 'Takwimu',
    },
    'cxj5fack': {
      'en': 'Status: On the way',
      'sw': 'Hali: Iko njiani',
    },
    'exa8pama': {
      'en': '1234 Park Avenue, Apt 12B New York, NY 10016',
      'sw': '1234 Park Avenue, Apt 12B New York, NY 10016',
    },
    '2si2vxa1': {
      'en': 'Your balance is',
      'sw': 'Salio lako ni',
    },
    'vxhllvsb': {
      'en': 'ZanNext',
      'sw': 'ZanNext',
    },
    'wq2aa696': {
      'en': '\$17,269',
      'sw': '\$17,269',
    },
    '5d2edomi': {
      'en': 'General',
      'sw': 'Jumla',
    },
    'seq2nx1x': {
      'en': 'Edit Profile',
      'sw': 'Hariri Wasifu',
    },
    'wd9uharo': {
      'en': 'My orders',
      'sw': 'Oda zangu',
    },
    'xsxj41xp': {
      'en': 'My Favorites',
      'sw': 'Vipendwa Vyangu',
    },
    'q6hewhbd': {
      'en': 'Account Settings',
      'sw': 'Mipangilio ya Akaunti',
    },
    '9m36o4x8': {
      'en': 'Addresses',
      'sw': 'Anwani',
    },
    'o50cjxdk': {
      'en': 'Notification',
      'sw': 'Taarifa',
    },
    'zjssgg77': {
      'en': 'Appearance',
      'sw': 'Muonekano',
    },
    'h59xiith': {
      'en': 'Default',
      'sw': 'Chaguomsingi',
    },
    'lk1jp59q': {
      'en': 'Light',
      'sw': 'Mwanga',
    },
    'evdqmewx': {
      'en': 'Dark',
      'sw': 'Giza',
    },
    '1v6040ay': {
      'en': 'Language',
      'sw': 'Lugha',
    },
    'u6tru9pt': {
      'en': 'Swahili',
      'sw': 'Kiswahili',
    },
    '7k8jkokt': {
      'en': 'English',
      'sw': 'Kiingereza',
    },
    '11dcnfdk': {
      'en': 'Other',
      'sw': 'Nyingine',
    },
    'e7qy19js': {
      'en': 'Rate the App',
      'sw': 'Ithibitishe App',
    },
    'c4q2cj8g': {
      'en': 'Invite Freends',
      'sw': 'Alika Marafiki',
    },
    'fx8zl4eq': {
      'en': 'App & Legal',
      'sw': 'App na Sheria',
    },
    'l82hsox4': {
      'en': 'Help Center',
      'sw': 'Kituo cha Msaada',
    },
    'dpklkj5t': {
      'en': 'About the App',
      'sw': 'Kuhusu App',
    },
    'tx1x9iyw': {
      'en': '1.02.135',
      'sw': '1.02.135',
    },
    'w06mtydg': {
      'en': 'Logout',
      'sw': 'Ondoka',
    },
    'x2n68n47': {
      'en': 'Profile',
      'sw': 'Nyumbani',
    },
  },
  // ProfileEdit
  {
    'ni75vinp': {
      'en': 'Edit Profile',
      'sw': 'Hariri Wasifu',
    },
    '1qzws35s': {
      'en': 'Name',
      'sw': 'Jina',
    },
    'a1d4pl50': {
      'en': 'Enter your name',
      'sw': 'Ingiza jina lako',
    },
    '9kuxmyqi': {
      'en': 'Email',
      'sw': 'Barua pepe',
    },
    '9k6xkbo0': {
      'en': 'Enter your email',
      'sw': 'Ingiza barua pepe yako',
    },
    's3c26eo2': {
      'en': 'Mobile',
      'sw': 'Simu ya mkononi',
    },
    'ldrqrysi': {
      'en': 'Enter your phone number',
      'sw': 'Ingiza namba yako ya simu',
    },
    'k9sznwao': {
      'en': 'Gender',
      'sw': 'Jinsia',
    },
    '7citznnc': {
      'en': 'Male\n',
      'sw': 'Mwanaume',
    },
    'cihivu32': {
      'en': 'Female\n',
      'sw': 'Mwanamke',
    },
    'ky448bmq': {
      'en': 'Other',
      'sw': 'Nyingine',
    },
    '502rq0zt': {
      'en': 'Birth date',
      'sw': 'Tarehe ya kuzaliwa',
    },
    '9huad7du': {
      'en': '01/01/2005',
      'sw': '01/01/2005',
    },
    'k788khbu': {
      'en': 'Save Changes',
      'sw': 'Hifadhi Mabadiliko',
    },
    '9i7weya7': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // myAdress
  {
    '0whiznii': {
      'en': 'My Addresses',
      'sw': 'Anwani Zangu',
    },
    'v0rpfoob': {
      'en': 'Multiple addresses',
      'sw': 'Anwani nyingi',
    },
    '0xb9r983': {
      'en': 'Add multiple addresses,  \nit\'s very easy',
      'sw': 'Ongeza anwani nyingi, ni rahisi sana',
    },
    'r6knf82p': {
      'en': 'Add Another Address',
      'sw': 'Ongeza Anwani Nyingine',
    },
    'shxc7b4n': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // AddNewadress
  {
    'dc4amxie': {
      'en': 'Add New Address',
      'sw': 'Ongeza Anwani Mpya',
    },
    'f36bnvui': {
      'en': 'Address Label',
      'sw': 'Jina la Anwani',
    },
    'bw43snrp': {
      'en': 'Select...',
      'sw': 'Chagua...',
    },
    'asj9ukp4': {
      'en': 'Search...',
      'sw': 'Tafuta...',
    },
    'u847rxp3': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
    'vgieavew': {
      'en': 'Office',
      'sw': 'Ofisi',
    },
    'esx55s1i': {
      'en': 'City / Region',
      'sw': 'Mji / Mkoa',
    },
    'tw02hqop': {
      'en': 'Select City',
      'sw': 'Chagua mji',
    },
    'hmbl7w65': {
      'en': 'Search...',
      'sw': 'Tafuta...',
    },
    'cjnf8quk': {
      'en': 'Mjini Magharibi (Unguja)',
      'sw': 'Mjini Magharibi (Unguja)',
    },
    '2229adfh': {
      'en': 'Kaskazini Unguja',
      'sw': '',
    },
    '7u2112az': {
      'en': 'Kusini Unguja',
      'sw': '',
    },
    '2cpxosx9': {
      'en': 'Kaskazini Pemba',
      'sw': '',
    },
    'iauoyyk0': {
      'en': 'Kusini Pemba',
      'sw': '',
    },
    'bf25nbe6': {
      'en': 'Dar es Salaam',
      'sw': '',
    },
    'rk7wboc4': {
      'en': 'Arusha',
      'sw': '',
    },
    '6rueboxi': {
      'en': 'Mwanza',
      'sw': '',
    },
    'vqseto5t': {
      'en': 'Dodoma',
      'sw': '',
    },
    '1djpm4ma': {
      'en': 'Tanga',
      'sw': '',
    },
    'vrjfzabv': {
      'en': 'Kilimanjaro',
      'sw': '',
    },
    'ivtufsr4': {
      'en': 'District /Ward',
      'sw': '',
    },
    'nhf7p2ca': {
      'en': 'Taja Wilaya au Kata',
      'sw': '',
    },
    'umjmnopr': {
      'en': 'Street / Area',
      'sw': '',
    },
    'ky26rf4w': {
      'en': 'Jina la mtaa',
      'sw': '',
    },
    'lhzsu0nj': {
      'en': 'Landmark',
      'sw': '',
    },
    '18ppubnk': {
      'en': 'Sehemu maarufu iliyo karibu',
      'sw': '',
    },
    'c2iahje8': {
      'en': 'Phone Number',
      'sw': '',
    },
    't9j2pnw9': {
      'en': 'Namba  ya mpokeaji',
      'sw': '',
    },
    'jzaz5lf2': {
      'en': 'House Number',
      'sw': '',
    },
    'i73v95z6': {
      'en': 'Namba ya nyumba',
      'sw': '',
    },
    'zxqvksqy': {
      'en': 'Delivery Instructions',
      'sw': '',
    },
    '0xe4ni4e': {
      'en': 'Maelekezo zaidi ya kufika Mfano: \"Piga simu nikifika getini.\"',
      'sw': '',
    },
    '4oc6mykk': {
      'en': 'Tafadhali jaza sehemu hii!',
      'sw': '',
    },
    'j2027iyo': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'o29bnjcn': {
      'en': 'Tafadhali jaza sehemu hii',
      'sw': '',
    },
    '3kkid5ha': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '0o0pl2oh': {
      'en': 'Tafadhali jaza sehemu hii',
      'sw': '',
    },
    'skeqohae': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    's4v9bhnp': {
      'en': 'Taja sehemu maarufu karibu nawe',
      'sw': '',
    },
    'kpc0omq5': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'lbtbpapb': {
      'en': 'Ingiza namba ya simu sahihi',
      'sw': '',
    },
    '1gabboky': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'aq4hgegl': {
      'en': 'Tafadhali jaza sehemu hii',
      'sw': '',
    },
    'y2pubcr8': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'apwpmfyp': {
      'en': 'Tafadhali toa maelezo zaidi.',
      'sw': '',
    },
    'hl50v6xd': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    's1bgtmu9': {
      'en': 'Save',
      'sw': '',
    },
    '1u6vvdvc': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // Welcome
  {
    'r6fj5vys': {
      'en': 'ZanNext',
      'sw': 'ZanNext',
    },
    '6xrbgngv': {
      'en': 'Let’s dive into your account',
      'sw': 'Anza kutumia akaunti yako',
    },
    '4pte6yc3': {
      'en': 'Welcome back',
      'sw': 'Karibu tena',
    },
    'naaa0kg7': {
      'en': 'Ready to update your profile?',
      'sw': 'Uko tayari kuhuisha wasifu wako?',
    },
    'k3k38k74': {
      'en': 'Sign In',
      'sw': 'Ingia',
    },
    'fc28zc17': {
      'en': 'Create New Account',
      'sw': 'Fungua Akaunti Mpya',
    },
    'h82gzw7u': {
      'en': 'Privacy Policy',
      'sw': 'Sera ya Faragha',
    },
    'uxxdthx2': {
      'en': 'Terms of Service',
      'sw': 'Masharti ya Huduma',
    },
    'k8v04zpa': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // LogInMethod
  {
    'tg0fshzy': {
      'en': 'Sign In Method',
      'sw': 'Njia za Kuingia',
    },
    'fcm5zn5z': {
      'en': 'Choose how you want to continue',
      'sw': 'Chagua jinsi unavyotaka kuendelea',
    },
    'kjzs8rsy': {
      'en': 'Fresh finds in minutes — sign in to start',
      'sw': 'Bidhaa mpya kwa dakika chache — ingia uanze',
    },
    'zqgwjkd2': {
      'en': 'Continue with Google',
      'sw': 'Endelea na Google',
    },
    '47r37h2i': {
      'en': 'Continue with Apple',
      'sw': 'Endelea na Apple',
    },
    'rxbhf7bs': {
      'en': 'Sign in with Username',
      'sw': 'Ingia kwa Jina la Mtumiaji',
    },
    '2q2iwzkq': {
      'en': 'Sign in with Phone Number',
      'sw': 'Ingia kwa Namba ya Simu',
    },
    'yecdx0nd': {
      'en': 'By continuing, you agree to our  ',
      'sw': 'Kwa kuendelea, unakubaliana na',
    },
    'blrmosyh': {
      'en': 'Terms of Service ',
      'sw': 'Masharti ya Huduma',
    },
    '6xc2d6xn': {
      'en': ' and',
      'sw': 'na',
    },
    'szjvfmjj': {
      'en': ' Privacy Policy.',
      'sw': 'Sera ya Faragha.',
    },
    'm4qztylm': {
      'en':
          'By continuing, you agree to our Terms of Service and Privacy Policy.',
      'sw':
          'Kwa kuendelea, unakubali Masharti yetu ya Huduma na Sera ya Faragha.',
    },
    'te0freaj': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // SignInMobile
  {
    'xaz857wd': {
      'en': 'Language',
      'sw': 'Lugha',
    },
    'cgasg5y5': {
      'en': 'Continue with \n',
      'sw': 'Endelea na',
    },
    'i4lv8p2l': {
      'en': 'Phone',
      'sw': 'Simu',
    },
    'rn4w6ley': {
      'en': 'Build Your\nFuture.',
      'sw': 'Jenga Baadaye Yako.',
    },
    '9zxd7drs': {
      'en':
          'We\'ll send a 6-digit code to verify your account and build your professional resume.',
      'sw':
          'Tutatuma nambari ya siri ya tarakimu 6 ili kuthibitisha akaunti yako na kutengeneza wasifu wako wa kitaalamu.',
    },
    '4f4pi26v': {
      'en': 'Enter Phone Number',
      'sw': 'Weka Nambari ya Simu',
    },
    '3ftx325z': {
      'en': 'Sign In',
      'sw': 'Ingia',
    },
    'rgv6hddf': {
      'en': 'Try another way',
      'sw': 'Jaribu njia nyingine',
    },
    'r0m7g955': {
      'en': 'or continue with',
      'sw': 'au endelea na',
    },
    'dvhodrtv': {
      'en': 'Continue with Google',
      'sw': 'Endelea na Google',
    },
    '7nb0uc2p': {
      'en': 'Continue with Apple',
      'sw': 'Endelea na Apple',
    },
    'r41kawbj': {
      'en': 'By continuing, you agree to our ',
      'sw': 'Kwa kuendelea, unakubali',
    },
    'p84vyzla': {
      'en': 'Terms of Service',
      'sw': 'Masharti ya Huduma',
    },
    'nuti4gh2': {
      'en': ' ',
      'sw': '',
    },
    '22lh1v7v': {
      'en': 'Privacy Policy',
      'sw': 'Sera ya Faragha',
    },
    'zfsunvzz': {
      'en': ' ',
      'sw': '',
    },
    '24itm4nn': {
      'en': 'Content Policy',
      'sw': 'Sera ya Maudhui',
    },
    'nref5d90': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // SignUp
  {
    'lxexr7ab': {
      'en': 'Create New Account',
      'sw': '',
    },
    '093rjmsp': {
      'en': 'Build Your\nFuture.',
      'sw': '',
    },
    'akp3pm6c': {
      'en': 'Create your account in second! Your privacy \nimportant to us',
      'sw': '',
    },
    'a7u18ytr': {
      'en': 'Name ',
      'sw': '',
    },
    'w50m9xwp': {
      'en': 'Enter your name...',
      'sw': '',
    },
    't03yss72': {
      'en': 'Phone',
      'sw': '',
    },
    '6v2i1jaf': {
      'en': 'Enter your phone no...',
      'sw': '',
    },
    'j7m8z8i7': {
      'en': 'Email',
      'sw': '',
    },
    't3cjv7q3': {
      'en': 'Enter your email...',
      'sw': '',
    },
    '79v0u5w7': {
      'en': 'Password',
      'sw': '',
    },
    'blwckotc': {
      'en': 'Enter your pasword...',
      'sw': '',
    },
    'xs99v9nq': {
      'en': 'I give my consent to the processing my\n',
      'sw': '',
    },
    'hi2nkqq8': {
      'en': 'Personal Data and',
      'sw': '',
    },
    'd6jlvnpq': {
      'en': ' and accept ',
      'sw': '',
    },
    'slkk6xsy': {
      'en': 'Privacy Policy',
      'sw': '',
    },
    '7mam7b41': {
      'en': 'Hello World',
      'sw': '',
    },
    'n20k709v': {
      'en': 'Sign Up',
      'sw': '',
    },
    'bak530lr': {
      'en': 'or continue with',
      'sw': '',
    },
    't6xybd65': {
      'en': 'Continue with Google',
      'sw': '',
    },
    '482zpiys': {
      'en': 'Continue with Apple',
      'sw': '',
    },
    '7t3fy6ly': {
      'en': 'Don’t have an account?',
      'sw': '',
    },
    'ymyail67': {
      'en': ' Sign In',
      'sw': '',
    },
    'eenbulo4': {
      'en': 'Or Use Instant Sign Up',
      'sw': '',
    },
    'qly9zj8t': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // SearchZ
  {
    'kuylacbm': {
      'en': 'Search',
      'sw': '',
    },
    'gonm7oqw': {
      'en': 'Search for Products...',
      'sw': '',
    },
    'er7ygf5i': {
      'en': 'Recent Search',
      'sw': '',
    },
    'xhoyy1tn': {
      'en': 'Clear all',
      'sw': '',
    },
    'nun6wuub': {
      'en': 'Last Seen',
      'sw': '',
    },
    'x4ajt9b9': {
      'en': 'Home',
      'sw': '',
    },
  },
  // CategorysZ
  {
    '1krp45fu': {
      'en': 'Men’s Wear',
      'sw': '',
    },
    'r5ojczta': {
      'en': 'Women’s Wear',
      'sw': '',
    },
    '0q6m5sw1': {
      'en': 'Kids’ Clothing',
      'sw': '',
    },
    'dwvmcwpb': {
      'en': 'Underwear & Socks',
      'sw': '',
    },
    '7h93yh8n': {
      'en': 'Sneakers & Sports',
      'sw': '',
    },
    'gx1izm6f': {
      'en': 'Formal Shoes',
      'sw': '',
    },
    'mxde9zgf': {
      'en': 'Sandals & Slippers',
      'sw': '',
    },
    'eqj9hsyd': {
      'en': 'Heels & Wedges',
      'sw': '',
    },
    'km29qijt': {
      'en': 'Computers & Laptops',
      'sw': '',
    },
    'u497oybd': {
      'en': 'Audio & Sound',
      'sw': '',
    },
    '7ftxouq5': {
      'en': 'Cameras',
      'sw': '',
    },
    '3mpxahwe': {
      'en': 'TV & Video',
      'sw': '',
    },
    '0kw3ji5w': {
      'en': 'Skincare',
      'sw': '',
    },
    'fwljt826': {
      'en': 'Fragrances',
      'sw': '',
    },
    '4743bnej': {
      'en': 'Hair Care',
      'sw': '',
    },
    '82dq9akg': {
      'en': 'Makeup',
      'sw': '',
    },
    's04dm68j': {
      'en': 'Lighting',
      'sw': '',
    },
    'wjhpebjk': {
      'en': 'Wall Art',
      'sw': '',
    },
    'dhrv6iv4': {
      'en': 'Furniture',
      'sw': '',
    },
    'ejh4coez': {
      'en': 'Bedding',
      'sw': '',
    },
    'jb0dz2us': {
      'en': 'Fresh Produce',
      'sw': '',
    },
    'g608rinb': {
      'en': 'Grains & Flour',
      'sw': '',
    },
    'yr0s4xrj': {
      'en': 'Beverages',
      'sw': '',
    },
    'ynp6fh7w': {
      'en': 'Snacks',
      'sw': '',
    },
    'kg1htdin': {
      'en': 'Wearables',
      'sw': '',
    },
    '387q5jac': {
      'en': 'Mobile Accessories',
      'sw': '',
    },
    '17c13avp': {
      'en': 'Smart Home',
      'sw': '',
    },
    'zoobbqk2': {
      'en': 'Team Sports',
      'sw': '',
    },
    'nzuw084a': {
      'en': 'Gym & Fitness',
      'sw': '',
    },
    'gr7nxfvv': {
      'en': 'Outdoor',
      'sw': '',
    },
    'jpti3l8h': {
      'en': 'Luxury Watches',
      'sw': '',
    },
    'k8ikkrtf': {
      'en': 'Digital Watches',
      'sw': '',
    },
    '8dupexf6': {
      'en': 'Wall Clocks',
      'sw': '',
    },
    '5yzq8t2m': {
      'en': 'Educational Toys',
      'sw': '',
    },
    'bqu74fl4': {
      'en': 'Baby Gear',
      'sw': '',
    },
    'p6qsnktb': {
      'en': 'Electronic Toys',
      'sw': '',
    },
    'ti91z0tn': {
      'en': 'Supplements',
      'sw': '',
    },
    'ymnkchyc': {
      'en': 'Medical Equipment',
      'sw': '',
    },
    'nhd6fe7m': {
      'en': 'Personal Hygiene',
      'sw': '',
    },
    'xk1dwtt1': {
      'en': 'Stationery',
      'sw': '',
    },
    'sh5wrhqk': {
      'en': 'Office Tech',
      'sw': '',
    },
    'fnyc85oc': {
      'en': 'Organization',
      'sw': '',
    },
    '8dksjr4c': {
      'en': 'Car Parts',
      'sw': '',
    },
    '8336mo8c': {
      'en': 'Interior Accessories',
      'sw': '',
    },
    'j68xli1g': {
      'en': 'Tires & Rims',
      'sw': '',
    },
    'sm4usdi9': {
      'en': 'Kitchen',
      'sw': '',
    },
    'gxm5jx3k': {
      'en': 'Laundry',
      'sw': '',
    },
    'r60vgcj2': {
      'en': 'Cooling',
      'sw': '',
    },
    'e2knmob0': {
      'en': 'Rings & Wedding',
      'sw': '',
    },
    'gms3i0na': {
      'en': 'Necklaces & Pendants',
      'sw': '',
    },
    '1oq0vx5v': {
      'en': 'Bracelets & Earrings',
      'sw': '',
    },
    'cv7clwrn': {
      'en': 'Last Seen',
      'sw': '',
    },
    '996a9j1y': {
      'en': '/kg',
      'sw': '',
    },
    '950i6p1b': {
      'en': 'Categories',
      'sw': '',
    },
    'r5fqxupq': {
      'en': 'Search for Products.....',
      'sw': '',
    },
    'lpgensda': {
      'en': 'Category',
      'sw': '',
    },
  },
  // Reviews
  {
    'o4qtemvk': {
      'en': 'Based on 216 Reviews',
      'sw': '',
    },
    'y522guh8': {
      'en': '5 Star',
      'sw': '',
    },
    'sln4oa1y': {
      'en': '4 Star',
      'sw': '',
    },
    'x5bo05ry': {
      'en': '3 Star',
      'sw': '',
    },
    'ep1hlpzg': {
      'en': '2 Star',
      'sw': '',
    },
    'dnunn9ij': {
      'en': '1  Star',
      'sw': '',
    },
    'zxh0sbpj': {
      'en': 'Search in reviews',
      'sw': '',
    },
    '48gug1xi': {
      'en': 'User reviews',
      'sw': '',
    },
    'dr3q2nsi': {
      'en': 'Most useful',
      'sw': '',
    },
    'qmcc45ru': {
      'en': 'Select...',
      'sw': '',
    },
    'yf1vqady': {
      'en': 'Search...',
      'sw': '',
    },
    'iieuuavm': {
      'en': 'Recent',
      'sw': '',
    },
    '3e9bv5ni': {
      'en': 'Most useful',
      'sw': '',
    },
    '031oasgo': {
      'en': 'Reviews',
      'sw': '',
    },
    '980mja7r': {
      'en': 'Home',
      'sw': '',
    },
  },
  // SelectAd
  {
    '4vwm3i1p': {
      'en': 'Fashion/Clothing',
      'sw': '',
    },
    '96tteevq': {
      'en': 'Shoes',
      'sw': '',
    },
    'trv1i7la': {
      'en': 'Electronics',
      'sw': '',
    },
    '6br0nidn': {
      'en': 'Beauty & Care',
      'sw': '',
    },
    'wu4cb1le': {
      'en': 'Home Decor',
      'sw': '',
    },
    '7v2xgqkb': {
      'en': 'Groceries',
      'sw': '',
    },
    'jhmod58s': {
      'en': 'Smart Tech',
      'sw': '',
    },
    'ggg66hl6': {
      'en': 'Sports Gear',
      'sw': '',
    },
    'u795zg0l': {
      'en': 'Watches',
      'sw': '',
    },
    'ka970loh': {
      'en': 'Kids & Toys',
      'sw': '',
    },
    'x6gtf547': {
      'en': 'Health',
      'sw': '',
    },
    'v6tdguaw': {
      'en': 'Office Supply',
      'sw': '',
    },
    'zj9u3a1y': {
      'en': 'Automotive',
      'sw': '',
    },
    'rvtqfeqh': {
      'en': 'Appliances',
      'sw': '',
    },
    'd64riknk': {
      'en': 'Jewelry',
      'sw': '',
    },
    'dksis879': {
      'en': 'Choose Category',
      'sw': '',
    },
    'kiyaswmo': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Fashion
  {
    '2u81zo7f': {
      'en': 'Choose  Fashion Collection',
      'sw': '',
    },
    'peded5ai': {
      'en': 'Men’s Collection',
      'sw': '',
    },
    'jbz0m1b6': {
      'en': 'Women’s Collection',
      'sw': '',
    },
    'mksa03up': {
      'en': 'Kids & Infants',
      'sw': '',
    },
    '35861rui': {
      'en': 'Essentials (Underwear & Socks)',
      'sw': '',
    },
    'bfh51vlm': {
      'en': 'Fashion',
      'sw': '',
    },
    '39oqnk14': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Footwear
  {
    'dy1hy1ko': {
      'en': 'Please select the appropriate Footwear',
      'sw': '',
    },
    'dh06indv': {
      'en': 'Sneakers & Sports',
      'sw': '',
    },
    'a9eyt64r': {
      'en': 'Formal Shoes',
      'sw': '',
    },
    'jbe1ndkc': {
      'en': 'Sandals & Slippers',
      'sw': '',
    },
    'pdk9r2m9': {
      'en': 'Heels & Wedge',
      'sw': '',
    },
    'mgcq4cgd': {
      'en': 'Shoes',
      'sw': '',
    },
    '01n5utxo': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Electronics
  {
    'v70io4nr': {
      'en': 'Select Electronic Category',
      'sw': '',
    },
    '5qlhqo6m': {
      'en': 'Computers & Laptops',
      'sw': '',
    },
    'ecd0uvoz': {
      'en': 'Audio & Sound',
      'sw': '',
    },
    'ih10554k': {
      'en': 'Cameras',
      'sw': '',
    },
    '64ytipqz': {
      'en': 'TV & Video',
      'sw': '',
    },
    'k0a3fpg0': {
      'en': 'Electronics',
      'sw': '',
    },
    's4l8pl2i': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Beauty
  {
    '9mlp1ovf': {
      'en': 'Select Beauty & Care Category',
      'sw': '',
    },
    'j40bubwm': {
      'en': 'Skincare',
      'sw': '',
    },
    '5rrxcicb': {
      'en': 'Fragrances',
      'sw': '',
    },
    'zzoaokhf': {
      'en': 'Hair Care',
      'sw': '',
    },
    'wu3xqnqm': {
      'en': 'Makeup',
      'sw': '',
    },
    '2zknhid4': {
      'en': 'Beauty & Care',
      'sw': '',
    },
    'kc76pk4o': {
      'en': 'Home',
      'sw': '',
    },
  },
  // HomeDecor
  {
    'ywgqogqx': {
      'en': 'Select Home Decor Category',
      'sw': '',
    },
    '8tpwr7tg': {
      'en': 'Lighting',
      'sw': '',
    },
    '4wkuxwer': {
      'en': 'Wall Art',
      'sw': '',
    },
    'e259hr60': {
      'en': 'Furniture',
      'sw': '',
    },
    '99oxyh7r': {
      'en': 'Bedding',
      'sw': '',
    },
    'axb7zo9o': {
      'en': 'Home Decor',
      'sw': '',
    },
    'g778hyrt': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Groceries
  {
    'ketlqpog': {
      'en': 'Select Groceries Category',
      'sw': '',
    },
    'fuaylizl': {
      'en': 'Fresh Produce',
      'sw': '',
    },
    'vbs582pv': {
      'en': 'Grains & Flour',
      'sw': '',
    },
    'xs7y20g8': {
      'en': 'Beverages',
      'sw': '',
    },
    'e6c5p68q': {
      'en': 'Snacks',
      'sw': '',
    },
    '4pb72uip': {
      'en': 'Groceries',
      'sw': '',
    },
    'vc4ra910': {
      'en': 'Home',
      'sw': '',
    },
  },
  // SmartTech
  {
    't38npjcn': {
      'en': 'Select Smart Tech Category',
      'sw': '',
    },
    'g8izdby1': {
      'en': 'Wearables',
      'sw': '',
    },
    'ocm8b19h': {
      'en': 'Mobile Accessories',
      'sw': '',
    },
    'spjvgfww': {
      'en': 'Smart Home',
      'sw': '',
    },
    'oy6d68vz': {
      'en': 'Smart Tech',
      'sw': '',
    },
    '7wmfht2b': {
      'en': 'Home',
      'sw': '',
    },
  },
  // SportsGear
  {
    'vanrdfgv': {
      'en': 'Select Sports Gear Category',
      'sw': '',
    },
    'rhmv4nri': {
      'en': 'Team Sports',
      'sw': '',
    },
    'ib2dccmc': {
      'en': 'Gym & Fitness',
      'sw': '',
    },
    'ukjhjzkt': {
      'en': 'Outdoor',
      'sw': '',
    },
    '3kzt1p99': {
      'en': 'Sports Gear',
      'sw': '',
    },
    'a0lmcb4n': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Watches
  {
    'i68x0il0': {
      'en': 'Select Watches Category',
      'sw': '',
    },
    'ekg5o7s2': {
      'en': 'Luxury Watches',
      'sw': '',
    },
    '5vd36fwt': {
      'en': 'Digital Watches',
      'sw': '',
    },
    '5epfnkkf': {
      'en': 'Wall Clocks',
      'sw': '',
    },
    'cyvj9mgq': {
      'en': 'Watches',
      'sw': '',
    },
    '08osr93a': {
      'en': 'Home',
      'sw': '',
    },
  },
  // KidsToys
  {
    'gg2qnb15': {
      'en': 'Select Kids & Toys Category',
      'sw': '',
    },
    'n5uu8j6y': {
      'en': 'Educational Toys',
      'sw': '',
    },
    'equtezx6': {
      'en': 'Baby Gear',
      'sw': '',
    },
    'wc254q0e': {
      'en': 'Electronic Toys',
      'sw': '',
    },
    'r05b8zyv': {
      'en': 'Kids & Toys',
      'sw': '',
    },
    '7r5ul8h2': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Health
  {
    'lt313vp1': {
      'en': 'Select Health Category',
      'sw': '',
    },
    'vaxp1id1': {
      'en': 'Supplements',
      'sw': '',
    },
    '7fipeovv': {
      'en': 'Medical Equipmen',
      'sw': '',
    },
    'd63g654l': {
      'en': 'Personal Hygiene',
      'sw': '',
    },
    'vjpp9hve': {
      'en': 'Health',
      'sw': '',
    },
    'xkjwjbu4': {
      'en': 'Home',
      'sw': '',
    },
  },
  // OfficeSupply
  {
    't7tlwkrh': {
      'en': 'Select Office Supply Category',
      'sw': '',
    },
    '9hmopl2k': {
      'en': 'Stationery',
      'sw': '',
    },
    'db0qda97': {
      'en': 'Office Tech',
      'sw': '',
    },
    'ieveppyu': {
      'en': 'Organization',
      'sw': '',
    },
    'lyyksei0': {
      'en': 'Office Supply',
      'sw': '',
    },
    '5r8okjow': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Automotive
  {
    'q9rgevlj': {
      'en': 'Select Automotive Category',
      'sw': '',
    },
    '4itig3sz': {
      'en': 'Car Parts',
      'sw': '',
    },
    'rbpcmmjo': {
      'en': 'Interior Accessories',
      'sw': '',
    },
    'm2m1013k': {
      'en': 'Tires & Rims',
      'sw': '',
    },
    'vnadsvmj': {
      'en': 'Automotive',
      'sw': '',
    },
    'nb1k6zcw': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Appliances
  {
    '4c41cynj': {
      'en': 'Select Appliances Category',
      'sw': '',
    },
    'aqotd3xr': {
      'en': 'Kitchen',
      'sw': '',
    },
    '18c0jjum': {
      'en': 'Laundry',
      'sw': '',
    },
    '3zwzscsq': {
      'en': 'Cooling',
      'sw': '',
    },
    'ytdasvlg': {
      'en': 'Appliances',
      'sw': '',
    },
    '25dg9bzs': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Jewelry
  {
    'noors3uy': {
      'en': 'Select Jewelry Category',
      'sw': '',
    },
    'm5syqlum': {
      'en': 'Rings & Wedding',
      'sw': '',
    },
    'azdqmsgt': {
      'en': 'Necklaces & Pendants',
      'sw': '',
    },
    'so41ge49': {
      'en': 'Bracelets & Earrings',
      'sw': '',
    },
    't69bf37g': {
      'en': 'Jewelry',
      'sw': '',
    },
    'cgwtzfdo': {
      'en': 'Home',
      'sw': '',
    },
  },
  // GiftCards
  {
    '74s7hx2u': {
      'en': 'Select Gift Cards Category',
      'sw': '',
    },
    'x293bae1': {
      'en': 'Digital Cards',
      'sw': '',
    },
    '9n8w5zf3': {
      'en': 'Physical Gifts',
      'sw': '',
    },
    'bd8g96lj': {
      'en': 'Gift Cards',
      'sw': '',
    },
    'c9kehjgu': {
      'en': 'Home',
      'sw': '',
    },
  },
  // AdInformation
  {
    'j8xq2spd': {
      'en': 'Product Category',
      'sw': '',
    },
    '3jshuzup': {
      'en': 'Change',
      'sw': '',
    },
    'kvezdrjo': {
      'en': 'Product Category',
      'sw': '',
    },
    'x51crf5o': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '7f4sfqio': {
      'en': 'Add Photo',
      'sw': '',
    },
    'fi75c7np': {
      'en': 'COVER',
      'sw': '',
    },
    'td9mywzw': {
      'en': 'Product Name',
      'sw': '',
    },
    'gp10aevb': {
      'en': 'Product Name',
      'sw': '',
    },
    'aiyzt1ql': {
      'en': 'Product Name',
      'sw': '',
    },
    'tx8ifgg2': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    'ztadgze1': {
      'en': 'New',
      'sw': '',
    },
    'o1ydhhx1': {
      'en': 'Used',
      'sw': '',
    },
    'jtry254i': {
      'en': 'Set Adress',
      'sw': '',
    },
    'boempoks': {
      'en': 'Contact information',
      'sw': '',
    },
    'dupc3rz5': {
      'en':
          'Select how your customers can contact you about this product! Choose at least one phone number or email.',
      'sw': '',
    },
    'zzbhecfu': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'ca3edd89': {
      'en': 'Mobile',
      'sw': '',
    },
    '3pucj1u9': {
      'en': 'Chat',
      'sw': '',
    },
    'm4k6urbp': {
      'en': 'Price',
      'sw': '',
    },
    'l18u7b7u': {
      'en': 'Price',
      'sw': '',
    },
    '72sk5yg5': {
      'en': '0.00',
      'sw': '',
    },
    'n1xrb3dk': {
      'en': 'Description',
      'sw': '',
    },
    'zlwleiml': {
      'en': 'Product description',
      'sw': '',
    },
    'kgnq85ti': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '5ft05gyy': {
      'en': 'Ad Information',
      'sw': '',
    },
    'shoy4myp': {
      'en': 'Home',
      'sw': '',
    },
  },
  // mensWear
  {
    '5khtyuy2': {
      'en': 'Fashion',
      'sw': '',
    },
    'cne076j9': {
      'en': 'Men’s Wear',
      'sw': '',
    },
    'hh7wbtwt': {
      'en': 'Change',
      'sw': '',
    },
    'qvxny62v': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    's72fmh1p': {
      'en': 'Add Photo',
      'sw': '',
    },
    'ru8s4vua': {
      'en': 'COVER',
      'sw': '',
    },
    '4akxgu7m': {
      'en': 'Product Name',
      'sw': '',
    },
    'csx73pde': {
      'en': 'Product Name',
      'sw': '',
    },
    'ywffz0sb': {
      'en': 'Product Name',
      'sw': '',
    },
    'te2dzyy5': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'thrdscvv': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    't2v6rzfx': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'jp13hjio': {
      'en': 'Product Collection',
      'sw': '',
    },
    '4rqxc7bf': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'dhmmpuzw': {
      'en': 'Men’s Wear',
      'sw': '',
    },
    'm0462iec': {
      'en': 'Select Men’s Wear Category',
      'sw': '',
    },
    'hi5ht56n': {
      'en': 'Select...',
      'sw': '',
    },
    '6r1pb0k1': {
      'en': 'Search...',
      'sw': '',
    },
    'c8erq1ya': {
      'en': 'Suits',
      'sw': '',
    },
    'rf4njc6n': {
      'en': 'Shirts',
      'sw': '',
    },
    '9fhx6r3m': {
      'en': 'T-Shirts',
      'sw': '',
    },
    'l291qy8i': {
      'en': 'Trousers',
      'sw': '',
    },
    'jjtqv9yq': {
      'en': 'Jackets',
      'sw': '',
    },
    'eg23rddj': {
      'en': 'Hoodies',
      'sw': '',
    },
    '7a3fu6i6': {
      'en': 'Alpha Sizes or Waist/Numerical Sizes',
      'sw': '',
    },
    'uivosngy': {
      'en': 'XS',
      'sw': '',
    },
    'zrxcxw4l': {
      'en': 'S',
      'sw': '',
    },
    '6ewt0tp1': {
      'en': 'M',
      'sw': '',
    },
    'eul7cr11': {
      'en': 'L',
      'sw': '',
    },
    'xps5t638': {
      'en': 'XL',
      'sw': '',
    },
    'srppsl9x': {
      'en': 'XXL',
      'sw': '',
    },
    'rgr9blae': {
      'en': '3XL',
      'sw': '',
    },
    'tmq6fzqj': {
      'en': '28',
      'sw': '',
    },
    'ayf4pn99': {
      'en': '30',
      'sw': '',
    },
    '9nehvgp3': {
      'en': '32',
      'sw': '',
    },
    'qft09e3x': {
      'en': '34',
      'sw': '',
    },
    'pzx5cpas': {
      'en': '36',
      'sw': '',
    },
    '4gmginbb': {
      'en': '38',
      'sw': '',
    },
    '6g5ivnwb': {
      'en': '40',
      'sw': '',
    },
    '3efia12j': {
      'en': '42',
      'sw': '',
    },
    'm548ilhl': {
      'en': 'Selct Color',
      'sw': '',
    },
    'rdeqou1a': {
      'en': 'Pure White',
      'sw': 'Nyeupe Saf',
    },
    '800virpt': {
      'en': 'Jet Black',
      'sw': 'Nyeusi Iliyokoza',
    },
    'va5ghssd': {
      'en': 'Navy Blue',
      'sw': 'Buluu ya Kibaharia',
    },
    'ktpj5xqj': {
      'en': 'Charcoal Grey',
      'sw': 'Kijivu cha Makaa',
    },
    'c1udo0ac': {
      'en': 'Khaki/Beige',
      'sw': 'Kaki/Bej',
    },
    'utqst1wj': {
      'en': 'Olive Green',
      'sw': 'Kijani cha Zeitun',
    },
    'qrbomnjx': {
      'en': 'Sky Blue',
      'sw': 'Buluu ya Anga',
    },
    'ggo3v5fy': {
      'en': 'Material & Fabric',
      'sw': '',
    },
    '2jbqlty9': {
      'en': 'Select...',
      'sw': '',
    },
    't5s0a8k2': {
      'en': 'Search...',
      'sw': '',
    },
    'iw5fw6xe': {
      'en': '100% Cotton',
      'sw': 'Pamba',
    },
    'xw0l8pcv': {
      'en': 'Linen',
      'sw': 'Kitani',
    },
    '3rw29dao': {
      'en': 'Wool',
      'sw': 'Sufu',
    },
    'b3uw5q5t': {
      'en': 'Polyester',
      'sw': 'Polyester',
    },
    'qgcgml4x': {
      'en': 'Denim',
      'sw': 'Jeans',
    },
    'ch1mi7ey': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'pl83j6vk': {
      'en': 'Slim Fit',
      'sw': '',
    },
    'xfg1xgja': {
      'en': 'Regular Fit',
      'sw': '',
    },
    'u47i51wk': {
      'en': 'Oversized',
      'sw': '',
    },
    '7zu0fltr': {
      'en': 'Solid',
      'sw': 'Rangi Moja',
    },
    'v9ldpykw': {
      'en': 'Striped',
      'sw': 'Mistari',
    },
    'vaooph1i': {
      'en': 'Printed',
      'sw': 'Picha',
    },
    'y94sas54': {
      'en': 'New',
      'sw': '',
    },
    'd4xwiwah': {
      'en': 'Used',
      'sw': '',
    },
    'yjs67z5f': {
      'en': 'Set Adress',
      'sw': '',
    },
    'jr5gitzq': {
      'en': 'Contact information',
      'sw': '',
    },
    'tixnulvf': {
      'en': 'WhatsApp',
      'sw': '',
    },
    's5to330w': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'b3ffknp8': {
      'en': 'Call no',
      'sw': '',
    },
    'ck95grqd': {
      'en': 'Call no',
      'sw': '',
    },
    'wh5fufna': {
      'en': 'Price',
      'sw': '',
    },
    'xmijpw6p': {
      'en': 'Price',
      'sw': '',
    },
    '1fj5wp84': {
      'en': '0.00',
      'sw': '',
    },
    'fnp6vszj': {
      'en': 'Please set a price',
      'sw': '',
    },
    '8lf3kjgl': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gsgkqkvm': {
      'en': 'Description',
      'sw': '',
    },
    'cp9ik6dw': {
      'en': 'Product description',
      'sw': '',
    },
    'q4iq48xp': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '14u8qdu4': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '9qvqevdm': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'ibtp3ah0': {
      'en': 'Trending',
      'sw': '',
    },
    '244oepcw': {
      'en': 'New Arrival',
      'sw': '',
    },
    '5qixalhp': {
      'en': 'Show in All',
      'sw': '',
    },
    'odbhjali': {
      'en': 'Post Now',
      'sw': '',
    },
    'kpjhnxqb': {
      'en': 'Home',
      'sw': '',
    },
  },
  // WomensWear
  {
    'jlo85k9w': {
      'en': 'Fashion',
      'sw': '',
    },
    '82f6koat': {
      'en': 'Women’s Wear',
      'sw': '',
    },
    '90t149g1': {
      'en': 'Change',
      'sw': '',
    },
    'v3clpkxu': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'e2eq4x39': {
      'en': 'Add Photo',
      'sw': '',
    },
    'n08jxufb': {
      'en': 'COVER',
      'sw': '',
    },
    '4cl5gl96': {
      'en': 'Product Name',
      'sw': '',
    },
    '9ngh9daj': {
      'en': 'Product Name',
      'sw': '',
    },
    'up7vmgay': {
      'en': 'Product Name',
      'sw': '',
    },
    'rmx2ssif': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '8eom05vn': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'ne3swr6c': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'yg0cjdaa': {
      'en': 'Product Collection',
      'sw': '',
    },
    'x6vcpr2i': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'm5bq65ln': {
      'en': 'Women’s Wear',
      'sw': '',
    },
    'd5a36ue8': {
      'en': 'Select Women’s Wear',
      'sw': '',
    },
    '2ae56i05': {
      'en': 'Select...',
      'sw': '',
    },
    'svow4a3l': {
      'en': 'Search...',
      'sw': '',
    },
    '87fpixor': {
      'en': 'Dresses',
      'sw': '',
    },
    'p7fjf2se': {
      'en': 'Tops/Blouses',
      'sw': '',
    },
    '2gg4e7gu': {
      'en': 'Skirts',
      'sw': '',
    },
    'wcbqjfpi': {
      'en': 'Trousers',
      'sw': '',
    },
    'kbckspnz': {
      'en': 'Trousers/Leggings',
      'sw': '',
    },
    'svgzyoa6': {
      'en': 'Abayas/Modest Wear',
      'sw': '',
    },
    'mqdeaj15': {
      'en': 'Select Size',
      'sw': '',
    },
    'geiwbsb4': {
      'en': 'XXS',
      'sw': '',
    },
    '8e419xvt': {
      'en': 'XS',
      'sw': '',
    },
    '1a5tptev': {
      'en': 'S',
      'sw': '',
    },
    'l8jqtgjm': {
      'en': 'M',
      'sw': '',
    },
    'yh4c48if': {
      'en': 'L',
      'sw': '',
    },
    'ofdpozq2': {
      'en': 'XL',
      'sw': '',
    },
    'brvdtuey': {
      'en': 'XXL',
      'sw': '',
    },
    'pz4lie2z': {
      'en': '3XL',
      'sw': '',
    },
    'aktg9ot1': {
      'en': '34',
      'sw': '',
    },
    'ew932zqd': {
      'en': '36',
      'sw': '',
    },
    'gpeigphd': {
      'en': '38',
      'sw': '',
    },
    'j9j5p933': {
      'en': '42',
      'sw': '',
    },
    'a6ra47eh': {
      'en': '44',
      'sw': '',
    },
    '1wv2nyqx': {
      'en': '46',
      'sw': '',
    },
    '7skozud7': {
      'en': '48',
      'sw': '',
    },
    'gzyszxh0': {
      'en': 'Select color',
      'sw': '',
    },
    'qs6gpcvy': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'wz9ugzzn': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    '9e9j5wby': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    '9zxelya5': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'kbnbrud8': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'l89htllb': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    's16hojqc': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'y5pa8frq': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'bp7eczq0': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'i6dhzlez': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'g86mds9o': {
      'en': '💛 Gold',
      'sw': '',
    },
    'vxdb5e4v': {
      'en': 'Select Material',
      'sw': '',
    },
    'aq26f6bm': {
      'en': 'Select...',
      'sw': '',
    },
    'nz87t0cd': {
      'en': 'Search...',
      'sw': '',
    },
    'ot50v63p': {
      'en': '100% Cotton',
      'sw': 'Pamba',
    },
    '8uz18i0w': {
      'en': 'Silk / Chiffon',
      'sw': 'Hariri',
    },
    's49ree0h': {
      'en': 'Wool',
      'sw': 'Sufu',
    },
    'yz2jbuui': {
      'en': 'Polyester',
      'sw': 'Polyester',
    },
    '4glwdcjm': {
      'en': 'Denim',
      'sw': 'Jeans',
    },
    'druxcj4j': {
      'en': 'Velvet',
      'sw': 'Nguo ya manyoya',
    },
    '8enl47g4': {
      'en': 'Length & Fit and Pattern',
      'sw': '',
    },
    'pg13u9qe': {
      'en': 'Slim Fit',
      'sw': '',
    },
    '073mkpss': {
      'en': 'Regular Fit',
      'sw': '',
    },
    'vfwpzg06': {
      'en': 'Oversized',
      'sw': '',
    },
    '216myx1i': {
      'en': 'Mini',
      'sw': 'Fupi',
    },
    '1ibm9mmj': {
      'en': 'Midi',
      'sw': '',
    },
    '6p3tt7b5': {
      'en': 'Maxi',
      'sw': '',
    },
    'z9deb89e': {
      'en': 'A-Line',
      'sw': '',
    },
    'r6177o2o': {
      'en': 'Loose/Boho',
      'sw': '',
    },
    'y07ra07o': {
      'en': 'Bell Sleeve',
      'sw': '',
    },
    '62calstf': {
      'en': 'Bodycon',
      'sw': '',
    },
    'pcvdr2bp': {
      'en': 'Solid',
      'sw': 'Rangi Moja',
    },
    'mkydefyk': {
      'en': 'Striped',
      'sw': 'Mistari',
    },
    '8coiaej7': {
      'en': 'Printed',
      'sw': 'Picha',
    },
    'x42mjdms': {
      'en': 'Floral',
      'sw': 'Maua',
    },
    'trm10smf': {
      'en': 'Animal Print | Polka Dot',
      'sw': 'Mapambo ya Kushona',
    },
    'ulcx6k9w': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    '2c5ssbq2': {
      'en': 'New',
      'sw': '',
    },
    'p1fpe9vy': {
      'en': 'Used',
      'sw': '',
    },
    'xrggoob2': {
      'en': 'Set Adress',
      'sw': '',
    },
    'rba2hsj3': {
      'en': 'Contact information',
      'sw': '',
    },
    '8eve77vq': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'ax798fgu': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'wvvh9pkz': {
      'en': 'Call no',
      'sw': '',
    },
    '0uaf3s96': {
      'en': 'Call no',
      'sw': '',
    },
    'fxn6xyvy': {
      'en': 'Price',
      'sw': '',
    },
    'vqi56xbp': {
      'en': 'Price',
      'sw': '',
    },
    '3fshbwik': {
      'en': '0.00',
      'sw': '',
    },
    '7vbhcgkq': {
      'en': 'Please set a price',
      'sw': '',
    },
    'sgehj9v1': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '2yrflyfu': {
      'en': 'Description',
      'sw': '',
    },
    'biq3xv0m': {
      'en': 'Product description',
      'sw': '',
    },
    'axrevh94': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'i45qflk4': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'nv7z5cfs': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'pli6ljk9': {
      'en': 'Trending',
      'sw': '',
    },
    '6gdihm8d': {
      'en': 'New Arrival',
      'sw': '',
    },
    'jhokfuvo': {
      'en': 'Show in All',
      'sw': '',
    },
    'v4z80b5v': {
      'en': 'Post Now',
      'sw': '',
    },
    'h87ecsrg': {
      'en': 'Home',
      'sw': '',
    },
  },
  // HeelsWedge
  {
    '0v4te4uz': {
      'en': 'Shoes',
      'sw': '',
    },
    '4vli37wi': {
      'en':
          'Provide accurate details and clear photos to help buyers trust you and buy faster!',
      'sw': '',
    },
    'ovuhdjkn': {
      'en': 'Heels & Wedge',
      'sw': '',
    },
    '79r7yn0c': {
      'en': 'Change',
      'sw': '',
    },
    '026vikoe': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'dp24jgms': {
      'en': 'Add Photo',
      'sw': '',
    },
    'zya61dkt': {
      'en': 'COVER',
      'sw': '',
    },
    'npj0jyel': {
      'en': 'Product Name',
      'sw': '',
    },
    '1yf11fc2': {
      'en': 'Product Name',
      'sw': '',
    },
    'yr9wmxic': {
      'en': 'Product Name',
      'sw': '',
    },
    'rjr9xmwc': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '6xx626z7': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'j6b65dnx': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'zmq1egdu': {
      'en': 'Product Collection',
      'sw': '',
    },
    'igja0o28': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '3lgboqtq': {
      'en': 'Heels & Wedge',
      'sw': '',
    },
    '1n6ssaev': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    'cdfad5xm': {
      'en': 'New',
      'sw': '',
    },
    'vaftibud': {
      'en': 'Used',
      'sw': '',
    },
    'vpu9qr3d': {
      'en': 'Set Adress',
      'sw': '',
    },
    'nr7opsq5': {
      'en': 'Contact information',
      'sw': '',
    },
    'oqq1ugfp': {
      'en':
          'Select how your customers can contact you about this product! Choose at least one phone number or email.',
      'sw': '',
    },
    'frcbsfva': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'a2bkzalt': {
      'en': 'Mobile',
      'sw': '',
    },
    'qmuufziw': {
      'en': 'Chat',
      'sw': '',
    },
    '43u0wzrv': {
      'en': 'Price',
      'sw': '',
    },
    'um6bvqli': {
      'en': 'Price',
      'sw': '',
    },
    'thcxusqj': {
      'en': '0.00',
      'sw': '',
    },
    'pcqqcvd1': {
      'en': 'Please set a price',
      'sw': '',
    },
    'ims4axtj': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '6c9hu5yr': {
      'en': 'Description',
      'sw': '',
    },
    'vhx2z3zy': {
      'en': 'Product description',
      'sw': '',
    },
    'nlf5e6d4': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'rpz1188w': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'yl2shjfj': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'i1m1sjpp': {
      'en': 'Get the Hot Label',
      'sw': '',
    },
    'lmpuehu2': {
      'en':
          'Want to sell faster? Boost your visibility for 7 days and let everyone know your item is trending',
      'sw': '',
    },
    'v3z57o0z': {
      'en': 'Get Featured',
      'sw': '',
    },
    '0qfdhqm4': {
      'en':
          'Want to be seen first? Highlight your ad to get 5x more visibility. Featured items stay pinned at the top of their category for 7 days and get a premium gold badge',
      'sw': '',
    },
    'y7lw83wo': {
      'en': 'Post Now',
      'sw': '',
    },
    '25ir7xj3': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Cooling
  {
    '8e8ja4kv': {
      'en': 'Appliances',
      'sw': '',
    },
    'fjk4btb6': {
      'en':
          'Provide accurate details and clear photos to help buyers trust you and buy faster!',
      'sw': '',
    },
    's0ggdxoe': {
      'en': 'Cooling',
      'sw': '',
    },
    'b53magj7': {
      'en': 'Change',
      'sw': '',
    },
    'p3ptrb0d': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '8uvp75d8': {
      'en': 'Add Photo',
      'sw': '',
    },
    'w2m4kynx': {
      'en': 'COVER',
      'sw': '',
    },
    'go539sfm': {
      'en': 'Product Name',
      'sw': '',
    },
    'zikmgsxc': {
      'en': 'Product Name',
      'sw': '',
    },
    'sb2yb3aa': {
      'en': 'Product Name',
      'sw': '',
    },
    'ovgfyfso': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'k1sjv6h4': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'qqmen3h8': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '5or8kh96': {
      'en': 'Product Collection',
      'sw': '',
    },
    '0sbpxmzt': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '1jqktxql': {
      'en': 'Cooling',
      'sw': '',
    },
    '1tvjg6ef': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    'dx0l5ey1': {
      'en': 'New',
      'sw': '',
    },
    'y1ipwkwn': {
      'en': 'Used',
      'sw': '',
    },
    'e3tbm2w3': {
      'en': 'Set Adress',
      'sw': '',
    },
    'r6jtnele': {
      'en': 'Contact information',
      'sw': '',
    },
    'gweahew6': {
      'en':
          'Select how your customers can contact you about this product! Choose at least one phone number or email.',
      'sw': '',
    },
    '6i3a2feu': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'qcnkvquv': {
      'en': 'Mobile',
      'sw': '',
    },
    'k35dqjj6': {
      'en': 'Chat',
      'sw': '',
    },
    'h5blxh86': {
      'en': 'Price',
      'sw': '',
    },
    '2pfxqhj0': {
      'en': 'Price',
      'sw': '',
    },
    'vzf35d6j': {
      'en': '0.00',
      'sw': '',
    },
    'je1anfwk': {
      'en': 'Please set a price',
      'sw': '',
    },
    'cb36rjya': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    's697659o': {
      'en': 'Description',
      'sw': '',
    },
    'q0frqnw9': {
      'en': 'Product description',
      'sw': '',
    },
    'poc7xy2s': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '8br8rcii': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'elavk9s5': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'b9ugh7do': {
      'en': 'Get the Hot Label',
      'sw': '',
    },
    'z1tpdknc': {
      'en':
          'Want to sell faster? Boost your visibility for 7 days and let everyone know your item is trending',
      'sw': '',
    },
    'va3hy289': {
      'en': 'Get Featured',
      'sw': '',
    },
    'x726z8r7': {
      'en':
          'Want to be seen first? Highlight your ad to get 5x more visibility. Featured items stay pinned at the top of their category for 7 days and get a premium gold badge',
      'sw': '',
    },
    'y24n5jfk': {
      'en': 'Post Now',
      'sw': '',
    },
    '95kpfvl5': {
      'en': 'Home',
      'sw': '',
    },
  },
  // messagelist
  {
    'vmk10a4u': {
      'en': 'Below are messages with your friends.',
      'sw': '',
    },
    '1sh5nq6c': {
      'en': 'Chat List',
      'sw': '',
    },
    '63bgnof7': {
      'en': 'chat',
      'sw': '',
    },
  },
  // ProCategory
  {
    'ndp1l3ms': {
      'en': 'Explore Category',
      'sw': '',
    },
    'cd9bc5k7': {
      'en': 'Main Categories',
      'sw': '',
    },
    'lh7tzn5h': {
      'en': 'Sub Categories',
      'sw': '',
    },
    'kvtxuwev': {
      'en': 'Fashion',
      'sw': '',
    },
    '36p2oq2y': {
      'en': 'Shoes',
      'sw': '',
    },
    's1ub4x2q': {
      'en': 'Electronics',
      'sw': '',
    },
    'p4cp5g73': {
      'en': 'Beauty',
      'sw': '',
    },
    'xvk7vbn6': {
      'en': 'Home  Decor',
      'sw': '',
    },
    'xgl6r1oj': {
      'en': 'Groceries',
      'sw': '',
    },
    'fpe1cy9y': {
      'en': 'Smart Tech',
      'sw': '',
    },
    'lkb1ofk5': {
      'en': 'Sports',
      'sw': '',
    },
    'lvbi7mki': {
      'en': 'Watches',
      'sw': '',
    },
    '502znt1x': {
      'en': 'Kids',
      'sw': '',
    },
    'h0cv7pj0': {
      'en': 'Health',
      'sw': '',
    },
    '60k96z1k': {
      'en': 'Office ',
      'sw': '',
    },
    'q3982zk8': {
      'en': 'Automotive',
      'sw': '',
    },
    'hdqq91an': {
      'en': 'Appliances',
      'sw': '',
    },
    'efdblv49': {
      'en': 'Jewelry',
      'sw': '',
    },
    '8cupdjrk': {
      'en': 'Men’s Collection',
      'sw': '',
    },
    '4x5xl9a3': {
      'en': 'Women’s Collection',
      'sw': '',
    },
    'p044xytl': {
      'en': 'Kids & Infants',
      'sw': '',
    },
    '2hs8uyoc': {
      'en': 'Underwear & Socks',
      'sw': '',
    },
    'pu459kwh': {
      'en': 'Sneakers & Sports',
      'sw': '',
    },
    'wzsbvf8v': {
      'en': 'Formal Shoes',
      'sw': '',
    },
    'd2kmjsdd': {
      'en': 'Sandals & Slippers',
      'sw': '',
    },
    'a9tnrghe': {
      'en': 'Heels & Wedges',
      'sw': '',
    },
    'icsypp5p': {
      'en': 'Fashion',
      'sw': '',
    },
    '93nywi5x': {
      'en': 'Fashion',
      'sw': '',
    },
    'b76p19wy': {
      'en': 'Fashion',
      'sw': '',
    },
    'q2cy6ejs': {
      'en': 'Fashion',
      'sw': '',
    },
    'jrien600': {
      'en': 'Fashion',
      'sw': '',
    },
    '4f5xf2zr': {
      'en': 'Fashion',
      'sw': '',
    },
    'suwvyvs9': {
      'en': 'Fashion',
      'sw': '',
    },
    'd3i1ll31': {
      'en': 'Fashion',
      'sw': '',
    },
    'nrg7nr41': {
      'en': 'Fashion',
      'sw': '',
    },
    'lp437z4t': {
      'en': 'Fashion',
      'sw': '',
    },
    'uwcfy6w6': {
      'en': 'Fashion',
      'sw': '',
    },
    'lk04i94m': {
      'en': 'Fashion',
      'sw': '',
    },
    'o94qnru7': {
      'en': 'Fashion',
      'sw': '',
    },
    'rpoazfw1': {
      'en': 'Fashion',
      'sw': '',
    },
    'f8scp2wm': {
      'en': 'Fashion',
      'sw': '',
    },
    'ili7fgq3': {
      'en': 'Fashion',
      'sw': '',
    },
    'ynrmo3b3': {
      'en': 'Fashion',
      'sw': '',
    },
    'vbdqefrv': {
      'en': 'Fashion',
      'sw': '',
    },
    'j81epdvz': {
      'en': 'Fashion',
      'sw': '',
    },
    '1xrybspo': {
      'en': 'Fashion',
      'sw': '',
    },
    'nt5zpc90': {
      'en': 'Fashion',
      'sw': '',
    },
    'eei8n49q': {
      'en': 'Fashion',
      'sw': '',
    },
    'h4w7bcbl': {
      'en': 'Fashion',
      'sw': '',
    },
    '6tg95q3u': {
      'en': 'Fashion',
      'sw': '',
    },
    '6px19juu': {
      'en': 'Fashion',
      'sw': '',
    },
    '89f91xzp': {
      'en': 'Fashion',
      'sw': '',
    },
    'kk8p50ir': {
      'en': 'Fashion',
      'sw': '',
    },
    'g6qxb12l': {
      'en': 'Fashion',
      'sw': '',
    },
    'omeh6usu': {
      'en': 'Fashion',
      'sw': '',
    },
    'cac32v5m': {
      'en': 'Fashion',
      'sw': '',
    },
    'z3ce1q25': {
      'en': 'Fashion',
      'sw': '',
    },
    'dpa8ho2s': {
      'en': 'Fashion',
      'sw': '',
    },
    'dc2iiwnc': {
      'en': 'Fashion',
      'sw': '',
    },
    'nt66owuj': {
      'en': 'Fashion',
      'sw': '',
    },
    '025lfgfa': {
      'en': 'Fashion',
      'sw': '',
    },
    'ng5cydvj': {
      'en': 'Fashion',
      'sw': '',
    },
    'jlwxic4o': {
      'en': 'Fashion',
      'sw': '',
    },
    'm2vqdtq5': {
      'en': 'Fashion',
      'sw': '',
    },
    '6vkw9qgq': {
      'en': 'Fashion',
      'sw': '',
    },
    'of8yoy0f': {
      'en': 'Fashion',
      'sw': '',
    },
    '9hsrjcki': {
      'en': 'Fashion',
      'sw': '',
    },
    '9gwqc39e': {
      'en': 'Fashion',
      'sw': '',
    },
    'si1ume58': {
      'en': 'Fashion',
      'sw': '',
    },
    '8xlqxv3e': {
      'en': 'Fashion',
      'sw': '',
    },
    '30ay631t': {
      'en': 'Fashion',
      'sw': '',
    },
    '7uc2sp0u': {
      'en': 'Fashion',
      'sw': '',
    },
    'iogodddi': {
      'en': 'Fashion',
      'sw': '',
    },
    'j4u5rv03': {
      'en': 'Fashion',
      'sw': '',
    },
    'ibd9404p': {
      'en': 'Fashion',
      'sw': '',
    },
    't64r4xdl': {
      'en': 'Fashion',
      'sw': '',
    },
    '5mgfzu3d': {
      'en': 'Fashion',
      'sw': '',
    },
    'iaq5n20c': {
      'en': 'Fashion',
      'sw': '',
    },
    'urphe0bj': {
      'en': 'Home',
      'sw': '',
    },
  },
  // order1
  {
    'edevaajg': {
      'en': 'On the way',
      'sw': '',
    },
    '5oo6bj01': {
      'en': 'Order',
      'sw': '',
    },
    'rh6xglvc': {
      'en': 'Arriving today, 5:30 – 6:00 PM',
      'sw': '',
    },
    'tjpfn907': {
      'en': '50%',
      'sw': '',
    },
    '8xkigvfu': {
      'en': 'Confirmed',
      'sw': '',
    },
    '71k2uxp1': {
      'en': 'Packed',
      'sw': '',
    },
    'g1wg3lug': {
      'en': 'On the way',
      'sw': '',
    },
    'km20uag9': {
      'en': 'Delivered',
      'sw': '',
    },
    'dli7z6zz': {
      'en': 'Track delivery',
      'sw': '',
    },
    '9ph294wu': {
      'en': 'Track now',
      'sw': 'Fuatilia sasa',
    },
    'fhz91qny': {
      'en': 'Order items',
      'sw': '',
    },
    '5h33j3ai': {
      'en': 'View all items',
      'sw': '',
    },
    'utsrpmvj': {
      'en': 'Delivery address',
      'sw': '',
    },
    'qe2kw26n': {
      'en': '1234 Park Avenue, Apt 12B',
      'sw': '',
    },
    'goccr05y': {
      'en': 'New York, NY 10016',
      'sw': '',
    },
    'u4betv9n': {
      'en': 'Your driver',
      'sw': 'Mletaji wako',
    },
    'ad2g55bc': {
      'en': 'Groceria Express Van',
      'sw': '',
    },
    '2wmm4fiv': {
      'en': 'Call',
      'sw': '',
    },
    '6929v3o3': {
      'en': 'Chat',
      'sw': '',
    },
    'opgihtel': {
      'en': 'Cancel Order',
      'sw': '',
    },
    '9q38syac': {
      'en': 'Need help',
      'sw': '',
    },
    'lcoaod20': {
      'en': 'Home',
      'sw': 'Nyumbani',
    },
  },
  // selectSeller
  {
    'rp8xfdfa': {
      'en': 'Select Sellers',
      'sw': '',
    },
    '7762oj9k': {
      'en': 'Chat',
      'sw': 'Nyumbani',
    },
  },
  // ChatD
  {
    'w1qzy82z': {
      'en': 'Sellers',
      'sw': '',
    },
    '6llmdsvd': {
      'en': 'Online',
      'sw': '',
    },
    'e9emcm0c': {
      'en': 'DISCUSSING PRODUCT',
      'sw': '',
    },
    'fbs6jpsv': {
      'en': 'In Stock',
      'sw': '',
    },
    'o92ovba4': {
      'en': 'View Item',
      'sw': '',
    },
    '2px9utm3': {
      'en': 'Type a message...',
      'sw': '',
    },
  },
  // KidsClothing
  {
    'yrt1v51k': {
      'en': 'Fashion',
      'sw': '',
    },
    'ko6n1htz': {
      'en': 'Kids’ Clothing',
      'sw': '',
    },
    'y8utvhex': {
      'en': 'Change',
      'sw': '',
    },
    '0l0kaolp': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'ayo3c5ux': {
      'en': 'Add Photo',
      'sw': '',
    },
    '90szp6eq': {
      'en': 'COVER',
      'sw': '',
    },
    'ts2bcg46': {
      'en': 'Product Name',
      'sw': '',
    },
    'rz7xyyuk': {
      'en': 'Product Name',
      'sw': '',
    },
    'ltiqpluo': {
      'en': 'Product Name',
      'sw': '',
    },
    'm1qu9vow': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'rbitwpl8': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'bcn919d8': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'zt2zpy47': {
      'en': 'Product Collection',
      'sw': '',
    },
    'g7afmuii': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'qrnpxekf': {
      'en': 'Kids’ Clothing',
      'sw': '',
    },
    '43wfs936': {
      'en': 'Select Kids’ Clothing Category',
      'sw': '',
    },
    'phse5eyf': {
      'en': 'Select...',
      'sw': '',
    },
    'zsxukhan': {
      'en': 'Search...',
      'sw': '',
    },
    '4xoc3i7k': {
      'en': 'Newborn & Baby',
      'sw': '',
    },
    'ahuih179': {
      'en': 'Toddler',
      'sw': '',
    },
    'wx8rodnt': {
      'en': 'Boys\' Clothing',
      'sw': '',
    },
    'r2xbni0p': {
      'en': 'Girls\' Clothing',
      'sw': '',
    },
    'kxmo6tju': {
      'en': 'School Uniforms',
      'sw': '',
    },
    'm3ezqtmi': {
      'en': ' Sizes',
      'sw': '',
    },
    'jvwu4d3z': {
      'en': '0-3M',
      'sw': '',
    },
    '9qrnaeoq': {
      'en': '3-6M',
      'sw': '',
    },
    'j216wdn1': {
      'en': '6-9M',
      'sw': '',
    },
    'igfvayqv': {
      'en': '9-12M',
      'sw': '',
    },
    '7bri2o1d': {
      'en': '12-18M',
      'sw': '',
    },
    '6h8l5i2k': {
      'en': '18-24M',
      'sw': '',
    },
    'ak9amo4g': {
      'en': '2-3Y',
      'sw': '',
    },
    '29kcos49': {
      'en': '4-5Y',
      'sw': '',
    },
    '16175rx5': {
      'en': '6-7Y',
      'sw': '',
    },
    'o0vk2qyc': {
      'en': '8-9Y',
      'sw': '',
    },
    'tw7ugw92': {
      'en': '10-11Y',
      'sw': '',
    },
    'w20duwpm': {
      'en': '12-14Y',
      'sw': '',
    },
    'eiu3mrp4': {
      'en': 'Selct Color',
      'sw': '',
    },
    'opm91s3n': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'zkghcm18': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'ufdvbxof': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    '14ijvsph': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'ztnk9zhg': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'ofs20ilj': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'l5c0eo18': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'mzxbd2rr': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'zlvqyxa8': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'ljwlc6d2': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    '22yz3i8y': {
      'en': '💛 Gold',
      'sw': '',
    },
    'p4i6p2ju': {
      'en': 'Material & Fabric',
      'sw': '',
    },
    'lmv325bj': {
      'en': 'Select...',
      'sw': '',
    },
    'q4qr4f1w': {
      'en': 'Search...',
      'sw': '',
    },
    'i7wgwe1r': {
      'en': '100% Cotton',
      'sw': 'Pamba',
    },
    'snrtq9yx': {
      'en': 'Fleece',
      'sw': 'Kitani',
    },
    '0eumh2iu': {
      'en': 'Wool',
      'sw': 'Sufu',
    },
    'nyypadmp': {
      'en': 'Polyester',
      'sw': 'Polyester',
    },
    '4bfbswin': {
      'en': 'Denim',
      'sw': 'Jeans',
    },
    'jsz94vtc': {
      'en': 'Soft Wool',
      'sw': '',
    },
    '9ityrfw4': {
      'en': 'Machine Washable',
      'sw': '',
    },
    '5vmii380': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    '3d7s51be': {
      'en': 'Boy',
      'sw': '',
    },
    '4ci42tlv': {
      'en': 'Girl',
      'sw': '',
    },
    'vijbu0rw': {
      'en': 'Unisex',
      'sw': '',
    },
    'rp5d47r7': {
      'en': 'Daily Wear',
      'sw': '',
    },
    '6j7gowoa': {
      'en': 'Party/Holiday',
      'sw': '',
    },
    '05wbr1wu': {
      'en': 'Sleepwear',
      'sw': '',
    },
    '961bcm8x': {
      'en': 'School/Active',
      'sw': '',
    },
    '6zjrwvxq': {
      'en': 'Solid',
      'sw': 'Rangi Moja',
    },
    'jecygpr1': {
      'en': 'Striped',
      'sw': 'Mistari',
    },
    'u1rxqxsz': {
      'en': 'Printed',
      'sw': 'Picha',
    },
    'c3280klf': {
      'en': 'Plain',
      'sw': '',
    },
    '1hz9noyw': {
      'en': 'Cartoons',
      'sw': '',
    },
    '7pw6pjoo': {
      'en': 'Animals',
      'sw': '',
    },
    '6fqed6u7': {
      'en': 'Brand New',
      'sw': '',
    },
    'kzdv361v': {
      'en': 'Like New',
      'sw': '',
    },
    '5rrr9ugl': {
      'en': 'Gently Used',
      'sw': '',
    },
    'z14y2ftv': {
      'en': 'Set Adress',
      'sw': '',
    },
    'p9pu4tem': {
      'en': 'location',
      'sw': '',
    },
    'kghcoqra': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'zeqmfqhm': {
      'en': 'Contact information',
      'sw': '',
    },
    'aqzrkw18': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '1hdt22eg': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '1epo870g': {
      'en': 'Call no',
      'sw': '',
    },
    'r1fddn48': {
      'en': 'Call no',
      'sw': '',
    },
    'ydu52sml': {
      'en': 'Price',
      'sw': '',
    },
    'j13wlu9i': {
      'en': 'Price',
      'sw': '',
    },
    'jr602ih3': {
      'en': '0.00',
      'sw': '',
    },
    '1tpavxdq': {
      'en': 'Please set a price',
      'sw': '',
    },
    'vz68d2h7': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'v1cd7t9x': {
      'en': 'Description',
      'sw': '',
    },
    'o86xm9kj': {
      'en': 'Product description',
      'sw': '',
    },
    'ghwvd79d': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'ninto9s7': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'wso2v3gp': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'ycesl2lw': {
      'en': 'Trending',
      'sw': '',
    },
    'ynxty7oy': {
      'en': 'New Arrival',
      'sw': '',
    },
    '9c8x895z': {
      'en': 'Show in All',
      'sw': '',
    },
    'wftv3st9': {
      'en': 'Post Now',
      'sw': '',
    },
    'r66sn15z': {
      'en': 'Home',
      'sw': '',
    },
  },
  // UnderwearSocks
  {
    'as14p7ee': {
      'en': 'Fashion',
      'sw': '',
    },
    '9w7lud8m': {
      'en': 'Underwear & Socks',
      'sw': '',
    },
    '2otf0mi2': {
      'en': 'Change',
      'sw': '',
    },
    'pyjy2g63': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'hgqghrqs': {
      'en': 'Add Photo',
      'sw': '',
    },
    'hm0u74uz': {
      'en': 'COVER',
      'sw': '',
    },
    'hnkwjkhk': {
      'en': 'Product Name',
      'sw': '',
    },
    'wm1plewd': {
      'en': 'Product Name',
      'sw': '',
    },
    'wel3rqh3': {
      'en': 'Product Name',
      'sw': '',
    },
    'x8s1exu4': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '7c5p871n': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'bjph4arc': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '0uino01u': {
      'en': 'Product Collection',
      'sw': '',
    },
    'xkxrxuai': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'fv0uhe9x': {
      'en': 'Underwear & Socks',
      'sw': '',
    },
    'jj8gi5vx': {
      'en': 'Select Women’s Wear',
      'sw': '',
    },
    'pg5ls6cz': {
      'en': 'Select...',
      'sw': '',
    },
    'etmrfe9m': {
      'en': 'Search...',
      'sw': '',
    },
    'rmmzp07l': {
      'en': 'Men\'s Underwear',
      'sw': '',
    },
    'zmxskkmt': {
      'en': 'Women\'s Underwear',
      'sw': '',
    },
    'xipyui43': {
      'en': 'Kids\' Underwear',
      'sw': '',
    },
    '6cem7lv6': {
      'en': 'Socks',
      'sw': '',
    },
    'pmqou2zp': {
      'en': 'Select Size',
      'sw': '',
    },
    '27bea28g': {
      'en': 'S',
      'sw': '',
    },
    '50jmbevg': {
      'en': 'M',
      'sw': '',
    },
    '4poibsp4': {
      'en': 'L',
      'sw': '',
    },
    'hbw3skxj': {
      'en': 'XL',
      'sw': '',
    },
    'amp6mtk0': {
      'en': 'XXL',
      'sw': '',
    },
    'z3dkhfmc': {
      'en': 'Select color',
      'sw': '',
    },
    'v9jk4d05': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'y00btmod': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'umizxw76': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'q1pv34q4': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    '4mx2ou3v': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    '5i4tjmdg': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'k5bnxkdm': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'kurdmafn': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'ptuenioz': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'o0npnf84': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'egofq4tq': {
      'en': '💛 Gold',
      'sw': '',
    },
    'ptwqmmyz': {
      'en': 'Select Material',
      'sw': '',
    },
    'yhmcmwl6': {
      'en': 'Select...',
      'sw': '',
    },
    'oju6tnzg': {
      'en': 'Search...',
      'sw': '',
    },
    '6bgmv2al': {
      'en': '100% Cotton',
      'sw': 'Pamba',
    },
    '7ifo800g': {
      'en': 'Sports/Synthetic',
      'sw': 'Hariri',
    },
    '49zv3f93': {
      'en': 'Wool',
      'sw': 'Sufu',
    },
    '0b6gzamg': {
      'en': 'Polyester',
      'sw': 'Polyester',
    },
    'yg69lj2t': {
      'en': 'Denim',
      'sw': 'Jeans',
    },
    '55zi41p4': {
      'en': 'Velvet',
      'sw': 'Nguo ya manyoya',
    },
    '3rghx9ls': {
      'en': 'Length & Fit and Pattern',
      'sw': '',
    },
    'ihyud6f8': {
      'en': 'One Size',
      'sw': '',
    },
    'hdbl14sv': {
      'en': 'Small',
      'sw': '',
    },
    'upmvl60r': {
      'en': 'Large',
      'sw': '',
    },
    'wg9cv8tf': {
      'en': 'Single Piece',
      'sw': 'Rangi Moja',
    },
    'fimf1qf5': {
      'en': '3-Pack',
      'sw': 'Mistari',
    },
    '7dyidf5x': {
      'en': '6-Pack',
      'sw': 'Picha',
    },
    'a3ve1m60': {
      'en': '12-Pack',
      'sw': 'Maua',
    },
    '4q7xwxic': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    'r6hmlhnu': {
      'en': 'New',
      'sw': '',
    },
    'usddedpz': {
      'en': 'Used',
      'sw': '',
    },
    't06f2n5x': {
      'en': 'Set Adress',
      'sw': '',
    },
    'th5az35b': {
      'en': 'Contact information',
      'sw': '',
    },
    '46ojboea': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'gm3m90zk': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '3xmovycr': {
      'en': 'Call no',
      'sw': '',
    },
    'w0o9941f': {
      'en': 'Call no',
      'sw': '',
    },
    'kl1gqhmx': {
      'en': 'Price',
      'sw': '',
    },
    'm9oscsfs': {
      'en': 'Price',
      'sw': '',
    },
    'tzhv9uj9': {
      'en': '0.00',
      'sw': '',
    },
    'tpb91g3i': {
      'en': 'Please set a price',
      'sw': '',
    },
    'wmhbwu0p': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'fqb9u4cl': {
      'en': 'Description',
      'sw': '',
    },
    'k1zbiwak': {
      'en': 'Product description',
      'sw': '',
    },
    '7gdoy9tl': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'ozaa72jk': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'owcv0lhz': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '89cnz462': {
      'en': 'Trending',
      'sw': '',
    },
    '3utikioj': {
      'en': 'New Arrival',
      'sw': '',
    },
    'w819kw1m': {
      'en': 'Show in All',
      'sw': '',
    },
    'vdt32ocq': {
      'en': 'Post Now',
      'sw': '',
    },
    'welpcqri': {
      'en': 'Home',
      'sw': '',
    },
  },
  // SneakersSports
  {
    'gv0oyl5g': {
      'en': 'Shoes',
      'sw': '',
    },
    '0g1ikjfq': {
      'en': 'Sneakers & Sports',
      'sw': '',
    },
    'l40a1dvo': {
      'en': 'Change',
      'sw': '',
    },
    'd0kp5cij': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'z08iq9ir': {
      'en': 'Add Photo',
      'sw': '',
    },
    'tgcyrov5': {
      'en': 'COVER',
      'sw': '',
    },
    'uhtiad5p': {
      'en': 'Product Name',
      'sw': '',
    },
    '82ye725b': {
      'en': 'Product Name',
      'sw': '',
    },
    'lyarkp7p': {
      'en': 'Product Name',
      'sw': '',
    },
    'xsr1vo3y': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'rtuiwz81': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'z28ee3bg': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '016yufyc': {
      'en': 'Product Collection',
      'sw': '',
    },
    'e0xq4ay5': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'to3v76jv': {
      'en': 'Sneakers & Sports',
      'sw': '',
    },
    '4cyktowd': {
      'en': 'Select  Category',
      'sw': '',
    },
    'afrc4p1k': {
      'en': 'Select...',
      'sw': '',
    },
    'sm3eft58': {
      'en': 'Search...',
      'sw': '',
    },
    'brigs8qg': {
      'en': 'Men\'s Sneakers',
      'sw': '',
    },
    '5g0so5ht': {
      'en': 'Women\'s Sneakers',
      'sw': '',
    },
    'aik3h2vj': {
      'en': 'Kids\' Sneakers',
      'sw': '',
    },
    'a5zapdc8': {
      'en': 'Sports/Running',
      'sw': '',
    },
    '121n7tgk': {
      'en': ' Sizes',
      'sw': '',
    },
    'oe9ccmqp': {
      'en': '28',
      'sw': '',
    },
    'e8zjj758': {
      'en': '30',
      'sw': '',
    },
    'ym80y28g': {
      'en': '32',
      'sw': '',
    },
    '0ndpwd1a': {
      'en': '34',
      'sw': '',
    },
    'iewe2p1e': {
      'en': '36',
      'sw': '',
    },
    'n6rdpy2c': {
      'en': '38',
      'sw': '',
    },
    'j5chmn2z': {
      'en': '39',
      'sw': '',
    },
    'sfiw4kal': {
      'en': '40',
      'sw': '',
    },
    'p7qq71mh': {
      'en': '41',
      'sw': '',
    },
    'cxwl8ic8': {
      'en': '42',
      'sw': '',
    },
    '9pyxwux8': {
      'en': '43',
      'sw': '',
    },
    '2bf9zc1v': {
      'en': '44',
      'sw': '',
    },
    '9vxh3ri7': {
      'en': '45',
      'sw': '',
    },
    '1r9vpkxc': {
      'en': 'Selct Color',
      'sw': '',
    },
    '5gcwkeoz': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'hn0qxlwv': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'zalerqxq': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'gqu8z73l': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'hhj1jlm8': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'nzhfvq0v': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'wf3q7qv2': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'p82um3iw': {
      'en': '⚪ White\n',
      'sw': '',
    },
    '82mxijf9': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'rq9sevvt': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'spx9b995': {
      'en': '💛 Gold',
      'sw': '',
    },
    'wmh4585w': {
      'en': 'Material & Fabric',
      'sw': '',
    },
    'a16f495t': {
      'en': 'Select...',
      'sw': '',
    },
    'rhhqs71k': {
      'en': 'Search...',
      'sw': '',
    },
    'oroandu6': {
      'en': 'Leather',
      'sw': 'Pamba',
    },
    'ugl6mtug': {
      'en': 'Mesh/Knit',
      'sw': 'Kitani',
    },
    'v2chldrr': {
      'en': 'Suede',
      'sw': 'Sufu',
    },
    'jn7wjqcf': {
      'en': 'Synthetic',
      'sw': 'Polyester',
    },
    'qe06v1bu': {
      'en': 'Canvas',
      'sw': 'Jeans',
    },
    'f2qwibey': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'pgvcaik9': {
      'en': 'Casual/Streetwear',
      'sw': '',
    },
    'nkt4foxb': {
      'en': 'Running/Gym',
      'sw': '',
    },
    'we9s3pre': {
      'en': 'Football/Soccer',
      'sw': '',
    },
    '57q2olct': {
      'en': 'Daily Wear',
      'sw': '',
    },
    'ocyumgji': {
      'en': 'Basketball',
      'sw': '',
    },
    '6adj2igk': {
      'en': 'School/Active',
      'sw': '',
    },
    'm8fym685': {
      'en': 'Nike',
      'sw': '',
    },
    'ys47m849': {
      'en': 'Adidas',
      'sw': '',
    },
    'oxxa4gqd': {
      'en': 'Jordan',
      'sw': '',
    },
    's9zx08yc': {
      'en': 'Puma',
      'sw': '',
    },
    'h0m8agmq': {
      'en': 'Reebok',
      'sw': '',
    },
    'bttb45kj': {
      'en': 'New Balance',
      'sw': '',
    },
    '13ubyiwd': {
      'en': 'Balenciaga',
      'sw': '',
    },
    'o5ike2ew': {
      'en': 'Gucci',
      'sw': '',
    },
    'ku8qfutj': {
      'en': 'Brand New',
      'sw': '',
    },
    'a4av662k': {
      'en': 'Like New',
      'sw': '',
    },
    '1i7za6zp': {
      'en': 'Gently Used',
      'sw': '',
    },
    'shphxxs6': {
      'en': 'Set Adress',
      'sw': '',
    },
    'kk0azm1u': {
      'en': 'Contact information',
      'sw': '',
    },
    'ay5en110': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'npb9gb80': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '63s1q3ug': {
      'en': 'Call no',
      'sw': '',
    },
    'gtmzi8gc': {
      'en': 'Call no',
      'sw': '',
    },
    'gg2gmd8t': {
      'en': 'Price',
      'sw': '',
    },
    '0gf8ya3s': {
      'en': 'Price',
      'sw': '',
    },
    'lbbxdu2s': {
      'en': '0.00',
      'sw': '',
    },
    '51m2dx7l': {
      'en': 'Please set a price',
      'sw': '',
    },
    'bepiy20k': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'ihxtbmhf': {
      'en': 'Description',
      'sw': '',
    },
    'm57evu66': {
      'en': 'Product description',
      'sw': '',
    },
    '8hzcb3qw': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'dywbzaxo': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'pmjp95yk': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gaoi1nj8': {
      'en': 'Trending',
      'sw': '',
    },
    '3onocsws': {
      'en': 'New Arrival',
      'sw': '',
    },
    'un16rtpf': {
      'en': 'Show in All',
      'sw': '',
    },
    '5add32ch': {
      'en': 'Post Now',
      'sw': '',
    },
    'wjfyu8wh': {
      'en': 'Home',
      'sw': '',
    },
  },
  // FormalShoes
  {
    'avwcob1f': {
      'en': 'Shoes',
      'sw': '',
    },
    'ccrz7rxu': {
      'en': 'Formal Shoes',
      'sw': '',
    },
    'gn5uotk6': {
      'en': 'Change',
      'sw': '',
    },
    'toxw82qn': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'g3a2lqux': {
      'en': 'Add Photo',
      'sw': '',
    },
    'ovhy0e85': {
      'en': 'COVER',
      'sw': '',
    },
    '659zh9wk': {
      'en': 'Product Name',
      'sw': '',
    },
    '0l4eov2q': {
      'en': 'Product Name',
      'sw': '',
    },
    '5lteeyz2': {
      'en': 'Product Name',
      'sw': '',
    },
    'o18jo93k': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'r9c6y60s': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'fuusw5du': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'bbri7asc': {
      'en': 'Product Collection',
      'sw': '',
    },
    '6jdl2zah': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'pr62h1oo': {
      'en': 'Formal Shoes',
      'sw': '',
    },
    'gqo7f54s': {
      'en': 'Select  Category',
      'sw': '',
    },
    '8i4atjac': {
      'en': 'Select...',
      'sw': '',
    },
    'hi8z178l': {
      'en': 'Search...',
      'sw': '',
    },
    '886j45pw': {
      'en': 'Men\'s Formal',
      'sw': '',
    },
    'i68ii3vh': {
      'en': 'Women\'s Formal/Heels',
      'sw': '',
    },
    'h1t3yhfz': {
      'en': 'Boots',
      'sw': '',
    },
    'ac87j6ok': {
      'en': 'Loafers',
      'sw': '',
    },
    'wvx6er8r': {
      'en': ' Sizes',
      'sw': '',
    },
    'rnygu1wk': {
      'en': '28',
      'sw': '',
    },
    'f1hoeita': {
      'en': '30',
      'sw': '',
    },
    'o9355aq6': {
      'en': '32',
      'sw': '',
    },
    '6ebb00h8': {
      'en': '34',
      'sw': '',
    },
    'nrhi7hcv': {
      'en': '36',
      'sw': '',
    },
    '0h4hyelk': {
      'en': '38',
      'sw': '',
    },
    'mn1ypxpe': {
      'en': '39',
      'sw': '',
    },
    'jltdhxeo': {
      'en': '40',
      'sw': '',
    },
    'w9zhlfm8': {
      'en': '41',
      'sw': '',
    },
    'pl0rm28c': {
      'en': '42',
      'sw': '',
    },
    '3qzx0p6q': {
      'en': '43',
      'sw': '',
    },
    'ctlpuhhh': {
      'en': '44',
      'sw': '',
    },
    'fjkfjij4': {
      'en': '45',
      'sw': '',
    },
    'gbim6q1t': {
      'en': 'Selct Color',
      'sw': '',
    },
    'e4ehmshu': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'kp6ckfqb': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'x7e2hewg': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'kzhtupvo': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    '8bh81s3j': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'guo6dff2': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'rtrafsdi': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    '5celmgkq': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'l6mg6wi3': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'lrjlmdu8': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'cio2mid0': {
      'en': '💛 Gold',
      'sw': '',
    },
    'nehwjhr3': {
      'en': 'Material & Fabric',
      'sw': '',
    },
    '6pv0p0l2': {
      'en': 'Select...',
      'sw': '',
    },
    'fl1kaxrc': {
      'en': 'Search...',
      'sw': '',
    },
    'qbymrk0z': {
      'en': 'Leather',
      'sw': 'Pamba',
    },
    '6ikkinnd': {
      'en': 'Patent Leather',
      'sw': 'Kitani',
    },
    '5meyp2jb': {
      'en': 'Suede',
      'sw': 'Sufu',
    },
    'pllawkc0': {
      'en': 'Synthetic',
      'sw': 'Polyester',
    },
    'd1ka2jmo': {
      'en': 'Canvas',
      'sw': 'Jeans',
    },
    'z1e4xmvd': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'qclnmgxk': {
      'en': 'Oxford/Lace-up',
      'sw': '',
    },
    'mfcnizjm': {
      'en': 'Loafers/Slip-on',
      'sw': '',
    },
    'u7af8acd': {
      'en': 'Monk Strap',
      'sw': '',
    },
    'uggys3qx': {
      'en': 'Daily Wear',
      'sw': '',
    },
    '8t4qoreu': {
      'en': 'Chelsea Boots',
      'sw': '',
    },
    '9yv42u7z': {
      'en': 'School/Active',
      'sw': '',
    },
    '6z4v11ou': {
      'en': 'Nike',
      'sw': '',
    },
    'pvbd3n8f': {
      'en': 'Adidas',
      'sw': '',
    },
    'khuoh9pd': {
      'en': 'Jordan',
      'sw': '',
    },
    'ycpplct7': {
      'en': 'Puma',
      'sw': '',
    },
    'j0s5q7l2': {
      'en': 'Reebok',
      'sw': '',
    },
    'zwkqvcu1': {
      'en': 'New Balance',
      'sw': '',
    },
    '7b7niv78': {
      'en': 'Balenciaga',
      'sw': '',
    },
    'zpa1l2qs': {
      'en': 'Gucci',
      'sw': '',
    },
    'h1530950': {
      'en': 'Brand New',
      'sw': '',
    },
    'ddl7oli7': {
      'en': 'Like New',
      'sw': '',
    },
    't5beprvp': {
      'en': 'Gently Used',
      'sw': '',
    },
    'r6sipiir': {
      'en': 'Set Adress',
      'sw': '',
    },
    'zfb2w2jr': {
      'en': 'Contact information',
      'sw': '',
    },
    '3oti3jfl': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'q9dzw6yv': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'fabrynci': {
      'en': 'Call no',
      'sw': '',
    },
    'vw6u5xrp': {
      'en': 'Call no',
      'sw': '',
    },
    'cn89y8sq': {
      'en': 'Price',
      'sw': '',
    },
    'gmzs8ehd': {
      'en': 'Price',
      'sw': '',
    },
    'dh4o3rna': {
      'en': '0.00',
      'sw': '',
    },
    'q74q352p': {
      'en': 'Please set a price',
      'sw': '',
    },
    'qtwvk8bf': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'yqi9m7mh': {
      'en': 'Description',
      'sw': '',
    },
    'w0di4wxh': {
      'en': 'Product description',
      'sw': '',
    },
    'llqyo02m': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'ziccu5uv': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'tf75c0ek': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'hj7cbbwj': {
      'en': 'Trending',
      'sw': '',
    },
    '2h9wi2yt': {
      'en': 'New Arrival',
      'sw': '',
    },
    'e819e8f2': {
      'en': 'Show in All',
      'sw': '',
    },
    'mrmp6an6': {
      'en': 'Post Now',
      'sw': '',
    },
    'c8gus6nt': {
      'en': 'Home',
      'sw': '',
    },
  },
  // SandalsSlippers
  {
    'misc5s8q': {
      'en': 'Shoes',
      'sw': '',
    },
    '0ysd69w9': {
      'en': 'Sandals & Slippers',
      'sw': '',
    },
    'zixw9wac': {
      'en': 'Change',
      'sw': '',
    },
    'yhwz2l24': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'wumfak6i': {
      'en': 'Add Photo',
      'sw': '',
    },
    'se7x23kn': {
      'en': 'COVER',
      'sw': '',
    },
    '1pqf8ylz': {
      'en': 'Product Name',
      'sw': '',
    },
    '9hsss8vd': {
      'en': 'Product Name',
      'sw': '',
    },
    'e7956g2m': {
      'en': 'Product Name',
      'sw': '',
    },
    'qnv27be5': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'm5gx8p9t': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'rpe5vu7o': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'fm33aogm': {
      'en': 'Product Collection',
      'sw': '',
    },
    'krykcjga': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'zs7ciauy': {
      'en': 'Sandals & Slippers',
      'sw': '',
    },
    '2pwa125x': {
      'en': 'Select  Category',
      'sw': '',
    },
    'rvu3tqsy': {
      'en': 'Select...',
      'sw': '',
    },
    'ekezd9ku': {
      'en': 'Search...',
      'sw': '',
    },
    'ooyjek6g': {
      'en': 'Men\'s Sandals',
      'sw': '',
    },
    'jnu0v9lg': {
      'en': 'Women\'s Sandals',
      'sw': '',
    },
    'nzuc40t5': {
      'en': 'Home Slippers',
      'sw': '',
    },
    'q0ot7vbu': {
      'en': 'Beach/Pool Slides',
      'sw': '',
    },
    '2en6aldj': {
      'en': ' Sizes',
      'sw': '',
    },
    'neeuywgh': {
      'en': '28',
      'sw': '',
    },
    'jpdx9daz': {
      'en': '30',
      'sw': '',
    },
    '5wbgqi3w': {
      'en': '32',
      'sw': '',
    },
    'woic00pb': {
      'en': '34',
      'sw': '',
    },
    '2lvnho7s': {
      'en': '36',
      'sw': '',
    },
    'imotg2ro': {
      'en': '38',
      'sw': '',
    },
    'jqg2xh62': {
      'en': '39',
      'sw': '',
    },
    '5cg9kxtn': {
      'en': '40',
      'sw': '',
    },
    'kb56rlnp': {
      'en': '41',
      'sw': '',
    },
    '4jr9md0l': {
      'en': '42',
      'sw': '',
    },
    'o06hbtel': {
      'en': '43',
      'sw': '',
    },
    '76pan5y7': {
      'en': '44',
      'sw': '',
    },
    'xspb3mpm': {
      'en': '45',
      'sw': '',
    },
    'sul1dygx': {
      'en': 'Selct Color',
      'sw': '',
    },
    'vzal0lby': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'dffa434l': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'zgmwps3y': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'm4s9q3um': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'isljxqhx': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    '805haepd': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    '637q6pfr': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    's3irmrff': {
      'en': '⚪ White\n',
      'sw': '',
    },
    '5oiynr1c': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    '73qq6ht1': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    '95w5ovyy': {
      'en': '💛 Gold',
      'sw': '',
    },
    'tbkkv842': {
      'en': 'Material & Fabric',
      'sw': '',
    },
    'w58dz83c': {
      'en': 'Select...',
      'sw': '',
    },
    'yf0qcoya': {
      'en': 'Search...',
      'sw': '',
    },
    'gdtzifzy': {
      'en': 'Rubber/Plastic',
      'sw': 'Pamba',
    },
    '0760y6c2': {
      'en': 'Leather',
      'sw': 'Kitani',
    },
    'qnvc4mn1': {
      'en': 'Fabric/Fluff',
      'sw': 'Sufu',
    },
    'edgyzgqi': {
      'en': 'Synthetic',
      'sw': 'Polyester',
    },
    '5rm5bsqs': {
      'en': 'Canvas',
      'sw': 'Jeans',
    },
    'qmyewry4': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'oevysfib': {
      'en': 'Oxford/Lace-up',
      'sw': '',
    },
    'fegr2di3': {
      'en': 'Loafers/Slip-on',
      'sw': '',
    },
    'yr8fzrn2': {
      'en': 'Monk Strap',
      'sw': '',
    },
    'cmt2yknk': {
      'en': 'Daily Wear',
      'sw': '',
    },
    '9jwxjokt': {
      'en': 'Flip-Flops',
      'sw': '',
    },
    '7g15g42b': {
      'en': 'Slides',
      'sw': '',
    },
    '25fq0tzy': {
      'en': 'Gladiator/Strappy',
      'sw': '',
    },
    'qycohb70': {
      'en': 'Nike',
      'sw': '',
    },
    'kls7ywyp': {
      'en': 'Adidas',
      'sw': '',
    },
    '54y5sp71': {
      'en': 'Jordan',
      'sw': '',
    },
    'ofnd49wq': {
      'en': 'Puma',
      'sw': '',
    },
    'rm5beo45': {
      'en': 'Reebok',
      'sw': '',
    },
    'gy97q1n3': {
      'en': 'New Balance',
      'sw': '',
    },
    'd1nv3fma': {
      'en': 'Balenciaga',
      'sw': '',
    },
    '5ref1az4': {
      'en': 'Gucci',
      'sw': '',
    },
    '58re7gl7': {
      'en': 'Brand New',
      'sw': '',
    },
    'dciqgdzw': {
      'en': 'Like New',
      'sw': '',
    },
    'bzewpzbg': {
      'en': 'Gently Used',
      'sw': '',
    },
    'w7t7ol4k': {
      'en': 'Set Adress',
      'sw': '',
    },
    '4utvaf2j': {
      'en': 'location',
      'sw': '',
    },
    'aqbepaae': {
      'en': 'Enter your location',
      'sw': '',
    },
    '1hnwpn60': {
      'en': 'Contact information',
      'sw': '',
    },
    '9qcoyzg5': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '96mglejv': {
      'en': 'WhatsApp no',
      'sw': 'WhatsApp',
    },
    '24zzdluh': {
      'en': 'Call no',
      'sw': '',
    },
    'hnq13edp': {
      'en': 'Call no',
      'sw': '',
    },
    'xcr7w6je': {
      'en': 'Price',
      'sw': '',
    },
    'njt680sh': {
      'en': 'Price',
      'sw': '',
    },
    'gmuw9m7z': {
      'en': '00,000',
      'sw': '',
    },
    'sxsqqthv': {
      'en': 'Please set a price',
      'sw': '',
    },
    'imky03fu': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'alhsxuqt': {
      'en': 'Description',
      'sw': '',
    },
    'go0xa8sb': {
      'en': 'Product description',
      'sw': '',
    },
    'vih5a09e': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'wc5o8uyx': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'po9sp39w': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '3u3dj4xo': {
      'en': 'Trending',
      'sw': '',
    },
    'l30whv24': {
      'en': 'New Arrival',
      'sw': '',
    },
    'vdonrae8': {
      'en': 'Show in All',
      'sw': '',
    },
    'xa1p6gdi': {
      'en': 'Post Now',
      'sw': '',
    },
    'jsctmr01': {
      'en': 'Home',
      'sw': '',
    },
  },
  // HeelsWedges
  {
    '4hrdvtnh': {
      'en': 'Shoes',
      'sw': '',
    },
    '9cr48jeu': {
      'en': 'Heels & Wedges',
      'sw': '',
    },
    '1e83exib': {
      'en': 'Change',
      'sw': '',
    },
    '5jgdxlz2': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'nweyyqpx': {
      'en': 'Add Photo',
      'sw': '',
    },
    'dm76zl83': {
      'en': 'COVER',
      'sw': '',
    },
    'epogj0nz': {
      'en': 'Product Name',
      'sw': '',
    },
    'ffuqua7v': {
      'en': 'Product Name',
      'sw': '',
    },
    'nuk6gkj2': {
      'en': 'Product Name',
      'sw': '',
    },
    'g5937eps': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '3pp91dx3': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'bkf905q8': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'seqkqvty': {
      'en': 'Product Collection',
      'sw': '',
    },
    'je6dkuyu': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '29kckpnx': {
      'en': 'Heels & Wedges',
      'sw': '',
    },
    'vj69549b': {
      'en': 'Select  Category',
      'sw': '',
    },
    'e9nzvn6a': {
      'en': 'Select...',
      'sw': '',
    },
    'cv0qamtb': {
      'en': 'Search...',
      'sw': '',
    },
    'vas6exzg': {
      'en': 'High Heels',
      'sw': '',
    },
    '28xyvgj6': {
      'en': 'Wedges',
      'sw': '',
    },
    '3gp6uhmz': {
      'en': ' Block Heels',
      'sw': '',
    },
    'kf86ysq7': {
      'en': 'Stilettos',
      'sw': '',
    },
    'e4t60y7j': {
      'en': ' Sizes',
      'sw': '',
    },
    'd2jwrzl3': {
      'en': '34',
      'sw': '',
    },
    'p0lfadzh': {
      'en': '35',
      'sw': '',
    },
    'hwz32fla': {
      'en': '36',
      'sw': '',
    },
    '9y69owz6': {
      'en': '37',
      'sw': '',
    },
    'i5hvcifm': {
      'en': '38',
      'sw': '',
    },
    'xyur5hf9': {
      'en': '39',
      'sw': '',
    },
    't1q4ygp6': {
      'en': '40',
      'sw': '',
    },
    '91yg2nrf': {
      'en': '41',
      'sw': '',
    },
    '28uh1ty2': {
      'en': 'Selct Color',
      'sw': '',
    },
    'vm7iz1g2': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    '9t9g7hhm': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'pv2w16tt': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'n4wt0wfh': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'pinamuek': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'n6dv4qh6': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    '7lkcwctl': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'dbklk82n': {
      'en': '⚪ White\n',
      'sw': '',
    },
    '856s3n8s': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'gkzbu1ij': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'lwpbxlnn': {
      'en': '💛 Gold',
      'sw': '',
    },
    'ai13jord': {
      'en': 'Material & Fabric',
      'sw': '',
    },
    'ughuuurj': {
      'en': 'Select...',
      'sw': '',
    },
    '65cgmhfy': {
      'en': 'Search...',
      'sw': '',
    },
    '6nuu4uuo': {
      'en': 'Suede',
      'sw': 'Pamba',
    },
    'cwcsrg4p': {
      'en': 'Shiny/Patent',
      'sw': 'Kitani',
    },
    's9hpty9x': {
      'en': 'Fabric/Fluff',
      'sw': 'Sufu',
    },
    'a4nj96c9': {
      'en': 'Matte',
      'sw': 'Polyester',
    },
    'q8pwlhz7': {
      'en': 'Glitter/Party',
      'sw': 'Jeans',
    },
    'pp4kucsg': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    '10odz769': {
      'en': 'Low (1–2 inches)',
      'sw': '',
    },
    'fosp63o9': {
      'en': 'Low (1–2 inches)',
      'sw': '',
    },
    '47dze8qc': {
      'en': 'High (4+ inches)',
      'sw': '',
    },
    '6uy9myf5': {
      'en': 'Nike',
      'sw': '',
    },
    '9ulwyw37': {
      'en': 'Adidas',
      'sw': '',
    },
    '2wgqjkbs': {
      'en': 'Jordan',
      'sw': '',
    },
    '1fabv0fv': {
      'en': 'Puma',
      'sw': '',
    },
    'tr65ixo5': {
      'en': 'Reebok',
      'sw': '',
    },
    'tvduznf5': {
      'en': 'New Balance',
      'sw': '',
    },
    'nifcl8w5': {
      'en': 'Balenciaga',
      'sw': '',
    },
    'm382yl76': {
      'en': 'Gucci',
      'sw': '',
    },
    'vuw0ustl': {
      'en': 'Brand New',
      'sw': '',
    },
    '7yxlyu1f': {
      'en': 'Like New',
      'sw': '',
    },
    'qub0nnq2': {
      'en': 'Gently Used',
      'sw': '',
    },
    '43yvtvrv': {
      'en': 'Set Adress',
      'sw': '',
    },
    'tuqtaxhf': {
      'en': 'location',
      'sw': '',
    },
    '90vixhoy': {
      'en': 'Enter your location',
      'sw': '',
    },
    'uplkjpez': {
      'en': 'Contact information',
      'sw': '',
    },
    'xzsc21z8': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'kf09rkb1': {
      'en': 'WhatsApp no',
      'sw': 'WhatsApp',
    },
    '09epv8dp': {
      'en': 'Call no',
      'sw': '',
    },
    'uh5zzdud': {
      'en': 'Call no',
      'sw': '',
    },
    '55ojxet1': {
      'en': 'Price',
      'sw': '',
    },
    '7sn8secf': {
      'en': 'Price',
      'sw': '',
    },
    'lqwtczsr': {
      'en': '00,000',
      'sw': '',
    },
    'slhhtvc6': {
      'en': 'Please set a price',
      'sw': '',
    },
    's5ekjifm': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '24ojnfzw': {
      'en': 'Description',
      'sw': '',
    },
    'c1hus4ig': {
      'en': 'Product description',
      'sw': '',
    },
    'khyibv9c': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'cmkxn9w4': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'jjycaleu': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'uogs82da': {
      'en': 'Trending',
      'sw': '',
    },
    '0xke9m1h': {
      'en': 'New Arrival',
      'sw': '',
    },
    '1vpufcz0': {
      'en': 'Show in All',
      'sw': '',
    },
    '10twehs5': {
      'en': 'Post Now',
      'sw': '',
    },
    'rsu2yd3o': {
      'en': 'Home',
      'sw': '',
    },
  },
  // ComputersLaptop
  {
    'z1ohp3qa': {
      'en': 'Electronics',
      'sw': '',
    },
    '2av7f649': {
      'en': 'Computers & Laptops',
      'sw': '',
    },
    '03yk47th': {
      'en': 'Change',
      'sw': '',
    },
    'dytpzu5j': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'yjkuminn': {
      'en': 'Add Photo',
      'sw': '',
    },
    'fknrpc59': {
      'en': 'COVER',
      'sw': '',
    },
    '7ghkvrma': {
      'en': 'Product Name',
      'sw': '',
    },
    '45m4g3kx': {
      'en': 'Product Name',
      'sw': '',
    },
    'u73k61uh': {
      'en': 'Product Name',
      'sw': '',
    },
    '7aqespgj': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'ni5zipfn': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '848to9x9': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'zeovj5dj': {
      'en': 'Product Collection',
      'sw': '',
    },
    'fbtnmt03': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'a5ekmtfl': {
      'en': 'Computers & Laptops',
      'sw': '',
    },
    'igwp0fus': {
      'en': 'Select  Category',
      'sw': '',
    },
    't4s42h9z': {
      'en': 'Select...',
      'sw': '',
    },
    'xttnee4n': {
      'en': 'Search...',
      'sw': '',
    },
    'c8z2z1h0': {
      'en': 'Apple',
      'sw': '',
    },
    'g66k79dj': {
      'en': 'Samsung',
      'sw': '',
    },
    '7t2nzjck': {
      'en': 'Sony',
      'sw': '',
    },
    'c66sp7c4': {
      'en': 'Dell',
      'sw': '',
    },
    't24towau': {
      'en': 'HP',
      'sw': '',
    },
    '6m6ahoql': {
      'en': 'Lenovo',
      'sw': '',
    },
    'esst7lk2': {
      'en': 'LG',
      'sw': '',
    },
    'fnqss5x1': {
      'en': 'Asus',
      'sw': '',
    },
    'b94i5l2y': {
      'en': 'Canon',
      'sw': '',
    },
    'gg4w5rgf': {
      'en': 'Nikon',
      'sw': '',
    },
    'lx4j0dk0': {
      'en': 'JBL',
      'sw': '',
    },
    'd1gwjghq': {
      'en': 'Xiaomi',
      'sw': '',
    },
    'h16f48kk': {
      'en': 'Google',
      'sw': '',
    },
    '2k57d9mu': {
      'en': 'Motorola',
      'sw': '',
    },
    'x0c1c4ww': {
      'en': 'OPPO',
      'sw': '',
    },
    'i13f0lqp': {
      'en': 'vivo',
      'sw': '',
    },
    '5za08zx4': {
      'en': 'Infinix & Tecno',
      'sw': '',
    },
    'rvgjhn3k': {
      'en': 'Huawei',
      'sw': '',
    },
    'ta2bntus': {
      'en': 'Realme',
      'sw': '',
    },
    '1h7tuq3w': {
      'en': 'OnePlus',
      'sw': '',
    },
    'bj3jarjy': {
      'en': 'Honor',
      'sw': '',
    },
    '721dy7s1': {
      'en': ' Sizes',
      'sw': '',
    },
    'aaxpd0k9': {
      'en': 'RAM 2GB',
      'sw': '',
    },
    'd3n2d3nu': {
      'en': 'RAM 4GB',
      'sw': '',
    },
    'qoe4y8f5': {
      'en': 'RAM 6GB',
      'sw': '',
    },
    'qf390nev': {
      'en': 'RAM 8GB',
      'sw': '',
    },
    '6jh9ai3k': {
      'en': 'RAM 12GB',
      'sw': '',
    },
    'nyw6fik2': {
      'en': 'RAM 16GB',
      'sw': '',
    },
    '7hochqdk': {
      'en': 'RAM 24GB',
      'sw': '',
    },
    'wlke5m9y': {
      'en': 'RAM 32GB',
      'sw': '',
    },
    'bbzh82wa': {
      'en': ' RAM 64GB',
      'sw': '',
    },
    'un16731o': {
      'en': '4K',
      'sw': '',
    },
    'j21egt6w': {
      'en': '1080p',
      'sw': '',
    },
    '8frunxk3': {
      'en': '20MP+',
      'sw': '',
    },
    'aiiur9ds': {
      'en': 'Screen Size: 32',
      'sw': '',
    },
    '6g6c3jqi': {
      'en': 'Screen Size: 43',
      'sw': '',
    },
    'jtaops56': {
      'en': 'Screen Size:55',
      'sw': '',
    },
    '402z6h6d': {
      'en': 'Screen Size:65',
      'sw': '',
    },
    'rt22omqe': {
      'en': 'Screen Size: 75+',
      'sw': '',
    },
    'dkcw36er': {
      'en': 'Selct Color',
      'sw': '',
    },
    'l3jr7fwo': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'xif4o3uw': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'yipmuitd': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'mz11vzrq': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'cxwegedk': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    '334s38l9': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'aeapakxf': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    '0ptu7nyt': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'm3nvk06a': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'p80nl4ys': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'nu6ojltv': {
      'en': '💛 Gold',
      'sw': '',
    },
    'r7pi1rye': {
      'en': 'Characters',
      'sw': 'Mtindo',
    },
    '4ugl4p1w': {
      'en': 'Storage 2GB',
      'sw': '',
    },
    'sk0vv5gf': {
      'en': 'Storage 4GB',
      'sw': '',
    },
    'x6pbyw0f': {
      'en': 'Storage 8GB',
      'sw': '',
    },
    'vfhg7ovb': {
      'en': 'Storage 16GB',
      'sw': '',
    },
    'qd6arlf2': {
      'en': 'Storage 32GB',
      'sw': '',
    },
    'x5p1mg49': {
      'en': 'Storage 64GB',
      'sw': '',
    },
    '6gwhzhl7': {
      'en': 'Storage 128GB',
      'sw': '',
    },
    'o1emq91t': {
      'en': 'Storage 256GB',
      'sw': '',
    },
    '1ds5bp6x': {
      'en': 'Storage 512GB\n',
      'sw': '',
    },
    'a1cf73h2': {
      'en': 'Storage 1024GB (1TB)',
      'sw': '',
    },
    '925fd6pc': {
      'en': 'Storage 2048GB (2TB)',
      'sw': '',
    },
    '1zn39fgz': {
      'en': 'Storage 4096GB (4TB)',
      'sw': '',
    },
    '8yimvzg6': {
      'en': 'Storage 8192GB (8TB)\n',
      'sw': '',
    },
    'vrwtulho': {
      'en': '4K Ultra HD',
      'sw': '',
    },
    'ee9lhyne': {
      'en': 'OLED/QLED',
      'sw': '',
    },
    '7bq1zviv': {
      'en': 'Smart TV',
      'sw': '',
    },
    '326p0988': {
      'en': 'Intel i5/i7',
      'sw': '',
    },
    'i2bhcw7b': {
      'en': 'Apple M1/M2/M3',
      'sw': '',
    },
    'yl54w98h': {
      'en': 'AMD Ryzen',
      'sw': '',
    },
    'j8ontm0b': {
      'en': 'Bluetooth/Wireless',
      'sw': '',
    },
    '0z8oihgq': {
      'en': 'Noise Cancelling',
      'sw': '',
    },
    'v7ay7hpo': {
      'en': 'Surround Sound',
      'sw': '',
    },
    'j5qvfxf1': {
      'en': 'Waterproof',
      'sw': '',
    },
    '8x3upb0b': {
      'en': 'Long Battery',
      'sw': '',
    },
    'jz0xpokq': {
      'en': 'Body Only',
      'sw': '',
    },
    'ed4l3qjv': {
      'en': 'With Lens',
      'sw': '',
    },
    'i9uj7ksn': {
      'en': 'Full Kit',
      'sw': '',
    },
    'u2vg7q30': {
      'en': 'Mirrorless',
      'sw': '',
    },
    '44dn8itt': {
      'en': 'GoPro/Action',
      'sw': '',
    },
    '73ztlvut': {
      'en': 'Security Cam',
      'sw': '',
    },
    'agrpo27e': {
      'en': 'Brand New',
      'sw': '',
    },
    'mvwc7eml': {
      'en': 'Like New',
      'sw': '',
    },
    'gacl62zz': {
      'en': 'Gently Used',
      'sw': '',
    },
    '7bvd3vil': {
      'en': 'Set Adress',
      'sw': '',
    },
    'k362z7h2': {
      'en': 'location',
      'sw': '',
    },
    '2ytpzsmk': {
      'en': 'Enter your location',
      'sw': '',
    },
    '07vmmqdh': {
      'en': 'Contact information',
      'sw': '',
    },
    'gpwtztof': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'nitpz9nh': {
      'en': 'WhatsApp no',
      'sw': 'WhatsApp',
    },
    'eo8hyn9t': {
      'en': 'Call no',
      'sw': '',
    },
    't2uzubts': {
      'en': 'Call no',
      'sw': '',
    },
    '2w2gg3xc': {
      'en': 'Price',
      'sw': '',
    },
    'aeqho3vf': {
      'en': 'Price',
      'sw': '',
    },
    '3qwa9i3u': {
      'en': '00,000',
      'sw': '',
    },
    'zgbd6z74': {
      'en': 'Please set a price',
      'sw': '',
    },
    'ej1z1r3g': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'ya3x4ks3': {
      'en': 'Description',
      'sw': '',
    },
    'ol6kc6rf': {
      'en': 'Product description',
      'sw': '',
    },
    'f3ozn2pw': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '5gyem9n5': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'qlgj1s9d': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'b6smbcul': {
      'en': 'Trending',
      'sw': '',
    },
    '83iks85l': {
      'en': 'New Arrival',
      'sw': '',
    },
    '7t0adbz5': {
      'en': 'Show in All',
      'sw': '',
    },
    'u3mv55h3': {
      'en': 'Post Now',
      'sw': '',
    },
    '3zzlmooi': {
      'en': 'Home',
      'sw': '',
    },
  },
  // AudioSounds
  {
    'nf56o5gc': {
      'en': 'Electronics',
      'sw': '',
    },
    'j2hdau0s': {
      'en': 'Audio & Sound',
      'sw': '',
    },
    'tu3i98n1': {
      'en': 'Change',
      'sw': '',
    },
    'xqccbhgd': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'u5krwo18': {
      'en': 'Add Photo',
      'sw': '',
    },
    '4yfo6zxg': {
      'en': 'COVER',
      'sw': '',
    },
    'jhyml0zu': {
      'en': 'Product Name',
      'sw': '',
    },
    'vtss544r': {
      'en': 'Product Name',
      'sw': '',
    },
    '73yg6154': {
      'en': 'Product Name',
      'sw': '',
    },
    '5dwxgm0c': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '83rbozrt': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'am74bqf4': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'i56amtqu': {
      'en': 'Product Collection',
      'sw': '',
    },
    'v3u40qhn': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'xro33nyt': {
      'en': 'Audio & Sound',
      'sw': '',
    },
    'we5j6pnb': {
      'en': 'Select  Category',
      'sw': '',
    },
    'jpdylawn': {
      'en': 'Select...',
      'sw': '',
    },
    '5k3s0nom': {
      'en': 'Search...',
      'sw': '',
    },
    '2na72wuq': {
      'en': 'Apple',
      'sw': '',
    },
    'llve5mu6': {
      'en': 'Samsung',
      'sw': '',
    },
    '07pbfsim': {
      'en': 'Sony',
      'sw': '',
    },
    'ihz6mldx': {
      'en': 'Dell',
      'sw': '',
    },
    'wl4a1cxl': {
      'en': 'HP',
      'sw': '',
    },
    'o3ikskro': {
      'en': 'Lenovo',
      'sw': '',
    },
    '2xu9d1or': {
      'en': 'LG',
      'sw': '',
    },
    'hq5zv2bc': {
      'en': 'Asus',
      'sw': '',
    },
    'x8euehtm': {
      'en': 'Canon',
      'sw': '',
    },
    'wghi4l99': {
      'en': 'Nikon',
      'sw': '',
    },
    'pbah0xlq': {
      'en': 'JBL',
      'sw': '',
    },
    'ke6jidtz': {
      'en': 'Xiaomi',
      'sw': '',
    },
    '2lvk9yvc': {
      'en': 'Google',
      'sw': '',
    },
    'd84hqkx1': {
      'en': 'Motorola',
      'sw': '',
    },
    'ijba2q0y': {
      'en': 'OPPO',
      'sw': '',
    },
    'j93bm3cy': {
      'en': 'vivo',
      'sw': '',
    },
    'vxebblul': {
      'en': 'Infinix & Tecno',
      'sw': '',
    },
    'ul1oxzc1': {
      'en': 'Huawei',
      'sw': '',
    },
    'ni72mb7i': {
      'en': 'Realme',
      'sw': '',
    },
    'l4m796m5': {
      'en': 'OnePlus',
      'sw': '',
    },
    '6wlfzy33': {
      'en': 'Honor',
      'sw': '',
    },
    '8ml5w0f8': {
      'en': ' Sizes',
      'sw': '',
    },
    '3qu3nmwj': {
      'en': 'RAM 2GB',
      'sw': '',
    },
    'wfadtatv': {
      'en': 'RAM 4GB',
      'sw': '',
    },
    '1afoqjvb': {
      'en': 'RAM 6GB',
      'sw': '',
    },
    'gaxf5gke': {
      'en': 'RAM 8GB',
      'sw': '',
    },
    '2dw5n50e': {
      'en': 'RAM 12GB',
      'sw': '',
    },
    '1t8kanku': {
      'en': 'RAM 16GB',
      'sw': '',
    },
    'j8j2mlah': {
      'en': 'RAM 24GB',
      'sw': '',
    },
    'a9p17loi': {
      'en': 'RAM 32GB',
      'sw': '',
    },
    'o67tc98r': {
      'en': ' RAM 64GB',
      'sw': '',
    },
    'jb035x1x': {
      'en': '4K',
      'sw': '',
    },
    'n8ixqo0i': {
      'en': '1080p',
      'sw': '',
    },
    'qikob4k8': {
      'en': '20MP+',
      'sw': '',
    },
    'cqioxya6': {
      'en': 'Screen Size: 32',
      'sw': '',
    },
    'gte0gxeb': {
      'en': 'Screen Size: 43',
      'sw': '',
    },
    'oakbrakn': {
      'en': 'Screen Size:55',
      'sw': '',
    },
    '65kvry2x': {
      'en': 'Screen Size:65',
      'sw': '',
    },
    'r8qlpv8b': {
      'en': 'Screen Size: 75+',
      'sw': '',
    },
    '5runra86': {
      'en': 'Selct Color',
      'sw': '',
    },
    'u69umv9l': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'yh9evi4j': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'ge05wwo8': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    '6z47tevm': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'ffljcfy1': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'c9wxmnev': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'x7w5qgt9': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'se675pcd': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'oqarjrxp': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'ea45t93u': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'qdp3l7am': {
      'en': '💛 Gold',
      'sw': '',
    },
    'o69mvq35': {
      'en': 'Material & Fabric',
      'sw': '',
    },
    'pobkkqla': {
      'en': 'Select...',
      'sw': '',
    },
    'gf4behi7': {
      'en': 'Search...',
      'sw': '',
    },
    'w4xjczbh': {
      'en': 'Rubber/Plastic',
      'sw': 'Pamba',
    },
    'htrjs235': {
      'en': 'Leather',
      'sw': 'Kitani',
    },
    'g1c3zk3n': {
      'en': 'Fabric/Fluff',
      'sw': 'Sufu',
    },
    '2qw3hzb9': {
      'en': 'Synthetic',
      'sw': 'Polyester',
    },
    '471wqo4r': {
      'en': 'Canvas',
      'sw': 'Jeans',
    },
    'oz8hord3': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'yjk5iy37': {
      'en': 'Storage 2GB',
      'sw': '',
    },
    'u6oj7xft': {
      'en': 'Storage 4GB',
      'sw': '',
    },
    'km0kgaxn': {
      'en': 'Storage 8GB',
      'sw': '',
    },
    'qs1pyhx9': {
      'en': 'Storage 16GB',
      'sw': '',
    },
    'fjq98eqn': {
      'en': 'Storage 32GB',
      'sw': '',
    },
    'o8u0tcz5': {
      'en': 'Storage 64GB',
      'sw': '',
    },
    'sim3wvzx': {
      'en': 'Storage 128GB',
      'sw': '',
    },
    'sr5cir09': {
      'en': 'Storage 256GB',
      'sw': '',
    },
    'ei18drmv': {
      'en': 'Storage 512GB\n',
      'sw': '',
    },
    'k8ud1rbl': {
      'en': 'Storage 1024GB (1TB)',
      'sw': '',
    },
    'u9ztfozv': {
      'en': 'Storage 2048GB (2TB)',
      'sw': '',
    },
    'x1ykqjya': {
      'en': 'Storage 4096GB (4TB)',
      'sw': '',
    },
    'e14q78mt': {
      'en': 'Storage 8192GB (8TB)\n',
      'sw': '',
    },
    'wqvbsrq9': {
      'en': '4K Ultra HD',
      'sw': '',
    },
    'hrz6nfmo': {
      'en': 'OLED/QLED',
      'sw': '',
    },
    '6nrp8h6w': {
      'en': 'Smart TV',
      'sw': '',
    },
    '0jvzxs3v': {
      'en': 'Intel i5/i7',
      'sw': '',
    },
    'sktfl20v': {
      'en': 'Apple M1/M2/M3',
      'sw': '',
    },
    '18smv9in': {
      'en': 'AMD Ryzen',
      'sw': '',
    },
    'g8oz6qx9': {
      'en': 'Bluetooth/Wireless',
      'sw': '',
    },
    '8ayed2ug': {
      'en': 'Noise Cancelling',
      'sw': '',
    },
    '4324iftc': {
      'en': 'Surround Sound',
      'sw': '',
    },
    'l6ijtisg': {
      'en': 'Waterproof',
      'sw': '',
    },
    'owjbo99z': {
      'en': 'Long Battery',
      'sw': '',
    },
    '0h6m5ts7': {
      'en': 'Body Only',
      'sw': '',
    },
    'qgqblamx': {
      'en': 'With Lens',
      'sw': '',
    },
    'n5d6zlmg': {
      'en': 'Full Kit',
      'sw': '',
    },
    'qx26oopn': {
      'en': 'Mirrorless',
      'sw': '',
    },
    'etrmswf9': {
      'en': 'GoPro/Action',
      'sw': '',
    },
    'dkz3i6rg': {
      'en': 'Security Cam',
      'sw': '',
    },
    'zbgoaag8': {
      'en': 'Brand New',
      'sw': '',
    },
    'npqu0xii': {
      'en': 'Like New',
      'sw': '',
    },
    'hehdmsg4': {
      'en': 'Gently Used',
      'sw': '',
    },
    'hpqtjgjt': {
      'en': 'Set Adress',
      'sw': '',
    },
    'mdqszu37': {
      'en': 'location',
      'sw': '',
    },
    'd55weo0s': {
      'en': 'Enter your location',
      'sw': '',
    },
    'dpamgyu3': {
      'en': 'Contact information',
      'sw': '',
    },
    'd6w0mvhz': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'qlj8hh37': {
      'en': 'WhatsApp no',
      'sw': 'WhatsApp',
    },
    'otso8dvt': {
      'en': 'Call no',
      'sw': '',
    },
    '2fym0wnq': {
      'en': 'Call no',
      'sw': '',
    },
    'fxgdvrkz': {
      'en': 'Price',
      'sw': '',
    },
    '2obs4b7d': {
      'en': 'Price',
      'sw': '',
    },
    'g7w3fqna': {
      'en': '00,000',
      'sw': '',
    },
    'jy1uv24p': {
      'en': 'Please set a price',
      'sw': '',
    },
    'wsr3f7ql': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gh7val4f': {
      'en': 'Description',
      'sw': '',
    },
    '75t7v1e4': {
      'en': 'Product description',
      'sw': '',
    },
    'zhivcp6z': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'h6nx0oqo': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '1rkv1y59': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gomj9h84': {
      'en': 'Trending',
      'sw': '',
    },
    'a4qerho1': {
      'en': 'New Arrival',
      'sw': '',
    },
    'lzmda20i': {
      'en': 'Show in All',
      'sw': '',
    },
    'v2l3cqqx': {
      'en': 'Post Now',
      'sw': '',
    },
    'prdrl5vc': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Cameras1
  {
    '2gigterb': {
      'en': 'Electronics',
      'sw': '',
    },
    'm58kw504': {
      'en': 'Cameras',
      'sw': '',
    },
    'g566qohy': {
      'en': 'Change',
      'sw': '',
    },
    'zleloa9n': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'gmlhub4q': {
      'en': 'Add Photo',
      'sw': '',
    },
    'u20tjrp7': {
      'en': 'COVER',
      'sw': '',
    },
    'lqtw5rnf': {
      'en': 'Product Name',
      'sw': '',
    },
    'g6chkurg': {
      'en': 'Product Name',
      'sw': '',
    },
    'ge2kvf9j': {
      'en': 'Product Name',
      'sw': '',
    },
    'cf9houuh': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '5c5v4aww': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'qsji70aq': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '8ckev0ja': {
      'en': 'Product Collection',
      'sw': '',
    },
    'zpayr97r': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '6zi7mqxn': {
      'en': 'Cameras',
      'sw': '',
    },
    'xfbi1y2c': {
      'en': 'Select  Category',
      'sw': '',
    },
    'xd5j8qht': {
      'en': 'Select...',
      'sw': '',
    },
    '7qg4q4fc': {
      'en': 'Search...',
      'sw': '',
    },
    '7es7ak0v': {
      'en': 'Apple',
      'sw': '',
    },
    'yavlmunw': {
      'en': 'Samsung',
      'sw': '',
    },
    '0769uhct': {
      'en': 'Sony',
      'sw': '',
    },
    'geq7qexe': {
      'en': 'Dell',
      'sw': '',
    },
    'vk4srv77': {
      'en': 'HP',
      'sw': '',
    },
    'oxlk67c5': {
      'en': 'Lenovo',
      'sw': '',
    },
    's9tecfbk': {
      'en': 'LG',
      'sw': '',
    },
    '17ovpu9y': {
      'en': 'Asus',
      'sw': '',
    },
    'ynh2kuy2': {
      'en': 'Canon',
      'sw': '',
    },
    'mw326n13': {
      'en': 'Nikon',
      'sw': '',
    },
    'o77xsr2s': {
      'en': 'JBL',
      'sw': '',
    },
    'q7lwmaqs': {
      'en': 'Xiaomi',
      'sw': '',
    },
    'sanrc4fy': {
      'en': 'Google',
      'sw': '',
    },
    'aj06rwd7': {
      'en': 'Motorola',
      'sw': '',
    },
    'kstqz17q': {
      'en': 'OPPO',
      'sw': '',
    },
    '8z9en9ks': {
      'en': 'vivo',
      'sw': '',
    },
    '4s2iuzwp': {
      'en': 'Infinix & Tecno',
      'sw': '',
    },
    'ym6hzrz7': {
      'en': 'Huawei',
      'sw': '',
    },
    '8x7cf19f': {
      'en': 'Realme',
      'sw': '',
    },
    '6dbo93ta': {
      'en': 'OnePlus',
      'sw': '',
    },
    '1nwjw873': {
      'en': 'Honor',
      'sw': '',
    },
    'wjv5p7ch': {
      'en': ' Sizes',
      'sw': '',
    },
    '6acml76t': {
      'en': 'RAM 2GB',
      'sw': '',
    },
    'dyh2pamj': {
      'en': 'RAM 4GB',
      'sw': '',
    },
    '3ecxbtp4': {
      'en': 'RAM 6GB',
      'sw': '',
    },
    'lbbrck9h': {
      'en': 'RAM 8GB',
      'sw': '',
    },
    '3z70f6fd': {
      'en': 'RAM 12GB',
      'sw': '',
    },
    '67bgoxih': {
      'en': 'RAM 16GB',
      'sw': '',
    },
    'bhhxp616': {
      'en': 'RAM 24GB',
      'sw': '',
    },
    'm129ky33': {
      'en': 'RAM 32GB',
      'sw': '',
    },
    'q56zb1bq': {
      'en': ' RAM 64GB',
      'sw': '',
    },
    'daduu16x': {
      'en': '4K',
      'sw': '',
    },
    'pink5zrd': {
      'en': '1080p',
      'sw': '',
    },
    'zq75ufou': {
      'en': '20MP+',
      'sw': '',
    },
    'mjloa14z': {
      'en': 'Screen Size: 32',
      'sw': '',
    },
    'lvgtxw82': {
      'en': 'Screen Size: 43',
      'sw': '',
    },
    'gflto854': {
      'en': 'Screen Size:55',
      'sw': '',
    },
    'tuhqgp85': {
      'en': 'Screen Size:65',
      'sw': '',
    },
    '8ylr6l3k': {
      'en': 'Screen Size: 75+',
      'sw': '',
    },
    'ufwdnrlq': {
      'en': 'Selct Color',
      'sw': '',
    },
    'fg5bu0eh': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'q0338vhj': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'qv2h70u6': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'vnijad8c': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'ah4pwxm9': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'u5pb7fno': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    '88jds54g': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'fw3cbv6d': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'qhqwg8hr': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    '57519w66': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    '2p12e9ze': {
      'en': '💛 Gold',
      'sw': '',
    },
    'inepmjqy': {
      'en': 'Characters',
      'sw': 'Mtindo',
    },
    'cgmupyd7': {
      'en': 'Storage 2GB',
      'sw': '',
    },
    'tgldrukr': {
      'en': 'Storage 4GB',
      'sw': '',
    },
    'g6hx0v39': {
      'en': 'Storage 8GB',
      'sw': '',
    },
    'jcadjxh4': {
      'en': 'Storage 16GB',
      'sw': '',
    },
    'w95uups1': {
      'en': 'Storage 32GB',
      'sw': '',
    },
    '95rdmvw9': {
      'en': 'Storage 64GB',
      'sw': '',
    },
    'd9qbjphk': {
      'en': 'Storage 128GB',
      'sw': '',
    },
    'uxh7z1ez': {
      'en': 'Storage 256GB',
      'sw': '',
    },
    'xe45ld57': {
      'en': 'Storage 512GB\n',
      'sw': '',
    },
    'moclsgcv': {
      'en': 'Storage 1024GB (1TB)',
      'sw': '',
    },
    'zwaxyezc': {
      'en': 'Storage 2048GB (2TB)',
      'sw': '',
    },
    'ynthpgdd': {
      'en': 'Storage 4096GB (4TB)',
      'sw': '',
    },
    'zv47geb9': {
      'en': 'Storage 8192GB (8TB)\n',
      'sw': '',
    },
    'ep4h2p1d': {
      'en': '4K Ultra HD',
      'sw': '',
    },
    'ms91svst': {
      'en': 'OLED/QLED',
      'sw': '',
    },
    'zbht8eyg': {
      'en': 'Smart TV',
      'sw': '',
    },
    'j5isdk44': {
      'en': 'Intel i5/i7',
      'sw': '',
    },
    'zd17nagp': {
      'en': 'Apple M1/M2/M3',
      'sw': '',
    },
    't8ydeamp': {
      'en': 'AMD Ryzen',
      'sw': '',
    },
    '4g94gun8': {
      'en': 'Bluetooth/Wireless',
      'sw': '',
    },
    '833isprx': {
      'en': 'Noise Cancelling',
      'sw': '',
    },
    'wz1085mi': {
      'en': 'Surround Sound',
      'sw': '',
    },
    'mwdj4f5c': {
      'en': 'Waterproof',
      'sw': '',
    },
    'fgrgjof6': {
      'en': 'Long Battery',
      'sw': '',
    },
    'p8ci26wz': {
      'en': 'Body Only',
      'sw': '',
    },
    'hwi76d85': {
      'en': 'With Lens',
      'sw': '',
    },
    'wpm3l89i': {
      'en': 'Full Kit',
      'sw': '',
    },
    '2ur4o0jz': {
      'en': 'Mirrorless',
      'sw': '',
    },
    '4r4qljx8': {
      'en': 'GoPro/Action',
      'sw': '',
    },
    'viemjamx': {
      'en': 'Security Cam',
      'sw': '',
    },
    '3iikyoh3': {
      'en': 'Brand New',
      'sw': '',
    },
    '65ybtnrs': {
      'en': 'Like New',
      'sw': '',
    },
    'x0tw9k1k': {
      'en': 'Gently Used',
      'sw': '',
    },
    'lw7xjdih': {
      'en': 'Set Adress',
      'sw': '',
    },
    'lgad3zrs': {
      'en': 'location',
      'sw': '',
    },
    'qlcpadsi': {
      'en': 'Enter your location',
      'sw': '',
    },
    'r4hsys18': {
      'en': 'Contact information',
      'sw': '',
    },
    'bv7hmxh7': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'dvm9iqiu': {
      'en': 'WhatsApp no',
      'sw': 'WhatsApp',
    },
    '79c33q3o': {
      'en': 'Call no',
      'sw': '',
    },
    'fxs5u2c6': {
      'en': 'Call no',
      'sw': '',
    },
    'gzhwr55k': {
      'en': 'Price',
      'sw': '',
    },
    'xoq1n4nq': {
      'en': 'Price',
      'sw': '',
    },
    '0s2oylfe': {
      'en': '00,000',
      'sw': '',
    },
    'ar9mcdnb': {
      'en': 'Please set a price',
      'sw': '',
    },
    'vwhc7x6e': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'jtz5tl71': {
      'en': 'Description',
      'sw': '',
    },
    'uw4ek3al': {
      'en': 'Product description',
      'sw': '',
    },
    'tbanndfp': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'ruoyuvfe': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'q6qarary': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '15f0oh37': {
      'en': 'Trending',
      'sw': '',
    },
    '3420hilc': {
      'en': 'New Arrival',
      'sw': '',
    },
    'euqou561': {
      'en': 'Show in All',
      'sw': '',
    },
    'ng9mkmwr': {
      'en': 'Post Now',
      'sw': '',
    },
    'izv49oby': {
      'en': 'Home',
      'sw': '',
    },
  },
  // TVVideo1
  {
    'yhfjjwiw': {
      'en': 'Electronics',
      'sw': '',
    },
    'bn6x02l7': {
      'en': 'TV & Video',
      'sw': '',
    },
    'k90hhulw': {
      'en': 'Change',
      'sw': '',
    },
    'egl4bzuu': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '4b2xqt4x': {
      'en': 'Add Photo',
      'sw': '',
    },
    'qdsnz2o3': {
      'en': 'COVER',
      'sw': '',
    },
    'nencftwz': {
      'en': 'Product Name',
      'sw': '',
    },
    'drs3j8hj': {
      'en': 'Product Name',
      'sw': '',
    },
    'z4eaine5': {
      'en': 'Product Name',
      'sw': '',
    },
    'mv9y7x8s': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '7uwr1p1g': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'afs163c5': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'zttwd0bh': {
      'en': 'Product Collection',
      'sw': '',
    },
    's3jfb9hd': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'i32lpxsl': {
      'en': 'TV & Video',
      'sw': '',
    },
    'x76qo5j2': {
      'en': 'Select  Category',
      'sw': '',
    },
    'c90aiyuv': {
      'en': 'Select...',
      'sw': '',
    },
    'mdvmz3jq': {
      'en': 'Search...',
      'sw': '',
    },
    'j5p1p7ex': {
      'en': 'Apple',
      'sw': '',
    },
    'e7oc0l49': {
      'en': 'Samsung',
      'sw': '',
    },
    'mt7ww8mk': {
      'en': 'Sony',
      'sw': '',
    },
    'w883snce': {
      'en': 'Dell',
      'sw': '',
    },
    'fsvg8453': {
      'en': 'HP',
      'sw': '',
    },
    'kxjdd591': {
      'en': 'Lenovo',
      'sw': '',
    },
    '0a0ydc1n': {
      'en': 'LG',
      'sw': '',
    },
    'mbvrxxff': {
      'en': 'Asus',
      'sw': '',
    },
    '6vkjtzbl': {
      'en': 'Canon',
      'sw': '',
    },
    '7si7mkp5': {
      'en': 'Nikon',
      'sw': '',
    },
    'pr604ofz': {
      'en': 'JBL',
      'sw': '',
    },
    'y8mjnfqc': {
      'en': 'Xiaomi',
      'sw': '',
    },
    'dvg4a59k': {
      'en': 'Google',
      'sw': '',
    },
    'yjv8nq5h': {
      'en': 'Motorola',
      'sw': '',
    },
    't0gjdneg': {
      'en': 'OPPO',
      'sw': '',
    },
    'woaedi6m': {
      'en': 'vivo',
      'sw': '',
    },
    '0psfs8hv': {
      'en': 'Infinix & Tecno',
      'sw': '',
    },
    'if5dq1xs': {
      'en': 'Huawei',
      'sw': '',
    },
    'oost3sdz': {
      'en': 'Realme',
      'sw': '',
    },
    'uhzzz36a': {
      'en': 'OnePlus',
      'sw': '',
    },
    'p8xdiop7': {
      'en': 'Honor',
      'sw': '',
    },
    'm8lfx30a': {
      'en': ' Sizes',
      'sw': '',
    },
    'm5m7p0ib': {
      'en': 'RAM 2GB',
      'sw': '',
    },
    'xwjeqhtv': {
      'en': 'RAM 4GB',
      'sw': '',
    },
    'rwly9rob': {
      'en': 'RAM 6GB',
      'sw': '',
    },
    'd44edfmj': {
      'en': 'RAM 8GB',
      'sw': '',
    },
    'cyqsj43d': {
      'en': 'RAM 12GB',
      'sw': '',
    },
    '7z1b0b49': {
      'en': 'RAM 16GB',
      'sw': '',
    },
    '4ce9x19i': {
      'en': 'RAM 24GB',
      'sw': '',
    },
    'xb0p6tqb': {
      'en': 'RAM 32GB',
      'sw': '',
    },
    'fhbwyh0g': {
      'en': ' RAM 64GB',
      'sw': '',
    },
    '14hjhd8a': {
      'en': '4K',
      'sw': '',
    },
    '0o25418l': {
      'en': '1080p',
      'sw': '',
    },
    '7jtcdnyq': {
      'en': '20MP+',
      'sw': '',
    },
    '99m9rdml': {
      'en': 'Screen Size: 32',
      'sw': '',
    },
    'd5g4m5r1': {
      'en': 'Screen Size: 43',
      'sw': '',
    },
    'orkan67k': {
      'en': 'Screen Size:55',
      'sw': '',
    },
    '9tp0slih': {
      'en': 'Screen Size:65',
      'sw': '',
    },
    'xrig3pta': {
      'en': 'Screen Size: 75+',
      'sw': '',
    },
    'u9n63cdj': {
      'en': 'Selct Color',
      'sw': '',
    },
    'lnhm4yu1': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'ov88e87l': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    's5apfhcs': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'lvwz82z3': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'k6sjxjj0': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'nxb5p2q8': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'tcxrgdop': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'ojkth8pq': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'uhnvq14a': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'm661srgb': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'fjsm0lr5': {
      'en': '💛 Gold',
      'sw': '',
    },
    '60rcijgu': {
      'en': 'Characters',
      'sw': 'Mtindo',
    },
    '1juqox42': {
      'en': 'Storage 2GB',
      'sw': '',
    },
    '0xnqcvfg': {
      'en': 'Storage 4GB',
      'sw': '',
    },
    '59y5g8ju': {
      'en': 'Storage 8GB',
      'sw': '',
    },
    'svxda2rr': {
      'en': 'Storage 16GB',
      'sw': '',
    },
    'spye30ac': {
      'en': 'Storage 32GB',
      'sw': '',
    },
    'vtr3l0rt': {
      'en': 'Storage 64GB',
      'sw': '',
    },
    'a2js7lll': {
      'en': 'Storage 128GB',
      'sw': '',
    },
    'mnlwh1ux': {
      'en': 'Storage 256GB',
      'sw': '',
    },
    'v31pyhhx': {
      'en': 'Storage 512GB\n',
      'sw': '',
    },
    'wh6momp8': {
      'en': 'Storage 1024GB (1TB)',
      'sw': '',
    },
    'imlympk2': {
      'en': 'Storage 2048GB (2TB)',
      'sw': '',
    },
    '7ea8afve': {
      'en': 'Storage 4096GB (4TB)',
      'sw': '',
    },
    'bpf0kohv': {
      'en': 'Storage 8192GB (8TB)\n',
      'sw': '',
    },
    'ooh2ff2s': {
      'en': '4K Ultra HD',
      'sw': '',
    },
    '0dk8811u': {
      'en': 'OLED/QLED',
      'sw': '',
    },
    '934hdifs': {
      'en': 'Smart TV',
      'sw': '',
    },
    '9ufz6izc': {
      'en': 'Intel i5/i7',
      'sw': '',
    },
    '9mm7ujba': {
      'en': 'Apple M1/M2/M3',
      'sw': '',
    },
    'he8pqi9d': {
      'en': 'AMD Ryzen',
      'sw': '',
    },
    '3m8nxfu7': {
      'en': 'Bluetooth/Wireless',
      'sw': '',
    },
    '25iu4i0e': {
      'en': 'Noise Cancelling',
      'sw': '',
    },
    '3bg7du9u': {
      'en': 'Surround Sound',
      'sw': '',
    },
    '6lzrbv0a': {
      'en': 'Waterproof',
      'sw': '',
    },
    '35rgxzm1': {
      'en': 'Long Battery',
      'sw': '',
    },
    '4kqvx0og': {
      'en': 'Body Only',
      'sw': '',
    },
    'ai7dtvrx': {
      'en': 'With Lens',
      'sw': '',
    },
    'h02maw54': {
      'en': 'Full Kit',
      'sw': '',
    },
    'h4k6vcfa': {
      'en': 'Mirrorless',
      'sw': '',
    },
    '3n6b5smy': {
      'en': 'GoPro/Action',
      'sw': '',
    },
    'gh1vp474': {
      'en': 'Security Cam',
      'sw': '',
    },
    '7f7p0es4': {
      'en': 'Brand New',
      'sw': '',
    },
    't9m51u4y': {
      'en': 'Like New',
      'sw': '',
    },
    'us9lbi1z': {
      'en': 'Gently Used',
      'sw': '',
    },
    '58z2480k': {
      'en': 'Set Adress',
      'sw': '',
    },
    'lq7z4k1a': {
      'en': 'location',
      'sw': '',
    },
    '5can9fts': {
      'en': 'Enter your location',
      'sw': '',
    },
    'zsr0hioj': {
      'en': 'Contact information',
      'sw': '',
    },
    'nvvbyq69': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '3p30r7nf': {
      'en': 'WhatsApp no',
      'sw': 'WhatsApp',
    },
    'j1xeaxfo': {
      'en': 'Call no',
      'sw': '',
    },
    'f7oup2p7': {
      'en': 'Call no',
      'sw': '',
    },
    'n0picbv5': {
      'en': 'Price',
      'sw': '',
    },
    '7hremlq0': {
      'en': 'Price',
      'sw': '',
    },
    'limirb9y': {
      'en': '00,000',
      'sw': '',
    },
    'znrvqzvw': {
      'en': 'Please set a price',
      'sw': '',
    },
    'mx611rd4': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'p2rfnguy': {
      'en': 'Description',
      'sw': '',
    },
    'y8mzgx2k': {
      'en': 'Product description',
      'sw': '',
    },
    'yggrz4qk': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'l196vqpv': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    's471d05i': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'f4cjmodf': {
      'en': 'Trending',
      'sw': '',
    },
    '22z2hubp': {
      'en': 'New Arrival',
      'sw': '',
    },
    'fb6zgwuu': {
      'en': 'Show in All',
      'sw': '',
    },
    'bq65l4re': {
      'en': 'Post Now',
      'sw': '',
    },
    'fsottfsy': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Skincare1
  {
    '264cb56f': {
      'en': 'Beauty',
      'sw': '',
    },
    'zwh8ooij': {
      'en': 'Skincare',
      'sw': '',
    },
    'xzmrek88': {
      'en': 'Change',
      'sw': '',
    },
    '2rbaayk8': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'ktkfp6dp': {
      'en': 'Add Photo',
      'sw': '',
    },
    '0t65nm33': {
      'en': 'COVER',
      'sw': '',
    },
    'g0ieod5k': {
      'en': 'Product Name',
      'sw': '',
    },
    'ed4j8vmv': {
      'en': 'Product Name',
      'sw': '',
    },
    '1p2nd2v4': {
      'en': 'Product Name',
      'sw': '',
    },
    '7h1wx6h6': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '7znl51mv': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'eo8w6tgn': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'v2lqrff8': {
      'en': 'Product Collection',
      'sw': '',
    },
    'zyjqjq7j': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'dydyatjj': {
      'en': 'Skincare',
      'sw': '',
    },
    'yq3in36n': {
      'en': 'Select Categories',
      'sw': '',
    },
    '6bk8amk9': {
      'en': 'Select...',
      'sw': '',
    },
    'x5dk6yke': {
      'en': 'Search...',
      'sw': '',
    },
    '3x3kc8gb': {
      'en': 'L\'Oréal',
      'sw': '',
    },
    '0az20207': {
      'en': 'The Ordinary',
      'sw': '',
    },
    'nuaujigs': {
      'en': 'CeraVe',
      'sw': '',
    },
    'qt5uzel4': {
      'en': 'Dior',
      'sw': '',
    },
    'va600ixw': {
      'en': 'MAC',
      'sw': '',
    },
    'vebxzxrf': {
      'en': 'Maybelline',
      'sw': '',
    },
    's3f5vd5f': {
      'en': 'Olaplex',
      'sw': '',
    },
    '1gpl6uaz': {
      'en': 'Select Size',
      'sw': '',
    },
    '3oc0w7z6': {
      'en': 'Liquds 30ml',
      'sw': '',
    },
    'iokhwfaq': {
      'en': 'Liquds 50ml',
      'sw': '',
    },
    'rxfx5dcq': {
      'en': 'Liquds 100ml',
      'sw': '',
    },
    '8q4ybcs2': {
      'en': 'Liquds 200ml',
      'sw': '',
    },
    '19ukktqq': {
      'en': 'Liquds 500ml',
      'sw': '',
    },
    'z721gecg': {
      'en': 'Weights 25g',
      'sw': '',
    },
    '8yqklhjg': {
      'en': 'Weights 30g',
      'sw': '',
    },
    'jc8fg3q3': {
      'en': 'Weights 50g',
      'sw': '',
    },
    '5j4604jm': {
      'en': 'Weights 100g',
      'sw': '',
    },
    'j658e5ur': {
      'en': 'Gender Tag',
      'sw': '',
    },
    'fbzhw9h2': {
      'en': 'Select...',
      'sw': '',
    },
    'tuepwf6e': {
      'en': 'Search...',
      'sw': '',
    },
    'ktk4dzz9': {
      'en': 'Women',
      'sw': 'Pamba',
    },
    'l8ytbsj1': {
      'en': 'Men',
      'sw': 'Hariri',
    },
    'gt906asd': {
      'en': 'Wool',
      'sw': 'Sufu',
    },
    '6fvbksyz': {
      'en': 'Unisex',
      'sw': 'Polyester',
    },
    'lkrqc8oy': {
      'en': 'Denim',
      'sw': 'Jeans',
    },
    '2rh9p0wi': {
      'en': 'Velvet',
      'sw': 'Nguo ya manyoya',
    },
    '96uc7i6k': {
      'en': 'The Benefit Row',
      'sw': '',
    },
    'tz70an6e': {
      'en': 'Oily',
      'sw': '',
    },
    'kyzv2v6u': {
      'en': 'Dry',
      'sw': '',
    },
    '8udgk9wr': {
      'en': 'Sensitive',
      'sw': '',
    },
    'gza370hv': {
      'en': 'Combination',
      'sw': 'Fupi',
    },
    '6jtjoln8': {
      'en': 'Eau de Parfum',
      'sw': '',
    },
    'mkpsfnk2': {
      'en': 'Eau de Toilette',
      'sw': '',
    },
    'j7zr6ynd': {
      'en': 'Oud',
      'sw': '',
    },
    'gm0vum7e': {
      'en': 'Damaged',
      'sw': '',
    },
    '1bz10qdc': {
      'en': 'Colored',
      'sw': '',
    },
    'hpruaziy': {
      'en': 'Waterproof',
      'sw': '',
    },
    'brdvw0ap': {
      'en': 'Glowing',
      'sw': 'Rangi Moja',
    },
    '8xn474pz': {
      'en': 'Long-wear',
      'sw': 'Mistari',
    },
    '2299yhgm': {
      'en': 'Sensitive Skin',
      'sw': 'Picha',
    },
    'lmc8g1tr': {
      'en': 'Anti-Aging',
      'sw': 'Maua',
    },
    '2pewaks3': {
      'en': 'Strong Hold',
      'sw': 'Mapambo ya Kushona',
    },
    'qh7xalhh': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    'ai4l8k2o': {
      'en': 'Brand New',
      'sw': '',
    },
    'bd4az50b': {
      'en': 'Like New',
      'sw': '',
    },
    'paczvhbs': {
      'en': 'Gently Used',
      'sw': '',
    },
    'c60nnw1m': {
      'en': 'Set Adress',
      'sw': '',
    },
    '8ph5psa6': {
      'en': 'location',
      'sw': '',
    },
    '7zqytceh': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'x0zak7ux': {
      'en': 'Contact information',
      'sw': '',
    },
    'c6gnloox': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'fxcx3ysc': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '52gi24ct': {
      'en': 'Call no',
      'sw': '',
    },
    'eqlfbzot': {
      'en': 'Call no',
      'sw': '',
    },
    'isoabmr5': {
      'en': 'Price',
      'sw': '',
    },
    'diulrbqj': {
      'en': 'Price',
      'sw': '',
    },
    '5oc9hsqm': {
      'en': '0.00',
      'sw': '',
    },
    '2iqs7i9h': {
      'en': 'Please set a price',
      'sw': '',
    },
    'sbzykz9l': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '69nbzp0f': {
      'en': 'Description',
      'sw': '',
    },
    'smc7p4bg': {
      'en': 'Product description',
      'sw': '',
    },
    'iaiz93fu': {
      'en': 'Describe your products',
      'sw': '',
    },
    '4lrjtvt1': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'b0ogy7d0': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '33n726zd': {
      'en': 'Trending',
      'sw': '',
    },
    'qxz49uim': {
      'en': 'New Arrival',
      'sw': '',
    },
    '1t5zqx17': {
      'en': 'Show in All',
      'sw': '',
    },
    '1daa20fg': {
      'en': 'Post Now',
      'sw': '',
    },
    'e1gp8mzn': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Fragrances1
  {
    'bqgjwm1k': {
      'en': 'Beauty',
      'sw': '',
    },
    'h9oudwyb': {
      'en': 'Fragrances',
      'sw': '',
    },
    'pjig3ziv': {
      'en': 'Change',
      'sw': '',
    },
    'fy0al96w': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'ou47yrei': {
      'en': 'Add Photo',
      'sw': '',
    },
    'ucwv4s0e': {
      'en': 'COVER',
      'sw': '',
    },
    'ng29yvxb': {
      'en': 'Product Name',
      'sw': '',
    },
    'pe3wsu8f': {
      'en': 'Product Name',
      'sw': '',
    },
    'ojft5oyr': {
      'en': 'Product Name',
      'sw': '',
    },
    '0zrxupou': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'qiy72col': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'ahr9yaja': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '6tu416xq': {
      'en': 'Product Collection',
      'sw': '',
    },
    'm3fs05gc': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '9zkgcukl': {
      'en': 'Fragrances',
      'sw': '',
    },
    'm1nbyfx1': {
      'en': 'Select Categories',
      'sw': '',
    },
    'cmnwd92c': {
      'en': 'Select...',
      'sw': '',
    },
    'hxwntzzx': {
      'en': 'Search...',
      'sw': '',
    },
    'pvu3gt4v': {
      'en': 'L\'Oréal',
      'sw': '',
    },
    'dxs1krsc': {
      'en': 'The Ordinary',
      'sw': '',
    },
    '2i63uniq': {
      'en': 'CeraVe',
      'sw': '',
    },
    'jdot9lks': {
      'en': 'Dior',
      'sw': '',
    },
    '1k8ff0le': {
      'en': 'MAC',
      'sw': '',
    },
    'x9ivmjef': {
      'en': 'Maybelline',
      'sw': '',
    },
    '65xgnx1b': {
      'en': 'Olaplex',
      'sw': '',
    },
    'otlr5rhm': {
      'en': 'Select Size',
      'sw': '',
    },
    'ee8j5jln': {
      'en': 'Liquds 30ml',
      'sw': '',
    },
    'ld5km1y8': {
      'en': 'Liquds 50ml',
      'sw': '',
    },
    'il30x0zz': {
      'en': 'Liquds 100ml',
      'sw': '',
    },
    'dvbiv9j5': {
      'en': 'Liquds 200ml',
      'sw': '',
    },
    'yxp1g5j7': {
      'en': 'Liquds 500ml',
      'sw': '',
    },
    'fin1x3el': {
      'en': 'Weights 25g',
      'sw': '',
    },
    'd5u0ua47': {
      'en': 'Weights 30g',
      'sw': '',
    },
    '01289jdr': {
      'en': 'Weights 50g',
      'sw': '',
    },
    'vxmpnx8g': {
      'en': 'Weights 100g',
      'sw': '',
    },
    'wl14fjyl': {
      'en': 'Gender Tag',
      'sw': '',
    },
    'mkzoclqk': {
      'en': 'Select...',
      'sw': '',
    },
    'jul9q1v1': {
      'en': 'Search...',
      'sw': '',
    },
    'ujuqww19': {
      'en': 'Women',
      'sw': 'Pamba',
    },
    'tnx5ycnp': {
      'en': 'Men',
      'sw': 'Hariri',
    },
    'u9buvpq7': {
      'en': 'Wool',
      'sw': 'Sufu',
    },
    '9x8vzpg6': {
      'en': 'Unisex',
      'sw': 'Polyester',
    },
    '86nrdcwk': {
      'en': 'Denim',
      'sw': 'Jeans',
    },
    'asv1t8dt': {
      'en': 'Velvet',
      'sw': 'Nguo ya manyoya',
    },
    '90ircv6z': {
      'en': 'The Benefit Row',
      'sw': '',
    },
    'teciba9c': {
      'en': 'Oily',
      'sw': '',
    },
    'umernu5q': {
      'en': 'Dry',
      'sw': '',
    },
    'aj9zdx6w': {
      'en': 'Sensitive',
      'sw': '',
    },
    '3n1yexwh': {
      'en': 'Combination',
      'sw': 'Fupi',
    },
    'm763hpjn': {
      'en': 'Eau de Parfum',
      'sw': '',
    },
    '3alzwxpm': {
      'en': 'Eau de Toilette',
      'sw': '',
    },
    't58bund2': {
      'en': 'Oud',
      'sw': '',
    },
    'c3dulwcp': {
      'en': 'Damaged',
      'sw': '',
    },
    'h3f2x7zw': {
      'en': 'Colored',
      'sw': '',
    },
    'aipf6syi': {
      'en': 'Waterproof',
      'sw': '',
    },
    '6gozghoh': {
      'en': 'Glowing',
      'sw': 'Rangi Moja',
    },
    'p2ivo3ey': {
      'en': 'Long-wear',
      'sw': 'Mistari',
    },
    'j67emdc2': {
      'en': 'Sensitive Skin',
      'sw': 'Picha',
    },
    '9clxoepx': {
      'en': 'Anti-Aging',
      'sw': 'Maua',
    },
    'xaxu7t3q': {
      'en': 'Strong Hold',
      'sw': 'Mapambo ya Kushona',
    },
    'cj3kkbsg': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    'dezjrpt9': {
      'en': 'New',
      'sw': '',
    },
    'kyjhv3wv': {
      'en': 'Used',
      'sw': '',
    },
    'vcupoqa8': {
      'en': 'Set Adress',
      'sw': '',
    },
    'wte7j8c6': {
      'en': 'location',
      'sw': '',
    },
    '7fbnnane': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'tk9kwkat': {
      'en': 'Contact information',
      'sw': '',
    },
    'wxxolm9s': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'meyp8v3m': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'mfqjiqxm': {
      'en': 'Call no',
      'sw': '',
    },
    'ko23usz7': {
      'en': 'Call no',
      'sw': '',
    },
    'qieg6nn0': {
      'en': 'Price',
      'sw': '',
    },
    '15spjqng': {
      'en': 'Price',
      'sw': '',
    },
    'hw341ov2': {
      'en': '0.00',
      'sw': '',
    },
    'jdkccrnr': {
      'en': 'Please set a price',
      'sw': '',
    },
    '5yogetgp': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'kl1pecpa': {
      'en': 'Description',
      'sw': '',
    },
    '2tpysa1c': {
      'en': 'Product description',
      'sw': '',
    },
    'ggytlxev': {
      'en': 'Describe your products',
      'sw': '',
    },
    'juzmlrb0': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'j9ojr36s': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'e5kpe603': {
      'en': 'Trending',
      'sw': '',
    },
    'aivhvirq': {
      'en': 'New Arrival',
      'sw': '',
    },
    '48x71lt6': {
      'en': 'Show in All',
      'sw': '',
    },
    'f0wdqvd8': {
      'en': 'Post Now',
      'sw': '',
    },
    'ql57epvo': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Makeup1
  {
    'zrru8tj5': {
      'en': 'Beauty',
      'sw': '',
    },
    'nl3o1ifx': {
      'en': 'Makeup',
      'sw': '',
    },
    'ufwmu4wf': {
      'en': 'Change',
      'sw': '',
    },
    'fsu5a5is': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'uvrdvyok': {
      'en': 'Add Photo',
      'sw': '',
    },
    'dtqdhc73': {
      'en': 'COVER',
      'sw': '',
    },
    'iyqrfdqp': {
      'en': 'Product Name',
      'sw': '',
    },
    'cwc2wpcu': {
      'en': 'Product Name',
      'sw': '',
    },
    'nfgmfz56': {
      'en': 'Product Name',
      'sw': '',
    },
    'mjkcpdlg': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '290t139i': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'e3zc4sg7': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'kkgjmrj9': {
      'en': 'Product Collection',
      'sw': '',
    },
    'dd368sba': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '8kfm790p': {
      'en': 'Makeup',
      'sw': '',
    },
    't88t2vxw': {
      'en': 'Select Categories',
      'sw': '',
    },
    'u50wv4jk': {
      'en': 'Select...',
      'sw': '',
    },
    'l5hhznze': {
      'en': 'Search...',
      'sw': '',
    },
    'ntry7aec': {
      'en': 'L\'Oréal',
      'sw': '',
    },
    '3i8tx22u': {
      'en': 'The Ordinary',
      'sw': '',
    },
    'qdbi7hgv': {
      'en': 'CeraVe',
      'sw': '',
    },
    '6xude7qy': {
      'en': 'Dior',
      'sw': '',
    },
    't5zmq2i3': {
      'en': 'MAC',
      'sw': '',
    },
    'lesy344k': {
      'en': 'Maybelline',
      'sw': '',
    },
    'w5rjg6ue': {
      'en': 'Olaplex',
      'sw': '',
    },
    'kbuqj3q1': {
      'en': 'Select Size',
      'sw': '',
    },
    'qorj7h2r': {
      'en': 'Liquds 30ml',
      'sw': '',
    },
    's0bqutb4': {
      'en': 'Liquds 50ml',
      'sw': '',
    },
    'ujgj6vis': {
      'en': 'Liquds 100ml',
      'sw': '',
    },
    'ryzofx2k': {
      'en': 'Liquds 200ml',
      'sw': '',
    },
    '2rabal79': {
      'en': 'Liquds 500ml',
      'sw': '',
    },
    'egn4009p': {
      'en': 'Weights 25g',
      'sw': '',
    },
    'lvyahoq2': {
      'en': 'Weights 30g',
      'sw': '',
    },
    'szklhsb3': {
      'en': 'Weights 50g',
      'sw': '',
    },
    'ukuid7yw': {
      'en': 'Weights 100g',
      'sw': '',
    },
    '2hyy2bvf': {
      'en': 'Gender Tag',
      'sw': '',
    },
    's15d37u1': {
      'en': 'Select...',
      'sw': '',
    },
    'jzuy7rf4': {
      'en': 'Search...',
      'sw': '',
    },
    'v4n5s8lu': {
      'en': 'Women',
      'sw': 'Pamba',
    },
    'fzjt4z6d': {
      'en': 'Men',
      'sw': 'Hariri',
    },
    's71mbhup': {
      'en': 'Wool',
      'sw': 'Sufu',
    },
    'crusxwvq': {
      'en': 'Unisex',
      'sw': 'Polyester',
    },
    '905w6e95': {
      'en': 'Denim',
      'sw': 'Jeans',
    },
    'ab7isxp9': {
      'en': 'Velvet',
      'sw': 'Nguo ya manyoya',
    },
    'b7rq2sof': {
      'en': 'The Benefit Row',
      'sw': '',
    },
    'soqetkyq': {
      'en': 'Oily',
      'sw': '',
    },
    'yvv5l8h0': {
      'en': 'Dry',
      'sw': '',
    },
    '2rrz32qn': {
      'en': 'Sensitive',
      'sw': '',
    },
    '1zha1r5z': {
      'en': 'Combination',
      'sw': 'Fupi',
    },
    '1fy9r7k2': {
      'en': 'Eau de Parfum',
      'sw': '',
    },
    'hcgz3nxx': {
      'en': 'Eau de Toilette',
      'sw': '',
    },
    'adhwbncu': {
      'en': 'Oud',
      'sw': '',
    },
    'zmpnooi1': {
      'en': 'Damaged',
      'sw': '',
    },
    'd1brmjaz': {
      'en': 'Colored',
      'sw': '',
    },
    'tbgoi68h': {
      'en': 'Waterproof',
      'sw': '',
    },
    '8rgv6i3n': {
      'en': 'Glowing',
      'sw': 'Rangi Moja',
    },
    'o74ose8p': {
      'en': 'Long-wear',
      'sw': 'Mistari',
    },
    'k6hducrm': {
      'en': 'Sensitive Skin',
      'sw': 'Picha',
    },
    'xy8zptcd': {
      'en': 'Anti-Aging',
      'sw': 'Maua',
    },
    'k0dd7lkg': {
      'en': 'Strong Hold',
      'sw': 'Mapambo ya Kushona',
    },
    'wrdb73tb': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    'j3uvms22': {
      'en': 'New',
      'sw': '',
    },
    'iypqtngf': {
      'en': 'Used',
      'sw': '',
    },
    'c7ug1cli': {
      'en': 'Set Adress',
      'sw': '',
    },
    'fmb4jii2': {
      'en': 'location',
      'sw': '',
    },
    '8ibl48y5': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'vhufzsds': {
      'en': 'Contact information',
      'sw': '',
    },
    't5fea03w': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'ecy4ndsb': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'wi7ku6x2': {
      'en': 'Call no',
      'sw': '',
    },
    'yqapg48u': {
      'en': 'Call no',
      'sw': '',
    },
    'di86p911': {
      'en': 'Price',
      'sw': '',
    },
    'cknr7j6r': {
      'en': 'Price',
      'sw': '',
    },
    '7naj0zez': {
      'en': '0.00',
      'sw': '',
    },
    'nh98sicx': {
      'en': 'Please set a price',
      'sw': '',
    },
    '7sdzy43l': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'isqrrxmg': {
      'en': 'Description',
      'sw': '',
    },
    'rkp5faot': {
      'en': 'Product description',
      'sw': '',
    },
    'ntrbg4hi': {
      'en': 'Describe your products',
      'sw': '',
    },
    'orzpzy4q': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'iecqbsdp': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'd0pj816m': {
      'en': 'Trending',
      'sw': '',
    },
    '3lsr0qrb': {
      'en': 'New Arrival',
      'sw': '',
    },
    '0hrgtq7d': {
      'en': 'Show in All',
      'sw': '',
    },
    'gh2moj84': {
      'en': 'Post Now',
      'sw': '',
    },
    'plz9k3z8': {
      'en': 'Home',
      'sw': '',
    },
  },
  // HairCare1
  {
    'f4wky1nt': {
      'en': 'Beauty',
      'sw': '',
    },
    'qhmjwqm6': {
      'en': 'Hair Care',
      'sw': '',
    },
    'rxsncezc': {
      'en': 'Change',
      'sw': '',
    },
    '03ayx3dj': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'gq7u3utu': {
      'en': 'Add Photo',
      'sw': '',
    },
    '7d8m3976': {
      'en': 'COVER',
      'sw': '',
    },
    'u8szu28u': {
      'en': 'Product Name',
      'sw': '',
    },
    'l7lizj22': {
      'en': 'Product Name',
      'sw': '',
    },
    'dhkgel6l': {
      'en': 'Product Name',
      'sw': '',
    },
    'vgkd5ekb': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'i93hpswh': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'kx0p51pi': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'fjfwznlh': {
      'en': 'Product Collection',
      'sw': '',
    },
    'ws0w9224': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'bqelm4hx': {
      'en': 'Hair Care',
      'sw': '',
    },
    'kw1th9pz': {
      'en': 'Select Categories',
      'sw': '',
    },
    'jv2lr45g': {
      'en': 'Select...',
      'sw': '',
    },
    'f8wj9b2a': {
      'en': 'Search...',
      'sw': '',
    },
    '75o0vcdt': {
      'en': 'L\'Oréal',
      'sw': '',
    },
    'uefxcxks': {
      'en': 'The Ordinary',
      'sw': '',
    },
    'n7s4t6nl': {
      'en': 'CeraVe',
      'sw': '',
    },
    '5425chwe': {
      'en': 'Dior',
      'sw': '',
    },
    'bcjcstro': {
      'en': 'MAC',
      'sw': '',
    },
    'pxaiboqs': {
      'en': 'Maybelline',
      'sw': '',
    },
    'i2kvh3u3': {
      'en': 'Olaplex',
      'sw': '',
    },
    '2b6mrk3i': {
      'en': 'Select Size',
      'sw': '',
    },
    'b0avl39c': {
      'en': 'Liquds 30ml',
      'sw': '',
    },
    'fdhtme1g': {
      'en': 'Liquds 50ml',
      'sw': '',
    },
    'i1sq1x6b': {
      'en': 'Liquds 100ml',
      'sw': '',
    },
    '8yp28ch2': {
      'en': 'Liquds 200ml',
      'sw': '',
    },
    'qb1egbp5': {
      'en': 'Liquds 500ml',
      'sw': '',
    },
    'q4y0qmsh': {
      'en': 'Weights 25g',
      'sw': '',
    },
    'yynnqnny': {
      'en': 'Weights 30g',
      'sw': '',
    },
    '8u97daln': {
      'en': 'Weights 50g',
      'sw': '',
    },
    'w7nlj68o': {
      'en': 'Weights 100g',
      'sw': '',
    },
    'yd92b4fw': {
      'en': 'Gender Tag',
      'sw': '',
    },
    'qy64yod7': {
      'en': 'Select...',
      'sw': '',
    },
    'm6sihao3': {
      'en': 'Search...',
      'sw': '',
    },
    'gk7owaxq': {
      'en': 'Women',
      'sw': 'Pamba',
    },
    '0cwhpne5': {
      'en': 'Men',
      'sw': 'Hariri',
    },
    't527bh4j': {
      'en': 'Wool',
      'sw': 'Sufu',
    },
    's7fy2g3n': {
      'en': 'Unisex',
      'sw': 'Polyester',
    },
    '8cybrhbh': {
      'en': 'Denim',
      'sw': 'Jeans',
    },
    'we4fys4r': {
      'en': 'Velvet',
      'sw': 'Nguo ya manyoya',
    },
    'gjefo0gt': {
      'en': 'The Benefit Row',
      'sw': '',
    },
    'u1ggy3wv': {
      'en': 'Oily',
      'sw': '',
    },
    '7czpk7hz': {
      'en': 'Dry',
      'sw': '',
    },
    '0kdu51gm': {
      'en': 'Sensitive',
      'sw': '',
    },
    'onkpqvns': {
      'en': 'Combination',
      'sw': 'Fupi',
    },
    'd6ig0j22': {
      'en': 'Eau de Parfum',
      'sw': '',
    },
    'hqjss9y3': {
      'en': 'Eau de Toilette',
      'sw': '',
    },
    'vzw7265m': {
      'en': 'Oud',
      'sw': '',
    },
    'r3gjylqc': {
      'en': 'Damaged',
      'sw': '',
    },
    '29lcxtbt': {
      'en': 'Colored',
      'sw': '',
    },
    'gc1ly49h': {
      'en': 'Waterproof',
      'sw': '',
    },
    'brli1129': {
      'en': 'Glowing',
      'sw': 'Rangi Moja',
    },
    '8jqv8fw5': {
      'en': 'Long-wear',
      'sw': 'Mistari',
    },
    'cyxusdbk': {
      'en': 'Sensitive Skin',
      'sw': 'Picha',
    },
    '1p479l0n': {
      'en': 'Anti-Aging',
      'sw': 'Maua',
    },
    'ry0l99hw': {
      'en': 'Strong Hold',
      'sw': 'Mapambo ya Kushona',
    },
    'nq3fh7qm': {
      'en': 'Is your good new or used ?',
      'sw': '',
    },
    'o092cxbb': {
      'en': 'New',
      'sw': '',
    },
    'h93n0gma': {
      'en': 'Used',
      'sw': '',
    },
    'pi78vzqp': {
      'en': 'Set Adress',
      'sw': '',
    },
    'r0z11nyz': {
      'en': 'location',
      'sw': '',
    },
    '5sty8k02': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'wp8lgj4v': {
      'en': 'Contact information',
      'sw': '',
    },
    'e15zyy9m': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'cz9v04v4': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'y688mddd': {
      'en': 'Call no',
      'sw': '',
    },
    '4wbwag5r': {
      'en': 'Call no',
      'sw': '',
    },
    '7sny0e32': {
      'en': 'Price',
      'sw': '',
    },
    '65jm38i0': {
      'en': 'Price',
      'sw': '',
    },
    '3sdyqyss': {
      'en': '0.00',
      'sw': '',
    },
    'mqnnzej1': {
      'en': 'Please set a price',
      'sw': '',
    },
    '0bshfv1t': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '1yld1dza': {
      'en': 'Description',
      'sw': '',
    },
    'gpxfctby': {
      'en': 'Product description',
      'sw': '',
    },
    'eqk02qhe': {
      'en': 'Describe your products',
      'sw': '',
    },
    '8xqedguo': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'kgd8fzj0': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'bnq910yi': {
      'en': 'Trending',
      'sw': '',
    },
    'b9lp7q28': {
      'en': 'New Arrival',
      'sw': '',
    },
    'puyidusi': {
      'en': 'Show in All',
      'sw': '',
    },
    'n1fd5sse': {
      'en': 'Post Now',
      'sw': '',
    },
    'hzw0sdgl': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Lighting1
  {
    'fvjrumkf': {
      'en': 'Home & Living',
      'sw': '',
    },
    '6yynea8h': {
      'en': 'Lighting',
      'sw': '',
    },
    'sprxwz3z': {
      'en': 'Change',
      'sw': '',
    },
    'peff5se8': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'flj9ur9e': {
      'en': 'Add Photo',
      'sw': '',
    },
    'z7mt3cfm': {
      'en': 'COVER',
      'sw': '',
    },
    'blyw98om': {
      'en': 'Product Name',
      'sw': '',
    },
    'ijunwbl8': {
      'en': 'Product Name',
      'sw': '',
    },
    '2edzs9pl': {
      'en': 'Product Name',
      'sw': '',
    },
    '1sdp2jth': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'qivehb3u': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '78nyx3kn': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'yb0eoz0k': {
      'en': 'Product Collection',
      'sw': '',
    },
    'z1va0ip6': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '40b7jozu': {
      'en': 'Lighting',
      'sw': '',
    },
    'a40rtll9': {
      'en': 'Brand & Designer',
      'sw': '',
    },
    'ou3x49b4': {
      'en': 'Select...',
      'sw': '',
    },
    'nx8eixgi': {
      'en': 'Search...',
      'sw': '',
    },
    'ls52r5bg': {
      'en': 'IKEA',
      'sw': '',
    },
    '9hbx6xmz': {
      'en': 'Home Centre',
      'sw': '',
    },
    'sdenj0sl': {
      'en': 'Local Artisan',
      'sw': '',
    },
    'zyatfw3x': {
      'en': 'Luxury Brand,',
      'sw': '',
    },
    'itff50xg': {
      'en': 'Unbranded',
      'sw': '',
    },
    '7wz9js3e': {
      'en': ' Sizes',
      'sw': '',
    },
    'xzu1czlk': {
      'en': 'Single',
      'sw': '',
    },
    'yhttuknl': {
      'en': 'Double',
      'sw': '',
    },
    'rvk3obd5': {
      'en': 'Queen',
      'sw': '',
    },
    'bm5ibuk7': {
      'en': 'King',
      'sw': '',
    },
    '37gxxute': {
      'en': 'Super King',
      'sw': '',
    },
    'sfs6m5km': {
      'en': 'Weight: Light',
      'sw': '',
    },
    '8oc1z1oq': {
      'en': 'Weight: Heavy',
      'sw': '',
    },
    'goln88of': {
      'en': 'Weight: Requires 2 people',
      'sw': '',
    },
    '465qcy7t': {
      'en': 'Selct Color',
      'sw': '',
    },
    '9npa50qa': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    '2akiq1yu': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    '60x14e9k': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'n1ioij97': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'r8105g80': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'scm5wwzb': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'kx47ou93': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    '1qb6woeg': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'sa0b2637': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'opqstr35': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'pbneuk1z': {
      'en': '💛 Gold',
      'sw': '',
    },
    'jortx143': {
      'en': 'Material ',
      'sw': '',
    },
    'spkf9fyp': {
      'en': 'Select...',
      'sw': '',
    },
    'hw6xzg18': {
      'en': 'Search...',
      'sw': '',
    },
    'gjad57ii': {
      'en': 'Wood',
      'sw': 'Pamba',
    },
    'zia3qoc6': {
      'en': 'Metal',
      'sw': 'Kitani',
    },
    '3phxds2e': {
      'en': 'Glass',
      'sw': 'Sufu',
    },
    'fnxvjou4': {
      'en': 'Fabric/Cotton',
      'sw': 'Polyester',
    },
    '8xung91a': {
      'en': 'Plastic',
      'sw': 'Jeans',
    },
    'grtb7wlv': {
      'en': 'Leather',
      'sw': '',
    },
    'oy0d9pku': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'd2bez2b8': {
      'en': 'Modern',
      'sw': '',
    },
    'bhbq835d': {
      'en': 'Vintage',
      'sw': '',
    },
    'k28zwqtl': {
      'en': 'Antique',
      'sw': '',
    },
    '9fsjevwv': {
      'en': 'Minimalist',
      'sw': '',
    },
    'agfkgoxc': {
      'en': 'Traditional',
      'sw': '',
    },
    'a1ys3hw0': {
      'en': 'Luxury',
      'sw': '',
    },
    'cw8yjjt3': {
      'en': 'Landscape',
      'sw': '',
    },
    'dk800cri': {
      'en': 'Portrait',
      'sw': '',
    },
    '81qeyw3p': {
      'en': 'Square',
      'sw': '',
    },
    'v3qra31s': {
      'en': '1-Seater',
      'sw': 'Rangi Moja',
    },
    'q9694bd8': {
      'en': '2-Seater',
      'sw': 'Mistari',
    },
    'agzzi6q4': {
      'en': 'L-Shape',
      'sw': 'Picha',
    },
    '7kex1rxf': {
      'en': 'Dining Set',
      'sw': '',
    },
    '97igrco0': {
      'en': 'Battery',
      'sw': '',
    },
    'wwpfwl0o': {
      'en': 'Electric',
      'sw': '',
    },
    'xyba7uun': {
      'en': 'Solar',
      'sw': '',
    },
    'mtvyoob6': {
      'en': 'LED',
      'sw': '',
    },
    'hq76vthn': {
      'en': 'Brand New',
      'sw': '',
    },
    '0et44pnf': {
      'en': 'Like New',
      'sw': '',
    },
    '2yqrz4mq': {
      'en': 'Gently Used',
      'sw': '',
    },
    'fswpq24h': {
      'en': 'Set Adress',
      'sw': '',
    },
    '4m0axfm1': {
      'en': 'location',
      'sw': '',
    },
    '8ewsr9tm': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'cc1fwedz': {
      'en': 'Contact information',
      'sw': '',
    },
    '52h1me9v': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'dbblg567': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'lrujmst1': {
      'en': 'Call no',
      'sw': '',
    },
    '04l483ap': {
      'en': 'Call no',
      'sw': '',
    },
    'yfvmfb7d': {
      'en': 'Price',
      'sw': '',
    },
    'kfzqs2jr': {
      'en': 'Price',
      'sw': '',
    },
    '6tbjeqg9': {
      'en': '0.00',
      'sw': '',
    },
    '4o2xdjjy': {
      'en': 'Please set a price',
      'sw': '',
    },
    'sqb8tzln': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'lvhjeahw': {
      'en': 'Description',
      'sw': '',
    },
    'lhbbtqi2': {
      'en': 'Product description',
      'sw': '',
    },
    'jwfmx3jq': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'ee71f976': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'euluh1ir': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'jt8e59rc': {
      'en': 'Trending',
      'sw': '',
    },
    'mayf1beb': {
      'en': 'New Arrival',
      'sw': '',
    },
    'g2va1ha7': {
      'en': 'Show in All',
      'sw': '',
    },
    '9wm4u6kr': {
      'en': 'Post Now',
      'sw': '',
    },
    '7arg3yyk': {
      'en': 'Home',
      'sw': '',
    },
  },
  // WallArt1
  {
    'i1m6uz5n': {
      'en': 'Home & Living',
      'sw': '',
    },
    'oai1xsnb': {
      'en': 'Wall Art',
      'sw': '',
    },
    'cug2auqp': {
      'en': 'Change',
      'sw': '',
    },
    'th7ak6l7': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '4m1ii84i': {
      'en': 'Add Photo',
      'sw': '',
    },
    'f3orbuu4': {
      'en': 'COVER',
      'sw': '',
    },
    'jguvdagw': {
      'en': 'Product Name',
      'sw': '',
    },
    'bmu6gvhj': {
      'en': 'Product Name',
      'sw': '',
    },
    'ezfmyua0': {
      'en': 'Product Name',
      'sw': '',
    },
    'lnp4fehz': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'qtlfoa6u': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'kpfelegx': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '3ujkj8mh': {
      'en': 'Product Collection',
      'sw': '',
    },
    'ggh5kn19': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'qfn0jfsc': {
      'en': 'Wall Art',
      'sw': '',
    },
    'xneq6zmh': {
      'en': 'Brand & Designer',
      'sw': '',
    },
    'qv4cjgg8': {
      'en': 'Select...',
      'sw': '',
    },
    's9gt5p0s': {
      'en': 'Search...',
      'sw': '',
    },
    'mv9ajip5': {
      'en': 'IKEA',
      'sw': '',
    },
    'iv8j7l34': {
      'en': 'Home Centre',
      'sw': '',
    },
    's2wvq1vu': {
      'en': 'Local Artisan',
      'sw': '',
    },
    'faru3n5w': {
      'en': 'Luxury Brand,',
      'sw': '',
    },
    '12qzrgog': {
      'en': 'Unbranded',
      'sw': '',
    },
    'kphnt6xq': {
      'en': ' Sizes',
      'sw': '',
    },
    'agcjvzf1': {
      'en': 'Single',
      'sw': '',
    },
    'xu6uxm8c': {
      'en': 'Double',
      'sw': '',
    },
    'h2fts252': {
      'en': 'Queen',
      'sw': '',
    },
    'z9ny18az': {
      'en': 'King',
      'sw': '',
    },
    'jfk7pziz': {
      'en': 'Super King',
      'sw': '',
    },
    'ot4lhce8': {
      'en': 'Weight: Light',
      'sw': '',
    },
    'llko6hal': {
      'en': 'Weight: Heavy',
      'sw': '',
    },
    'q2p7qtz8': {
      'en': 'Weight: Requires 2 people',
      'sw': '',
    },
    'pzww601u': {
      'en': 'Selct Color',
      'sw': '',
    },
    'p0zbb9um': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'afpc0ff5': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    '0bfk2aen': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'ef7nylnx': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'hehde2kt': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    '0iwqnl8z': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'jk3gzz1n': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'cwai19hn': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'tdemb7xu': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'elq67h62': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    '8kvlqt6y': {
      'en': '💛 Gold',
      'sw': '',
    },
    'vkdi0e76': {
      'en': 'Material ',
      'sw': '',
    },
    '3x3btgf8': {
      'en': 'Select...',
      'sw': '',
    },
    'ehi6tzzm': {
      'en': 'Search...',
      'sw': '',
    },
    'fiw2in20': {
      'en': 'Wood',
      'sw': 'Pamba',
    },
    '5z25iiri': {
      'en': 'Metal',
      'sw': 'Kitani',
    },
    'ywl62r0e': {
      'en': 'Glass',
      'sw': 'Sufu',
    },
    'ztupg275': {
      'en': 'Fabric/Cotton',
      'sw': 'Polyester',
    },
    'j8rhju3l': {
      'en': 'Plastic',
      'sw': 'Jeans',
    },
    'vewzco3r': {
      'en': 'Leather',
      'sw': '',
    },
    '2736cdm8': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'bdxjxx7v': {
      'en': 'Modern',
      'sw': '',
    },
    'x45vo9eh': {
      'en': 'Vintage',
      'sw': '',
    },
    'wlluzex2': {
      'en': 'Antique',
      'sw': '',
    },
    'htkejaoc': {
      'en': 'Minimalist',
      'sw': '',
    },
    '7mb38ro8': {
      'en': 'Traditional',
      'sw': '',
    },
    'k5yf10ot': {
      'en': 'Luxury',
      'sw': '',
    },
    'adu9pno5': {
      'en': 'Landscape',
      'sw': '',
    },
    'bvh1bxgy': {
      'en': 'Portrait',
      'sw': '',
    },
    'qa148on2': {
      'en': 'Square',
      'sw': '',
    },
    'c2pppgu1': {
      'en': '1-Seater',
      'sw': 'Rangi Moja',
    },
    'sw0bbljo': {
      'en': '2-Seater',
      'sw': 'Mistari',
    },
    'bh2h3nbc': {
      'en': 'L-Shape',
      'sw': 'Picha',
    },
    'i10n1cyq': {
      'en': 'Dining Set',
      'sw': '',
    },
    'zncn7ufj': {
      'en': 'Battery',
      'sw': '',
    },
    'ukmzdd5t': {
      'en': 'Electric',
      'sw': '',
    },
    'abahwb3p': {
      'en': 'Solar',
      'sw': '',
    },
    'mamop2yz': {
      'en': 'LED',
      'sw': '',
    },
    'dbsojma0': {
      'en': 'Brand New',
      'sw': '',
    },
    'sjehtoza': {
      'en': 'Like New',
      'sw': '',
    },
    '0vub63lv': {
      'en': 'Gently Used',
      'sw': '',
    },
    '91wdw4dy': {
      'en': 'Set Adress',
      'sw': '',
    },
    'gqu5ry8x': {
      'en': 'location',
      'sw': '',
    },
    'dlqg3xlv': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'w3upe4kp': {
      'en': 'Contact information',
      'sw': '',
    },
    'g9r66724': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'qj210o4u': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'njhzorkj': {
      'en': 'Call no',
      'sw': '',
    },
    'im6o7y4o': {
      'en': 'Call no',
      'sw': '',
    },
    '32muowwh': {
      'en': 'Price',
      'sw': '',
    },
    'ht1bnevp': {
      'en': 'Price',
      'sw': '',
    },
    'wexfml2g': {
      'en': '0.00',
      'sw': '',
    },
    'vq7ksll0': {
      'en': 'Please set a price',
      'sw': '',
    },
    '80k2thah': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'kteynzbc': {
      'en': 'Description',
      'sw': '',
    },
    'nw3e5fne': {
      'en': 'Product description',
      'sw': '',
    },
    'sx10suqr': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'lk89up6p': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'j5sv2qu1': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    's2im9nvk': {
      'en': 'Trending',
      'sw': '',
    },
    'rsbopgz4': {
      'en': 'New Arrival',
      'sw': '',
    },
    '907t2ufz': {
      'en': 'Show in All',
      'sw': '',
    },
    '8b7w3omi': {
      'en': 'Post Now',
      'sw': '',
    },
    '84nd5xyp': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Furniture1
  {
    '49nf0g71': {
      'en': 'Home & Living',
      'sw': '',
    },
    'w4yev5lz': {
      'en': 'Furniture',
      'sw': '',
    },
    'c9b2hpe8': {
      'en': 'Change',
      'sw': '',
    },
    '4yhj3qsg': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'scit14qq': {
      'en': 'Add Photo',
      'sw': '',
    },
    '3rona56w': {
      'en': 'COVER',
      'sw': '',
    },
    'hsor1k2j': {
      'en': 'Product Name',
      'sw': '',
    },
    'fqkfs8ad': {
      'en': 'Product Name',
      'sw': '',
    },
    'sv113olx': {
      'en': 'Product Name',
      'sw': '',
    },
    '11pmt7u1': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'lpdwskkh': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'vr1q9qvu': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '8d2uup13': {
      'en': 'Product Collection',
      'sw': '',
    },
    'n9q494w9': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'lhh81vyt': {
      'en': 'Furniture',
      'sw': '',
    },
    '2cy5n4v3': {
      'en': 'Brand & Designer',
      'sw': '',
    },
    '18jdzfdb': {
      'en': 'Select...',
      'sw': '',
    },
    '22p5rmie': {
      'en': 'Search...',
      'sw': '',
    },
    'vgbepv9q': {
      'en': 'IKEA',
      'sw': '',
    },
    'fy3pvobz': {
      'en': 'Home Centre',
      'sw': '',
    },
    'j27hi86i': {
      'en': 'Local Artisan',
      'sw': '',
    },
    'dnx386nr': {
      'en': 'Luxury Brand,',
      'sw': '',
    },
    'yq03n114': {
      'en': 'Unbranded',
      'sw': '',
    },
    '4lr5p4s1': {
      'en': ' Sizes',
      'sw': '',
    },
    'gksapo5y': {
      'en': 'Single',
      'sw': '',
    },
    'sudi4z1k': {
      'en': 'Double',
      'sw': '',
    },
    'rv54tae1': {
      'en': 'Queen',
      'sw': '',
    },
    'uentk3fx': {
      'en': 'King',
      'sw': '',
    },
    'o39s11tc': {
      'en': 'Super King',
      'sw': '',
    },
    'tj78fap8': {
      'en': 'Weight: Light',
      'sw': '',
    },
    'u92ykoq7': {
      'en': 'Weight: Heavy',
      'sw': '',
    },
    '6kv0x3kl': {
      'en': 'Weight: Requires 2 people',
      'sw': '',
    },
    '76hu8peb': {
      'en': 'Selct Color',
      'sw': '',
    },
    'uhwimqlz': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'm4hhygtf': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    'kgj7eici': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    '4hd8ouzv': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    'liqgea5y': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    'hcvpk4t1': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'vqo6zrod': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'rdgyjtcv': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'dxf9dlw8': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    'l9x01b54': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'gs2wxorz': {
      'en': '💛 Gold',
      'sw': '',
    },
    '5igveido': {
      'en': 'Material ',
      'sw': '',
    },
    'y9hk40w7': {
      'en': 'Select...',
      'sw': '',
    },
    'z816rhbz': {
      'en': 'Search...',
      'sw': '',
    },
    '449hdhe3': {
      'en': 'Wood',
      'sw': 'Pamba',
    },
    'suw3xlgq': {
      'en': 'Metal',
      'sw': 'Kitani',
    },
    'nbrfttaw': {
      'en': 'Glass',
      'sw': 'Sufu',
    },
    'h1483uhr': {
      'en': 'Fabric/Cotton',
      'sw': 'Polyester',
    },
    'qf761zx8': {
      'en': 'Plastic',
      'sw': 'Jeans',
    },
    't2va0enk': {
      'en': 'Leather',
      'sw': '',
    },
    'cub8xher': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'jb22zuxx': {
      'en': 'Modern',
      'sw': '',
    },
    'ugj5092q': {
      'en': 'Vintage',
      'sw': '',
    },
    'mef0vc4s': {
      'en': 'Antique',
      'sw': '',
    },
    '2jsrs2pg': {
      'en': 'Minimalist',
      'sw': '',
    },
    'a7qxog3a': {
      'en': 'Traditional',
      'sw': '',
    },
    'dmsjayix': {
      'en': 'Luxury',
      'sw': '',
    },
    'uyc3vskx': {
      'en': 'Landscape',
      'sw': '',
    },
    'efy6p7hk': {
      'en': 'Portrait',
      'sw': '',
    },
    'a105vh9e': {
      'en': 'Square',
      'sw': '',
    },
    'ho9k821t': {
      'en': '1-Seater',
      'sw': 'Rangi Moja',
    },
    'p7bt3sr6': {
      'en': '2-Seater',
      'sw': 'Mistari',
    },
    'v24zv35w': {
      'en': 'L-Shape',
      'sw': 'Picha',
    },
    'xvft7a2h': {
      'en': 'Dining Set',
      'sw': '',
    },
    'ebb1htvr': {
      'en': 'Battery',
      'sw': '',
    },
    'yl9mux4n': {
      'en': 'Electric',
      'sw': '',
    },
    '17w14zma': {
      'en': 'Solar',
      'sw': '',
    },
    'j8y4wfis': {
      'en': 'LED',
      'sw': '',
    },
    'blhhei1t': {
      'en': 'Brand New',
      'sw': '',
    },
    'raowuooa': {
      'en': 'Like New',
      'sw': '',
    },
    'zv4pendc': {
      'en': 'Gently Used',
      'sw': '',
    },
    'qpnzqhnt': {
      'en': 'Set Adress',
      'sw': '',
    },
    'rwhna2fd': {
      'en': 'location',
      'sw': '',
    },
    '1r1munak': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'jammtfxq': {
      'en': 'Contact information',
      'sw': '',
    },
    'qzjry6l7': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '6obkdsjy': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'gxg316xw': {
      'en': 'Call no',
      'sw': '',
    },
    'btw1dnwz': {
      'en': 'Call no',
      'sw': '',
    },
    '9sad7ks2': {
      'en': 'Price',
      'sw': '',
    },
    'ngkwphh9': {
      'en': 'Price',
      'sw': '',
    },
    'wzp5dcxu': {
      'en': '0.00',
      'sw': '',
    },
    'bvmos0s4': {
      'en': 'Please set a price',
      'sw': '',
    },
    '5jyae1r0': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'fy7ngxbf': {
      'en': 'Description',
      'sw': '',
    },
    'x6upqd6v': {
      'en': 'Product description',
      'sw': '',
    },
    'rya1mvfw': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'xbe865ry': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '54q6nfcu': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'p9b7p5n0': {
      'en': 'Trending',
      'sw': '',
    },
    'l2hrfswa': {
      'en': 'New Arrival',
      'sw': '',
    },
    'qga7nq8h': {
      'en': 'Show in All',
      'sw': '',
    },
    'p8hba1iq': {
      'en': 'Post Now',
      'sw': '',
    },
    'mmtgfhsq': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Bedding1
  {
    'ji2h3wws': {
      'en': 'Home & Living',
      'sw': '',
    },
    'p2o1wr31': {
      'en': 'Bedding',
      'sw': '',
    },
    'yqb4vurv': {
      'en': 'Change',
      'sw': '',
    },
    'c8q5aghx': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'lj61n4mp': {
      'en': 'Add Photo',
      'sw': '',
    },
    'c6hrwkqy': {
      'en': 'COVER',
      'sw': '',
    },
    'encil8ud': {
      'en': 'Product Name',
      'sw': '',
    },
    '293e3fqz': {
      'en': 'Product Name',
      'sw': '',
    },
    'nec0a6mm': {
      'en': 'Product Name',
      'sw': '',
    },
    '71kn42dy': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'j7np8z2x': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'z8dqwn0d': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'n8xghliv': {
      'en': 'Product Collection',
      'sw': '',
    },
    'tsv60win': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'sp029lmf': {
      'en': 'Bedding',
      'sw': '',
    },
    'h5x4e8ku': {
      'en': 'Brand & Designer',
      'sw': '',
    },
    'b6964u36': {
      'en': 'Select...',
      'sw': '',
    },
    'flpieh7m': {
      'en': 'Search...',
      'sw': '',
    },
    'lgpel1p6': {
      'en': 'IKEA',
      'sw': '',
    },
    'nr42mhi9': {
      'en': 'Home Centre',
      'sw': '',
    },
    'sftj7lsx': {
      'en': 'Local Artisan',
      'sw': '',
    },
    '43vm7hms': {
      'en': 'Luxury Brand,',
      'sw': '',
    },
    '4qrwzh3q': {
      'en': 'Unbranded',
      'sw': '',
    },
    '9oe423km': {
      'en': ' Sizes',
      'sw': '',
    },
    '2l4ay3iv': {
      'en': 'Single',
      'sw': '',
    },
    '19kwvnnl': {
      'en': 'Double',
      'sw': '',
    },
    't4hrikx4': {
      'en': 'Queen',
      'sw': '',
    },
    'kn876n9s': {
      'en': 'King',
      'sw': '',
    },
    'xozllo9z': {
      'en': 'Super King',
      'sw': '',
    },
    'ga839aad': {
      'en': 'Weight: Light',
      'sw': '',
    },
    '4g1wo2xs': {
      'en': 'Weight: Heavy',
      'sw': '',
    },
    '6krq2zl3': {
      'en': 'Weight: Requires 2 people',
      'sw': '',
    },
    'hn3g6754': {
      'en': 'Selct Color',
      'sw': '',
    },
    'x33r8ke5': {
      'en': '🔴 Red',
      'sw': 'Nyeupe Saf',
    },
    'o8gvr500': {
      'en': '💗 Pink',
      'sw': 'Nyeusi Iliyokoza',
    },
    '66c56p5k': {
      'en': '🟣 Purple',
      'sw': 'Buluu ya Kibaharia',
    },
    'v3iavzav': {
      'en': '🟡 Yellow',
      'sw': 'Kijivu cha Makaa',
    },
    '9yohv4jf': {
      'en': '🟢 Mint Green',
      'sw': 'Kaki/Bej',
    },
    '3zexrd5j': {
      'en': '🔵 Royal Blue',
      'sw': 'Kijani cha Zeitun',
    },
    'vj451f1w': {
      'en': '🟠 Orange\n',
      'sw': 'Buluu ya Anga',
    },
    'aamdvgyw': {
      'en': '⚪ White\n',
      'sw': '',
    },
    'm2kwyvph': {
      'en': '⚫ Black\n',
      'sw': '',
    },
    '6aviq4ju': {
      'en': '🟤 Brown\n',
      'sw': '',
    },
    'fc1tepvl': {
      'en': '💛 Gold',
      'sw': '',
    },
    'zjclyykv': {
      'en': 'Material ',
      'sw': '',
    },
    'w9jo38mc': {
      'en': 'Select...',
      'sw': '',
    },
    'nv2b9qhe': {
      'en': 'Search...',
      'sw': '',
    },
    '8jscd6wa': {
      'en': 'Wood',
      'sw': 'Pamba',
    },
    'kyamjhth': {
      'en': 'Metal',
      'sw': 'Kitani',
    },
    'nxir4xms': {
      'en': 'Glass',
      'sw': 'Sufu',
    },
    'eewh3yjg': {
      'en': 'Fabric/Cotton',
      'sw': 'Polyester',
    },
    '4xx28ju3': {
      'en': 'Plastic',
      'sw': 'Jeans',
    },
    'scvsht3i': {
      'en': 'Leather',
      'sw': '',
    },
    's51bvn1f': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    '5cm8qzuq': {
      'en': 'Modern',
      'sw': '',
    },
    '0f199gsg': {
      'en': 'Vintage',
      'sw': '',
    },
    'fembf8ej': {
      'en': 'Antique',
      'sw': '',
    },
    'dwsijt3k': {
      'en': 'Minimalist',
      'sw': '',
    },
    '3nunahpq': {
      'en': 'Traditional',
      'sw': '',
    },
    'nuhwgh86': {
      'en': 'Luxury',
      'sw': '',
    },
    'zw6zgt5j': {
      'en': 'Landscape',
      'sw': '',
    },
    'onosf65p': {
      'en': 'Portrait',
      'sw': '',
    },
    '4ksfnorp': {
      'en': 'Square',
      'sw': '',
    },
    'p26juelz': {
      'en': '1-Seater',
      'sw': 'Rangi Moja',
    },
    'rpb9terb': {
      'en': '2-Seater',
      'sw': 'Mistari',
    },
    'wt7ulrww': {
      'en': 'L-Shape',
      'sw': 'Picha',
    },
    '12e6vkve': {
      'en': 'Dining Set',
      'sw': '',
    },
    'zrt9ect1': {
      'en': 'Battery',
      'sw': '',
    },
    'b2xym7fd': {
      'en': 'Electric',
      'sw': '',
    },
    'we44c3h3': {
      'en': 'Solar',
      'sw': '',
    },
    'zovjmv7a': {
      'en': 'LED',
      'sw': '',
    },
    'y8dz7dk2': {
      'en': 'Brand New',
      'sw': '',
    },
    'bag742dd': {
      'en': 'Like New',
      'sw': '',
    },
    'nn0iko0q': {
      'en': 'Gently Used',
      'sw': '',
    },
    '960lwvtl': {
      'en': 'Set Adress',
      'sw': '',
    },
    '72iqh56g': {
      'en': 'location',
      'sw': '',
    },
    '74xk8q9z': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'p0zjvrc8': {
      'en': 'Contact information',
      'sw': '',
    },
    '8x6xm6v5': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '8k2yz954': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '7edf3vvs': {
      'en': 'Call no',
      'sw': '',
    },
    'vyfndp9z': {
      'en': 'Call no',
      'sw': '',
    },
    'r5orpu7s': {
      'en': 'Price',
      'sw': '',
    },
    '2llakk8s': {
      'en': 'Price',
      'sw': '',
    },
    'mkkwo1dx': {
      'en': '0.00',
      'sw': '',
    },
    'mpvrvft9': {
      'en': 'Please set a price',
      'sw': '',
    },
    '3399xc5j': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '0945ihgc': {
      'en': 'Description',
      'sw': '',
    },
    '8oflzpph': {
      'en': 'Product description',
      'sw': '',
    },
    'bay36zea': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'g507e34e': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '3ynm8gut': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'ioinl9re': {
      'en': 'Trending',
      'sw': '',
    },
    '573ssuov': {
      'en': 'New Arrival',
      'sw': '',
    },
    'oxj124sx': {
      'en': 'Show in All',
      'sw': '',
    },
    'xnuztwzh': {
      'en': 'Post Now',
      'sw': '',
    },
    'rgishabn': {
      'en': 'Home',
      'sw': '',
    },
  },
  // FreshProduce1
  {
    '7lqzeac6': {
      'en': 'Grocery',
      'sw': '',
    },
    'igbk71es': {
      'en': 'Fresh Produce',
      'sw': '',
    },
    'jrjqaxo9': {
      'en': 'Change',
      'sw': '',
    },
    'pzqjbop7': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '7squlhdu': {
      'en': 'Add Photo',
      'sw': '',
    },
    'wu5e268h': {
      'en': 'COVER',
      'sw': '',
    },
    '6dxvtzn5': {
      'en': 'Product Name',
      'sw': '',
    },
    'al1k54st': {
      'en': 'Product Name',
      'sw': '',
    },
    'c3ve27jb': {
      'en': 'Product Name',
      'sw': '',
    },
    'io100x5p': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'm2wk3niq': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '6gwjfakx': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '7i8sfptz': {
      'en': 'Product Collection',
      'sw': '',
    },
    'mx06fjyo': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'nztsj5x4': {
      'en': 'Fresh Produce',
      'sw': '',
    },
    'lcplvs31': {
      'en': 'Category',
      'sw': '',
    },
    '24zkf7x0': {
      'en': 'Select...',
      'sw': '',
    },
    'z19lbdlj': {
      'en': 'Search...',
      'sw': '',
    },
    'a6p0n0lb': {
      'en': 'Fruits/Veg',
      'sw': '',
    },
    '0ntjlrwl': {
      'en': '(Rice, Wheat, Maize',
      'sw': '',
    },
    '8w476bj9': {
      'en': 'Juice, Soda, Water',
      'sw': '',
    },
    '4u3x0amz': {
      'en': 'Meat & Dairy',
      'sw': '',
    },
    'ajohrb8s': {
      'en': ' Sizes',
      'sw': '',
    },
    'nrnb3xi5': {
      'en': '250g',
      'sw': '',
    },
    '9y5rhi6p': {
      'en': '500g',
      'sw': '',
    },
    'ep8g8u6h': {
      'en': '1kg',
      'sw': '',
    },
    'sxs2qpgf': {
      'en': '2kg',
      'sw': '',
    },
    't3s0l4dz': {
      'en': '5kg',
      'sw': '',
    },
    'j0r5hiy1': {
      'en': '25kg',
      'sw': '',
    },
    '20kgfsq6': {
      'en': '50kg',
      'sw': '',
    },
    'aja5p6bz': {
      'en': '250ml',
      'sw': '',
    },
    '8zvtxwwd': {
      'en': '500ml',
      'sw': '',
    },
    'v9eoci2q': {
      'en': '1L',
      'sw': '',
    },
    '693o0dbo': {
      'en': '1.5L',
      'sw': '',
    },
    'lcnsgetm': {
      'en': '5L',
      'sw': '',
    },
    'h4cam3i6': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'csvdjhni': {
      'en': 'Fresh/Room Temp',
      'sw': '',
    },
    'p77mmko2': {
      'en': 'Chilled/Fridge',
      'sw': '',
    },
    'ry2nbu4w': {
      'en': 'Frozen',
      'sw': '',
    },
    'mooifpdr': {
      'en': 'Dry/Pantry',
      'sw': '',
    },
    '42js8t6z': {
      'en': 'Picked Today',
      'sw': 'Rangi Moja',
    },
    'b9ryamts': {
      'en': 'Best Before [Date]',
      'sw': 'Mistari',
    },
    'zpvbbb81': {
      'en': 'Organic/No Chemicals',
      'sw': 'Picha',
    },
    'kxnk2t3h': {
      'en': 'Loose/Per Piece',
      'sw': '',
    },
    '91el6gsz': {
      'en': 'Packaged/Boxed',
      'sw': '',
    },
    '4emz4z71': {
      'en': 'Bulk/Wholesale',
      'sw': '',
    },
    'bzwsazmu': {
      'en': 'Brand New',
      'sw': '',
    },
    'o5hiysj2': {
      'en': 'Like New',
      'sw': '',
    },
    '4htxdxa5': {
      'en': 'Gently Used',
      'sw': '',
    },
    'nbg56a1t': {
      'en': 'Set Adress',
      'sw': '',
    },
    't3f8y38t': {
      'en': 'location',
      'sw': '',
    },
    '66en746z': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'v8q079jz': {
      'en': 'Contact information',
      'sw': '',
    },
    '91h9uu1t': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'l0ccftrf': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'o8c07crx': {
      'en': 'Call no',
      'sw': '',
    },
    '8wwnpjmy': {
      'en': 'Call no',
      'sw': '',
    },
    'rx7vhh8l': {
      'en': 'Price',
      'sw': '',
    },
    'y9orjs92': {
      'en': 'Price',
      'sw': '',
    },
    'mu6vkuxf': {
      'en': '0.00',
      'sw': '',
    },
    'f8ox02ce': {
      'en': 'Please set a price',
      'sw': '',
    },
    'hxxf1e5s': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'c7zl1xgu': {
      'en': 'Description',
      'sw': '',
    },
    '8a7ajfr4': {
      'en': 'Product description',
      'sw': '',
    },
    'y0os94re': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'ypnukw7i': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '01tu43qv': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'b2ppeccx': {
      'en': 'Trending',
      'sw': '',
    },
    'v06u1je0': {
      'en': 'New Arrival',
      'sw': '',
    },
    'g4pjefzt': {
      'en': 'Show in All',
      'sw': '',
    },
    'wwnsik4m': {
      'en': 'Post Now',
      'sw': '',
    },
    'ji0297w5': {
      'en': 'Home',
      'sw': '',
    },
  },
  // GrainsFlour1
  {
    '71t8iy71': {
      'en': 'Grocery',
      'sw': '',
    },
    'hd21khhj': {
      'en': 'Grains & Flour',
      'sw': '',
    },
    'e3lubuah': {
      'en': 'Change',
      'sw': '',
    },
    'vobbmc5v': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '0wd7ekt2': {
      'en': 'Add Photo',
      'sw': '',
    },
    'x8dld7hb': {
      'en': 'COVER',
      'sw': '',
    },
    'nral5d3z': {
      'en': 'Product Name',
      'sw': '',
    },
    'jhr380od': {
      'en': 'Product Name',
      'sw': '',
    },
    'irnrgip8': {
      'en': 'Product Name',
      'sw': '',
    },
    'x7i31gfg': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'gi0lukzg': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'bo5aowoc': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gw1rrjoj': {
      'en': 'Product Collection',
      'sw': '',
    },
    '6c8hjqkw': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '3m2qu6t9': {
      'en': 'Grains & Flour',
      'sw': '',
    },
    '7qflgy5d': {
      'en': 'Category',
      'sw': '',
    },
    'dvfr72bo': {
      'en': 'Select...',
      'sw': '',
    },
    'z62ob35t': {
      'en': 'Search...',
      'sw': '',
    },
    '417j9yec': {
      'en': 'Fruits/Veg',
      'sw': '',
    },
    '7lrnpxtb': {
      'en': '(Rice, Wheat, Maize',
      'sw': '',
    },
    '1rfka8lz': {
      'en': 'Juice, Soda, Water',
      'sw': '',
    },
    'nmlu70z4': {
      'en': 'Meat & Dairy',
      'sw': '',
    },
    'rc3wtfzt': {
      'en': ' Sizes',
      'sw': '',
    },
    'qqq6otr2': {
      'en': '250g',
      'sw': '',
    },
    'xiae9728': {
      'en': '500g',
      'sw': '',
    },
    'nhs8v05l': {
      'en': '1kg',
      'sw': '',
    },
    '93pwac83': {
      'en': '2kg',
      'sw': '',
    },
    'lcb1zy97': {
      'en': '5kg',
      'sw': '',
    },
    'kzwkhds9': {
      'en': '25kg',
      'sw': '',
    },
    'bdnsm8u1': {
      'en': '50kg',
      'sw': '',
    },
    '6d02b6f4': {
      'en': '250ml',
      'sw': '',
    },
    'cwnmvif7': {
      'en': '500ml',
      'sw': '',
    },
    'vjix01tv': {
      'en': '1L',
      'sw': '',
    },
    'qdw3dvu5': {
      'en': '1.5L',
      'sw': '',
    },
    'r6f76mcd': {
      'en': '5L',
      'sw': '',
    },
    'dl9tggcu': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    '2rm89r7j': {
      'en': 'Fresh/Room Temp',
      'sw': '',
    },
    '706jahhq': {
      'en': 'Chilled/Fridge',
      'sw': '',
    },
    'pxfwkduq': {
      'en': 'Frozen',
      'sw': '',
    },
    '5j4divoc': {
      'en': 'Dry/Pantry',
      'sw': '',
    },
    '4gi8mio4': {
      'en': 'Picked Today',
      'sw': 'Rangi Moja',
    },
    'hmaz7ewh': {
      'en': 'Best Before [Date]',
      'sw': 'Mistari',
    },
    'drei0bt6': {
      'en': 'Organic/No Chemicals',
      'sw': 'Picha',
    },
    'zwa3lnuw': {
      'en': 'Loose/Per Piece',
      'sw': '',
    },
    'ptfjxdl0': {
      'en': 'Packaged/Boxed',
      'sw': '',
    },
    'vz3irixf': {
      'en': 'Bulk/Wholesale',
      'sw': '',
    },
    'd9cwv36k': {
      'en': 'Brand New',
      'sw': '',
    },
    'y59xlji4': {
      'en': 'Like New',
      'sw': '',
    },
    'bgk4i5bh': {
      'en': 'Gently Used',
      'sw': '',
    },
    '7md1m39h': {
      'en': 'Set Adress',
      'sw': '',
    },
    'pomjw1wi': {
      'en': 'location',
      'sw': '',
    },
    'nea21e5i': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'noqcxfts': {
      'en': 'Contact information',
      'sw': '',
    },
    '1d7sipq5': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'zp0ytpqx': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '9nipeifg': {
      'en': 'Call no',
      'sw': '',
    },
    'j3pf4u0s': {
      'en': 'Call no',
      'sw': '',
    },
    'q7ttbwrl': {
      'en': 'Price',
      'sw': '',
    },
    'ed1gpomi': {
      'en': 'Price',
      'sw': '',
    },
    '8be6z1b5': {
      'en': '0.00',
      'sw': '',
    },
    '04ao4p63': {
      'en': 'Please set a price',
      'sw': '',
    },
    '4vbj7a59': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'tukrfu9r': {
      'en': 'Description',
      'sw': '',
    },
    'tzlymqq4': {
      'en': 'Product description',
      'sw': '',
    },
    'ilfi1b5i': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'w0vsye1u': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'lmbu3m3a': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'aplqrugt': {
      'en': 'Trending',
      'sw': '',
    },
    's001rdvl': {
      'en': 'New Arrival',
      'sw': '',
    },
    'dphx3i0d': {
      'en': 'Show in All',
      'sw': '',
    },
    't1u84mva': {
      'en': 'Post Now',
      'sw': '',
    },
    'yq0032b3': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Beverages1
  {
    'qizwtru8': {
      'en': 'Grocery',
      'sw': '',
    },
    'x38c59fy': {
      'en': 'Beverages',
      'sw': '',
    },
    'dipcc8b3': {
      'en': 'Change',
      'sw': '',
    },
    'l9j833pc': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '8z2i96wm': {
      'en': 'Add Photo',
      'sw': '',
    },
    'p3crvllo': {
      'en': 'COVER',
      'sw': '',
    },
    'kfqp3i5k': {
      'en': 'Product Name',
      'sw': '',
    },
    'sroxki4y': {
      'en': 'Product Name',
      'sw': '',
    },
    'mjsxz348': {
      'en': 'Product Name',
      'sw': '',
    },
    '4qskdjes': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '1imwxhwp': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'ruiyw637': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'capp0pty': {
      'en': 'Product Collection',
      'sw': '',
    },
    'dce4yaei': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'utj54322': {
      'en': 'Beverages',
      'sw': '',
    },
    'zl37vlvg': {
      'en': 'Category',
      'sw': '',
    },
    '7awvbo6m': {
      'en': 'Select...',
      'sw': '',
    },
    '7c6hyxik': {
      'en': 'Search...',
      'sw': '',
    },
    '75fm8qt3': {
      'en': 'Fruits/Veg',
      'sw': '',
    },
    'wlf8hhnq': {
      'en': '(Rice, Wheat, Maize',
      'sw': '',
    },
    'oucrro4k': {
      'en': 'Juice, Soda, Water',
      'sw': '',
    },
    'rvm79g79': {
      'en': 'Meat & Dairy',
      'sw': '',
    },
    'oi6un8nd': {
      'en': ' Sizes',
      'sw': '',
    },
    '5ldm71aa': {
      'en': '250g',
      'sw': '',
    },
    '0dsofsfq': {
      'en': '500g',
      'sw': '',
    },
    'ljyxqpc5': {
      'en': '1kg',
      'sw': '',
    },
    '289xz4ew': {
      'en': '2kg',
      'sw': '',
    },
    'vo9a4w3m': {
      'en': '5kg',
      'sw': '',
    },
    'firpru4j': {
      'en': '25kg',
      'sw': '',
    },
    'bofnz4cy': {
      'en': '50kg',
      'sw': '',
    },
    '5nn6g4ci': {
      'en': '250ml',
      'sw': '',
    },
    '4xd92hzz': {
      'en': '500ml',
      'sw': '',
    },
    'k6hb9dfh': {
      'en': '1L',
      'sw': '',
    },
    '05ehkof1': {
      'en': '1.5L',
      'sw': '',
    },
    'hum3z365': {
      'en': '5L',
      'sw': '',
    },
    'exjiukec': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    '0kur4blx': {
      'en': 'Fresh/Room Temp',
      'sw': '',
    },
    'n328prz5': {
      'en': 'Chilled/Fridge',
      'sw': '',
    },
    'mjkbecb4': {
      'en': 'Frozen',
      'sw': '',
    },
    'f4kzciip': {
      'en': 'Dry/Pantry',
      'sw': '',
    },
    'gyn7s9mu': {
      'en': 'Picked Today',
      'sw': 'Rangi Moja',
    },
    'pj38hpnc': {
      'en': 'Best Before [Date]',
      'sw': 'Mistari',
    },
    'bss2cvfj': {
      'en': 'Organic/No Chemicals',
      'sw': 'Picha',
    },
    'clzbqzid': {
      'en': 'Loose/Per Piece',
      'sw': '',
    },
    'z89s4qt8': {
      'en': 'Packaged/Boxed',
      'sw': '',
    },
    'ftkb05lk': {
      'en': 'Bulk/Wholesale',
      'sw': '',
    },
    '89f4olpu': {
      'en': 'Brand New',
      'sw': '',
    },
    '2f7ddit1': {
      'en': 'Like New',
      'sw': '',
    },
    '65ht82yx': {
      'en': 'Gently Used',
      'sw': '',
    },
    '682ndeou': {
      'en': 'Set Adress',
      'sw': '',
    },
    '2htfplcc': {
      'en': 'location',
      'sw': '',
    },
    'u2w8xbqr': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'jb14gl0f': {
      'en': 'Contact information',
      'sw': '',
    },
    'zjimoxhu': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'rga31qp2': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '9giph3n6': {
      'en': 'Call no',
      'sw': '',
    },
    'jd0x9xvx': {
      'en': 'Call no',
      'sw': '',
    },
    '4pp57lzg': {
      'en': 'Price',
      'sw': '',
    },
    '3ay0dhiy': {
      'en': 'Price',
      'sw': '',
    },
    '2e10cx6c': {
      'en': '0.00',
      'sw': '',
    },
    '84ce1ns1': {
      'en': 'Please set a price',
      'sw': '',
    },
    '5m33ipwb': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'x8arm671': {
      'en': 'Description',
      'sw': '',
    },
    'ibi67fe2': {
      'en': 'Product description',
      'sw': '',
    },
    'o837jouf': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '0wbl0spz': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '5eejwjke': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'b2m7ee7w': {
      'en': 'Trending',
      'sw': '',
    },
    '6wgpk33l': {
      'en': 'New Arrival',
      'sw': '',
    },
    'oqlqibhe': {
      'en': 'Show in All',
      'sw': '',
    },
    '2iks263k': {
      'en': 'Post Now',
      'sw': '',
    },
    '574f9l6e': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Snacks1
  {
    'y7yi684m': {
      'en': 'Grocery',
      'sw': '',
    },
    'czj4m8q0': {
      'en': 'Snacks',
      'sw': '',
    },
    '2eaw98pn': {
      'en': 'Change',
      'sw': '',
    },
    't378whd1': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '69l9vjay': {
      'en': 'Add Photo',
      'sw': '',
    },
    'idk64gea': {
      'en': 'COVER',
      'sw': '',
    },
    'fm1jlrv2': {
      'en': 'Product Name',
      'sw': '',
    },
    '0php5nwo': {
      'en': 'Product Name',
      'sw': '',
    },
    'xo3hpqew': {
      'en': 'Product Name',
      'sw': '',
    },
    'l7esgky2': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'y1pnwaf5': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'd1s46zg3': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '34lat2rz': {
      'en': 'Product Collection',
      'sw': '',
    },
    'okd38nz0': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'c8dgo37u': {
      'en': 'Snacks',
      'sw': '',
    },
    'f3tgcu13': {
      'en': 'Category',
      'sw': '',
    },
    'q6g4uz09': {
      'en': 'Select...',
      'sw': '',
    },
    'yri1j9wu': {
      'en': 'Search...',
      'sw': '',
    },
    '80d325jz': {
      'en': 'Fruits/Veg',
      'sw': '',
    },
    'ty6bqryz': {
      'en': '(Rice, Wheat, Maize',
      'sw': '',
    },
    'ek154pey': {
      'en': 'Juice, Soda, Water',
      'sw': '',
    },
    'ji3nrb69': {
      'en': 'Meat & Dairy',
      'sw': '',
    },
    'q9qqfja9': {
      'en': ' Sizes',
      'sw': '',
    },
    'nmixoye2': {
      'en': '250g',
      'sw': '',
    },
    '4olo0aq8': {
      'en': '500g',
      'sw': '',
    },
    'opcwehjz': {
      'en': '1kg',
      'sw': '',
    },
    'h6vtm701': {
      'en': '2kg',
      'sw': '',
    },
    '1pbp7xm2': {
      'en': '5kg',
      'sw': '',
    },
    'vbhvtcfo': {
      'en': '25kg',
      'sw': '',
    },
    'q30qo8d1': {
      'en': '50kg',
      'sw': '',
    },
    '7277cugu': {
      'en': '250ml',
      'sw': '',
    },
    'stcv3znv': {
      'en': '500ml',
      'sw': '',
    },
    'gpp670yr': {
      'en': '1L',
      'sw': '',
    },
    '5tni0mmi': {
      'en': '1.5L',
      'sw': '',
    },
    'y55uoid7': {
      'en': '5L',
      'sw': '',
    },
    'wip11zuk': {
      'en': 'Fit & Style',
      'sw': 'Mtindo',
    },
    'i6cuv6lc': {
      'en': 'Fresh/Room Temp',
      'sw': '',
    },
    'm7yynf3g': {
      'en': 'Chilled/Fridge',
      'sw': '',
    },
    'ctgeovl9': {
      'en': 'Frozen',
      'sw': '',
    },
    '6e5evx2q': {
      'en': 'Dry/Pantry',
      'sw': '',
    },
    'pn0wdno0': {
      'en': 'Picked Today',
      'sw': 'Rangi Moja',
    },
    'zsivt5ud': {
      'en': 'Best Before [Date]',
      'sw': 'Mistari',
    },
    'pjbb2sqh': {
      'en': 'Organic/No Chemicals',
      'sw': 'Picha',
    },
    'qus4ufth': {
      'en': 'Loose/Per Piece',
      'sw': '',
    },
    'i3nguo4a': {
      'en': 'Packaged/Boxed',
      'sw': '',
    },
    'n0z0jl1j': {
      'en': 'Bulk/Wholesale',
      'sw': '',
    },
    'zx5pjk0g': {
      'en': 'Brand New',
      'sw': '',
    },
    'cud9p2g8': {
      'en': 'Like New',
      'sw': '',
    },
    'b3c5pbx0': {
      'en': 'Gently Used',
      'sw': '',
    },
    'ey15l11l': {
      'en': 'Set Adress',
      'sw': '',
    },
    'afbhg93t': {
      'en': 'location',
      'sw': '',
    },
    'lllu1eq6': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '8000olqt': {
      'en': 'Contact information',
      'sw': '',
    },
    'xg8q22ey': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'b5l8w1t6': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '8gdyusdd': {
      'en': 'Call no',
      'sw': '',
    },
    'ym6rjbwh': {
      'en': 'Call no',
      'sw': '',
    },
    'syt1e6ae': {
      'en': 'Price',
      'sw': '',
    },
    'y6egh67l': {
      'en': 'Price',
      'sw': '',
    },
    'm9tkwgp2': {
      'en': '0.00',
      'sw': '',
    },
    '89u550cp': {
      'en': 'Please set a price',
      'sw': '',
    },
    'nagjtd3s': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'glmkizzg': {
      'en': 'Description',
      'sw': '',
    },
    'bj39l3yd': {
      'en': 'Product description',
      'sw': '',
    },
    'ookyfrvw': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'zelke0xr': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'z24tu1oc': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'k55xmxhy': {
      'en': 'Trending',
      'sw': '',
    },
    'vn9jxvgu': {
      'en': 'New Arrival',
      'sw': '',
    },
    'qpuo2p6x': {
      'en': 'Show in All',
      'sw': '',
    },
    'g3cthkkm': {
      'en': 'Post Now',
      'sw': '',
    },
    'yii7rfpe': {
      'en': 'Home',
      'sw': '',
    },
  },
  // RingsWeddings
  {
    'u67cj70x': {
      'en': 'Jewelry',
      'sw': '',
    },
    '2dj0dcl1': {
      'en': 'Rings & Wedding',
      'sw': '',
    },
    'fm6noujy': {
      'en': 'Change',
      'sw': '',
    },
    'z8e9g70k': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'k095wmwn': {
      'en': 'Add Photo',
      'sw': '',
    },
    's9rzhkis': {
      'en': 'COVER',
      'sw': '',
    },
    'odolhcas': {
      'en': 'Product Name',
      'sw': '',
    },
    'nrdz4mgh': {
      'en': 'Product Name',
      'sw': '',
    },
    'hkojva86': {
      'en': 'Product Name',
      'sw': '',
    },
    'qcz5m1r6': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '1jdp6jqa': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'zb7hrq2x': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'sw47l5bj': {
      'en': 'Product Collection',
      'sw': '',
    },
    '90anpuxh': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'k42fc8if': {
      'en': 'Rings & Wedding',
      'sw': '',
    },
    'ws6l09k2': {
      'en': 'Brand New',
      'sw': '',
    },
    'bbvpms9z': {
      'en': 'Like New',
      'sw': '',
    },
    'mde694a2': {
      'en': 'Gently Used',
      'sw': '',
    },
    'sj26er0e': {
      'en': 'Set Adress',
      'sw': '',
    },
    'lq33tyzs': {
      'en': 'location',
      'sw': '',
    },
    '0xmu60fr': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'fuxb5xu8': {
      'en': 'Contact information',
      'sw': '',
    },
    'etf1oz8h': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '7moyy506': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '7yamucp0': {
      'en': 'Call no',
      'sw': '',
    },
    'zya435e2': {
      'en': 'Call no',
      'sw': '',
    },
    '76gl45bs': {
      'en': 'Price',
      'sw': '',
    },
    'h1nb2kpi': {
      'en': 'Price',
      'sw': '',
    },
    '908i2pcn': {
      'en': '0.00',
      'sw': '',
    },
    '8lkmdlaj': {
      'en': 'Please set a price',
      'sw': '',
    },
    '8e40sqf8': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '4qd7dljs': {
      'en': 'Description',
      'sw': '',
    },
    '75zh37k5': {
      'en': 'Product description',
      'sw': '',
    },
    'dy05k6vd': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'ip179zo2': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'siw38gf9': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '7852dfpq': {
      'en': 'Trending',
      'sw': '',
    },
    'i2grm7np': {
      'en': 'New Arrival',
      'sw': '',
    },
    'hehia6j3': {
      'en': 'Show in All',
      'sw': '',
    },
    'pnyfva99': {
      'en': 'Post Now',
      'sw': '',
    },
    'yvkiszq9': {
      'en': 'Home',
      'sw': '',
    },
  },
  // NecklacesPendant
  {
    'nxc9x3gk': {
      'en': 'Jewelry',
      'sw': '',
    },
    'utrsmyd2': {
      'en': 'Necklaces & Pendants',
      'sw': '',
    },
    'ku8gbe9p': {
      'en': 'Change',
      'sw': '',
    },
    '5spbwxi9': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'thg3tnes': {
      'en': 'Add Photo',
      'sw': '',
    },
    'g41t39de': {
      'en': 'COVER',
      'sw': '',
    },
    'vxqfp97r': {
      'en': 'Product Name',
      'sw': '',
    },
    'ojp3vwr3': {
      'en': 'Product Name',
      'sw': '',
    },
    'obshkqqc': {
      'en': 'Product Name',
      'sw': '',
    },
    'hy5brz6f': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '495wzgnj': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'o37lomts': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'faatweuq': {
      'en': 'Product Collection',
      'sw': '',
    },
    'g1pcsyxz': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'am910dnq': {
      'en': 'Necklaces & Pendants',
      'sw': '',
    },
    'vgky445z': {
      'en': 'Brand New',
      'sw': '',
    },
    'jxf3npq6': {
      'en': 'Like New',
      'sw': '',
    },
    'c0e2o9l6': {
      'en': 'Gently Used',
      'sw': '',
    },
    '3i5368ta': {
      'en': 'Set Adress',
      'sw': '',
    },
    'tbeszrm3': {
      'en': 'location',
      'sw': '',
    },
    'vjtgxqax': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '11hqmelv': {
      'en': 'Contact information',
      'sw': '',
    },
    'vhnj8i2h': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'af9s9b7v': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '3iy5o7kp': {
      'en': 'Call no',
      'sw': '',
    },
    'iwjjuqkr': {
      'en': 'Call no',
      'sw': '',
    },
    'sj2m5kbj': {
      'en': 'Price',
      'sw': '',
    },
    '8d67i3lt': {
      'en': 'Price',
      'sw': '',
    },
    'rllqr3j6': {
      'en': '0.00',
      'sw': '',
    },
    'evjowd07': {
      'en': 'Please set a price',
      'sw': '',
    },
    'yxjqq7lq': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'v629prkq': {
      'en': 'Description',
      'sw': '',
    },
    'y9y443v7': {
      'en': 'Product description',
      'sw': '',
    },
    '743qu87k': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '28ptycbj': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'xp2qv03k': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'wbhluqic': {
      'en': 'Trending',
      'sw': '',
    },
    'wtvxgqpu': {
      'en': 'New Arrival',
      'sw': '',
    },
    'zujzj8f7': {
      'en': 'Show in All',
      'sw': '',
    },
    'n39vxoxj': {
      'en': 'Post Now',
      'sw': '',
    },
    'e0wcn83o': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Seller_Dashbord
  {
    '6hgpcqop': {
      'en': 'Zanzibar Market',
      'sw': '',
    },
    '4v0whzk5': {
      'en': 'Revenue',
      'sw': '',
    },
    'ic9koqdj': {
      'en': 'TZS 4.2M',
      'sw': '',
    },
    'sye5uffr': {
      'en': '+12% this month',
      'sw': '',
    },
    'jx71dlxj': {
      'en': 'Orders',
      'sw': '',
    },
    'c0g5cs0w': {
      'en': 'Total Products',
      'sw': '',
    },
    'ylomg3tk': {
      'en': 'Views',
      'sw': '',
    },
    'zm49af79': {
      'en': '+23% this week',
      'sw': '',
    },
    '7ivyetfz': {
      'en': 'Quick Actions',
      'sw': '',
    },
    'k974n1mn': {
      'en': 'Add Product',
      'sw': '',
    },
    'hu447k0z': {
      'en': 'My Products',
      'sw': '',
    },
    'p5sbp3yt': {
      'en': 'Orders',
      'sw': '',
    },
    'd85m3mud': {
      'en': 'Analytics',
      'sw': '',
    },
  },
  // BraceletsEarring
  {
    '28zm8yrl': {
      'en': 'Jewelry',
      'sw': '',
    },
    'uyjw8dvr': {
      'en': 'Rings & Wedding',
      'sw': '',
    },
    'hz802boy': {
      'en': 'Change',
      'sw': '',
    },
    'l2wq4si8': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'zdayt83j': {
      'en': 'Add Photo',
      'sw': '',
    },
    '7t3oqyad': {
      'en': 'COVER',
      'sw': '',
    },
    'oei57uw3': {
      'en': 'Product Name',
      'sw': '',
    },
    'z76v44kl': {
      'en': 'Product Name',
      'sw': '',
    },
    'szehk5tr': {
      'en': 'Product Name',
      'sw': '',
    },
    'ncvfaal8': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '6bep5h83': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'pn9qaxuo': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '69zvbegg': {
      'en': 'Product Collection',
      'sw': '',
    },
    'hdrk5b42': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'elq0oigb': {
      'en': 'Rings & Wedding',
      'sw': '',
    },
    '9rsophcs': {
      'en': 'Brand New',
      'sw': '',
    },
    'scg8hb99': {
      'en': 'Like New',
      'sw': '',
    },
    '9pshl8sq': {
      'en': 'Gently Used',
      'sw': '',
    },
    '50nho804': {
      'en': 'Set Adress',
      'sw': '',
    },
    'kdcxcfb4': {
      'en': 'location',
      'sw': '',
    },
    'fo2s60o3': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '8yrbzbzx': {
      'en': 'Contact information',
      'sw': '',
    },
    'aypxeivu': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'zddytdxy': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '1crx1zre': {
      'en': 'Call no',
      'sw': '',
    },
    'jusn3ov5': {
      'en': 'Call no',
      'sw': '',
    },
    'qt9jpees': {
      'en': 'Price',
      'sw': '',
    },
    'i8fus0do': {
      'en': 'Price',
      'sw': '',
    },
    '5ztztmfs': {
      'en': '0.00',
      'sw': '',
    },
    '19nzeasc': {
      'en': 'Please set a price',
      'sw': '',
    },
    'lo6k9r31': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'o7jss2na': {
      'en': 'Description',
      'sw': '',
    },
    '84ardyi6': {
      'en': 'Product description',
      'sw': '',
    },
    'y7kow9eh': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '5b65kd2k': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '27hcd7r4': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'moht9phc': {
      'en': 'Trending',
      'sw': '',
    },
    'm19mhq1a': {
      'en': 'New Arrival',
      'sw': '',
    },
    'r4lx1vcp': {
      'en': 'Show in All',
      'sw': '',
    },
    'ew5xhz53': {
      'en': 'Post Now',
      'sw': '',
    },
    'cgqxzfr6': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Kitchens
  {
    'vpz6b8f0': {
      'en': 'Appliances',
      'sw': '',
    },
    'o44ohwo9': {
      'en': 'Kitchen',
      'sw': '',
    },
    'ia38bior': {
      'en': 'Change',
      'sw': '',
    },
    'yckj4bwn': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '8mgbwc5c': {
      'en': 'Add Photo',
      'sw': '',
    },
    'utp6vzwk': {
      'en': 'COVER',
      'sw': '',
    },
    'im4dv7w2': {
      'en': 'Product Name',
      'sw': '',
    },
    '9b4buttq': {
      'en': 'Product Name',
      'sw': '',
    },
    'uu28jpmt': {
      'en': 'Product Name',
      'sw': '',
    },
    'r79mayj8': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'gpjrqs3m': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'vufj3v6e': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '7kg4j1iv': {
      'en': 'Product Collection',
      'sw': '',
    },
    'sooywwxn': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '1pgp1py2': {
      'en': 'Kitchen',
      'sw': '',
    },
    'zznlcpia': {
      'en': 'Brand New',
      'sw': '',
    },
    'xvzamgh5': {
      'en': 'Like New',
      'sw': '',
    },
    '44hg0y0p': {
      'en': 'Gently Used',
      'sw': '',
    },
    'vk1rqcr3': {
      'en': 'Set Adress',
      'sw': '',
    },
    'b6xqenxd': {
      'en': 'location',
      'sw': '',
    },
    'ex0l76j5': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'ienqy4cx': {
      'en': 'Contact information',
      'sw': '',
    },
    'uq1vwjgl': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '39kzhvax': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '24zriw4a': {
      'en': 'Call no',
      'sw': '',
    },
    '7aqmchnd': {
      'en': 'Call no',
      'sw': '',
    },
    'rore7wz0': {
      'en': 'Price',
      'sw': '',
    },
    'g2yifvbn': {
      'en': 'Price',
      'sw': '',
    },
    'sgiclig7': {
      'en': '0.00',
      'sw': '',
    },
    'ebmswxs1': {
      'en': 'Please set a price',
      'sw': '',
    },
    'tyfz3pvs': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '1z9624ff': {
      'en': 'Description',
      'sw': '',
    },
    'ag8d365y': {
      'en': 'Product description',
      'sw': '',
    },
    'rzxtm1tb': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'p8n1vg6j': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'uid7shex': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'kp4ybasw': {
      'en': 'Trending',
      'sw': '',
    },
    'to42wdb8': {
      'en': 'New Arrival',
      'sw': '',
    },
    '6mfdb5ru': {
      'en': 'Show in All',
      'sw': '',
    },
    'mrkye4if': {
      'en': 'Post Now',
      'sw': '',
    },
    '0bqcoat6': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Laundrys
  {
    'i78hy7xr': {
      'en': 'Appliances',
      'sw': '',
    },
    'b2i42rl3': {
      'en': 'Laundry',
      'sw': '',
    },
    '33h7m70q': {
      'en': 'Change',
      'sw': '',
    },
    'mpb0o0n9': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'qc8y9k4e': {
      'en': 'Add Photo',
      'sw': '',
    },
    'xaqymll6': {
      'en': 'COVER',
      'sw': '',
    },
    '4oa3drg4': {
      'en': 'Product Name',
      'sw': '',
    },
    '8a6bpio3': {
      'en': 'Product Name',
      'sw': '',
    },
    'cf2mb2lx': {
      'en': 'Product Name',
      'sw': '',
    },
    'pwlqgmwh': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '5b2q15jc': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'ptgdlcg2': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    't5acoeee': {
      'en': 'Product Collection',
      'sw': '',
    },
    '55bylvk5': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'b6tysy7j': {
      'en': 'Laundry',
      'sw': '',
    },
    'p827s8qn': {
      'en': 'Brand New',
      'sw': '',
    },
    'nx3zxupi': {
      'en': 'Like New',
      'sw': '',
    },
    'jvfkmidl': {
      'en': 'Gently Used',
      'sw': '',
    },
    'nxfhtyfe': {
      'en': 'Set Adress',
      'sw': '',
    },
    '2koz65vh': {
      'en': 'location',
      'sw': '',
    },
    'dgwvbi3p': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'uyt6ovzm': {
      'en': 'Contact information',
      'sw': '',
    },
    'sktpjgkr': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'i0gx22hq': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'xwwux9a6': {
      'en': 'Call no',
      'sw': '',
    },
    'zg0vjz6f': {
      'en': 'Call no',
      'sw': '',
    },
    'ais8rh1o': {
      'en': 'Price',
      'sw': '',
    },
    'osw5of8o': {
      'en': 'Price',
      'sw': '',
    },
    'aqwvw3bg': {
      'en': '0.00',
      'sw': '',
    },
    '7axds8xc': {
      'en': 'Please set a price',
      'sw': '',
    },
    'ifwqok3u': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'cx1cvf7s': {
      'en': 'Description',
      'sw': '',
    },
    '1j8qwo6q': {
      'en': 'Product description',
      'sw': '',
    },
    'x4p6c30i': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'sv3tzkel': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'zu8rfdzn': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    't0t63k26': {
      'en': 'Trending',
      'sw': '',
    },
    'n0064w5v': {
      'en': 'New Arrival',
      'sw': '',
    },
    'odqq41qo': {
      'en': 'Show in All',
      'sw': '',
    },
    'nn7dhmom': {
      'en': 'Post Now',
      'sw': '',
    },
    'subs2hui': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Coolings
  {
    '6pgzzli2': {
      'en': 'Appliances',
      'sw': '',
    },
    'sitpnhbk': {
      'en': 'Cooling',
      'sw': '',
    },
    '5oktlbvf': {
      'en': 'Change',
      'sw': '',
    },
    'sqer80gy': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'fne9n14t': {
      'en': 'Add Photo',
      'sw': '',
    },
    'uqbafbpa': {
      'en': 'COVER',
      'sw': '',
    },
    'co89rkha': {
      'en': 'Product Name',
      'sw': '',
    },
    'objkxz20': {
      'en': 'Product Name',
      'sw': '',
    },
    'ntj28c51': {
      'en': 'Product Name',
      'sw': '',
    },
    '96gdos9i': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'ssdslgej': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'o5wwq5bx': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gikbibwq': {
      'en': 'Product Collection',
      'sw': '',
    },
    '7k5asr0l': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '0ez8wxtn': {
      'en': 'Cooling',
      'sw': '',
    },
    '7hhweybh': {
      'en': 'Brand New',
      'sw': '',
    },
    'h6g49kml': {
      'en': 'Like New',
      'sw': '',
    },
    '30hd2od7': {
      'en': 'Gently Used',
      'sw': '',
    },
    'dxo2t0c1': {
      'en': 'Set Adress',
      'sw': '',
    },
    'q1lplj5j': {
      'en': 'location',
      'sw': '',
    },
    'hlarabe0': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'kd0i9cyl': {
      'en': 'Contact information',
      'sw': '',
    },
    'xb8mjc0g': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'h96lj0do': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'rm3i6zqe': {
      'en': 'Call no',
      'sw': '',
    },
    '5s32jp1u': {
      'en': 'Call no',
      'sw': '',
    },
    'suubsowd': {
      'en': 'Price',
      'sw': '',
    },
    '47aumpgz': {
      'en': 'Price',
      'sw': '',
    },
    'v5au2huw': {
      'en': '0.00',
      'sw': '',
    },
    'ff0joyid': {
      'en': 'Please set a price',
      'sw': '',
    },
    'sai1hjb9': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'oiv81cik': {
      'en': 'Description',
      'sw': '',
    },
    '9sriehm5': {
      'en': 'Product description',
      'sw': '',
    },
    'zlce4ghm': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '37ubcuin': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'foky57qe': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'vayy5kk7': {
      'en': 'Trending',
      'sw': '',
    },
    'udspjnhh': {
      'en': 'New Arrival',
      'sw': '',
    },
    'whd31tvs': {
      'en': 'Show in All',
      'sw': '',
    },
    'cl8scg9m': {
      'en': 'Post Now',
      'sw': '',
    },
    'dpoimgt1': {
      'en': 'Home',
      'sw': '',
    },
  },
  // CarPart
  {
    'yj13fs46': {
      'en': 'automotive',
      'sw': '',
    },
    '40k0qa4x': {
      'en': 'Car Parts',
      'sw': '',
    },
    '7kflyir2': {
      'en': 'Change',
      'sw': '',
    },
    'rskqpmf6': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'rk4bibaq': {
      'en': 'Add Photo',
      'sw': '',
    },
    '9nhh5yq6': {
      'en': 'COVER',
      'sw': '',
    },
    '4jc7873z': {
      'en': 'Product Name',
      'sw': '',
    },
    't7fhwi0f': {
      'en': 'Product Name',
      'sw': '',
    },
    'odd55p4a': {
      'en': 'Product Name',
      'sw': '',
    },
    'biisinpl': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'esuytwgm': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '21pdmaw0': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'hn46ff96': {
      'en': 'Product Collection',
      'sw': '',
    },
    'pzell31y': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '7wiskmai': {
      'en': 'Car Parts',
      'sw': '',
    },
    '0lv8vqkh': {
      'en': 'Brand New',
      'sw': '',
    },
    's7b5sa96': {
      'en': 'Like New',
      'sw': '',
    },
    '2t6eea8q': {
      'en': 'Gently Used',
      'sw': '',
    },
    'n74s4dx4': {
      'en': 'Set Adress',
      'sw': '',
    },
    '7ewegpjy': {
      'en': 'location',
      'sw': '',
    },
    'h5pediuw': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '3xcixb1m': {
      'en': 'Contact information',
      'sw': '',
    },
    'ha3a6xib': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'dcuqjgsx': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'sbkn3ubc': {
      'en': 'Call no',
      'sw': '',
    },
    '7gbq7zgu': {
      'en': 'Call no',
      'sw': '',
    },
    'dn17o7tt': {
      'en': 'Price',
      'sw': '',
    },
    'fozhv593': {
      'en': 'Price',
      'sw': '',
    },
    'wf5vz9af': {
      'en': '0.00',
      'sw': '',
    },
    '5xoyzdpb': {
      'en': 'Please set a price',
      'sw': '',
    },
    'm7aacexb': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '192plerv': {
      'en': 'Description',
      'sw': '',
    },
    '4agsk417': {
      'en': 'Product description',
      'sw': '',
    },
    '3okky9pu': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'unp3mzq9': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'j0agn1jo': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'lmbmyeei': {
      'en': 'Trending',
      'sw': '',
    },
    'smyvvfhr': {
      'en': 'New Arrival',
      'sw': '',
    },
    'dopt8gqs': {
      'en': 'Show in All',
      'sw': '',
    },
    '265ye2rl': {
      'en': 'Post Now',
      'sw': '',
    },
    '4whgg8rn': {
      'en': 'Home',
      'sw': '',
    },
  },
  // InteriorAccessor
  {
    'gx6cdavj': {
      'en': 'automotive',
      'sw': '',
    },
    '9ehm2tn2': {
      'en': 'Interior Accessories',
      'sw': '',
    },
    'jdq1gcu2': {
      'en': 'Change',
      'sw': '',
    },
    '70t0fk8e': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '0s7thvoz': {
      'en': 'Add Photo',
      'sw': '',
    },
    'zjw0v1bi': {
      'en': 'COVER',
      'sw': '',
    },
    '0k9om7he': {
      'en': 'Product Name',
      'sw': '',
    },
    'ekyjqii4': {
      'en': 'Product Name',
      'sw': '',
    },
    '7zoxm7up': {
      'en': 'Product Name',
      'sw': '',
    },
    'g29vj57q': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'x3umxktt': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'gjhiza4j': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'fnkvlxc5': {
      'en': 'Product Collection',
      'sw': '',
    },
    'a2l4e6a4': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'jl63mxou': {
      'en': 'Interior Accessories',
      'sw': '',
    },
    'n8ioieca': {
      'en': 'Brand New',
      'sw': '',
    },
    'dii6wmjh': {
      'en': 'Like New',
      'sw': '',
    },
    'kq0xuzw2': {
      'en': 'Gently Used',
      'sw': '',
    },
    't62hsyuu': {
      'en': 'Set Adress',
      'sw': '',
    },
    '4avoyuho': {
      'en': 'location',
      'sw': '',
    },
    'qsirxgkj': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'fd7h940z': {
      'en': 'Contact information',
      'sw': '',
    },
    '4c9j75wj': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'hdvoxarr': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '1aehcmug': {
      'en': 'Call no',
      'sw': '',
    },
    '6wcp3myy': {
      'en': 'Call no',
      'sw': '',
    },
    'od7ovd1x': {
      'en': 'Price',
      'sw': '',
    },
    'n3birflo': {
      'en': 'Price',
      'sw': '',
    },
    '6r6tivtq': {
      'en': '0.00',
      'sw': '',
    },
    'xb4lftv4': {
      'en': 'Please set a price',
      'sw': '',
    },
    'dyx5sxhy': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '4ki8ioay': {
      'en': 'Description',
      'sw': '',
    },
    '33w3dwf4': {
      'en': 'Product description',
      'sw': '',
    },
    '81dubgs4': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '2ny2r7fa': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'z05w674k': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gk69wqt0': {
      'en': 'Trending',
      'sw': '',
    },
    'k9zhphip': {
      'en': 'New Arrival',
      'sw': '',
    },
    'tsy2565h': {
      'en': 'Show in All',
      'sw': '',
    },
    '5wyxiyqw': {
      'en': 'Post Now',
      'sw': '',
    },
    '619ocz3p': {
      'en': 'Home',
      'sw': '',
    },
  },
  // TiresRim
  {
    '5csfpvpr': {
      'en': 'automotive',
      'sw': '',
    },
    'owtp5fng': {
      'en': 'Tires & Rims',
      'sw': '',
    },
    'x3w8elc9': {
      'en': 'Change',
      'sw': '',
    },
    'kbwbk8rr': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    's7p39dmm': {
      'en': 'Add Photo',
      'sw': '',
    },
    'e3ddi7f2': {
      'en': 'COVER',
      'sw': '',
    },
    '1g97fori': {
      'en': 'Product Name',
      'sw': '',
    },
    '1hdndwqe': {
      'en': 'Product Name',
      'sw': '',
    },
    'cwf9vn5q': {
      'en': 'Product Name',
      'sw': '',
    },
    'wc9b47kb': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'yahj40zg': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'fqzmys73': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'r7bb9755': {
      'en': 'Product Collection',
      'sw': '',
    },
    'f2q6nxmj': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'mbt7vms0': {
      'en': 'Tires & Rims',
      'sw': '',
    },
    '76lyzoed': {
      'en': 'Brand New',
      'sw': '',
    },
    'fi97lncu': {
      'en': 'Like New',
      'sw': '',
    },
    'ublrpzdf': {
      'en': 'Gently Used',
      'sw': '',
    },
    'i14jb2qb': {
      'en': 'Set Adress',
      'sw': '',
    },
    'tj9vspgq': {
      'en': 'location',
      'sw': '',
    },
    'jjj0ijgb': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'mo32bd8e': {
      'en': 'Contact information',
      'sw': '',
    },
    '0q4l2jgx': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'r5ye4v0z': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'a2ssrkrw': {
      'en': 'Call no',
      'sw': '',
    },
    'x8nwq53v': {
      'en': 'Call no',
      'sw': '',
    },
    'h3lme0zb': {
      'en': 'Price',
      'sw': '',
    },
    '6e7i81qz': {
      'en': 'Price',
      'sw': '',
    },
    '6wz49wdp': {
      'en': '0.00',
      'sw': '',
    },
    'accdo90x': {
      'en': 'Please set a price',
      'sw': '',
    },
    'j2djvbr5': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'fk7cnabr': {
      'en': 'Description',
      'sw': '',
    },
    'iyl7m3fn': {
      'en': 'Product description',
      'sw': '',
    },
    'z4k2dyqg': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'glvyusia': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '6bd8ub4f': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '194d5h9p': {
      'en': 'Trending',
      'sw': '',
    },
    '9odya6kc': {
      'en': 'New Arrival',
      'sw': '',
    },
    '6u8mjzdi': {
      'en': 'Show in All',
      'sw': '',
    },
    'oyqh7cnv': {
      'en': 'Post Now',
      'sw': '',
    },
    'drqkmdbp': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Wearable
  {
    'iucg808w': {
      'en': 'Smart Tech',
      'sw': '',
    },
    'frz2bfch': {
      'en': 'Wearables',
      'sw': '',
    },
    '4wyfvnlo': {
      'en': 'Change',
      'sw': '',
    },
    '1zb7cbny': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'o82an1t3': {
      'en': 'Add Photo',
      'sw': '',
    },
    'h8hs07pj': {
      'en': 'COVER',
      'sw': '',
    },
    '5s1wnp6a': {
      'en': 'Product Name',
      'sw': '',
    },
    'b7gz1xsq': {
      'en': 'Product Name',
      'sw': '',
    },
    'ngn82rj3': {
      'en': 'Product Name',
      'sw': '',
    },
    'iz44yukx': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    's2y56mkr': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '8huc2fde': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '9qe82cv1': {
      'en': 'Product Collection',
      'sw': '',
    },
    'pa9cs8sd': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '5e97pvsq': {
      'en': 'Wearables',
      'sw': '',
    },
    'kblw6ckd': {
      'en': 'Brand New',
      'sw': '',
    },
    'x0z49ctu': {
      'en': 'Like New',
      'sw': '',
    },
    'ipnx1m3r': {
      'en': 'Gently Used',
      'sw': '',
    },
    'n05na11b': {
      'en': 'Set Adress',
      'sw': '',
    },
    '1lcndnx3': {
      'en': 'location',
      'sw': '',
    },
    's4mjnjyq': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'quyqxilu': {
      'en': 'Contact information',
      'sw': '',
    },
    'x8wn8uox': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'uuebabib': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'c40etzue': {
      'en': 'Call no',
      'sw': '',
    },
    'w2l9f19g': {
      'en': 'Call no',
      'sw': '',
    },
    'jz4k7quw': {
      'en': 'Price',
      'sw': '',
    },
    'hzt5mb7r': {
      'en': 'Price',
      'sw': '',
    },
    'd76lfhd7': {
      'en': '0.00',
      'sw': '',
    },
    't7ai0vq1': {
      'en': 'Please set a price',
      'sw': '',
    },
    'rnuwlmkk': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'cxncs025': {
      'en': 'Description',
      'sw': '',
    },
    'dbxyp4ps': {
      'en': 'Product description',
      'sw': '',
    },
    'nmkcwlw3': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'mimtcai6': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '4qhuyu02': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'muuyaovv': {
      'en': 'Trending',
      'sw': '',
    },
    'cvb9y8e6': {
      'en': 'New Arrival',
      'sw': '',
    },
    'tj8pd4ds': {
      'en': 'Show in All',
      'sw': '',
    },
    '9pe4xe5u': {
      'en': 'Post Now',
      'sw': '',
    },
    '8an4uwet': {
      'en': 'Home',
      'sw': '',
    },
  },
  // MobileAccessorie
  {
    'q1h6yhfp': {
      'en': 'Smart Tech',
      'sw': '',
    },
    'rpiq559a': {
      'en': 'Mobile Accessories',
      'sw': '',
    },
    'fv17002r': {
      'en': 'Change',
      'sw': '',
    },
    'k11m3a31': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'tnir16aj': {
      'en': 'Add Photo',
      'sw': '',
    },
    '3fmbg03h': {
      'en': 'COVER',
      'sw': '',
    },
    'xhupa31h': {
      'en': 'Product Name',
      'sw': '',
    },
    '1trvd0c8': {
      'en': 'Product Name',
      'sw': '',
    },
    '0xspjlxx': {
      'en': 'Product Name',
      'sw': '',
    },
    'w1jz8pdm': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '9mpce8oq': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '14imarsj': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'mkxtoljd': {
      'en': 'Product Collection',
      'sw': '',
    },
    'l1iqiigw': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '3ncsrb7e': {
      'en': 'Mobile Accessories',
      'sw': '',
    },
    '9g65p2pc': {
      'en': 'Brand New',
      'sw': '',
    },
    'uv8i2jgy': {
      'en': 'Like New',
      'sw': '',
    },
    'r00sn4fr': {
      'en': 'Gently Used',
      'sw': '',
    },
    '1ea87q0b': {
      'en': 'Set Adress',
      'sw': '',
    },
    '2hl62i7k': {
      'en': 'location',
      'sw': '',
    },
    'joqmqps5': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'zzgjj4b1': {
      'en': 'Contact information',
      'sw': '',
    },
    'pwbzh3px': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'uek2fsf0': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'bvfyc5q8': {
      'en': 'Call no',
      'sw': '',
    },
    'b9wwjt7w': {
      'en': 'Call no',
      'sw': '',
    },
    'mdhshv8c': {
      'en': 'Price',
      'sw': '',
    },
    '2qwkk4ey': {
      'en': 'Price',
      'sw': '',
    },
    'vuqvb5hw': {
      'en': '0.00',
      'sw': '',
    },
    'o8p2d2a7': {
      'en': 'Please set a price',
      'sw': '',
    },
    '885ow5az': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '6e9wbrsd': {
      'en': 'Description',
      'sw': '',
    },
    '5x9rh2j7': {
      'en': 'Product description',
      'sw': '',
    },
    'poi8gmr9': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'b9ddajs2': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '7bo0ca5v': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'k6sd0gnp': {
      'en': 'Trending',
      'sw': '',
    },
    '1885rhtp': {
      'en': 'New Arrival',
      'sw': '',
    },
    '63b1xm24': {
      'en': 'Show in All',
      'sw': '',
    },
    'ihcx39pw': {
      'en': 'Post Now',
      'sw': '',
    },
    'f0rt7gzd': {
      'en': 'Home',
      'sw': '',
    },
  },
  // SmartHomes
  {
    'opl3212i': {
      'en': 'Smart Tech',
      'sw': '',
    },
    '9fpxypge': {
      'en': 'Smart Home',
      'sw': '',
    },
    '8zusyvi3': {
      'en': 'Change',
      'sw': '',
    },
    '1kqesc4b': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '5jczg7ay': {
      'en': 'Add Photo',
      'sw': '',
    },
    'dwubd6he': {
      'en': 'COVER',
      'sw': '',
    },
    '4q6s1uvq': {
      'en': 'Product Name',
      'sw': '',
    },
    'u45yim0z': {
      'en': 'Product Name',
      'sw': '',
    },
    'yixzv2br': {
      'en': 'Product Name',
      'sw': '',
    },
    'hpfzer5c': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'gh2667mh': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '86p2pzb5': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'q3xdeuaw': {
      'en': 'Product Collection',
      'sw': '',
    },
    'dkp5g2lq': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '0vi82no3': {
      'en': 'Smart Home',
      'sw': '',
    },
    '0jlyubbe': {
      'en': 'Brand New',
      'sw': '',
    },
    'zbqnmjlw': {
      'en': 'Like New',
      'sw': '',
    },
    '7ne82dxj': {
      'en': 'Gently Used',
      'sw': '',
    },
    'tck9gjr1': {
      'en': 'Set Adress',
      'sw': '',
    },
    '7g7r3tc7': {
      'en': 'location',
      'sw': '',
    },
    'rapemmf1': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    's76g0sk4': {
      'en': 'Contact information',
      'sw': '',
    },
    'ya00ygu9': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'yxz23lf2': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'g81lkkan': {
      'en': 'Call no',
      'sw': '',
    },
    'x28hgdx8': {
      'en': 'Call no',
      'sw': '',
    },
    'y85yl8sw': {
      'en': 'Price',
      'sw': '',
    },
    '5hem210u': {
      'en': 'Price',
      'sw': '',
    },
    '4qt6w0bt': {
      'en': '0.00',
      'sw': '',
    },
    'adde55ww': {
      'en': 'Please set a price',
      'sw': '',
    },
    'gjywtiqx': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'vbk3dmj9': {
      'en': 'Description',
      'sw': '',
    },
    'j06cq78r': {
      'en': 'Product description',
      'sw': '',
    },
    '6xqzg7ts': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '4tnhzjjw': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '31dqu9i1': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'znk9k2nq': {
      'en': 'Trending',
      'sw': '',
    },
    '4gmtfm0s': {
      'en': 'New Arrival',
      'sw': '',
    },
    '6x177ujx': {
      'en': 'Show in All',
      'sw': '',
    },
    'ok4tgh6v': {
      'en': 'Post Now',
      'sw': '',
    },
    '1zln9if7': {
      'en': 'Home',
      'sw': '',
    },
  },
  // TeamSport
  {
    '16q8uhrk': {
      'en': 'Sports',
      'sw': '',
    },
    'zw302giq': {
      'en': 'Team Sports',
      'sw': '',
    },
    'denfhi2b': {
      'en': 'Change',
      'sw': '',
    },
    '1jee3dji': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'kqcg6dfk': {
      'en': 'Add Photo',
      'sw': '',
    },
    'pvvbjo1f': {
      'en': 'COVER',
      'sw': '',
    },
    '07kdn9ih': {
      'en': 'Product Name',
      'sw': '',
    },
    'df91vmc4': {
      'en': 'Product Name',
      'sw': '',
    },
    'adnw9xus': {
      'en': 'Product Name',
      'sw': '',
    },
    '4h8l1rrc': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '1fbcw8xh': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '0j6go1ci': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gpphkdcj': {
      'en': 'Product Collection',
      'sw': '',
    },
    'vprjo4dq': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'zqv2juox': {
      'en': 'Team Sports',
      'sw': '',
    },
    'j5tsaxaq': {
      'en': 'Brand New',
      'sw': '',
    },
    'py6sui6d': {
      'en': 'Like New',
      'sw': '',
    },
    'nv8uixbi': {
      'en': 'Gently Used',
      'sw': '',
    },
    '3g4ulmwv': {
      'en': 'Set Adress',
      'sw': '',
    },
    'bm03q0fx': {
      'en': 'location',
      'sw': '',
    },
    'vqjvnx26': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'ow21ses4': {
      'en': 'Contact information',
      'sw': '',
    },
    'p3vgcttr': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'hmkegopj': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'kfna835g': {
      'en': 'Call no',
      'sw': '',
    },
    'pfi5p5dy': {
      'en': 'Call no',
      'sw': '',
    },
    'jmwnte2x': {
      'en': 'Price',
      'sw': '',
    },
    'fxwoflrd': {
      'en': 'Price',
      'sw': '',
    },
    '63mbvktj': {
      'en': '0.00',
      'sw': '',
    },
    'zidcapa0': {
      'en': 'Please set a price',
      'sw': '',
    },
    'jywpwhwc': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'l5yxz2eo': {
      'en': 'Description',
      'sw': '',
    },
    '1hnc3gmy': {
      'en': 'Product description',
      'sw': '',
    },
    '6m0gwfgp': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '1m8yxuyq': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    's6ua13dj': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '3cejtzy7': {
      'en': 'Trending',
      'sw': '',
    },
    '2wb3i03m': {
      'en': 'New Arrival',
      'sw': '',
    },
    'fcst6nqx': {
      'en': 'Show in All',
      'sw': '',
    },
    '1wdje28w': {
      'en': 'Post Now',
      'sw': '',
    },
    '8a7j3616': {
      'en': 'Home',
      'sw': '',
    },
  },
  // GymFitnes
  {
    '9qolg9vh': {
      'en': 'Sports',
      'sw': '',
    },
    '8fvixvos': {
      'en': 'Gym & Fitness',
      'sw': '',
    },
    '67miz0v8': {
      'en': 'Change',
      'sw': '',
    },
    '43k3axx2': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'xggr4m1w': {
      'en': 'Add Photo',
      'sw': '',
    },
    '0q5rfd99': {
      'en': 'COVER',
      'sw': '',
    },
    'xn2851bb': {
      'en': 'Product Name',
      'sw': '',
    },
    'dfnqwvls': {
      'en': 'Product Name',
      'sw': '',
    },
    'dlpx2a5d': {
      'en': 'Product Name',
      'sw': '',
    },
    '11dq80c4': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'n3n768lh': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'v759diuk': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'f0wo5yet': {
      'en': 'Product Collection',
      'sw': '',
    },
    'fkuw93al': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '8iwkk193': {
      'en': 'Gym & Fitness',
      'sw': '',
    },
    'l4wc6kfy': {
      'en': 'Brand New',
      'sw': '',
    },
    'fqv9l3nj': {
      'en': 'Like New',
      'sw': '',
    },
    'twymvm8l': {
      'en': 'Gently Used',
      'sw': '',
    },
    '8w7rlj12': {
      'en': 'Set Adress',
      'sw': '',
    },
    'igzidsev': {
      'en': 'location',
      'sw': '',
    },
    'b1dgfjjr': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '1i5wayi4': {
      'en': 'Contact information',
      'sw': '',
    },
    '8vgiv6au': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '3ygsx97f': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'zaxh6q3b': {
      'en': 'Call no',
      'sw': '',
    },
    'rak85d8w': {
      'en': 'Call no',
      'sw': '',
    },
    'l7yqdqok': {
      'en': 'Price',
      'sw': '',
    },
    '6o1j1lov': {
      'en': 'Price',
      'sw': '',
    },
    'uy8gmq8c': {
      'en': '0.00',
      'sw': '',
    },
    'mlcsukz1': {
      'en': 'Please set a price',
      'sw': '',
    },
    '24au4zze': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'oj3d68ip': {
      'en': 'Description',
      'sw': '',
    },
    'avl7xwu9': {
      'en': 'Product description',
      'sw': '',
    },
    't0uzndpi': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'csgr4699': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'i5j6cmlj': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'q1mz1q52': {
      'en': 'Trending',
      'sw': '',
    },
    'xnartac0': {
      'en': 'New Arrival',
      'sw': '',
    },
    '7tif68ju': {
      'en': 'Show in All',
      'sw': '',
    },
    's9j638kb': {
      'en': 'Post Now',
      'sw': '',
    },
    'ayqs7ajo': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Outdoors
  {
    '1b599fd3': {
      'en': 'Sports',
      'sw': '',
    },
    'dmt6pou6': {
      'en': 'Outdoor',
      'sw': '',
    },
    'v4f4j4p6': {
      'en': 'Change',
      'sw': '',
    },
    'm32ht4yy': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '45nfci1v': {
      'en': 'Add Photo',
      'sw': '',
    },
    '5ltakqnp': {
      'en': 'COVER',
      'sw': '',
    },
    'iw29nobg': {
      'en': 'Product Name',
      'sw': '',
    },
    '6hropz09': {
      'en': 'Product Name',
      'sw': '',
    },
    'fssx114h': {
      'en': 'Product Name',
      'sw': '',
    },
    'qxl57pn8': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '947qd628': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'r7z9cv4k': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'q2q933hk': {
      'en': 'Product Collection',
      'sw': '',
    },
    '9nidvttl': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'rr2w54sd': {
      'en': 'Outdoor',
      'sw': '',
    },
    'l29q138c': {
      'en': 'Brand New',
      'sw': '',
    },
    'nrx1uqj1': {
      'en': 'Like New',
      'sw': '',
    },
    'r236wu6r': {
      'en': 'Gently Used',
      'sw': '',
    },
    'p1stux0t': {
      'en': 'Set Adress',
      'sw': '',
    },
    'zcomgepd': {
      'en': 'location',
      'sw': '',
    },
    '0fy4zlre': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'd16fy505': {
      'en': 'Contact information',
      'sw': '',
    },
    'cl0itb33': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'nik42gtt': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'mfgvf1iv': {
      'en': 'Call no',
      'sw': '',
    },
    '5vf3kje1': {
      'en': 'Call no',
      'sw': '',
    },
    'i8umec6b': {
      'en': 'Price',
      'sw': '',
    },
    '03tegl8z': {
      'en': 'Price',
      'sw': '',
    },
    'zxap78l1': {
      'en': '0.00',
      'sw': '',
    },
    '2907pfsn': {
      'en': 'Please set a price',
      'sw': '',
    },
    'ysin6frp': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'gjn6opzd': {
      'en': 'Description',
      'sw': '',
    },
    'kkknutgo': {
      'en': 'Product description',
      'sw': '',
    },
    'p4540cov': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '2rnhdhht': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'poz2xci7': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'uei3yev1': {
      'en': 'Trending',
      'sw': '',
    },
    'trn16qh4': {
      'en': 'New Arrival',
      'sw': '',
    },
    '8xfitcc2': {
      'en': 'Show in All',
      'sw': '',
    },
    'yufwtcw5': {
      'en': 'Post Now',
      'sw': '',
    },
    '3ifflrfj': {
      'en': 'Home',
      'sw': '',
    },
  },
  // LuxuryWatche
  {
    'hri9jy23': {
      'en': 'Watches',
      'sw': '',
    },
    'qnizsxk3': {
      'en': 'Luxury Watches',
      'sw': '',
    },
    'z5d5yzw9': {
      'en': 'Change',
      'sw': '',
    },
    'ejm3pcs1': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'gjkebli4': {
      'en': 'Add Photo',
      'sw': '',
    },
    'a9ydm41t': {
      'en': 'COVER',
      'sw': '',
    },
    '1ex7p4yg': {
      'en': 'Product Name',
      'sw': '',
    },
    'y12482d1': {
      'en': 'Product Name',
      'sw': '',
    },
    '5ij8iqz1': {
      'en': 'Product Name',
      'sw': '',
    },
    'rbemlw3i': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '29754isb': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '1ifqhs8r': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'wwswq5lw': {
      'en': 'Product Collection',
      'sw': '',
    },
    'oqjhh8ti': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'bcos2h9p': {
      'en': 'Luxury Watches',
      'sw': '',
    },
    'wd0caz3x': {
      'en': 'Brand New',
      'sw': '',
    },
    '22j0y47l': {
      'en': 'Like New',
      'sw': '',
    },
    '4ao8n2kz': {
      'en': 'Gently Used',
      'sw': '',
    },
    '4ttnku69': {
      'en': 'Set Adress',
      'sw': '',
    },
    'py59x9di': {
      'en': 'location',
      'sw': '',
    },
    '81qyp1we': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '3rw5n1a7': {
      'en': 'Contact information',
      'sw': '',
    },
    'lm9ynt2j': {
      'en': 'WhatsApp',
      'sw': '',
    },
    's84oh4pl': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '2pa37670': {
      'en': 'Call no',
      'sw': '',
    },
    '823nfpbx': {
      'en': 'Call no',
      'sw': '',
    },
    '172zf7u7': {
      'en': 'Price',
      'sw': '',
    },
    'em4b5zof': {
      'en': 'Price',
      'sw': '',
    },
    'yzwx9m4k': {
      'en': '0.00',
      'sw': '',
    },
    'q5l5187y': {
      'en': 'Please set a price',
      'sw': '',
    },
    'qs5rnllq': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'o1xmgegb': {
      'en': 'Description',
      'sw': '',
    },
    '6cuzfnup': {
      'en': 'Product description',
      'sw': '',
    },
    '6wfzkzb9': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '9gmjy72k': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '8b150nmz': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '04tx0h2t': {
      'en': 'Trending',
      'sw': '',
    },
    'qyapuchi': {
      'en': 'New Arrival',
      'sw': '',
    },
    'e8i0lktz': {
      'en': 'Show in All',
      'sw': '',
    },
    'rhm90kpd': {
      'en': 'Post Now',
      'sw': '',
    },
    'fqowo0hn': {
      'en': 'Home',
      'sw': '',
    },
  },
  // DigitalWatche
  {
    'h0wbr08o': {
      'en': 'Watches',
      'sw': '',
    },
    'f3jdiuzp': {
      'en': 'Digital Watches',
      'sw': '',
    },
    'wafzzvpg': {
      'en': 'Change',
      'sw': '',
    },
    'heknjeic': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'myakc5yw': {
      'en': 'Add Photo',
      'sw': '',
    },
    'nxe3c1mh': {
      'en': 'COVER',
      'sw': '',
    },
    'sf9eo0iy': {
      'en': 'Product Name',
      'sw': '',
    },
    'adrl0cxa': {
      'en': 'Product Name',
      'sw': '',
    },
    'pjjdzmcj': {
      'en': 'Product Name',
      'sw': '',
    },
    '6syhjdqn': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'ams7g7nk': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'q5e5h1zd': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'x9fn2s8r': {
      'en': 'Product Collection',
      'sw': '',
    },
    'f8b3ps1d': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'tazzcjj2': {
      'en': 'Digital Watches',
      'sw': '',
    },
    'an7ol1eq': {
      'en': 'Brand New',
      'sw': '',
    },
    '0vcr3fie': {
      'en': 'Like New',
      'sw': '',
    },
    'chlhdwew': {
      'en': 'Gently Used',
      'sw': '',
    },
    'kfba1lz1': {
      'en': 'Set Adress',
      'sw': '',
    },
    'expaah4p': {
      'en': 'location',
      'sw': '',
    },
    'p0d34el7': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '6d7f4zwc': {
      'en': 'Contact information',
      'sw': '',
    },
    'rbxm0kbp': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'vx8yxvc0': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'bvlzuu1x': {
      'en': 'Call no',
      'sw': '',
    },
    'zlsrfvzs': {
      'en': 'Call no',
      'sw': '',
    },
    'itig1h3r': {
      'en': 'Price',
      'sw': '',
    },
    'fmj13dnc': {
      'en': 'Price',
      'sw': '',
    },
    'yie4t2zs': {
      'en': '0.00',
      'sw': '',
    },
    '099ku98k': {
      'en': 'Please set a price',
      'sw': '',
    },
    'jc29ee0d': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'wrufmky6': {
      'en': 'Description',
      'sw': '',
    },
    '7ibsgzjb': {
      'en': 'Product description',
      'sw': '',
    },
    'n7enup83': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'hjtw32d9': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'mm5qt192': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '2xt2wiol': {
      'en': 'Trending',
      'sw': '',
    },
    'k8czeu8d': {
      'en': 'New Arrival',
      'sw': '',
    },
    'aj9ws4u5': {
      'en': 'Show in All',
      'sw': '',
    },
    'zqv3mtwm': {
      'en': 'Post Now',
      'sw': '',
    },
    'da8ytn49': {
      'en': 'Home',
      'sw': '',
    },
  },
  // WallClock
  {
    'uee427w5': {
      'en': 'Watches',
      'sw': '',
    },
    'xc8ao2dz': {
      'en': 'Wall Clocks',
      'sw': '',
    },
    'exsodeqg': {
      'en': 'Change',
      'sw': '',
    },
    '56rk6a4o': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'yiw1relv': {
      'en': 'Add Photo',
      'sw': '',
    },
    'uw8d59vc': {
      'en': 'COVER',
      'sw': '',
    },
    'r61a5v5m': {
      'en': 'Product Name',
      'sw': '',
    },
    'y9z4y3gl': {
      'en': 'Product Name',
      'sw': '',
    },
    'u635sndc': {
      'en': 'Product Name',
      'sw': '',
    },
    'ufebhvoz': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'madchs2j': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'c18eoft5': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'uptsz954': {
      'en': 'Product Collection',
      'sw': '',
    },
    'rv31kq5p': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'f97igig3': {
      'en': 'Wall Clocks',
      'sw': '',
    },
    'luio1vl0': {
      'en': 'Brand New',
      'sw': '',
    },
    '1z8n2elj': {
      'en': 'Like New',
      'sw': '',
    },
    'vl3pxr41': {
      'en': 'Gently Used',
      'sw': '',
    },
    'kvrv78ha': {
      'en': 'Set Adress',
      'sw': '',
    },
    'uprcqgrr': {
      'en': 'location',
      'sw': '',
    },
    'i717x1em': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '25r3l94u': {
      'en': 'Contact information',
      'sw': '',
    },
    'i5wzmk76': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '11q7q9uf': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'fux7pxg8': {
      'en': 'Call no',
      'sw': '',
    },
    '84wo4ac8': {
      'en': 'Call no',
      'sw': '',
    },
    'nmpt8t29': {
      'en': 'Price',
      'sw': '',
    },
    'u7ugj5gg': {
      'en': 'Price',
      'sw': '',
    },
    'kybwfvia': {
      'en': '0.00',
      'sw': '',
    },
    'g9ih3xjy': {
      'en': 'Please set a price',
      'sw': '',
    },
    'dipxj1z1': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'v0u7gv0n': {
      'en': 'Description',
      'sw': '',
    },
    'a686ry6u': {
      'en': 'Product description',
      'sw': '',
    },
    '8efkl7t3': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'd5siyg6k': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'exzsw0u4': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'n4flvhmw': {
      'en': 'Trending',
      'sw': '',
    },
    'men52j7u': {
      'en': 'New Arrival',
      'sw': '',
    },
    '2swz8d7y': {
      'en': 'Show in All',
      'sw': '',
    },
    'pucota6f': {
      'en': 'Post Now',
      'sw': '',
    },
    'v8gauj6s': {
      'en': 'Home',
      'sw': '',
    },
  },
  // EducationalToy
  {
    'e27iy4fu': {
      'en': 'Toys',
      'sw': '',
    },
    '79p72bm6': {
      'en': 'Educational Toys',
      'sw': '',
    },
    'aiunl36a': {
      'en': 'Change',
      'sw': '',
    },
    'pwigxhh9': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '5iurzqht': {
      'en': 'Add Photo',
      'sw': '',
    },
    'yraxseys': {
      'en': 'COVER',
      'sw': '',
    },
    '3swpw8os': {
      'en': 'Product Name',
      'sw': '',
    },
    'ga418vad': {
      'en': 'Product Name',
      'sw': '',
    },
    'c9h970yd': {
      'en': 'Product Name',
      'sw': '',
    },
    'x3epjz66': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'le7y4x9l': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'j8s7md0r': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '339q0zzv': {
      'en': 'Product Collection',
      'sw': '',
    },
    'ic0kwr4x': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '10m1uqel': {
      'en': 'Educational Toys',
      'sw': '',
    },
    'kdow3bqo': {
      'en': 'Brand New',
      'sw': '',
    },
    '6qpb620y': {
      'en': 'Like New',
      'sw': '',
    },
    '3fscrkpu': {
      'en': 'Gently Used',
      'sw': '',
    },
    'aosx4sno': {
      'en': 'Set Adress',
      'sw': '',
    },
    'sbyjgxbd': {
      'en': 'location',
      'sw': '',
    },
    'etgr4ij5': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '4w1iojqe': {
      'en': 'Contact information',
      'sw': '',
    },
    'p0z6gqw0': {
      'en': 'WhatsApp',
      'sw': '',
    },
    '1vglmly4': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'ax5cp1ws': {
      'en': 'Call no',
      'sw': '',
    },
    'rm1rrc4p': {
      'en': 'Call no',
      'sw': '',
    },
    'ds3723qz': {
      'en': 'Price',
      'sw': '',
    },
    'ln9gw5h5': {
      'en': 'Price',
      'sw': '',
    },
    'cw3aqqk4': {
      'en': '0.00',
      'sw': '',
    },
    '2ywfxd6w': {
      'en': 'Please set a price',
      'sw': '',
    },
    'znwex2mf': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    't7g4sgs4': {
      'en': 'Description',
      'sw': '',
    },
    '3ffcxgxd': {
      'en': 'Product description',
      'sw': '',
    },
    '9aj8nlku': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '29tjl6pk': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'zkfrikgu': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'uqddmmxc': {
      'en': 'Trending',
      'sw': '',
    },
    'b3shmb8b': {
      'en': 'New Arrival',
      'sw': '',
    },
    '96bj5kjb': {
      'en': 'Show in All',
      'sw': '',
    },
    '4kff0q5c': {
      'en': 'Post Now',
      'sw': '',
    },
    'up6ivo94': {
      'en': 'Home',
      'sw': '',
    },
  },
  // BabyGears
  {
    'mdmxsss8': {
      'en': 'Toys',
      'sw': '',
    },
    'p688t9a2': {
      'en': 'Baby Gear',
      'sw': '',
    },
    '8yfnog8i': {
      'en': 'Change',
      'sw': '',
    },
    '9blemk9s': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'prhpef56': {
      'en': 'Add Photo',
      'sw': '',
    },
    '4i9r4nin': {
      'en': 'COVER',
      'sw': '',
    },
    'el8etj2c': {
      'en': 'Product Name',
      'sw': '',
    },
    'r00i9zlj': {
      'en': 'Product Name',
      'sw': '',
    },
    'c5oz0wmr': {
      'en': 'Product Name',
      'sw': '',
    },
    'zot2frae': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '1tws32oa': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '3p6jcn80': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '9wpse1ud': {
      'en': 'Product Collection',
      'sw': '',
    },
    '740qwbeu': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'epmmvwrr': {
      'en': 'Baby Gear',
      'sw': '',
    },
    'oakq4emk': {
      'en': 'Brand New',
      'sw': '',
    },
    'y19o6fio': {
      'en': 'Like New',
      'sw': '',
    },
    '8xslvk8c': {
      'en': 'Gently Used',
      'sw': '',
    },
    '19w4vsdw': {
      'en': 'Set Adress',
      'sw': '',
    },
    '3r1heo2n': {
      'en': 'location',
      'sw': '',
    },
    'w9pyzl2q': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'i14asnbv': {
      'en': 'Contact information',
      'sw': '',
    },
    '7vytgrps': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'j1kr5i2c': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '3x17dsn6': {
      'en': 'Call no',
      'sw': '',
    },
    '8sr2namy': {
      'en': 'Call no',
      'sw': '',
    },
    '8tuozodb': {
      'en': 'Price',
      'sw': '',
    },
    '4ozabppz': {
      'en': 'Price',
      'sw': '',
    },
    'xbex70ru': {
      'en': '0.00',
      'sw': '',
    },
    'mzcsr0av': {
      'en': 'Please set a price',
      'sw': '',
    },
    'gkuwfhal': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    're7rclyh': {
      'en': 'Description',
      'sw': '',
    },
    'o3np6t6o': {
      'en': 'Product description',
      'sw': '',
    },
    'uh3gkq7w': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'zewoje9v': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '9jn0fm1y': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'fnry96q2': {
      'en': 'Trending',
      'sw': '',
    },
    'mfjcdyc3': {
      'en': 'New Arrival',
      'sw': '',
    },
    'bu7deeiy': {
      'en': 'Show in All',
      'sw': '',
    },
    'a1ht2pta': {
      'en': 'Post Now',
      'sw': '',
    },
    '0ndutmq6': {
      'en': 'Home',
      'sw': '',
    },
  },
  // ElectronicToy
  {
    'cyxy0kde': {
      'en': 'Toys',
      'sw': '',
    },
    'l51pb8bu': {
      'en': 'Electronic Toys',
      'sw': '',
    },
    '1rznqc0m': {
      'en': 'Change',
      'sw': '',
    },
    'tdbwl456': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'ro3wzqac': {
      'en': 'Add Photo',
      'sw': '',
    },
    'im01w65z': {
      'en': 'COVER',
      'sw': '',
    },
    'zztebalg': {
      'en': 'Product Name',
      'sw': '',
    },
    '23fiplvd': {
      'en': 'Product Name',
      'sw': '',
    },
    'feh66i34': {
      'en': 'Product Name',
      'sw': '',
    },
    'z6id6u99': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'l5wpldez': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '1jely1o2': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '5af3h2fb': {
      'en': 'Product Collection',
      'sw': '',
    },
    'qm47hw57': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'x15uqvui': {
      'en': 'Electronic Toys',
      'sw': '',
    },
    'nwra4ll2': {
      'en': 'Brand New',
      'sw': '',
    },
    'l239z0la': {
      'en': 'Like New',
      'sw': '',
    },
    'yyzasbhc': {
      'en': 'Gently Used',
      'sw': '',
    },
    'lni9fze7': {
      'en': 'Set Adress',
      'sw': '',
    },
    'rpw9zuqe': {
      'en': 'location',
      'sw': '',
    },
    'vjmdv772': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'fmjyihqu': {
      'en': 'Contact information',
      'sw': '',
    },
    'r6tytkye': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'cfm7dy7i': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'g0boxj7f': {
      'en': 'Call no',
      'sw': '',
    },
    'nzmijkjz': {
      'en': 'Call no',
      'sw': '',
    },
    'emjgzhxz': {
      'en': 'Price',
      'sw': '',
    },
    'suo37qs0': {
      'en': 'Price',
      'sw': '',
    },
    '6eyhybwz': {
      'en': '0.00',
      'sw': '',
    },
    'ybptk6xv': {
      'en': 'Please set a price',
      'sw': '',
    },
    'uhz5xwef': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    's2y7pdov': {
      'en': 'Description',
      'sw': '',
    },
    't20ibxvc': {
      'en': 'Product description',
      'sw': '',
    },
    '2xwq32yv': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'qgcpmrhm': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'yh8s3o10': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '05ckc8zp': {
      'en': 'Trending',
      'sw': '',
    },
    'xdhs26qd': {
      'en': 'New Arrival',
      'sw': '',
    },
    'prh248hd': {
      'en': 'Show in All',
      'sw': '',
    },
    'u55kfptl': {
      'en': 'Post Now',
      'sw': '',
    },
    't5n2mhq8': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Supplement
  {
    'shekmwjl': {
      'en': 'Health',
      'sw': '',
    },
    'gyt5zif4': {
      'en': 'Supplements',
      'sw': '',
    },
    'tb2o3p3d': {
      'en': 'Change',
      'sw': '',
    },
    'ao4cmcvs': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'szomjrxx': {
      'en': 'Add Photo',
      'sw': '',
    },
    'nqmv4o54': {
      'en': 'COVER',
      'sw': '',
    },
    'r2kz3vy1': {
      'en': 'Product Name',
      'sw': '',
    },
    'bm112tw8': {
      'en': 'Product Name',
      'sw': '',
    },
    'i1cxu6e4': {
      'en': 'Product Name',
      'sw': '',
    },
    'zy8spfdu': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '3o8d9fip': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'tmtatmhm': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'si58b2sq': {
      'en': 'Product Collection',
      'sw': '',
    },
    '2ce4uyxn': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'nxofyqos': {
      'en': 'Supplements',
      'sw': '',
    },
    're5lj8wy': {
      'en': 'Brand New',
      'sw': '',
    },
    '9udkhvha': {
      'en': 'Like New',
      'sw': '',
    },
    'tnjp7klh': {
      'en': 'Gently Used',
      'sw': '',
    },
    '88g5ogyk': {
      'en': 'Set Adress',
      'sw': '',
    },
    'i56zu7j5': {
      'en': 'location',
      'sw': '',
    },
    'wgbak8ug': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'ew4gokfp': {
      'en': 'Contact information',
      'sw': '',
    },
    'jfs7oh29': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'ggai1fz5': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    '9c9j5b0z': {
      'en': 'Call no',
      'sw': '',
    },
    'x1r77ota': {
      'en': 'Call no',
      'sw': '',
    },
    'emre0kh4': {
      'en': 'Price',
      'sw': '',
    },
    '3vmybgzx': {
      'en': 'Price',
      'sw': '',
    },
    'cwy9872b': {
      'en': '0.00',
      'sw': '',
    },
    'lbv0attv': {
      'en': 'Please set a price',
      'sw': '',
    },
    'h7r58l5g': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'ymik8e2k': {
      'en': 'Description',
      'sw': '',
    },
    'thd030mg': {
      'en': 'Product description',
      'sw': '',
    },
    '0u3ezxpo': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'ma7ogrxg': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'lql8qev3': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '89znfm5w': {
      'en': 'Trending',
      'sw': '',
    },
    '9cczt323': {
      'en': 'New Arrival',
      'sw': '',
    },
    't346hj96': {
      'en': 'Show in All',
      'sw': '',
    },
    'qpro4z9e': {
      'en': 'Post Now',
      'sw': '',
    },
    'uedbugg9': {
      'en': 'Home',
      'sw': '',
    },
  },
  // MedicalEquipment
  {
    'hv2tokki': {
      'en': 'Health',
      'sw': '',
    },
    'c0jkmby6': {
      'en': 'Medical Equipment',
      'sw': '',
    },
    '4htui5ry': {
      'en': 'Change',
      'sw': '',
    },
    'y9nbrixv': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'ce7ch40g': {
      'en': 'Add Photo',
      'sw': '',
    },
    'mxg4xvii': {
      'en': 'COVER',
      'sw': '',
    },
    '2iflx6f1': {
      'en': 'Product Name',
      'sw': '',
    },
    'ep6b46hd': {
      'en': 'Product Name',
      'sw': '',
    },
    'cmdjfwt7': {
      'en': 'Product Name',
      'sw': '',
    },
    '63ycuibx': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'uzmsby3x': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'itilv0ej': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'hd9wpe6d': {
      'en': 'Product Collection',
      'sw': '',
    },
    'srnahayo': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'u2uif1qc': {
      'en': 'Medical Equipment',
      'sw': '',
    },
    'lzjzcs00': {
      'en': 'Brand New',
      'sw': '',
    },
    'tscm3fbr': {
      'en': 'Like New',
      'sw': '',
    },
    'wt4gso50': {
      'en': 'Gently Used',
      'sw': '',
    },
    'l9kp06gc': {
      'en': 'Set Adress',
      'sw': '',
    },
    'zd2mspnr': {
      'en': 'location',
      'sw': '',
    },
    'h5t03eqv': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'tive02ig': {
      'en': 'Contact information',
      'sw': '',
    },
    'm6g00msq': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'xjbhduf7': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'v7ttitxc': {
      'en': 'Call no',
      'sw': '',
    },
    'jfvpighh': {
      'en': 'Call no',
      'sw': '',
    },
    'op4r2jtc': {
      'en': 'Price',
      'sw': '',
    },
    'bz049uhy': {
      'en': 'Price',
      'sw': '',
    },
    'ubdmap88': {
      'en': '0.00',
      'sw': '',
    },
    'the9165v': {
      'en': 'Please set a price',
      'sw': '',
    },
    'mud9q1rp': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'slyieohl': {
      'en': 'Description',
      'sw': '',
    },
    't80x632t': {
      'en': 'Product description',
      'sw': '',
    },
    'qsqjwmqt': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'dty5tjyl': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'qjmk7gdb': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'jmwi7t0l': {
      'en': 'Trending',
      'sw': '',
    },
    'mq6hoaxz': {
      'en': 'New Arrival',
      'sw': '',
    },
    'u5iyxxc6': {
      'en': 'Show in All',
      'sw': '',
    },
    'jyqq01x3': {
      'en': 'Post Now',
      'sw': '',
    },
    'ld5o5uq2': {
      'en': 'Home',
      'sw': '',
    },
  },
  // PersonalHygienes
  {
    'o71d6wey': {
      'en': 'Health',
      'sw': '',
    },
    'q4xr2w92': {
      'en': 'Personal Hygienes',
      'sw': '',
    },
    '1mzb0xna': {
      'en': 'Change',
      'sw': '',
    },
    '768b2ytk': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'zcx63zv3': {
      'en': 'Add Photo',
      'sw': '',
    },
    'mclcv5y7': {
      'en': 'COVER',
      'sw': '',
    },
    '3labadja': {
      'en': 'Product Name',
      'sw': '',
    },
    'e7ifqpy5': {
      'en': 'Product Name',
      'sw': '',
    },
    'p51rcczj': {
      'en': 'Product Name',
      'sw': '',
    },
    't8xxmhh5': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'uzzmtbao': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    '6k8fpeun': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'wisonf7d': {
      'en': 'Product Collection',
      'sw': '',
    },
    '32kci33a': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'k00a64db': {
      'en': 'Personal Hygienes',
      'sw': '',
    },
    'ijvqx17h': {
      'en': 'Brand New',
      'sw': '',
    },
    'e2x82ivq': {
      'en': 'Like New',
      'sw': '',
    },
    'x3h18xzj': {
      'en': 'Gently Used',
      'sw': '',
    },
    '5sj1xli3': {
      'en': 'Set Adress',
      'sw': '',
    },
    'fylgi4tw': {
      'en': 'location',
      'sw': '',
    },
    'q9om7cay': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'rr4fflbb': {
      'en': 'Contact information',
      'sw': '',
    },
    'o2cnp4a7': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'wn6bsj4k': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'zw4br45s': {
      'en': 'Call no',
      'sw': '',
    },
    '19rh9e03': {
      'en': 'Call no',
      'sw': '',
    },
    'kobamh4r': {
      'en': 'Price',
      'sw': '',
    },
    'gf2sxe1n': {
      'en': 'Price',
      'sw': '',
    },
    'yys2yauk': {
      'en': '0.00',
      'sw': '',
    },
    '4iv4bqw1': {
      'en': 'Please set a price',
      'sw': '',
    },
    '5z3jxlm5': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '9dacpk2w': {
      'en': 'Description',
      'sw': '',
    },
    'veee1y45': {
      'en': 'Product description',
      'sw': '',
    },
    '25curps6': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '9k2alvji': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'dwv1vbfd': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'spw496ks': {
      'en': 'Trending',
      'sw': '',
    },
    '4c1y10zm': {
      'en': 'New Arrival',
      'sw': '',
    },
    'bi7gla0j': {
      'en': 'Show in All',
      'sw': '',
    },
    'bu414348': {
      'en': 'Post Now',
      'sw': '',
    },
    'm4yekb94': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Stationerys
  {
    'th5hjet0': {
      'en': 'Offices',
      'sw': '',
    },
    'gdqxfzbz': {
      'en': 'Stationery',
      'sw': '',
    },
    'r5y0sdg2': {
      'en': 'Change',
      'sw': '',
    },
    'k1c1x85p': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'oiluicic': {
      'en': 'Add Photo',
      'sw': '',
    },
    'wk4d5s7g': {
      'en': 'COVER',
      'sw': '',
    },
    'd74nnwcc': {
      'en': 'Product Name',
      'sw': '',
    },
    'ybk2eweq': {
      'en': 'Product Name',
      'sw': '',
    },
    '24exemii': {
      'en': 'Product Name',
      'sw': '',
    },
    'f5hze7pl': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'v8x4e5x7': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'dsyqb0wk': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'fbk5swzp': {
      'en': 'Product Collection',
      'sw': '',
    },
    'mgauj1pc': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'v3t71iee': {
      'en': 'Stationery',
      'sw': '',
    },
    'udvtjvw0': {
      'en': 'Brand New',
      'sw': '',
    },
    '5ll42m9a': {
      'en': 'Like New',
      'sw': '',
    },
    'rpq10rk3': {
      'en': 'Gently Used',
      'sw': '',
    },
    'o0hc7hj8': {
      'en': 'Set Adress',
      'sw': '',
    },
    'ar4loacx': {
      'en': 'location',
      'sw': '',
    },
    'g3qbippb': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'tnn3blc9': {
      'en': 'Contact information',
      'sw': '',
    },
    'gpi9etkj': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'kuuzbm86': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'hdpivpp8': {
      'en': 'Call no',
      'sw': '',
    },
    '7x3g3bix': {
      'en': 'Call no',
      'sw': '',
    },
    '1b180rso': {
      'en': 'Price',
      'sw': '',
    },
    'l3sf6fki': {
      'en': 'Price',
      'sw': '',
    },
    '818mspu3': {
      'en': '0.00',
      'sw': '',
    },
    'cjge36rl': {
      'en': 'Please set a price',
      'sw': '',
    },
    '670j8mql': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '0wf2flb3': {
      'en': 'Description',
      'sw': '',
    },
    'lf0jmmi0': {
      'en': 'Product description',
      'sw': '',
    },
    'v7o7hovo': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'yjp99g22': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    '6ykaowr3': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'o1m9hc64': {
      'en': 'Trending',
      'sw': '',
    },
    'jz57kme4': {
      'en': 'New Arrival',
      'sw': '',
    },
    'zywlcw1u': {
      'en': 'Show in All',
      'sw': '',
    },
    '4s2uvgzl': {
      'en': 'Post Now',
      'sw': '',
    },
    'dpiat50o': {
      'en': 'Home',
      'sw': '',
    },
  },
  // OfficeTechs
  {
    'zmz0oszt': {
      'en': 'Offices',
      'sw': '',
    },
    '6h85ireg': {
      'en': 'Office Tech',
      'sw': '',
    },
    '1gnoufui': {
      'en': 'Change',
      'sw': '',
    },
    '97jcu67z': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '1y632704': {
      'en': 'Add Photo',
      'sw': '',
    },
    'sgnly2sv': {
      'en': 'COVER',
      'sw': '',
    },
    'o7xbkklc': {
      'en': 'Product Name',
      'sw': '',
    },
    'gc82wz1a': {
      'en': 'Product Name',
      'sw': '',
    },
    'qfky5bfm': {
      'en': 'Product Name',
      'sw': '',
    },
    'o5xt4axj': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'lf86xu7x': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'ue76mxvh': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '8t0brpi3': {
      'en': 'Product Collection',
      'sw': '',
    },
    's13gpiy9': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'bzbmw32x': {
      'en': 'Office Tech',
      'sw': '',
    },
    'nyxs7wv8': {
      'en': 'Brand New',
      'sw': '',
    },
    'u6ae5qaf': {
      'en': 'Like New',
      'sw': '',
    },
    'x7pxyr8c': {
      'en': 'Gently Used',
      'sw': '',
    },
    'dm5xzwy0': {
      'en': 'Set Adress',
      'sw': '',
    },
    'ptl6fhsh': {
      'en': 'location',
      'sw': '',
    },
    'xqjna982': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    '27t4ao5e': {
      'en': 'Contact information',
      'sw': '',
    },
    '3z4gxxn4': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'r0lne52d': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'obtlnuqz': {
      'en': 'Call no',
      'sw': '',
    },
    'fg1wgyyv': {
      'en': 'Call no',
      'sw': '',
    },
    '67107n7o': {
      'en': 'Price',
      'sw': '',
    },
    'pc6q0yhk': {
      'en': 'Price',
      'sw': '',
    },
    'cea1ht2r': {
      'en': '0.00',
      'sw': '',
    },
    '0032htu3': {
      'en': 'Please set a price',
      'sw': '',
    },
    'hserwfvu': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'ejz8gham': {
      'en': 'Description',
      'sw': '',
    },
    '0hmfxhxu': {
      'en': 'Product description',
      'sw': '',
    },
    'q12dlf4o': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    '0s723xvy': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'trkoanza': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'slzahw5w': {
      'en': 'Trending',
      'sw': '',
    },
    'zcpj7naz': {
      'en': 'New Arrival',
      'sw': '',
    },
    '9k925jzu': {
      'en': 'Show in All',
      'sw': '',
    },
    'xp2bsmfw': {
      'en': 'Post Now',
      'sw': '',
    },
    'vek79x5h': {
      'en': 'Home',
      'sw': '',
    },
  },
  // Organizations
  {
    'qez2udws': {
      'en': 'Offices',
      'sw': '',
    },
    'gjc81qzp': {
      'en': 'Organization',
      'sw': '',
    },
    'mwpw5hsh': {
      'en': 'Change',
      'sw': '',
    },
    'i5nch4iu': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    '1kwjmcid': {
      'en': 'Add Photo',
      'sw': '',
    },
    '0r0jqv34': {
      'en': 'COVER',
      'sw': '',
    },
    'nmkumuk3': {
      'en': 'Product Name',
      'sw': '',
    },
    'w14xce3h': {
      'en': 'Product Name',
      'sw': '',
    },
    'pb5tf2si': {
      'en': 'Product Name',
      'sw': '',
    },
    '1fbbxj5m': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    'wnm2j9uy': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'sxn7x2ez': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'aqqzevq9': {
      'en': 'Product Collection',
      'sw': '',
    },
    '1t0shmpe': {
      'en': 'ProductCollection',
      'sw': '',
    },
    '35m637jb': {
      'en': 'Organization',
      'sw': '',
    },
    'd4yf4ozt': {
      'en': 'Brand New',
      'sw': '',
    },
    '1ume4wxp': {
      'en': 'Like New',
      'sw': '',
    },
    'd0379b3q': {
      'en': 'Gently Used',
      'sw': '',
    },
    'itdup9no': {
      'en': 'Set Adress',
      'sw': '',
    },
    'ay3qf68s': {
      'en': 'location',
      'sw': '',
    },
    'r6cz4c74': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'dmqhi2f0': {
      'en': 'Contact information',
      'sw': '',
    },
    'y41sfugo': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'y5cvzf8r': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'dr3lmpqe': {
      'en': 'Call no',
      'sw': '',
    },
    'sx8hj3dh': {
      'en': 'Call no',
      'sw': '',
    },
    'draq08mb': {
      'en': 'Price',
      'sw': '',
    },
    'duhok69i': {
      'en': 'Price',
      'sw': '',
    },
    'p9l3eqdr': {
      'en': '0.00',
      'sw': '',
    },
    'byi5njmq': {
      'en': 'Please set a price',
      'sw': '',
    },
    'me9nqc12': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    's7i8gr46': {
      'en': 'Description',
      'sw': '',
    },
    'whsxoyws': {
      'en': 'Product description',
      'sw': '',
    },
    'k1b6ub4q': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'z6ar078i': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'ivg2d9oe': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    '5qz0x0sf': {
      'en': 'Trending',
      'sw': '',
    },
    'on7a5q5o': {
      'en': 'New Arrival',
      'sw': '',
    },
    'tg3l1q7v': {
      'en': 'Show in All',
      'sw': '',
    },
    '9lnc2vtr': {
      'en': 'Post Now',
      'sw': '',
    },
    '8monwnid': {
      'en': 'Home',
      'sw': '',
    },
  },
  // EditMode
  {
    'gjmsso64': {
      'en': 'Edit  Product',
      'sw': '',
    },
    'jb5kvcdc': {
      'en': 'Upload up to 10 images of your product',
      'sw': '',
    },
    'a5zsbtqy': {
      'en': 'Add Photo',
      'sw': '',
    },
    'qqicz47x': {
      'en': 'COVER',
      'sw': '',
    },
    'l5axxpcf': {
      'en': 'Product Name',
      'sw': '',
    },
    'l6sfc9hx': {
      'en': 'Product Name',
      'sw': '',
    },
    'rpntjed0': {
      'en': 'Product Name',
      'sw': '',
    },
    'zocg5qce': {
      'en': 'Please enter a product name',
      'sw': '',
    },
    '0kgtzquz': {
      'en': 'Name is too long. Use 60 characters or less',
      'sw': '',
    },
    'm6gu3mh6': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'eglxl840': {
      'en': 'Product Collection',
      'sw': '',
    },
    '2uepgku5': {
      'en': 'ProductCollection',
      'sw': '',
    },
    'kn2y9mq2': {
      'en': 'Like New',
      'sw': '',
    },
    '80fnlz66': {
      'en': 'Gently Used',
      'sw': '',
    },
    'fmf6c6x5': {
      'en': 'Set Adress',
      'sw': '',
    },
    'at9dr5ih': {
      'en': 'location',
      'sw': '',
    },
    'hnk0m68w': {
      'en': 'Enter your Location',
      'sw': 'WhatsApp',
    },
    'qh52snmz': {
      'en': 'Contact information',
      'sw': '',
    },
    'kv1kxzt6': {
      'en': 'WhatsApp',
      'sw': '',
    },
    'ys1xbdxb': {
      'en': 'WhatsApp',
      'sw': 'WhatsApp',
    },
    'ad1ql92m': {
      'en': 'Call no',
      'sw': '',
    },
    'bg04ujnc': {
      'en': 'Call no',
      'sw': '',
    },
    '7dzpt425': {
      'en': 'Price',
      'sw': '',
    },
    'ojh3tf8b': {
      'en': 'Price',
      'sw': '',
    },
    'ng9k68b0': {
      'en': '0.00',
      'sw': '',
    },
    'oyxv9olm': {
      'en': 'Please set a price',
      'sw': '',
    },
    'mpgalc5s': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    'x3hxcq1p': {
      'en': 'Description',
      'sw': '',
    },
    '9uliyxuk': {
      'en': 'Product description',
      'sw': '',
    },
    'o4b0waol': {
      'en': 'Describe your product... (e.g., size, material, condition)',
      'sw': '',
    },
    'bfdswvfi': {
      'en': 'Please provide a description of the item.',
      'sw': '',
    },
    'p905jshj': {
      'en': 'Please choose an option from the dropdown',
      'sw': '',
    },
    't0c8twoq': {
      'en': 'Trending',
      'sw': '',
    },
    'r6l3xa49': {
      'en': 'New Arrival',
      'sw': '',
    },
    '86bdhxei': {
      'en': 'Show in All',
      'sw': '',
    },
    'qszstowa': {
      'en': 'Save Changes',
      'sw': '',
    },
    'fm3hig9h': {
      'en': 'Home',
      'sw': '',
    },
  },
  // RatePage
  {
    'fbepfn06': {
      'en': 'Rate your experience',
      'sw': '',
    },
    'uqdj7yj8': {
      'en': 'Your feedback helps us improve',
      'sw': '',
    },
    'i5l1y95s': {
      'en': 'How would you rate us?',
      'sw': '',
    },
    'fx898h7m': {
      'en': 'Terrible',
      'sw': '',
    },
    'c3vmj98h': {
      'en': 'Amazing',
      'sw': '',
    },
    '55bdpn6x': {
      'en': 'Good',
      'sw': '',
    },
    'cw8kdgy3': {
      'en': 'Write a review',
      'sw': '',
    },
    'qjrqy0w5': {
      'en': 'Tell us what you think... (optional)',
      'sw': '',
    },
    '0ezkrqmc': {
      'en': 'Quick tags',
      'sw': '',
    },
    'hdgfsci0': {
      'en': 'Easy to use',
      'sw': '',
    },
    'rixzzn9p': {
      'en': 'Great design',
      'sw': '',
    },
    'lgdgurzb': {
      'en': 'Fast & reliable',
      'sw': '',
    },
    'rw2jdeuw': {
      'en': 'Needs work',
      'sw': '',
    },
    'w58nseuj': {
      'en': 'Love it!',
      'sw': '',
    },
    'fgjh87ip': {
      'en': 'Review details',
      'sw': '',
    },
    'vk1n6b58': {
      'en': 'App version',
      'sw': '',
    },
    '9jxorn4o': {
      'en': 'v2.4.1',
      'sw': '',
    },
    '5atk64vj': {
      'en': 'Source',
      'sw': '',
    },
    'uvv18r2d': {
      'en': 'Post-purchase',
      'sw': '',
    },
    '2xh7lsry': {
      'en': 'Submitted',
      'sw': '',
    },
    'kk4fu9nn': {
      'en': 'Today',
      'sw': '',
    },
    '53y2thsx': {
      'en': 'Submit Review',
      'sw': '',
    },
    '7yfvum0m': {
      'en': 'Your review is private and secure',
      'sw': '',
    },
  },
  // wishlistPrefe
  {
    '39n9pgp0': {
      'en': 'My Wishlist',
      'sw': '',
    },
    'wfoakg6c': {
      'en': 'Search your wishlist...',
      'sw': '',
    },
    '4m49hqpg': {
      'en': 'Saved Items  ',
      'sw': '',
    },
    '33oe2d06': {
      'en': '12',
      'sw': '',
    },
    's8s5lonq': {
      'en': 'NEW',
      'sw': '',
    },
  },
  // sortbyGender
  {
    'vrrrfkkl': {
      'en': 'Futa',
      'sw': '',
    },
    'b4eyn101': {
      'en': 'Jinsia',
      'sw': '',
    },
    '5op4tfpc': {
      'en': 'Wanaume',
      'sw': '',
    },
    'lxs5svpz': {
      'en': 'Wanawake',
      'sw': '',
    },
    'x7pdnblr': {
      'en': 'Watoto',
      'sw': '',
    },
  },
  // sortbyPrice
  {
    '2zvmk83o': {
      'en': 'Futa',
      'sw': '',
    },
    'asxwgohm': {
      'en': 'Bei',
      'sw': '',
    },
    'q6ej49kw': {
      'en': 'Ndogo',
      'sw': '',
    },
    '5mgjm2gu': {
      'en': 'Kubwa',
      'sw': '',
    },
  },
  // sortbyColour
  {
    '9kw7yhh4': {
      'en': 'Rangi',
      'sw': '',
    },
    'kqzzfwww': {
      'en': 'Nyeupe',
      'sw': '',
    },
    'rpchgaui': {
      'en': 'Orengi',
      'sw': '',
    },
    'm9nhzrp0': {
      'en': 'Nyeusi',
      'sw': '',
    },
    'f5ir0x14': {
      'en': 'Nyekundu',
      'sw': '',
    },
    '2hzt2se9': {
      'en': 'Kijani',
      'sw': '',
    },
    '7pv5ag2w': {
      'en': 'Bluu',
      'sw': '',
    },
    '7tkn8zsk': {
      'en': 'Njano',
      'sw': '',
    },
    'nhdnxp9g': {
      'en': 'Kijivu',
      'sw': '',
    },
    'eyh2y7tc': {
      'en': 'Bluu bahri',
      'sw': '',
    },
    'zi9oje47': {
      'en': 'Kijani kibichi',
      'sw': '',
    },
    'puanm1u0': {
      'en': 'Dhahabu',
      'sw': '',
    },
  },
  // sortbySize
  {
    '1hu0j45g': {
      'en': 'Saizi',
      'sw': '',
    },
    '8zuhp553': {
      'en': 'XS',
      'sw': '',
    },
    'kk9gs3ws': {
      'en': 'S',
      'sw': '',
    },
    'tq6ob2ey': {
      'en': 'M',
      'sw': '',
    },
    'xcg5n24d': {
      'en': 'L',
      'sw': '',
    },
    '1i917eba': {
      'en': 'XL',
      'sw': '',
    },
    'kxzwqi3o': {
      'en': 'XXL',
      'sw': '',
    },
    'p4m8bwej': {
      'en': 'XXXL',
      'sw': '',
    },
  },
  // ordersuccessfulpopul
  {
    'gzmq154n': {
      'en': 'Agizo limefanikiwa',
      'sw': '',
    },
    '6lu4py2n': {
      'en': 'Utapokeye  email ya uthibitisho ',
      'sw': '',
    },
    '7ggejuc1': {
      'en': 'Angaliya maelezo ya agizo',
      'sw': '',
    },
  },
  // hometop_nav
  {
    '6rm50yly': {
      'en': 'ZanNext',
      'sw': '',
    },
    'kj7n21vl': {
      'en': 'Notifications',
      'sw': '',
    },
  },
  // uploadphoto
  {
    '4cp2zf7s': {
      'en': 'Badilisha picha',
      'sw': '',
    },
    '6fsv0no9': {
      'en': 'Pakia picha mpya hapa chini ili ubadilishe picha yako ya wasifu',
      'sw': '',
    },
    '0d9x5ecp': {
      'en': 'Chagua Picha',
      'sw': '',
    },
    '7zxtv6dh': {
      'en': 'Hifadhi Mabadiliko',
      'sw': '',
    },
  },
  // Search_bar
  {
    '00auhf46': {
      'en': 'tafuta bidhaa...',
      'sw': '',
    },
  },
  // pymentgateways
  {
    '9ivcc85l': {
      'en': 'Futa',
      'sw': '',
    },
    '098o5g8d': {
      'en': 'Ofa',
      'sw': '',
    },
    '1kchrhol': {
      'en': 'Lipa kwa Benki',
      'sw': '',
    },
    'n69vj8vd': {
      'en': 'Lipa kwa Simu',
      'sw': '',
    },
  },
  // deletepromt
  {
    'cmo5i8ba': {
      'en': 'Je, una uhakika unataka kufuta hiki?',
      'sw': '',
    },
    'dxhj9286': {
      'en': 'Bonyeza chaguo hapa chini ili kuthibitisha:\n\n',
      'sw': '',
    },
    'gpgu6s72': {
      'en': 'Futa\n\n',
      'sw': '',
    },
    'd75c8p58': {
      'en': 'Ghairi\n\n',
      'sw': '',
    },
  },
  // preoductBottomNav
  {
    '5l7pe1b2': {
      'en': 'Wasiliana na Muuzaji',
      'sw': '',
    },
  },
  // Logout
  {
    's1u9nzso': {
      'en': 'Logout',
      'sw': '',
    },
    'x87ebcmq': {
      'en': 'Confirm Logout',
      'sw': '',
    },
    'xzaqys25': {
      'en': 'Are you sure you want to log out?',
      'sw': '',
    },
    'sw0n4m4d': {
      'en': 'Cancel',
      'sw': '',
    },
    '43mvvsoj': {
      'en': 'Logout',
      'sw': '',
    },
  },
  // LanguageModal
  {
    'kiz57wcm': {
      'en': 'Choose your language',
      'sw': '',
    },
    'clilj302': {
      'en': 'Select your preferred language',
      'sw': '',
    },
    'j5j1szgg': {
      'en': 'Swahili',
      'sw': '',
    },
    'zq6bq946': {
      'en': 'English',
      'sw': '',
    },
    'de7ci7a7': {
      'en': 'Change Language',
      'sw': '',
    },
  },
  // locationModal
  {
    '6bamx18g': {
      'en': 'Choose Location',
      'sw': '',
    },
    'vjaq3kgd': {
      'en': 'Select your city to check service, then add delivery details',
      'sw': '',
    },
    'eqgl6z70': {
      'en': 'Badili',
      'sw': '',
    },
    '51cgfklk': {
      'en': 'Delivery Address',
      'sw': '',
    },
    '0zohb913': {
      'en': 'See all',
      'sw': '',
    },
    'vun638xl': {
      'en': 'Add Another Address',
      'sw': '',
    },
  },
  // shareModel
  {
    'vckorsi9': {
      'en': 'Share',
      'sw': '',
    },
    'mekcvuae': {
      'en': 'Recent people',
      'sw': '',
    },
    'p7mdtu79': {
      'en': 'Ibrahim Talib',
      'sw': '',
    },
    '7ufab5dh': {
      'en': 'Social media',
      'sw': '',
    },
    '5n5onr35': {
      'en': 'Whatsapp',
      'sw': '',
    },
    'bffe8eus': {
      'en': 'Telegram',
      'sw': '',
    },
    '1g2v3rh2': {
      'en': 'Instagram',
      'sw': '',
    },
    'dkwt6bth': {
      'en': 'TikTok',
      'sw': '',
    },
    'wm1rhi15': {
      'en': 'Facebook',
      'sw': '',
    },
    'bbfvlj9h': {
      'en': 'Email',
      'sw': '',
    },
    '7d0if1th': {
      'en': 'Cancel',
      'sw': '',
    },
    's0zmwjg5': {
      'en': 'Share',
      'sw': '',
    },
  },
  // Miscellaneous
  {
    'tap2gxpq': {
      'en':
          'In order to take a picture or video, this app requires permission to access the camera.',
      'sw':
          'Ili uweze kupiga picha au video, app hii inahitaji ruhusa ya kutumia kamera yako.',
    },
    'vkujb8xs': {
      'en':
          'In order to upload data, this app requires permission to access the photo library.',
      'sw':
          'Ili uweze kupakia picha, app hii inahitaji ruhusa ya kufungua maktaba yako ya picha.',
    },
    'mlm3vtt7': {
      'en': 'Error',
      'sw': 'Kosa',
    },
    '0uvrpaz8': {
      'en': 'Password reset email sent!',
      'sw': 'Barua pepe ya kubadili nenosiri imetumwa!',
    },
    'xqhu0p8m': {
      'en': 'Email is required!',
      'sw': 'Barua pepe inahitajika!',
    },
    'ccryfzwu': {
      'en': 'Phone number must start with +',
      'sw': 'Namba ya simu ianze na +.',
    },
    'q8gzvnl0': {
      'en': 'Passwords do not match.',
      'sw': 'Nenosiri hazifanani.',
    },
    'm9uegfe6': {
      'en': 'Enter SMS verification code.',
      'sw': 'Weka kodi uliyotumiwa (SMS).',
    },
    'nxs9e1vz': {
      'en':
          'Too long since most recent sign in. Sign in again before deleting your account.',
      'sw':
          'Umekaa muda mrefu tangu uingie. Tafadhali ingia tena ili uweze kufuta akaunti yako.',
    },
    'swiobtu7': {
      'en':
          'Too long since most recent sign in. Sign in again before updating your email.',
      'sw':
          'Umekaa muda mrefu tangu uingie. Tafadhali ingia tena ili uweze kubadili barua pepe yako.',
    },
    'bk2ta6ip': {
      'en': 'Email change confirmation sent!',
      'sw': 'Ombi la kubadili barua pepe limetumwa!',
    },
    'd48yxrpw': {
      'en': 'Email already in use by another account',
      'sw': 'Barua pepe tayari inatumiwa',
    },
    '4v0p03m5': {
      'en': 'The supplied info is incorrect',
      'sw': 'Maelezo uliyoweka si sahihi',
    },
    'gz2oodn7': {
      'en': 'Invalid file format.',
      'sw': 'Aina ya faili haikubaliwi.',
    },
    '4mnpfykk': {
      'en': 'Uploading file...',
      'sw': 'Inapakia faili...',
    },
    '2phagxy6': {
      'en': 'Success!',
      'sw': 'Imefanikiwa!',
    },
    'xhsw1j1r': {
      'en': 'Failed to upload data.',
      'sw': 'Imeshindwa kupakia data.',
    },
    '11cnpd9w': {
      'en': '',
      'sw': '',
    },
    '0uv7rmp6': {
      'en': 'Choose Source',
      'sw': 'Chagua chanzo cha picha',
    },
    'zxc99uey': {
      'en': 'Gallery',
      'sw': 'Picha (Gallery)',
    },
    'ffblm5j6': {
      'en': 'Gallery (Photo)',
      'sw': 'Picha (Photo)',
    },
    '101m935e': {
      'en': '',
      'sw': '',
    },
    'kqjopq6x': {
      'en': 'Camera',
      'sw': 'Kamera',
    },
    'puuveaqa': {
      'en': '',
      'sw': '',
    },
    'blx8slw2': {
      'en': '',
      'sw': '',
    },
    '44tjxjvh': {
      'en': '',
      'sw': '',
    },
    'p328gvi4': {
      'en': 'Error: [error]',
      'sw': 'Kosa: [error]',
    },
  },
].reduce((a, b) => a..addAll(b));
