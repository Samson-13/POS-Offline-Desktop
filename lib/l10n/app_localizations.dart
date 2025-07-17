import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @brand_name.
  ///
  /// In en, this message translates to:
  /// **'POS Samsun'**
  String get brand_name;

  /// No description provided for @brand_name_subtitle.
  ///
  /// In en, this message translates to:
  /// **'(NextComm)'**
  String get brand_name_subtitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @enter_valid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Phone Number'**
  String get enter_valid_phone_number;

  /// No description provided for @product_list.
  ///
  /// In en, this message translates to:
  /// **'Product List'**
  String get product_list;

  /// No description provided for @add_product.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get add_product;

  /// No description provided for @save_product.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get save_product;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get product_name;

  /// No description provided for @enter_product_name.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enter_product_name;

  /// No description provided for @enter_valid_product_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid product name'**
  String get enter_valid_product_name;

  /// No description provided for @delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get delete_confirmation;

  /// No description provided for @are_you_sure_you_want_to_delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get are_you_sure_you_want_to_delete;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @remove_product.
  ///
  /// In en, this message translates to:
  /// **'Remove Product'**
  String get remove_product;

  /// No description provided for @please_fill_the_form.
  ///
  /// In en, this message translates to:
  /// **'Fill up the Form'**
  String get please_fill_the_form;

  /// No description provided for @export_to_pdf.
  ///
  /// In en, this message translates to:
  /// **'Export to Pdf'**
  String get export_to_pdf;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @select_products.
  ///
  /// In en, this message translates to:
  /// **'Select Products'**
  String get select_products;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @total_customer.
  ///
  /// In en, this message translates to:
  /// **'Total Customer'**
  String get total_customer;

  /// No description provided for @total_product.
  ///
  /// In en, this message translates to:
  /// **'Total Product'**
  String get total_product;

  /// No description provided for @exceeds_available_stock.
  ///
  /// In en, this message translates to:
  /// **'Exceeds Available Stock'**
  String get exceeds_available_stock;

  /// No description provided for @enter_quantity.
  ///
  /// In en, this message translates to:
  /// **'Enter Quantity'**
  String get enter_quantity;

  /// No description provided for @invalid_quantity_or_product.
  ///
  /// In en, this message translates to:
  /// **'Invalid Quantity or Product'**
  String get invalid_quantity_or_product;

  /// No description provided for @select_customer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get select_customer;

  /// No description provided for @select_product.
  ///
  /// In en, this message translates to:
  /// **'Select Product'**
  String get select_product;

  /// No description provided for @select_customer_and_product.
  ///
  /// In en, this message translates to:
  /// **'Select Customer and Product'**
  String get select_customer_and_product;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @other_settings.
  ///
  /// In en, this message translates to:
  /// **'Other Settings'**
  String get other_settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @enter_valid_price.
  ///
  /// In en, this message translates to:
  /// **'Enter valid Price'**
  String get enter_valid_price;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @enter_valid_quantity.
  ///
  /// In en, this message translates to:
  /// **'Enter valid Quantity'**
  String get enter_valid_quantity;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @gstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get gstin;

  /// No description provided for @enter_valid_gstin.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Gstin number'**
  String get enter_valid_gstin;

  /// No description provided for @enter_valid_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get enter_valid_name;

  /// No description provided for @customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customer_name;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @phone_num.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_num;

  /// No description provided for @gst.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get gst;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @invoice_number.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoice_number;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @add_customer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get add_customer;

  /// No description provided for @customer_list.
  ///
  /// In en, this message translates to:
  /// **'Customer List'**
  String get customer_list;

  /// No description provided for @save_customer.
  ///
  /// In en, this message translates to:
  /// **'Save Customer'**
  String get save_customer;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @enter_invoice_number.
  ///
  /// In en, this message translates to:
  /// **'Enter invoice number'**
  String get enter_invoice_number;

  /// No description provided for @enter_valid_invoice_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid invoice number'**
  String get enter_valid_invoice_number;

  /// No description provided for @enter_customer_name.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enter_customer_name;

  /// No description provided for @enter_valid_customer_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid customer name'**
  String get enter_valid_customer_name;

  /// No description provided for @enter_total_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter total amount'**
  String get enter_total_amount;

  /// No description provided for @total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// No description provided for @enter_valid_total_amount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid total amount'**
  String get enter_valid_total_amount;

  /// No description provided for @save_invoice.
  ///
  /// In en, this message translates to:
  /// **'Save Invoice'**
  String get save_invoice;

  /// No description provided for @add_invoice.
  ///
  /// In en, this message translates to:
  /// **'Add Invoice'**
  String get add_invoice;

  /// No description provided for @ctn.
  ///
  /// In en, this message translates to:
  /// **'CTN'**
  String get ctn;

  /// No description provided for @enter_ctn.
  ///
  /// In en, this message translates to:
  /// **'Enter CTN'**
  String get enter_ctn;

  /// No description provided for @edit_customer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get edit_customer;

  /// No description provided for @edit_invoice.
  ///
  /// In en, this message translates to:
  /// **'Edit Invoice'**
  String get edit_invoice;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @invoice_details.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoice_details;

  /// No description provided for @invoice_list.
  ///
  /// In en, this message translates to:
  /// **'Invoice List'**
  String get invoice_list;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
