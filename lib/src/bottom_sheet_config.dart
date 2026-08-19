import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'search_config.dart';

/// Controls the appearance of the country picker bottom sheet.
///
/// All values are optional at the [CountryPhonePicker] level because this
/// configuration provides defaults that preserve the package's standard
/// design.
@immutable
class BottomSheetConfig {
  /// Creates a bottom sheet configuration.
  const BottomSheetConfig({
    this.backgroundColor,
    this.elevation,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    this.clipBehavior = Clip.none,
    this.initialHeightFactor = 0.6,
    this.expandedHeightFactor = 0.95,
    this.expandOnSearchTap = true,
    this.expandDuration = const Duration(milliseconds: 250),
    this.expandCurve = Curves.easeOutCubic,
    this.topSpacing = 14,
    this.closeIcon = const Icon(Icons.close_rounded),
    this.closeIconColor,
    this.closeIconSize,
    this.closeButtonPadding = const EdgeInsets.all(8),
    this.closeButtonConstraints,
    this.closeButtonTooltip,
    this.titleStyle,
    this.titleTextAlign = TextAlign.center,
    this.headerBottomSpacing = 4,
    this.searchConfig = const SearchConfig(),
    this.listPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.separator = const Divider(),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 2),
    this.radioScale = 1.1,
    this.radioActiveColor,
    this.flagShape = const RoundedRectangle(4),
    this.flagWidth = 28,
    this.flagHeight = 24,
    this.flagSpacing = 8,
    this.countryNameStyle,
    this.dialCodeStyle,
    this.bottomSpacing = 8,
    this.scrollToSelected = true,
    this.scrollToSelectedAlignment = 0.5,
  }) : assert(
         scrollToSelectedAlignment >= 0 && scrollToSelectedAlignment <= 1,
         'scrollToSelectedAlignment must be between 0 and 1.',
       ),
       assert(
         initialHeightFactor > 0 && initialHeightFactor <= 1,
         'initialHeightFactor must be between 0 and 1.',
       ),
       assert(
         expandedHeightFactor > 0 && expandedHeightFactor <= 1,
         'expandedHeightFactor must be between 0 and 1.',
       ),
       assert(
         expandedHeightFactor >= initialHeightFactor,
         'expandedHeightFactor must be greater than or equal to '
         'initialHeightFactor.',
       );

  /// Background color passed to [showModalBottomSheet].
  final Color? backgroundColor;

  /// Elevation passed to [showModalBottomSheet].
  final double? elevation;

  /// Shape passed to [showModalBottomSheet].
  final ShapeBorder shape;

  /// Clip behavior passed to [showModalBottomSheet].
  final Clip clipBehavior;

  /// Fraction of the available height the sheet occupies when it opens.
  final double initialHeightFactor;

  /// Fraction of the available height the sheet grows to once the search field
  /// is tapped.
  final double expandedHeightFactor;

  /// Whether tapping the search field grows the sheet before the keyboard is
  /// shown.
  ///
  /// When `false` the sheet keeps [initialHeightFactor] and the keyboard opens
  /// on the first tap.
  final bool expandOnSearchTap;

  /// Duration of the growth animation.
  ///
  /// The keyboard is requested once this animation completes, so the sheet is
  /// already at its expanded height when the keyboard slides in.
  final Duration expandDuration;

  /// Curve of the growth animation.
  final Curve expandCurve;

  /// Space above the header.
  final double topSpacing;

  /// Widget displayed inside the dismiss button.
  ///
  /// This can be an asset from the host application, for example:
  /// `Image.asset('assets/icons/close.png')`.
  final Widget closeIcon;

  /// Optional color applied by the dismiss [IconButton].
  final Color? closeIconColor;

  /// Optional size applied by the dismiss [IconButton].
  final double? closeIconSize;

  /// Padding inside the dismiss [IconButton].
  final EdgeInsetsGeometry closeButtonPadding;

  /// Optional constraints for the dismiss [IconButton].
  final BoxConstraints? closeButtonConstraints;

  /// Optional accessibility tooltip for the dismiss button.
  final String? closeButtonTooltip;

  /// Style of the bottom sheet title.
  final TextStyle? titleStyle;

  /// Alignment of text within the title.
  final TextAlign titleTextAlign;

  /// Space between the header and the search field.
  final double headerBottomSpacing;

  /// Appearance and behavior of the search field.
  final SearchConfig searchConfig;

  /// Padding around the country list.
  final EdgeInsetsGeometry listPadding;

  /// Widget displayed between country rows.
  final Widget separator;

  /// Padding inside each country row.
  final EdgeInsetsGeometry itemPadding;

  /// Scale applied to each country selection radio.
  final double radioScale;

  /// Active color of the selected country radio.
  final Color? radioActiveColor;

  /// Shape used to display country flags.
  final Shape flagShape;

  /// Width of country flags.
  final double flagWidth;

  /// Height of country flags.
  final double flagHeight;

  /// Space between a flag and its country name.
  final double flagSpacing;

  /// Style of country names.
  final TextStyle? countryNameStyle;

  /// Style of country dial codes.
  final TextStyle? dialCodeStyle;

  /// Space below the country list.
  final double bottomSpacing;

  /// Whether the list scrolls to the selected country when the sheet opens.
  final bool scrollToSelected;

  /// Where the selected country is placed in the viewport by that scroll.
  ///
  /// `0` aligns it with the top of the list, `0.5` centers it, and `1` aligns it
  /// with the bottom.
  final double scrollToSelectedAlignment;
}

/// Former name of [BottomSheetConfig].
@Deprecated('Renamed to BottomSheetConfig. Will be removed in a future release.')
typedef CountryPhonePickerBottomSheetConfig = BottomSheetConfig;
