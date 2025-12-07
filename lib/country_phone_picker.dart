import 'package:country_flags/country_flags.dart';
import 'package:country_phone_picker/src/country_model.dart';
import 'package:country_phone_picker/src/country_phone_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';

export 'src/country_picker_localizations.dart';
export 'src/country_model.dart';

class CountryPhonePicker extends StatefulWidget {
  final ValueChanged<CountryModel> onChanged;
  final String bottomSheetTitle ;

  const CountryPhonePicker({super.key, required this.onChanged, required this.bottomSheetTitle});

  @override
  State<CountryPhonePicker> createState() => _CountryPhonePickerState();
}

class _CountryPhonePickerState extends State<CountryPhonePicker> {
  CountryModel? selectedCountryModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final CountryModel? model = await showModalBottomSheet(
          context: context,
          isScrollControlled: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          builder: (_) {
            return CountryPhonePickerBottomSheet(
              selectedCountryCode: selectedCountryModel ?? CountryModel.initialModel(),
              bottomSheetTitle: widget.bottomSheetTitle,
            );
          },
        );

        if (model == null) {
          return;
        }
        setState(() {
          selectedCountryModel = model;
          widget.onChanged(selectedCountryModel!);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 14.0),
          CountryFlag.fromCountryCode(
            selectedCountryModel?.isoCode ??
                CountryModel.initialModel().isoCode,
            shape: const RoundedRectangle(4),
            width: 28,
            height: 24,
          ),
          const SizedBox(width: 4.0),
          Text(
            selectedCountryModel?.dialCode ??
                CountryModel.initialModel().dialCode,
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}
