import 'package:country_phone_picker/country_phone_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Phone Picker',
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
      home: const PhoneInputExample(),
    );
  }
}

class PhoneInputExample extends StatefulWidget {
  const PhoneInputExample({super.key});

  @override
  State<PhoneInputExample> createState() => _PhoneInputExampleState();
}

class _PhoneInputExampleState extends State<PhoneInputExample> {
  static const String _initialCountryCode = 'IQ';

  CountryModel selectedCountry =
      findCountryByIsoCode(_initialCountryCode) ?? CountryModel.initialModel();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = CountryPickerLocalizations.of(context);
    final countryName =
        localizations?.translate(selectedCountry.isoCode) ??
        selectedCountry.name;

    return Scaffold(
      appBar: AppBar(title: const Text('Phone Number Input')),
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
                CountryPhonePicker(
                  bottomSheetTitle: 'Choose Country',
                  bottomSheetConfig: BottomSheetConfig(
                    closeIcon: const Icon(Icons.arrow_back_rounded),
                    titleStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    radioActiveColor: Colors.deepPurple,
                    initialHeightFactor: 0.6,
                    expandedHeightFactor: 0.95,
                    searchConfig: SearchConfig(
                      hintText: 'Search country or code',
                      filled: true,
                      fillColor: Colors.deepPurple.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  onChanged: (CountryModel country) {
                    setState(() {
                      selectedCountry = country;
                    });
                  },
                  initialCountryCode: _initialCountryCode,
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
                if (phoneController.text.isEmpty) {
                  return;
                }
                final fullNumber =
                    '${selectedCountry.dialCode}${phoneController.text}';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Phone number: $fullNumber')),
                );
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Country: $countryName'),
                    Text('Dial Code: ${selectedCountry.dialCode}'),
                    Text('ISO Code: ${selectedCountry.isoCode}'),
                    Text('Phone Length: ${selectedCountry.lengthNumber}'),
                    Text('Hint: ${selectedCountry.hintText}'),
                    Text(
                      'Starts With: ${selectedCountry.phoneStartsWith.join(", ")}',
                    ),
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
