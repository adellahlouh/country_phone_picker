import 'package:flutter/material.dart';

import 'country_model.dart';

/// Signature used to override how a country is matched against a search query.
///
/// The [query] is passed exactly as typed by the user.
typedef CountrySearchMatcher = bool Function(CountryModel country, String query);

/// Controls the appearance and behavior of the search field inside the country
/// picker bottom sheet.
///
/// All values have defaults that preserve the package's standard design, so
/// only the properties you want to change need to be provided.
@immutable
class SearchConfig {
  /// Creates a search field configuration.
  const SearchConfig({
    this.enabled = true,
    this.autofocus = false,
    this.matcher,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.bottomSpacing = 8,
    this.contentPadding,
    this.hintText = 'Search',
    this.textStyle,
    this.hintStyle,
    this.cursorColor,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.search,
    this.prefixIcon = const Icon(Icons.search),
    this.showClearButton = true,
    this.clearIcon = const Icon(Icons.clear),
    this.filled = false,
    this.fillColor,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.decoration,
    this.emptyResultText = 'No countries found',
    this.emptyResultStyle,
    this.emptyResultBuilder,
  });

  /// Whether the search field is displayed.
  final bool enabled;

  /// Whether the search field requests focus when the sheet opens.
  final bool autofocus;

  /// Optional replacement for the default filtering logic.
  ///
  /// The default matcher compares the query against the localized country
  /// name, the fallback country name, the ISO code, and the dial code.
  final CountrySearchMatcher? matcher;

  /// Padding around the search field.
  final EdgeInsetsGeometry padding;

  /// Space between the search field and the country list.
  final double bottomSpacing;

  /// Padding inside the search field.
  final EdgeInsetsGeometry? contentPadding;

  /// Placeholder shown while the search field is empty.
  final String hintText;

  /// Style of the typed query.
  final TextStyle? textStyle;

  /// Style of [hintText].
  final TextStyle? hintStyle;

  /// Color of the search field cursor.
  final Color? cursorColor;

  /// Keyboard type used by the search field.
  final TextInputType keyboardType;

  /// Keyboard action button used by the search field.
  final TextInputAction textInputAction;

  /// Optional widget displayed before the query.
  ///
  /// This can be an asset from the host application, for example:
  /// `Image.asset('assets/icons/search.png')`.
  final Widget? prefixIcon;

  /// Whether a button that clears the query is shown while typing.
  final bool showClearButton;

  /// Widget displayed inside the clear button.
  final Widget clearIcon;

  /// Whether the search field is filled with [fillColor].
  final bool filled;

  /// Fill color applied when [filled] is `true`.
  final Color? fillColor;

  /// Border used by the search field in every state.
  final InputBorder? border;

  /// Border used while the search field is enabled and unfocused.
  final InputBorder? enabledBorder;

  /// Border used while the search field is focused.
  final InputBorder? focusedBorder;

  /// Complete decoration override.
  ///
  /// When provided, it replaces the decoration built from [hintText],
  /// [prefixIcon], [filled], and the border properties. The clear button is
  /// still appended unless [decoration] already defines a `suffixIcon`.
  final InputDecoration? decoration;

  /// Message shown when no country matches the query.
  final String emptyResultText;

  /// Style of [emptyResultText].
  final TextStyle? emptyResultStyle;

  /// Optional replacement for the default empty result message.
  final WidgetBuilder? emptyResultBuilder;
}
