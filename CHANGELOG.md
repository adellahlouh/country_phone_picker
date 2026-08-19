## 0.0.2

* Search countries in the bottom sheet by name, dial code, or ISO code.
* Add `SearchConfig` to style the search field, hide it, change the empty message, or replace the filter.
* Add `BottomSheetConfig` to style the sheet (title, close button, flags, list, colors).
* The old name `CountryPhonePickerBottomSheetConfig` still works, but is deprecated.
* The sheet opens at 60% of the screen, grows when search is tapped, then shrinks when the keyboard closes.
* Add `initialHeightFactor`, `expandedHeightFactor`, `expandOnSearchTap`, `expandDuration`, and `expandCurve` to control that height.
* The search field stays above the keyboard after the sheet grows.
* Add `initialCountry` to set the country shown before the user picks one.
* The sheet now opens scrolled to the selected country, with `scrollToSelected` and `scrollToSelectedAlignment` to control it.
* `CountryModel` now supports `==` and `hashCode`.
* Update Jordan’s phone hint to `7X-XXXXXXX`.
* Fix performance issues in the bottom sheet: parse the country list once, filter only when the search query changes, and avoid rebuilding the list on every keyboard frame.

## 0.0.1

* First release: pick a country and get its flag, name, ISO code, and dial code.
* Localized country names and a customizable bottom sheet title.
