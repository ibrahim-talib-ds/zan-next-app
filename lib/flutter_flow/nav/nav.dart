import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? NavBarPage() : SplashWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? NavBarPage() : SplashWidget(),
        ),
        FFRoute(
          name: ForgotPasswordWidget.routeName,
          path: ForgotPasswordWidget.routePath,
          builder: (context, params) => ForgotPasswordWidget(),
        ),
        FFRoute(
          name: ResetpasswordnotificationWidget.routeName,
          path: ResetpasswordnotificationWidget.routePath,
          builder: (context, params) => ResetpasswordnotificationWidget(),
        ),
        FFRoute(
          name: NotificationsSplashWidget.routeName,
          path: NotificationsSplashWidget.routePath,
          builder: (context, params) => NotificationsSplashWidget(),
        ),
        FFRoute(
          name: OrderSplashWidget.routeName,
          path: OrderSplashWidget.routePath,
          builder: (context, params) => OrderSplashWidget(),
        ),
        FFRoute(
          name: NotificationDetailsWidget.routeName,
          path: NotificationDetailsWidget.routePath,
          builder: (context, params) => NotificationDetailsWidget(),
        ),
        FFRoute(
          name: OrderDetailsWidget.routeName,
          path: OrderDetailsWidget.routePath,
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: OrderDetailsWidget(),
          ),
        ),
        FFRoute(
          name: EmptycartWidget.routeName,
          path: EmptycartWidget.routePath,
          builder: (context, params) => EmptycartWidget(),
        ),
        FFRoute(
          name: CartWidget.routeName,
          path: CartWidget.routePath,
          builder: (context, params) => CartWidget(),
        ),
        FFRoute(
          name: CheckoutWidget.routeName,
          path: CheckoutWidget.routePath,
          builder: (context, params) => CheckoutWidget(),
        ),
        FFRoute(
          name: OrderSuccessifulWidget.routeName,
          path: OrderSuccessifulWidget.routePath,
          builder: (context, params) => OrderSuccessifulWidget(),
        ),
        FFRoute(
          name: WishlistWidget.routeName,
          path: WishlistWidget.routePath,
          builder: (context, params) => WishlistWidget(),
        ),
        FFRoute(
          name: SplashWidget.routeName,
          path: SplashWidget.routePath,
          builder: (context, params) => SplashWidget(),
        ),
        FFRoute(
          name: SigninIngiaWidget.routeName,
          path: SigninIngiaWidget.routePath,
          builder: (context, params) => SigninIngiaWidget(),
        ),
        FFRoute(
          name: SigninContinueKaribuWidget.routeName,
          path: SigninContinueKaribuWidget.routePath,
          builder: (context, params) => SigninContinueKaribuWidget(),
        ),
        FFRoute(
          name: HomeWidget.routeName,
          path: HomeWidget.routePath,
          builder: (context, params) =>
              params.isEmpty ? NavBarPage(initialPage: 'Home') : HomeWidget(),
        ),
        FFRoute(
            name: SearchWidget.routeName,
            path: SearchWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: SearchWidget(),
                )),
        FFRoute(
          name: SigninWidget.routeName,
          path: SigninWidget.routePath,
          builder: (context, params) => SigninWidget(),
        ),
        FFRoute(
            name: SpecificCategoriesWidget.routeName,
            path: SpecificCategoriesWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: SpecificCategoriesWidget(),
                )),
        FFRoute(
          name: SettingPaymentWidget.routeName,
          path: SettingPaymentWidget.routePath,
          builder: (context, params) => SettingPaymentWidget(),
        ),
        FFRoute(
          name: SettingAddPymentWidget.routeName,
          path: SettingAddPymentWidget.routePath,
          builder: (context, params) => SettingAddPymentWidget(),
        ),
        FFRoute(
          name: ShopByCategoriesSearchFilterDealsWidget.routeName,
          path: ShopByCategoriesSearchFilterDealsWidget.routePath,
          builder: (context, params) =>
              ShopByCategoriesSearchFilterDealsWidget(),
        ),
        FFRoute(
            name: ProductDetailsWidget.routeName,
            path: ProductDetailsWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: ProductDetailsWidget(
                    inventoryRef: params.getParam(
                      'inventoryRef',
                      ParamType.DocumentReference,
                      isList: false,
                      collectionNamePath: ['Inventory'],
                    ),
                  ),
                )),
        FFRoute(
          name: PaymnetMethodWidget.routeName,
          path: PaymnetMethodWidget.routePath,
          builder: (context, params) => PaymnetMethodWidget(),
        ),
        FFRoute(
            name: TrendingProductWidget.routeName,
            path: TrendingProductWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: TrendingProductWidget(),
                )),
        FFRoute(
            name: NewProductsWidget.routeName,
            path: NewProductsWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: NewProductsWidget(),
                )),
        FFRoute(
          name: ZannextSignInWidget.routeName,
          path: ZannextSignInWidget.routePath,
          builder: (context, params) => ZannextSignInWidget(),
        ),
        FFRoute(
          name: LogInWidget.routeName,
          path: LogInWidget.routePath,
          builder: (context, params) => LogInWidget(),
        ),
        FFRoute(
          name: AudiocallWidget.routeName,
          path: AudiocallWidget.routePath,
          builder: (context, params) => AudiocallWidget(),
        ),
        FFRoute(
          name: ProfileWidget.routeName,
          path: ProfileWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Profile')
              : ProfileWidget(),
        ),
        FFRoute(
            name: ProfileEditWidget.routeName,
            path: ProfileEditWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: ProfileEditWidget(),
                )),
        FFRoute(
          name: MyAdressWidget.routeName,
          path: MyAdressWidget.routePath,
          builder: (context, params) => MyAdressWidget(),
        ),
        FFRoute(
            name: AddNewadressWidget.routeName,
            path: AddNewadressWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: AddNewadressWidget(),
                )),
        FFRoute(
          name: WelcomeWidget.routeName,
          path: WelcomeWidget.routePath,
          builder: (context, params) => WelcomeWidget(),
        ),
        FFRoute(
          name: LogInMethodWidget.routeName,
          path: LogInMethodWidget.routePath,
          builder: (context, params) => LogInMethodWidget(),
        ),
        FFRoute(
          name: SignInMobileWidget.routeName,
          path: SignInMobileWidget.routePath,
          builder: (context, params) => SignInMobileWidget(),
        ),
        FFRoute(
          name: SignUpWidget.routeName,
          path: SignUpWidget.routePath,
          builder: (context, params) => SignUpWidget(),
        ),
        FFRoute(
          name: SearchZWidget.routeName,
          path: SearchZWidget.routePath,
          builder: (context, params) => SearchZWidget(),
        ),
        FFRoute(
          name: CategorysZWidget.routeName,
          path: CategorysZWidget.routePath,
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: CategorysZWidget(),
          ),
        ),

        FFRoute(
          name: AddProductWidget.routeName,
          path: AddProductWidget.routePath,
          builder: (context, params) => const AddProductWidget(),
        ),
        FFRoute(
          name: NotificationWidget.routeName,
          path: NotificationWidget.routePath,
          builder: (context, params) => NotificationWidget(),
        ),
        FFRoute(
          name: HelpCenterWidget.routeName,
          path: HelpCenterWidget.routePath,
          builder: (context, params) => const HelpCenterWidget(),
        ),

        FFRoute(
          name: AdminSupportInboxWidget.routeName,
          path: AdminSupportInboxWidget.routePath,
          builder: (context, params) => const AdminSupportInboxWidget(),
        ),

        FFRoute(
          name: AdminDashboardWidget.routeName,
          path: AdminDashboardWidget.routePath,
          builder: (context, params) => const AdminDashboardWidget(),
        ),

        FFRoute(
          name: AdminBroadcastWidget.routeName,
          path: AdminBroadcastWidget.routePath,
          builder: (context, params) => const AdminBroadcastWidget(),
        ),

        FFRoute(
          name: AdminSellersWidget.routeName,
          path: AdminSellersWidget.routePath,
          builder: (context, params) => const AdminSellersWidget(),
        ),

        FFRoute(
          name: AdminReportsWidget.routeName,
          path: AdminReportsWidget.routePath,
          builder: (context, params) => const AdminReportsWidget(),
        ),
        FFRoute(
          name: AboutAppWidget.routeName,
          path: AboutAppWidget.routePath,
          builder: (context, params) => const AboutAppWidget(),
        ),
        FFRoute(
          name: SupportChatWidget.routeName,
          path: SupportChatWidget.routePath,
          builder: (context, params) => const SupportChatWidget(),
        ),
        FFRoute(
          name: ReviewsWidget.routeName,
          path: ReviewsWidget.routePath,
          builder: (context, params) => ReviewsWidget(),
        ),
        FFRoute(
          name: SelectAdWidget.routeName,
          path: SelectAdWidget.routePath,
          builder: (context, params) => SelectAdWidget(),
        ),
        FFRoute(
          name: FashionWidget.routeName,
          path: FashionWidget.routePath,
          builder: (context, params) => FashionWidget(
            mainCategoryName: params.getParam(
              'mainCategoryName',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: FootwearWidget.routeName,
          path: FootwearWidget.routePath,
          builder: (context, params) => FootwearWidget(),
        ),
        FFRoute(
          name: ElectronicsWidget.routeName,
          path: ElectronicsWidget.routePath,
          builder: (context, params) => ElectronicsWidget(),
        ),
        FFRoute(
          name: BeautyWidget.routeName,
          path: BeautyWidget.routePath,
          builder: (context, params) => BeautyWidget(),
        ),
        FFRoute(
          name: HomeDecorWidget.routeName,
          path: HomeDecorWidget.routePath,
          builder: (context, params) => HomeDecorWidget(),
        ),
        FFRoute(
          name: GroceriesWidget.routeName,
          path: GroceriesWidget.routePath,
          builder: (context, params) => GroceriesWidget(),
        ),
        FFRoute(
          name: SmartTechWidget.routeName,
          path: SmartTechWidget.routePath,
          builder: (context, params) => SmartTechWidget(),
        ),
        FFRoute(
          name: SportsGearWidget.routeName,
          path: SportsGearWidget.routePath,
          builder: (context, params) => SportsGearWidget(),
        ),
        FFRoute(
          name: WatchesWidget.routeName,
          path: WatchesWidget.routePath,
          builder: (context, params) => WatchesWidget(),
        ),
        FFRoute(
          name: KidsToysWidget.routeName,
          path: KidsToysWidget.routePath,
          builder: (context, params) => KidsToysWidget(),
        ),
        FFRoute(
          name: HealthWidget.routeName,
          path: HealthWidget.routePath,
          builder: (context, params) => HealthWidget(),
        ),
        FFRoute(
          name: OfficeSupplyWidget.routeName,
          path: OfficeSupplyWidget.routePath,
          builder: (context, params) => OfficeSupplyWidget(),
        ),
        FFRoute(
          name: AutomotiveWidget.routeName,
          path: AutomotiveWidget.routePath,
          builder: (context, params) => AutomotiveWidget(),
        ),
        FFRoute(
          name: AppliancesWidget.routeName,
          path: AppliancesWidget.routePath,
          builder: (context, params) => AppliancesWidget(),
        ),
        FFRoute(
          name: JewelryWidget.routeName,
          path: JewelryWidget.routePath,
          builder: (context, params) => JewelryWidget(),
        ),
        FFRoute(
          name: GiftCardsWidget.routeName,
          path: GiftCardsWidget.routePath,
          builder: (context, params) => GiftCardsWidget(),
        ),
        FFRoute(
          name: AdInformationWidget.routeName,
          path: AdInformationWidget.routePath,
          builder: (context, params) => AdInformationWidget(),
        ),
        FFRoute(
          name: MensWearWidget.routeName,
          path: MensWearWidget.routePath,
          builder: (context, params) => MensWearWidget(),
        ),
        FFRoute(
          name: WomensWearWidget.routeName,
          path: WomensWearWidget.routePath,
          builder: (context, params) => WomensWearWidget(),
        ),
        FFRoute(
          name: HeelsWedgeWidget.routeName,
          path: HeelsWedgeWidget.routePath,
          builder: (context, params) => HeelsWedgeWidget(),
        ),
        FFRoute(
          name: CoolingWidget.routeName,
          path: CoolingWidget.routePath,
          builder: (context, params) => CoolingWidget(),
        ),
        FFRoute(
          name: MessagelistWidget.routeName,
          path: MessagelistWidget.routePath,
          builder: (context, params) => MessagelistWidget(),
        ),
        FFRoute(
          name: ProCategoryWidget.routeName,
          path: ProCategoryWidget.routePath,
          builder: (context, params) => ProCategoryWidget(),
        ),
        FFRoute(
          name: Order1Widget.routeName,
          path: Order1Widget.routePath,
          asyncParams: {
            'orderRef': getDoc(['orders'], OrdersRecord.fromSnapshot),
          },
          builder: (context, params) => Order1Widget(
            orderRef: params.getParam(
              'orderRef',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: SelectSellerWidget.routeName,
          path: SelectSellerWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'selectSeller')
              : SelectSellerWidget(),
        ),
        FFRoute(
          name: ChatDWidget.routeName,
          path: ChatDWidget.routePath,
          builder: (context, params) => ChatDWidget(
            receiveChats: params.getParam(
              'receiveChats',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Chats'],
            ),
          ),
        ),
        FFRoute(
          name: KidsClothingWidget.routeName,
          path: KidsClothingWidget.routePath,
          builder: (context, params) => KidsClothingWidget(),
        ),
        FFRoute(
          name: UnderwearSocksWidget.routeName,
          path: UnderwearSocksWidget.routePath,
          builder: (context, params) => UnderwearSocksWidget(),
        ),
        FFRoute(
          name: SneakersSportsWidget.routeName,
          path: SneakersSportsWidget.routePath,
          builder: (context, params) => SneakersSportsWidget(),
        ),
        FFRoute(
          name: FormalShoesWidget.routeName,
          path: FormalShoesWidget.routePath,
          builder: (context, params) => FormalShoesWidget(),
        ),
        FFRoute(
          name: SandalsSlippersWidget.routeName,
          path: SandalsSlippersWidget.routePath,
          builder: (context, params) => SandalsSlippersWidget(),
        ),
        FFRoute(
          name: HeelsWedgesWidget.routeName,
          path: HeelsWedgesWidget.routePath,
          builder: (context, params) => HeelsWedgesWidget(),
        ),
        FFRoute(
          name: ComputersLaptopWidget.routeName,
          path: ComputersLaptopWidget.routePath,
          builder: (context, params) => ComputersLaptopWidget(),
        ),
        FFRoute(
          name: AudioSoundsWidget.routeName,
          path: AudioSoundsWidget.routePath,
          builder: (context, params) => AudioSoundsWidget(),
        ),
        FFRoute(
          name: Cameras1Widget.routeName,
          path: Cameras1Widget.routePath,
          builder: (context, params) => Cameras1Widget(),
        ),
        FFRoute(
          name: TVVideo1Widget.routeName,
          path: TVVideo1Widget.routePath,
          builder: (context, params) => TVVideo1Widget(),
        ),
        FFRoute(
          name: Skincare1Widget.routeName,
          path: Skincare1Widget.routePath,
          builder: (context, params) => Skincare1Widget(),
        ),
        FFRoute(
          name: Fragrances1Widget.routeName,
          path: Fragrances1Widget.routePath,
          builder: (context, params) => Fragrances1Widget(),
        ),
        FFRoute(
          name: Makeup1Widget.routeName,
          path: Makeup1Widget.routePath,
          builder: (context, params) => Makeup1Widget(),
        ),
        FFRoute(
          name: HairCare1Widget.routeName,
          path: HairCare1Widget.routePath,
          builder: (context, params) => HairCare1Widget(),
        ),
        FFRoute(
          name: Lighting1Widget.routeName,
          path: Lighting1Widget.routePath,
          builder: (context, params) => Lighting1Widget(),
        ),
        FFRoute(
          name: WallArt1Widget.routeName,
          path: WallArt1Widget.routePath,
          builder: (context, params) => WallArt1Widget(),
        ),
        FFRoute(
          name: Furniture1Widget.routeName,
          path: Furniture1Widget.routePath,
          builder: (context, params) => Furniture1Widget(),
        ),
        FFRoute(
          name: Bedding1Widget.routeName,
          path: Bedding1Widget.routePath,
          builder: (context, params) => Bedding1Widget(),
        ),
        FFRoute(
          name: FreshProduce1Widget.routeName,
          path: FreshProduce1Widget.routePath,
          builder: (context, params) => FreshProduce1Widget(),
        ),
        FFRoute(
          name: GrainsFlour1Widget.routeName,
          path: GrainsFlour1Widget.routePath,
          builder: (context, params) => GrainsFlour1Widget(),
        ),
        FFRoute(
          name: Beverages1Widget.routeName,
          path: Beverages1Widget.routePath,
          builder: (context, params) => Beverages1Widget(),
        ),
        FFRoute(
          name: Snacks1Widget.routeName,
          path: Snacks1Widget.routePath,
          builder: (context, params) => Snacks1Widget(),
        ),
        FFRoute(
          name: RingsWeddingsWidget.routeName,
          path: RingsWeddingsWidget.routePath,
          builder: (context, params) => RingsWeddingsWidget(),
        ),
        FFRoute(
          name: NecklacesPendantWidget.routeName,
          path: NecklacesPendantWidget.routePath,
          builder: (context, params) => NecklacesPendantWidget(),
        ),
        FFRoute(
            name: SellerDashbordWidget.routeName,
            path: SellerDashbordWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: SellerDashbordWidget(),
                )),
        FFRoute(
          name: BraceletsEarringWidget.routeName,
          path: BraceletsEarringWidget.routePath,
          builder: (context, params) => BraceletsEarringWidget(),
        ),
        FFRoute(
          name: KitchensWidget.routeName,
          path: KitchensWidget.routePath,
          builder: (context, params) => KitchensWidget(),
        ),
        FFRoute(
          name: LaundrysWidget.routeName,
          path: LaundrysWidget.routePath,
          builder: (context, params) => LaundrysWidget(),
        ),
        FFRoute(
          name: CoolingsWidget.routeName,
          path: CoolingsWidget.routePath,
          builder: (context, params) => CoolingsWidget(),
        ),
        FFRoute(
          name: CarPartWidget.routeName,
          path: CarPartWidget.routePath,
          builder: (context, params) => CarPartWidget(),
        ),
        FFRoute(
          name: InteriorAccessorWidget.routeName,
          path: InteriorAccessorWidget.routePath,
          builder: (context, params) => InteriorAccessorWidget(),
        ),
        FFRoute(
          name: TiresRimWidget.routeName,
          path: TiresRimWidget.routePath,
          builder: (context, params) => TiresRimWidget(),
        ),
        FFRoute(
          name: WearableWidget.routeName,
          path: WearableWidget.routePath,
          builder: (context, params) => WearableWidget(),
        ),
        FFRoute(
          name: MobileAccessorieWidget.routeName,
          path: MobileAccessorieWidget.routePath,
          builder: (context, params) => MobileAccessorieWidget(),
        ),
        FFRoute(
          name: SmartHomesWidget.routeName,
          path: SmartHomesWidget.routePath,
          builder: (context, params) => SmartHomesWidget(),
        ),
        FFRoute(
          name: TeamSportWidget.routeName,
          path: TeamSportWidget.routePath,
          builder: (context, params) => TeamSportWidget(),
        ),
        FFRoute(
          name: GymFitnesWidget.routeName,
          path: GymFitnesWidget.routePath,
          builder: (context, params) => GymFitnesWidget(),
        ),
        FFRoute(
          name: OutdoorsWidget.routeName,
          path: OutdoorsWidget.routePath,
          builder: (context, params) => OutdoorsWidget(),
        ),
        FFRoute(
          name: LuxuryWatcheWidget.routeName,
          path: LuxuryWatcheWidget.routePath,
          builder: (context, params) => LuxuryWatcheWidget(),
        ),
        FFRoute(
          name: DigitalWatcheWidget.routeName,
          path: DigitalWatcheWidget.routePath,
          builder: (context, params) => DigitalWatcheWidget(),
        ),
        FFRoute(
          name: WallClockWidget.routeName,
          path: WallClockWidget.routePath,
          builder: (context, params) => WallClockWidget(),
        ),
        FFRoute(
          name: EducationalToyWidget.routeName,
          path: EducationalToyWidget.routePath,
          builder: (context, params) => EducationalToyWidget(),
        ),
        FFRoute(
          name: BabyGearsWidget.routeName,
          path: BabyGearsWidget.routePath,
          builder: (context, params) => BabyGearsWidget(),
        ),
        FFRoute(
          name: ElectronicToyWidget.routeName,
          path: ElectronicToyWidget.routePath,
          builder: (context, params) => ElectronicToyWidget(),
        ),
        FFRoute(
          name: SupplementWidget.routeName,
          path: SupplementWidget.routePath,
          builder: (context, params) => SupplementWidget(),
        ),
        FFRoute(
          name: MedicalEquipmentWidget.routeName,
          path: MedicalEquipmentWidget.routePath,
          builder: (context, params) => MedicalEquipmentWidget(),
        ),
        FFRoute(
          name: PersonalHygienesWidget.routeName,
          path: PersonalHygienesWidget.routePath,
          builder: (context, params) => PersonalHygienesWidget(),
        ),
        FFRoute(
          name: StationerysWidget.routeName,
          path: StationerysWidget.routePath,
          builder: (context, params) => StationerysWidget(),
        ),
        FFRoute(
          name: OfficeTechsWidget.routeName,
          path: OfficeTechsWidget.routePath,
          builder: (context, params) => OfficeTechsWidget(),
        ),
        FFRoute(
          name: OrganizationsWidget.routeName,
          path: OrganizationsWidget.routePath,
          builder: (context, params) => OrganizationsWidget(),
        ),
        FFRoute(
            name: EditModeWidget.routeName,
            path: EditModeWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: EditModeWidget(
                    targetProduct: params.getParam(
                      'targetProduct',
                      ParamType.DocumentReference,
                      isList: false,
                      collectionNamePath: ['Inventory'],
                    ),
                  ),
                )),
        FFRoute(
          name: RatePageWidget.routeName,
          path: RatePageWidget.routePath,
          builder: (context, params) => RatePageWidget(
            sourceName: params.getParam(
              'sourceName',
              ParamType.String,
            ),
          ),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/splash';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Color(0xFF064640),
                  child: Center(
                    child: Image.asset(
                      'assets/images/zannext_logo.png',
                      width: 180.0,
                      height: 180.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
