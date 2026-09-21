import 'dart:async';

import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _emailsignin = prefs.getString('ff_emailsignin') ?? _emailsignin;
    });
    _safeInit(() {
      _clotheType = prefs.getString('ff_clotheType') ?? _clotheType;
    });
    _safeInit(() {
      _totalPrice = prefs.getDouble('ff_totalPrice') ?? _totalPrice;
    });
    _safeInit(() {
      _grandTotal = prefs.getDouble('ff_grandTotal') ?? _grandTotal;
    });
    _safeInit(() {
      _totalitems = prefs.getInt('ff_totalitems') ?? _totalitems;
    });
    _safeInit(() {
      _phoneNumber = prefs.getString('ff_phoneNumber') ?? _phoneNumber;
    });
    _safeInit(() {
      _categories = prefs.getString('ff_categories') ?? _categories;
    });
    _safeInit(() {
      _showProductCard =
          prefs.getBool('ff_showProductCard') ?? _showProductCard;
    });
    _safeInit(() {
      _hasReviewedThisVersion =
          prefs.getBool('ff_hasReviewedThisVersion') ?? _hasReviewedThisVersion;
    });
    _safeInit(() {
      _notificationSeen =
          prefs.getBool('ff_notificationSeen') ?? _notificationSeen;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _emailsignin = '';
  String get emailsignin => _emailsignin;
  set emailsignin(String value) {
    _emailsignin = value;
    prefs.setString('ff_emailsignin', value);
    notifyListeners();
  }

  bool _isSearched = false;
  bool get isSearched => _isSearched;
  set isSearched(bool value) {
    _isSearched = value;
    notifyListeners();
  }

  bool _home = false;
  bool get home => _home;
  set home(bool value) {
    _home = value;
    notifyListeners();
  }

  bool _notifications = false;
  bool get notifications => _notifications;
  set notifications(bool value) {
    _notifications = value;
    notifyListeners();
  }

  bool _orders = false;
  bool get orders => _orders;
  set orders(bool value) {
    _orders = value;
    notifyListeners();
  }

  bool _profile = false;
  bool get profile => _profile;
  set profile(bool value) {
    _profile = value;
    notifyListeners();
  }

  String _clotheType = '';
  String get clotheType => _clotheType;
  set clotheType(String value) {
    _clotheType = value;
    prefs.setString('ff_clotheType', value);
    notifyListeners();
  }

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;
  set totalPrice(double value) {
    _totalPrice = value;
    prefs.setDouble('ff_totalPrice', value);
    notifyListeners();
  }

  double _grandTotal = 0.0;
  double get grandTotal => _grandTotal;
  set grandTotal(double value) {
    _grandTotal = value;
    prefs.setDouble('ff_grandTotal', value);
    notifyListeners();
  }

  int _totalitems = 0;
  int get totalitems => _totalitems;
  set totalitems(int value) {
    _totalitems = value;
    prefs.setInt('ff_totalitems', value);
    notifyListeners();
  }

  String _fullName = '';
  String get fullName => _fullName;
  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) {
    _phoneNumber = value;
    prefs.setString('ff_phoneNumber', value);
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  bool _isloggedIn = false;
  bool get isloggedIn => _isloggedIn;
  set isloggedIn(bool value) {
    _isloggedIn = value;
    notifyListeners();
  }

  String _UserId = '';
  String get UserId => _UserId;
  set UserId(String value) {
    _UserId = value;
    notifyListeners();
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  set confirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  bool _acceptTerms = false;
  bool get acceptTerms => _acceptTerms;
  set acceptTerms(bool value) {
    _acceptTerms = value;
    notifyListeners();
  }

  bool _ShowPassword = false;
  bool get ShowPassword => _ShowPassword;
  set ShowPassword(bool value) {
    _ShowPassword = value;
    notifyListeners();
  }

  String _categories = '';
  String get categories => _categories;
  set categories(String value) {
    _categories = value;
    prefs.setString('ff_categories', value);
    notifyListeners();
  }

  bool _cartitems = false;
  bool get cartitems => _cartitems;
  set cartitems(bool value) {
    _cartitems = value;
    notifyListeners();
  }

  bool _filter = false;
  bool get filter => _filter;
  set filter(bool value) {
    _filter = value;
    notifyListeners();
  }

  String _gender = '';
  String get gender => _gender;
  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  String _SearchTem = '';
  String get SearchTem => _SearchTem;
  set SearchTem(String value) {
    _SearchTem = value;
    notifyListeners();
  }

  String _deal = '';
  String get deal => _deal;
  set deal(String value) {
    _deal = value;
    notifyListeners();
  }

  bool _cart = false;
  bool get cart => _cart;
  set cart(bool value) {
    _cart = value;
    notifyListeners();
  }

  bool _showProductCard = false;
  bool get showProductCard => _showProductCard;
  set showProductCard(bool value) {
    _showProductCard = value;
    prefs.setBool('ff_showProductCard', value);
    notifyListeners();
  }

  bool _chat = false;
  bool get chat => _chat;
  set chat(bool value) {
    _chat = value;
    notifyListeners();
  }

  bool _like = false;
  bool get like => _like;
  set like(bool value) {
    _like = value;
    notifyListeners();
  }

  List<DocumentReference> _favorite = [];
  List<DocumentReference> get favorite => _favorite;
  set favorite(List<DocumentReference> value) {
    _favorite = value;
    notifyListeners();
  }

  void addToFavorite(DocumentReference value) {
    favorite.add(value);
    notifyListeners();
  }

  void removeFromFavorite(DocumentReference value) {
    favorite.remove(value);
    notifyListeners();
  }

  void removeAtIndexFromFavorite(int index) {
    favorite.removeAt(index);
    notifyListeners();
  }

  void updateFavoriteAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    favorite[index] = updateFn(_favorite[index]);
    notifyListeners();
  }

  void insertAtIndexInFavorite(int index, DocumentReference value) {
    favorite.insert(index, value);
    notifyListeners();
  }

  Color _accentColor = Colors.transparent;
  Color get accentColor => _accentColor;
  set accentColor(Color value) {
    _accentColor = value;
    notifyListeners();
  }

  bool _hasReviewedThisVersion = false;
  bool get hasReviewedThisVersion => _hasReviewedThisVersion;
  set hasReviewedThisVersion(bool value) {
    _hasReviewedThisVersion = value;
    prefs.setBool('ff_hasReviewedThisVersion', value);
    notifyListeners();
  }

  bool _notificationSeen = false;
  bool get notificationSeen => _notificationSeen;
  set notificationSeen(bool value) {
    _notificationSeen = value;
    prefs.setBool('ff_notificationSeen', value);
    notifyListeners();
  }

  List<String> _selectedTags = [];
  List<String> get selectedTags => _selectedTags;
  set selectedTags(List<String> value) {
    _selectedTags = value;
    notifyListeners();
  }

  void addToSelectedTags(String value) {
    selectedTags.add(value);
    notifyListeners();
  }

  void removeFromSelectedTags(String value) {
    selectedTags.remove(value);
    notifyListeners();
  }

  void removeAtIndexFromSelectedTags(int index) {
    selectedTags.removeAt(index);
    notifyListeners();
  }

  void updateSelectedTagsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedTags[index] = updateFn(_selectedTags[index]);
    notifyListeners();
  }

  void insertAtIndexInSelectedTags(int index, String value) {
    selectedTags.insert(index, value);
    notifyListeners();
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

Color? _colorFromIntValue(int? val) {
  if (val == null) {
    return null;
  }
  return Color(val);
}
