import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'country_picker_codes.dart';
import 'country_model.dart';

class CountryPhonePickerBottomSheet extends StatefulWidget {
  final CountryModel selectedCountryCode;
  final String bottomSheetTitle ;


  const CountryPhonePickerBottomSheet({
    super.key,
    required this.selectedCountryCode, required this.bottomSheetTitle,
  });

  @override
  State<CountryPhonePickerBottomSheet> createState() =>
      _CountryPhonePickerBottomSheetState();
}

class _CountryPhonePickerBottomSheetState extends State<CountryPhonePickerBottomSheet> {
   List<CountryModel> countriesList = [];
  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14.0),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  widget.bottomSheetTitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.separated(
                itemCount: countriesList.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  final country = countriesList[index];
                  return _rowWidget(country, context);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _rowWidget(CountryModel country, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, country);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Radio<String>(
                value: country.code.toString(),
                groupValue: widget.selectedCountryCode.code.toString(),
                onChanged: (value) {
                  Navigator.pop(context, country);
                },
              ),
            ),
            CountryFlag.fromCountryCode(
              country.isoCode,
              shape: const RoundedRectangle(4),
              width: 28,
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(
              country.name,

            ),
            const Spacer(),
            Text(
              country.dialCode,
              textDirection: TextDirection.ltr,

            ),
          ],
        ),
      ),
    );
  }

  void initData() {
    countriesList = codes.map((e) => CountryModel.fromJson(e)).toList();
    setState(() {

    });
  }
}
