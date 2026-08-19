import 'package:country_phone_picker/country_phone_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildPicker({
  BottomSheetConfig config = const BottomSheetConfig(),
  ValueChanged<CountryModel>? onChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: CountryPhonePicker(
        bottomSheetTitle: 'Choose Country',
        bottomSheetConfig: config,
        onChanged: onChanged ?? (_) {},
      ),
    ),
  );
}

Future<void> _openSheet(WidgetTester tester) async {
  await tester.tap(find.byType(CountryPhonePicker));
  await tester.pumpAndSettle();
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(find.byType(TextField), query);
  await tester.pumpAndSettle();
}

/// Restricts a finder to the country list, since the collapsed picker and the
/// search field also render dial codes and names.
Finder _inList(Finder finder) {
  return find.descendant(of: find.byType(ListView), matching: finder);
}

void main() {
  test('does not claim locales that have no bundled translations', () {
    expect(
      CountryPickerLocalizations.delegate.isSupported(const Locale('tk')),
      isFalse,
    );
    expect(
      CountryPickerLocalizations.delegate.isSupported(const Locale('en')),
      isTrue,
    );
  });

  testWidgets('loads bundled English translations from package assets', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          CountryPickerLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            return Text(
              CountryPickerLocalizations.of(context)?.translate('JO') ??
                  'missing',
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Jordan'), findsOneWidget);
  });

  testWidgets('uses the standard design and dismisses from the close button', (
    tester,
  ) async {
    await tester.pumpWidget(_buildPicker());

    await _openSheet(tester);

    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.text('Choose Country'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Choose Country'), findsNothing);
  });

  testWidgets('applies custom close content and title styling', (tester) async {
    const closeIconKey = Key('host-close-icon');
    const titleStyle = TextStyle(
      color: Colors.purple,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    await tester.pumpWidget(
      _buildPicker(
        config: const BottomSheetConfig(
          closeIcon: SizedBox(key: closeIconKey, width: 18, height: 18),
          titleStyle: titleStyle,
          radioActiveColor: Colors.purple,
        ),
      ),
    );

    await _openSheet(tester);

    expect(find.byKey(closeIconKey), findsOneWidget);
    expect(tester.widget<Text>(find.text('Choose Country')).style, titleStyle);

    await tester.tap(
      find.ancestor(
        of: find.byKey(closeIconKey),
        matching: find.byType(IconButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose Country'), findsNothing);
  });

  testWidgets('returns the country selected from the configured sheet', (
    tester,
  ) async {
    CountryModel? selectedCountry;
    await tester.pumpWidget(
      _buildPicker(onChanged: (country) => selectedCountry = country),
    );

    await _openSheet(tester);
    await tester.tap(_inList(find.text('+964')));
    await tester.pumpAndSettle();

    expect(selectedCountry?.isoCode, 'IQ');
    expect(selectedCountry?.dialCode, '+964');
  });

  testWidgets('shows the search field with its configured hint', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildPicker(
        config: const BottomSheetConfig(
          searchConfig: SearchConfig(hintText: 'Search country'),
        ),
      ),
    );

    await _openSheet(tester);

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search country'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('filters the country list by name', (tester) async {
    await tester.pumpWidget(_buildPicker());

    await _openSheet(tester);
    // Names fall back to the package data when no translations are registered.
    await _search(tester, 'الأردن');

    expect(_inList(find.text('الأردن')), findsOneWidget);
    expect(_inList(find.text('+962')), findsOneWidget);
    expect(_inList(find.text('+964')), findsNothing);
  });

  testWidgets('filters the country list by dial code and iso code', (
    tester,
  ) async {
    await tester.pumpWidget(_buildPicker());

    await _openSheet(tester);
    await _search(tester, '+964');

    expect(_inList(find.text('+964')), findsOneWidget);
    expect(_inList(find.text('+962')), findsNothing);

    await _search(tester, 'jo');

    expect(_inList(find.text('+962')), findsOneWidget);
    expect(_inList(find.text('+964')), findsNothing);
  });

  testWidgets('clear button restores the full country list', (tester) async {
    await tester.pumpWidget(_buildPicker());

    await _openSheet(tester);
    expect(find.byIcon(Icons.clear), findsNothing);

    await _search(tester, 'jo');
    expect(_inList(find.text('+964')), findsNothing);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      '',
    );
    expect(_inList(find.text('+964')), findsOneWidget);
  });

  testWidgets('shows the empty result message when nothing matches', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildPicker(
        config: const BottomSheetConfig(
          searchConfig: SearchConfig(emptyResultText: 'Nothing here'),
        ),
      ),
    );

    await _openSheet(tester);
    await _search(tester, 'zzzzzz');

    expect(find.text('Nothing here'), findsOneWidget);
    expect(_inList(find.text('+962')), findsNothing);
  });

  testWidgets('uses a custom matcher when provided', (tester) async {
    await tester.pumpWidget(
      _buildPicker(
        config: BottomSheetConfig(
          searchConfig: SearchConfig(
            matcher: (country, query) => country.isoCode == 'IQ',
          ),
        ),
      ),
    );

    await _openSheet(tester);
    await _search(tester, 'jo');

    expect(_inList(find.text('+964')), findsOneWidget);
    expect(_inList(find.text('+962')), findsNothing);
  });

  testWidgets('keeps the search field above the keyboard', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(viewInsets: EdgeInsets.only(bottom: 300)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 500,
              child: Material(
                child: CountryPhonePickerBottomSheet(
                  selectedCountryCode: CountryModel(
                    code: 85,
                    name: 'Jordan',
                    isoCode: 'JO',
                    dialCode: '+962',
                    hintText: '77-XXXXXXX',
                    lengthNumber: 9,
                    phoneStartsWith: ['77'],
                  ),
                  bottomSheetTitle: 'Choose Country',
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final searchBottom = tester.getRect(find.byType(TextField)).bottom;
    final keyboardTop = tester.getSize(find.byType(MaterialApp)).height - 300;

    expect(tester.takeException(), isNull);
    expect(searchBottom, lessThan(keyboardTop));
  });

  testWidgets('opens at the configured height and grows on a search tap', (
    tester,
  ) async {
    const config = BottomSheetConfig(
      initialHeightFactor: 0.5,
      expandedHeightFactor: 0.9,
    );
    await tester.pumpWidget(_buildPicker(config: config));

    await _openSheet(tester);

    final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
    final sheet = find.byType(CountryPhonePickerBottomSheet);
    expect(tester.getSize(sheet).height, closeTo(screenHeight * 0.5, 0.5));

    // The collapsed field is behind an absorber, so the tap lands on the
    // gesture detector that grows the sheet.
    await tester.tap(find.byType(TextField), warnIfMissed: false);
    await tester.pump();

    // The keyboard is only requested once the sheet reached its full height.
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isFalse,
    );

    await tester.pumpAndSettle();

    expect(tester.getSize(sheet).height, closeTo(screenHeight * 0.9, 0.5));
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );
  });

  testWidgets('returns to its initial height when the keyboard closes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildPicker(
        config: const BottomSheetConfig(
          initialHeightFactor: 0.5,
          expandedHeightFactor: 0.9,
        ),
      ),
    );

    await _openSheet(tester);
    await tester.tap(find.byType(TextField), warnIfMissed: false);
    await tester.pumpAndSettle();

    final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
    final sheet = find.byType(CountryPhonePickerBottomSheet);
    expect(tester.getSize(sheet).height, closeTo(screenHeight * 0.9, 0.5));

    tester.widget<EditableText>(find.byType(EditableText)).focusNode.unfocus();
    await tester.pumpAndSettle();

    expect(tester.getSize(sheet).height, closeTo(screenHeight * 0.5, 0.5));
  });

  testWidgets('keeps the sheet at its initial height when expansion is off', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildPicker(
        config: const BottomSheetConfig(
          initialHeightFactor: 0.5,
          expandOnSearchTap: false,
        ),
      ),
    );

    await _openSheet(tester);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
    expect(
      tester.getSize(find.byType(CountryPhonePickerBottomSheet)).height,
      closeTo(screenHeight * 0.5, 0.5),
    );
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );
  });

  testWidgets('opens scrolled to the selected country', (tester) async {
    const selected = CountryModel(
      code: 187,
      name: 'United States',
      isoCode: 'US',
      dialCode: '+1',
      hintText: '(XXX) XXX-XXXX',
      lengthNumber: 10,
      phoneStartsWith: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountryPhonePicker(
            bottomSheetTitle: 'Choose Country',
            initialCountry: selected,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await _openSheet(tester);

    final selectedRow = _inList(find.text('United States'));
    expect(selectedRow, findsOneWidget);

    final listRect = tester.getRect(find.byType(ListView));
    final rowCenter = tester.getRect(selectedRow).center.dy;
    expect(rowCenter, closeTo(listRect.center.dy, 4));
  });

  testWidgets('stays at the top when scrolling to the selection is off', (
    tester,
  ) async {
    const selected = CountryModel(
      code: 187,
      name: 'United States',
      isoCode: 'US',
      dialCode: '+1',
      hintText: '(XXX) XXX-XXXX',
      lengthNumber: 10,
      phoneStartsWith: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountryPhonePicker(
            bottomSheetTitle: 'Choose Country',
            initialCountry: selected,
            bottomSheetConfig: const BottomSheetConfig(
              scrollToSelected: false,
            ),
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await _openSheet(tester);

    expect(_inList(find.text('United States')), findsNothing);
  });

  testWidgets('hides the search field when search is disabled', (tester) async {
    await tester.pumpWidget(
      _buildPicker(
        config: const BottomSheetConfig(
          searchConfig: SearchConfig(enabled: false),
        ),
      ),
    );

    await _openSheet(tester);

    expect(find.byType(TextField), findsNothing);
    expect(_inList(find.text('+962')), findsOneWidget);
  });
}
