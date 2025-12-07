import 'package:flutter/material.dart';
import 'package:country_phone_picker/country_phone_picker.dart';
import 'package:country_phone_picker/country_phone_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
                  bottomSheetTitle: 'Choose Country',
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


