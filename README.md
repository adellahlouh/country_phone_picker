# Country Phone Picker

A beautiful and customizable Flutter package for selecting countries with phone codes. This package provides a user-friendly bottom sheet picker that displays countries with their flags, names, and dial codes, making it perfect for phone number input forms in Flutter applications.

## Features

- 🌍 **Comprehensive Country List**: Includes all countries with their ISO codes, dial codes, and flags
- 🎨 **Beautiful UI**: Modern bottom sheet design with country flags and dial codes
- 🌐 **Multi-language Support**: Supports 69 languages for country names
- 📱 **Phone Validation Data**: Includes phone number length and valid starting digits for each country
- 🎯 **Easy Integration**: Simple widget that can be easily integrated into any Flutter app
- 🎨 **Customizable**: Uses Material Design components for consistent look and feel

## Installation

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  country_phone_picker: ^0.0.1
  country_flags: ^3.3.0
  flutter_localizations:
    sdk: flutter
```

Then run:

```bash
flutter pub get
```

## Supported Languages

The package supports 69 languages including:
- English (en)
- Arabic (ar)
- Spanish (es)
- French (fr)
- German (de)
- Chinese (zh)
- Japanese (ja)
- Russian (ru)
- And 61 more languages...

See the full list in the [Localization](#localization) section.

## Basic Usage

### 1. Setup Localization

First, configure your app to support localization:

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
      // Add supported locales
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('es'),
        Locale('fr'),
        // Add more locales as needed
      ],
      // Add localization delegates
      localizationsDelegates: const [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
```

### 2. Use the Country Phone Picker

```dart
import 'package:flutter/material.dart';
import 'package:country_phone_picker/country_phone_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CountryModel? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Country Phone Picker Widget
            CountryPhonePicker(
              onChanged: (CountryModel country) {
                setState(() {
                  selectedCountry = country;
                });
                print('Selected: ${country.name}');
                print('Dial Code: ${country.dialCode}');
                print('ISO Code: ${country.isoCode}');
              },
            ),
            const SizedBox(height: 20),
            // Display selected country info
            if (selectedCountry != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Country: ${selectedCountry!.name}'),
                      Text('Dial Code: ${selectedCountry!.dialCode}'),
                      Text('ISO Code: ${selectedCountry!.isoCode}'),
                      Text('Phone Length: ${selectedCountry!.lengthNumber}'),
                      Text('Starts With: ${selectedCountry!.phoneStartsWith.join(", ")}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

## Complete Example

Here's a complete example with a phone number input field:

```dart
import 'package:flutter/material.dart';
import 'package:country_phone_picker/country_phone_picker.dart';

class PhoneInputExample extends StatefulWidget {
  const PhoneInputExample({super.key});

  @override
  State<PhoneInputExample> createState() => _PhoneInputExampleState();
}

class _PhoneInputExampleState extends State<PhoneInputExample> {
  CountryModel? selectedCountry;
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your phone number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Country Picker
                CountryPhonePicker(
                  onChanged: (CountryModel country) {
                    setState(() {
                      selectedCountry = country;
                    });
                  },
                ),
                const SizedBox(width: 8),
                // Phone Number Input
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: selectedCountry?.hintText ?? 'Phone number',
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
                if (selectedCountry != null && phoneController.text.isNotEmpty) {
                  final fullNumber = '${selectedCountry!.dialCode}${phoneController.text}';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Phone number: $fullNumber'),
                    ),
                  );
                }
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

## API Reference

### CountryPhonePicker Widget

The main widget for selecting a country.

#### Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `onChanged` | `ValueChanged<CountryModel>` | Yes | Callback function called when a country is selected |
| `key` | `Key?` | No | Widget key |

#### Example

```dart
CountryPhonePicker(
  onChanged: (CountryModel country) {
    // Handle country selection
    print('Selected: ${country.name}');
  },
)
```

### CountryModel Class

Represents a country with its phone code information.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `code` | `int` | Unique country code |
| `name` | `String` | Country name (localized) |
| `isoCode` | `String` | ISO 3166-1 alpha-2 country code (e.g., "US", "GB") |
| `dialCode` | `String` | International dial code (e.g., "+1", "+44") |
| `hintText` | `String?` | Phone number format hint (e.g., "77-XXXXXXX") |
| `lengthNumber` | `int` | Expected phone number length |
| `phoneStartsWith` | `List<String>` | Valid starting digits for phone numbers |

#### Methods

##### `CountryModel.initialModel()`

Returns the default country model (Jordan by default).

```dart
final defaultCountry = CountryModel.initialModel();
// Returns: CountryModel with code: 85, name: "Jordan", dialCode: "+962"
```

##### `CountryModel.fromJson(Map<String, dynamic> json)`

Creates a `CountryModel` from a JSON map.

```dart
final country = CountryModel.fromJson({
  "code": 1,
  "name": "United States",
  "isoCode": "US",
  "dialCode": "+1",
  "hintText": "XXX-XXX-XXXX",
  "lengthNumber": 10,
  "phoneStartsWith": ["2", "3", "4", "5", "6", "7", "8", "9"]
});
```

#### Example Usage

```dart
CountryPhonePicker(
  onChanged: (CountryModel country) {
    // Access country properties
    print('Country Name: ${country.name}');
    print('ISO Code: ${country.isoCode}');
    print('Dial Code: ${country.dialCode}');
    print('Phone Length: ${country.lengthNumber}');
    print('Valid Starts: ${country.phoneStartsWith}');
    
    // Use for phone validation
    if (phoneNumber.length != country.lengthNumber) {
      // Show error: invalid length
    }
    
    if (!country.phoneStartsWith.any((prefix) => 
        phoneNumber.startsWith(prefix))) {
      // Show error: invalid starting digits
    }
  },
)
```

## Localization

The package supports 69 languages. To use localization:

1. **Add supported locales** to your `MaterialApp`:

```dart
supportedLocales: const [
  Locale('en'), // English
  Locale('ar'), // Arabic
  Locale('es'), // Spanish
  Locale('fr'), // French
  Locale('de'), // German
  Locale('zh'), // Chinese
  Locale('ja'), // Japanese
  Locale('ru'), // Russian
  // ... add more as needed
],
```

2. **Add localization delegates**:

```dart
localizationsDelegates: const [
  CountryLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
```

### Supported Language Codes

The package supports the following language codes:

`af`, `am`, `ar`, `az`, `be`, `bg`, `bn`, `bs`, `ca`, `cs`, `da`, `de`, `el`, `en`, `es`, `et`, `fa`, `fi`, `fr`, `gl`, `ha`, `he`, `hi`, `hr`, `hu`, `hy`, `id`, `is`, `it`, `ja`, `ka`, `kk`, `km`, `ko`, `ku`, `ky`, `lt`, `lv`, `mk`, `ml`, `mn`, `ms`, `nb`, `nl`, `nn`, `no`, `pl`, `ps`, `pt`, `ro`, `ru`, `sd`, `sk`, `sl`, `so`, `sq`, `sr`, `sv`, `ta`, `tg`, `th`, `tk`, `tr`, `tt`, `uk`, `ug`, `ur`, `uz`, `vi`, `zh`

### Disabling Localization

If you want to disable localization and always use English:

```dart
localizationsDelegates: [
  CountryLocalizations.getDelegate(enableLocalization: false),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
],
```

## Phone Number Validation

The `CountryModel` provides useful information for phone number validation:

```dart
CountryPhonePicker(
  onChanged: (CountryModel country) {
    // Validate phone number length
    bool isValidLength = phoneNumber.length == country.lengthNumber;
    
    // Validate phone number starts with valid digits
    bool hasValidStart = country.phoneStartsWith.any(
      (prefix) => phoneNumber.startsWith(prefix)
    );
    
    if (isValidLength && hasValidStart) {
      // Phone number is valid
    } else {
      // Show validation error
    }
  },
)
```

## Styling and Customization

The `CountryPhonePicker` widget displays:
- Country flag (using `country_flags` package)
- Dial code (e.g., "+1", "+44")

The bottom sheet picker shows:
- Close button
- Country list with radio buttons
- Country flags
- Country names (localized)
- Dial codes

## Dependencies

- `flutter`: SDK
- `country_flags: ^3.3.0`: For displaying country flags

## Requirements

- Flutter SDK: `>=1.17.0`
- Dart SDK: `^3.7.2`

## Example App

Check the `example` directory for a complete working example.

To run the example:

```bash
cd example
flutter run
```

## Default Country

By default, the package initializes with Jordan (JO) as the selected country:
- **Code**: 85
- **Name**: Jordan
- **ISO Code**: JO
- **Dial Code**: +962
- **Hint Text**: 77-XXXXXXX
- **Length**: 9
- **Starts With**: ["77", "78", "79"]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

---

Made with ❤️ for Flutter developers
