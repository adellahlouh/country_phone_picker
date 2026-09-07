import 'package:country_flags/country_flags.dart';
import 'package:country_phone_picker/src/bottom_sheet_config.dart';
import 'package:country_phone_picker/src/country_model.dart';
import 'package:country_phone_picker/src/country_phone_picker_bottom_sheet.dart';
import 'package:country_phone_picker/src/country_picker_codes.dart';
import 'package:flutter/material.dart';

class CountryPhonePicker extends StatefulWidget {
  final ValueChanged<CountryModel> onChanged;
  final String bottomSheetTitle;
  final BottomSheetConfig bottomSheetConfig;

  /// ISO 3166-1 alpha-2 code of the country shown initially (e.g. `'US'`).
  /// Kept in sync when the parent updates it. Defaults to Jordan when null
  /// or unrecognized.
  final String? initialCountryCode;

  const CountryPhonePicker({
    super.key,
    required this.onChanged,
    required this.bottomSheetTitle,
    this.bottomSheetConfig = const BottomSheetConfig(),
    this.initialCountryCode,
  });

  @override
  State<CountryPhonePicker> createState() => _CountryPhonePickerState();
}

class _CountryPhonePickerState extends State<CountryPhonePicker> {
  late CountryModel selectedCountryModel;

  CountryModel _resolveCountry(String? isoCode) {
    if (isoCode == null || isoCode.isEmpty) {
      return CountryModel.initialModel();
    }
    final country = findCountryByIsoCode(isoCode);
    assert(
      country != null,
      'Unknown initialCountryCode "$isoCode"; falling back to Jordan.',
    );
    return country ?? CountryModel.initialModel();
  }

  @override
  void initState() {
    super.initState();
    selectedCountryModel = _resolveCountry(widget.initialCountryCode);
  }

  @override
  void didUpdateWidget(covariant CountryPhonePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCountryCode != oldWidget.initialCountryCode) {
      selectedCountryModel = _resolveCountry(widget.initialCountryCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final CountryModel? model = await showModalBottomSheet(
          context: context,
          // The sheet manages its own height, so it needs the full screen as
          // its upper bound.
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: widget.bottomSheetConfig.backgroundColor,
          elevation: widget.bottomSheetConfig.elevation,
          shape: widget.bottomSheetConfig.shape,
          clipBehavior: widget.bottomSheetConfig.clipBehavior,
          builder: (_) {
            return CountryPhonePickerBottomSheet(
              selectedCountryCode: selectedCountryModel,
              bottomSheetTitle: widget.bottomSheetTitle,
              config: widget.bottomSheetConfig,
            );
          },
        );

        if (!mounted) {
          return;
        }
        if (model == null) {
          return;
        }
        setState(() {
          selectedCountryModel = model;
        });
        widget.onChanged(selectedCountryModel);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 14.0),
          CountryFlag.fromCountryCode(
            selectedCountryModel.isoCode,
            theme: ImageTheme(
              shape: const RoundedRectangle(4),
              width: 28,
              height: 24,
            ),
          ),
          const SizedBox(width: 4.0),
          Text(selectedCountryModel.dialCode, textDirection: TextDirection.ltr),
        ],
      ),
    );
  }
}
