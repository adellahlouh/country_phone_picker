# Country Phone Picker

A Flutter package for selecting countries with phone codes. It provides a bottom sheet picker with country flags, localized names, and dial codes — useful for phone number input forms.

## Features

- Country list with ISO codes, dial codes, and flags
- Bottom sheet picker UI
- Built-in search by country name, dial code, or ISO code
- Localized country names (69 languages)
- Phone length and valid starting digits per country
- Simple `CountryPhonePicker` widget for quick integration
- Performance: country data is parsed once, search runs only when the query changes, and keyboard animation does not rebuild the list

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  country_phone_picker: ^0.0.2
  flutter_localizations:
    sdk: flutter
```

Then run:

```bash
flutter pub get
```

## Basic Usage

### 1. Setup localization

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_phone_picker/country_phone_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('es'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        CountryPickerLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
```

### 2. Use the picker

`bottomSheetTitle` and `onChanged` are required.

```dart
CountryPhonePicker(
  bottomSheetTitle: 'Choose Country',
  bottomSheetConfig: BottomSheetConfig(
    closeIcon: Image.asset(
      'assets/icons/close.png',
      width: 20,
      height: 20,
    ),
    titleStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    radioActiveColor: Colors.deepPurple,
    searchConfig: const SearchConfig(hintText: 'Search country'),
  ),
  onChanged: (CountryModel country) {
    print(country.name);
    print(country.dialCode);
    print(country.isoCode);
  },
)
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:country_phone_picker/country_phone_picker.dart';

class PhoneInputExample extends StatefulWidget {
  const PhoneInputExample({super.key});

  @override
  State<PhoneInputExample> createState() => _PhoneInputExampleState();
}

class _PhoneInputExampleState extends State<PhoneInputExample> {
  CountryModel selectedCountry = CountryModel.initialModel();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Number Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CountryPhonePicker(
                  bottomSheetTitle: 'Choose Country',
                  onChanged: (CountryModel country) {
                    setState(() => selectedCountry = country);
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: selectedCountry.hintText ?? 'Phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final fullNumber =
                    '${selectedCountry.dialCode}${phoneController.text}';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Phone number: $fullNumber')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
```

See the full working app in the [`example`](example) directory:

```bash
cd example
flutter run
```

## API Reference

### `CountryPhonePicker`

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `onChanged` | `ValueChanged<CountryModel>` | Yes | Called when a country is selected |
| `bottomSheetTitle` | `String` | Yes | Title shown at the top of the bottom sheet |
| `bottomSheetConfig` | `BottomSheetConfig` | No | Bottom sheet appearance; defaults to the standard package design |
| `initialCountry` | `CountryModel?` | No | Country shown before the user picks one; defaults to Jordan |
| `key` | `Key?` | No | Widget key |

### `BottomSheetConfig`

An optional immutable configuration for the modal, header, search field, country
rows, flags, radio controls, text, spacing, and separator. All properties have
defaults, so you only need to provide the values you want to change.

The `closeIcon` accepts any widget. Assets are resolved from the host
application, while the package keeps ownership of the dismiss action.

The sheet opens at `initialHeightFactor` of the available height instead of
taking the whole screen. Tapping the search field grows it to
`expandedHeightFactor` first, and the keyboard is only requested once that
animation completes, so the field never slides under the keyboard. Closing the
keyboard shrinks the sheet back to `initialHeightFactor`.

When the sheet opens, the list scrolls to the country that is currently selected
and centers it, so the previous choice is visible without scrolling.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `initialHeightFactor` | `double` | `0.6` | Height fraction used when the sheet opens |
| `expandedHeightFactor` | `double` | `0.95` | Height fraction used after the search field is tapped |
| `expandOnSearchTap` | `bool` | `true` | Grow the sheet before showing the keyboard |
| `expandDuration` | `Duration` | `250ms` | Duration of the growth animation |
| `expandCurve` | `Curve` | `Curves.easeOutCubic` | Curve of the growth animation |
| `scrollToSelected` | `bool` | `true` | Scroll to the selected country when the sheet opens |
| `scrollToSelectedAlignment` | `double` | `0.5` | Position of that country in the list: `0` top, `0.5` center, `1` bottom |

Set `expandOnSearchTap: false` to keep a fixed height and open the keyboard on
the first tap. Set `scrollToSelected: false` to always open at the top of the
list.

> `CountryPhonePickerBottomSheetConfig` still works as a deprecated alias of
> `BottomSheetConfig`.

### `SearchConfig`

Controls the search field shown between the header and the country list. It is
enabled by default and filters on the localized country name, the fallback
package name, the ISO code, and the dial code (`962`, `+962`, and `+ 962` all
match Jordan).

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `enabled` | `bool` | `true` | Whether the search field is shown |
| `autofocus` | `bool` | `false` | Focus the field when the sheet opens |
| `matcher` | `CountrySearchMatcher?` | `null` | Replaces the default filtering logic |
| `padding` | `EdgeInsetsGeometry` | `horizontal: 16` | Padding around the field |
| `bottomSpacing` | `double` | `8` | Space between the field and the list |
| `contentPadding` | `EdgeInsetsGeometry?` | `null` | Padding inside the field |
| `hintText` | `String` | `'Search'` | Placeholder text |
| `textStyle` / `hintStyle` | `TextStyle?` | `null` | Query and hint styles |
| `cursorColor` | `Color?` | `null` | Cursor color |
| `keyboardType` | `TextInputType` | `TextInputType.text` | Keyboard type |
| `textInputAction` | `TextInputAction` | `TextInputAction.search` | Keyboard action |
| `prefixIcon` | `Widget?` | `Icon(Icons.search)` | Leading widget, accepts host assets |
| `showClearButton` | `bool` | `true` | Show a clear button while typing |
| `clearIcon` | `Widget` | `Icon(Icons.clear)` | Clear button content |
| `filled` / `fillColor` | `bool` / `Color?` | `false` / `null` | Field background |
| `border` / `enabledBorder` / `focusedBorder` | `InputBorder?` | `null` | Field borders |
| `decoration` | `InputDecoration?` | `null` | Complete decoration override |
| `emptyResultText` | `String` | `'No countries found'` | Message when nothing matches |
| `emptyResultStyle` | `TextStyle?` | `null` | Style of the empty message |
| `emptyResultBuilder` | `WidgetBuilder?` | `null` | Replaces the empty message widget |

```dart
CountryPhonePicker(
  bottomSheetTitle: 'Choose Country',
  bottomSheetConfig: BottomSheetConfig(
    initialHeightFactor: 0.6,
    expandedHeightFactor: 0.95,
    searchConfig: SearchConfig(
      hintText: 'Search country or code',
      autofocus: true,
      filled: true,
      fillColor: Colors.deepPurple.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      emptyResultText: 'No match',
    ),
  ),
  onChanged: (CountryModel country) {},
)
```

To hide the field, or to filter with your own rules:

```dart
const SearchConfig(enabled: false);

SearchConfig(
  matcher: (CountryModel country, String query) =>
      country.dialCode.contains(query),
);
```

### `CountryModel`

| Property | Type | Description |
|----------|------|-------------|
| `code` | `int` | Internal country id |
| `name` | `String` | Fallback country name from package data |
| `isoCode` | `String` | ISO 3166-1 alpha-2 code (e.g. `"US"`) |
| `dialCode` | `String` | Dial code (e.g. `"+1"`) |
| `hintText` | `String?` | Phone format hint (e.g. `"77-XXXXXXX"`) |
| `lengthNumber` | `int` | Expected national number length |
| `phoneStartsWith` | `List<String>` | Valid starting digit prefixes |

**Factories**

- `CountryModel.initialModel()` — default country (Jordan / `JO` / `+962`)
- `CountryModel.fromJson(Map<String, dynamic> json)` — create from a map

To show a localized name in your own UI:

```dart
final name = CountryPickerLocalizations.of(context)
        ?.translate(country.isoCode) ??
    country.name;
```

### `CountryPhonePickerBottomSheet`

Public bottom sheet widget if you want to present the list yourself.

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `selectedCountryCode` | `CountryModel` | Yes | Currently selected country |
| `bottomSheetTitle` | `String` | Yes | Sheet title |
| `config` | `BottomSheetConfig` | No | Bottom sheet appearance |

## Localization

Register the delegate and locales you need:

```dart
localizationsDelegates: const [
  CountryPickerLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
```

### Force English names

```dart
localizationsDelegates: [
  CountryPickerLocalizations.getDelegate(enableLocalization: false),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
```

### Supported language codes (69)

`af`, `am`, `ar`, `az`, `be`, `bg`, `bn`, `bs`, `ca`, `cs`, `da`, `de`, `el`, `en`, `es`, `et`, `fa`, `fi`, `fr`, `gl`, `ha`, `he`, `hi`, `hr`, `hu`, `hy`, `id`, `is`, `it`, `ja`, `ka`, `kk`, `km`, `ko`, `ku`, `ky`, `lt`, `lv`, `mk`, `ml`, `mn`, `ms`, `nb`, `nl`, `nn`, `no`, `pl`, `ps`, `pt`, `ro`, `ru`, `sd`, `sk`, `sl`, `so`, `sq`, `sr`, `sv`, `ta`, `tg`, `th`, `tr`, `tt`, `ug`, `uk`, `ur`, `uz`, `vi`, `zh`

## Phone number validation helpers

```dart
CountryPhonePicker(
  bottomSheetTitle: 'Choose Country',
  onChanged: (CountryModel country) {
    final isValidLength = phoneNumber.length == country.lengthNumber;
    final hasValidStart = country.phoneStartsWith.any(
      (prefix) => phoneNumber.startsWith(prefix),
    );

    if (isValidLength && hasValidStart) {
      // Valid against package rules
    }
  },
)
```

## Default country

The picker starts with Jordan:

| Field | Value |
|-------|-------|
| Name | Jordan |
| ISO | `JO` |
| Dial code | `+962` |
| Hint | `7X-XXXXXXX` |
| Length | `9` |
| Starts with | `77`, `78`, `79` |

## Dependencies

- `flutter` (SDK)
- [`country_flags`](https://pub.dev/packages/country_flags) `^3.3.0`

## Requirements

- Flutter `>=1.17.0`
- Dart `^3.7.2`

## Contributing

Pull requests are welcome.

## License

See [LICENSE](LICENSE).

## Changelog

See [CHANGELOG.md](CHANGELOG.md).
