import 'dart:math' as math;

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet_config.dart';
import 'country_model.dart';
import 'country_picker_codes.dart';
import 'country_picker_localizations.dart';
import 'search_config.dart';

class CountryPhonePickerBottomSheet extends StatefulWidget {
  final CountryModel selectedCountryCode;
  final String bottomSheetTitle;
  final BottomSheetConfig config;

  const CountryPhonePickerBottomSheet({
    super.key,
    required this.selectedCountryCode,
    required this.bottomSheetTitle,
    this.config = const BottomSheetConfig(),
  });

  @override
  State<CountryPhonePickerBottomSheet> createState() =>
      _CountryPhonePickerBottomSheetState();
}

class _CountryPhonePickerBottomSheetState
    extends State<CountryPhonePickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _firstItemKey = GlobalKey();
  final GlobalKey _firstSeparatorKey = GlobalKey();
  final GlobalKey _selectedItemKey = GlobalKey();
  late final List<CountryModel> countriesList;
  late List<CountryModel> _visibleCountries;
  String _query = '';
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    countriesList = allCountries;
    _visibleCountries = countriesList;
    _expanded = widget.config.searchConfig.autofocus;
    _searchFocusNode.addListener(_handleSearchFocusChange);
    if (widget.config.scrollToSelected) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToSelectedCountry(),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_handleSearchFocusChange);
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Brings the current selection into view when the sheet opens, so the user
  /// does not have to scroll through the whole list to find it again.
  void _scrollToSelectedCountry() {
    if (!mounted || !_scrollController.hasClients) {
      return;
    }

    final index = countriesList.indexWhere(
      (country) => country.isoCode == widget.selectedCountryCode.isoCode,
    );
    // The first row is already at the top of the list.
    if (index <= 0) {
      return;
    }

    final itemExtent = _renderedHeight(_firstItemKey);
    if (itemExtent == null) {
      return;
    }
    final separatorExtent = _renderedHeight(_firstSeparatorKey) ?? 0;

    final alignment = widget.config.scrollToSelectedAlignment;
    final position = _scrollController.position;
    final target =
        index * (itemExtent + separatorExtent) -
        (position.viewportDimension - itemExtent) * alignment;
    _scrollController.jumpTo(
      target.clamp(position.minScrollExtent, position.maxScrollExtent),
    );

    // Rows are measured from the first one, so any sub-pixel difference adds up
    // over the list. Once the selected row is built it corrects the position.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedContext = _selectedItemKey.currentContext;
      if (!mounted || selectedContext == null) {
        return;
      }
      Scrollable.ensureVisible(
        selectedContext,
        alignment: alignment,
        duration: Duration.zero,
      );
    });
  }

  double? _renderedHeight(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.size.height;
    }
    return null;
  }

  /// Ties the sheet height to the search focus, so it also grows when the field
  /// is focused without a tap, such as by autofocus, and shrinks back once the
  /// keyboard is gone.
  void _handleSearchFocusChange() {
    if (!widget.config.expandOnSearchTap) {
      return;
    }
    final hasFocus = _searchFocusNode.hasFocus;
    if (hasFocus != _expanded) {
      setState(() => _expanded = hasFocus);
    }
  }

  void _handleKeyboardDismissed() {
    if (_expanded && mounted) {
      _searchFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = CountryPickerLocalizations.of(context);
    final config = widget.config;
    final searchConfig = config.searchConfig;
    final selectedIsoCode = widget.selectedCountryCode.isoCode;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: config.topSpacing),
        Row(
          children: [
            const SizedBox(width: 16),
            Text(
              widget.bottomSheetTitle,
              textAlign: config.titleTextAlign,
              style: config.titleStyle,
            ),
            const Spacer(),
            IconButton(
              icon: config.closeIcon,
              color: config.closeIconColor,
              iconSize: config.closeIconSize,
              padding: config.closeButtonPadding,
              constraints: config.closeButtonConstraints,
              tooltip: config.closeButtonTooltip,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        SizedBox(height: config.headerBottomSpacing),
        if (searchConfig.enabled) ...[
          Padding(
            padding: searchConfig.padding,
            child: _searchField(searchConfig),
          ),
          SizedBox(height: searchConfig.bottomSpacing),
        ],
        Expanded(
          child: _visibleCountries.isEmpty
              ? _emptyResultWidget(searchConfig)
              : ListView.separated(
                  controller: _scrollController,
                  itemCount: _visibleCountries.length,
                  padding: config.listPadding,
                  itemBuilder: (_, index) {
                    final country = _visibleCountries[index];
                    final row = _CountryRow(
                      country: country,
                      displayName:
                          localizations?.translate(country.isoCode) ??
                          country.name,
                      selectedIsoCode: selectedIsoCode,
                      config: config,
                    );
                    final key = _measureKeyFor(index, country);
                    return key == null
                        ? row
                        : KeyedSubtree(key: key, child: row);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return index == 0
                        ? KeyedSubtree(
                            key: _firstSeparatorKey,
                            child: config.separator,
                          )
                        : config.separator;
                  },
                ),
        ),
        SizedBox(height: config.bottomSpacing),
      ],
    );

    return _KeyboardAwareSheetSize(
      config: config,
      expanded: _expanded,
      offsetForKeyboard: searchConfig.enabled,
      onKeyboardDismissed: _handleKeyboardDismissed,
      child: content,
    );
  }

  /// Grows the sheet first and only then asks for the keyboard, so the list is
  /// not resized twice while the keyboard slides in.
  Future<void> _handleSearchTap() async {
    if (!_expanded) {
      setState(() => _expanded = true);
      await Future<void>.delayed(widget.config.expandDuration);
      if (!mounted) {
        return;
      }
    }
    _searchFocusNode.requestFocus();
  }

  Widget _searchField(SearchConfig searchConfig) {
    final clearButton = searchConfig.showClearButton && _query.isNotEmpty
        ? IconButton(
            icon: searchConfig.clearIcon,
            onPressed: () {
              _searchController.clear();
              _updateQuery('');
            },
          )
        : null;

    final decoration =
        searchConfig.decoration ??
        InputDecoration(
          hintText: searchConfig.hintText,
          hintStyle: searchConfig.hintStyle,
          prefixIcon: searchConfig.prefixIcon,
          contentPadding: searchConfig.contentPadding,
          filled: searchConfig.filled,
          fillColor: searchConfig.fillColor,
          border: searchConfig.border,
          enabledBorder: searchConfig.enabledBorder,
          focusedBorder: searchConfig.focusedBorder,
        );

    final field = TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      autofocus: searchConfig.autofocus,
      style: searchConfig.textStyle,
      cursorColor: searchConfig.cursorColor,
      keyboardType: searchConfig.keyboardType,
      textInputAction: searchConfig.textInputAction,
      decoration: decoration.suffixIcon == null
          ? decoration.copyWith(suffixIcon: clearButton)
          : decoration,
      onChanged: _updateQuery,
    );

    if (!widget.config.expandOnSearchTap || _expanded) {
      return field;
    }

    // While collapsed the field must not take focus on its own, otherwise the
    // keyboard would open before the sheet finished growing.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleSearchTap,
      child: AbsorbPointer(child: field),
    );
  }

  /// Row extents are read from the first row, and the selected row is tracked so
  /// the initial scroll can land exactly on it.
  GlobalKey? _measureKeyFor(int index, CountryModel country) {
    if (index == 0) {
      return _firstItemKey;
    }
    if (country.isoCode == widget.selectedCountryCode.isoCode) {
      return _selectedItemKey;
    }
    return null;
  }

  Widget _emptyResultWidget(SearchConfig searchConfig) {
    if (searchConfig.emptyResultBuilder != null) {
      return searchConfig.emptyResultBuilder!(context);
    }

    return Center(
      child: Padding(
        padding: widget.config.listPadding,
        child: Text(
          searchConfig.emptyResultText,
          textAlign: TextAlign.center,
          style: searchConfig.emptyResultStyle,
        ),
      ),
    );
  }

  void _updateQuery(String value) {
    setState(() {
      _query = value;
      _visibleCountries = _filterCountries(
        CountryPickerLocalizations.of(context),
      );
    });
  }

  List<CountryModel> _filterCountries(
    CountryPickerLocalizations? localizations,
  ) {
    final searchConfig = widget.config.searchConfig;
    if (!searchConfig.enabled || _query.trim().isEmpty) {
      return countriesList;
    }

    final matcher = searchConfig.matcher;
    if (matcher != null) {
      return countriesList
          .where((country) => matcher(country, _query))
          .toList(growable: false);
    }

    final query = _query.trim().toLowerCase();
    final digitsQuery = CountryModel.digitsOnly(query);

    return countriesList.where((country) {
      final localizedName = localizations?.translate(country.isoCode);
      final matchesName =
          (localizedName?.toLowerCase().contains(query) ?? false) ||
          country.nameLower.contains(query) ||
          country.isoLower.contains(query);

      if (matchesName) {
        return true;
      }

      return digitsQuery.isNotEmpty &&
          country.dialDigits.contains(digitsQuery);
    }).toList(growable: false);
  }
}

/// Sizes the sheet from keyboard and screen metrics so the list content is not
/// rebuilt on every inset tick.
class _KeyboardAwareSheetSize extends StatefulWidget {
  final BottomSheetConfig config;
  final bool expanded;
  final bool offsetForKeyboard;
  final VoidCallback onKeyboardDismissed;
  final Widget child;

  const _KeyboardAwareSheetSize({
    required this.config,
    required this.expanded,
    required this.offsetForKeyboard,
    required this.onKeyboardDismissed,
    required this.child,
  });

  @override
  State<_KeyboardAwareSheetSize> createState() =>
      _KeyboardAwareSheetSizeState();
}

class _KeyboardAwareSheetSizeState extends State<_KeyboardAwareSheetSize> {
  bool _keyboardVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncKeyboardVisibility();
  }

  @override
  void didUpdateWidget(covariant _KeyboardAwareSheetSize oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncKeyboardVisibility();
  }

  void _syncKeyboardVisibility() {
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    if (keyboardVisible == _keyboardVisible) {
      return;
    }
    _keyboardVisible = keyboardVisible;

    // The keyboard can be dismissed without the field losing focus, for
    // instance with the Android back button or an iOS swipe, so the sheet also
    // collapses from the keyboard metrics.
    if (!keyboardVisible && widget.expanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onKeyboardDismissed();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.sizeOf(context);
        final padding = MediaQuery.paddingOf(context);
        final keyboardInset = widget.offsetForKeyboard
            ? MediaQuery.viewInsetsOf(context).bottom
            : 0.0;
        final available = math.min(
          size.height - padding.top,
          constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : double.infinity,
        );
        final factor = widget.expanded
            ? widget.config.expandedHeightFactor
            : widget.config.initialHeightFactor;
        // The keyboard is added on top of the requested fraction so the list
        // keeps its size, then clamped so the sheet never exceeds the screen.
        final height = math.min(available * factor + keyboardInset, available);

        return AnimatedContainer(
          duration: widget.config.expandDuration,
          curve: widget.config.expandCurve,
          height: height,
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardInset),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _CountryRow extends StatelessWidget {
  final CountryModel country;
  final String displayName;
  final String selectedIsoCode;
  final BottomSheetConfig config;

  const _CountryRow({
    required this.country,
    required this.displayName,
    required this.selectedIsoCode,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: InkWell(
        onTap: () {
          Navigator.pop(context, country);
        },
        child: Padding(
          padding: config.itemPadding,
          child: Row(
            children: [
              Transform.scale(
                scale: config.radioScale,
                child: Radio<String>(
                  value: country.isoCode,
                  // Kept for compatibility with the package's Flutter minimum.
                  // ignore: deprecated_member_use
                  groupValue: selectedIsoCode,
                  activeColor: config.radioActiveColor,
                  // ignore: deprecated_member_use
                  onChanged: (value) {
                    Navigator.pop(context, country);
                  },
                ),
              ),
              CountryFlag.fromCountryCode(
                country.isoCode,
                shape: config.flagShape,
                width: config.flagWidth,
                height: config.flagHeight,
              ),
              SizedBox(width: config.flagSpacing),
              Expanded(
                child: Text(displayName, style: config.countryNameStyle),
              ),
              Text(
                country.dialCode,
                textDirection: TextDirection.ltr,
                style: config.dialCodeStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
