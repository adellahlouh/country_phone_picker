class CountryModel {
  static final RegExp _nonDigits = RegExp(r'\D');

  final int code;
  final String name;
  final String isoCode;
  final String dialCode;
  final String? hintText;
  final int lengthNumber;
  final List<String> phoneStartsWith;

  const CountryModel({
    required this.code,
    required this.name,
    required this.isoCode,
    required this.dialCode,
    required this.hintText,
    required this.lengthNumber,
    required this.phoneStartsWith,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      code: json['code'],
      name: json['name'],
      isoCode: json['isoCode'],
      dialCode: json['dialCode'],
      hintText: json['hintText'] ?? '',
      lengthNumber: json['lengthNumber'],
      phoneStartsWith: List<String>.from(json['phoneStartsWith']),
    );
  }

  String get nameLower => name.toLowerCase();

  String get isoLower => isoCode.toLowerCase();

  String get dialDigits => dialCode.replaceAll(_nonDigits, '');

  static String digitsOnly(String value) => value.replaceAll(_nonDigits, '');

  factory CountryModel.initialModel() {
    return const CountryModel(
      code: 85,
      name: 'Jordan',
      isoCode: 'JO',
      dialCode: '+962',
      hintText: '7X-XXXXXXX',
      lengthNumber: 9,
      phoneStartsWith: ["77", "78", "79"],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryModel &&
        other.code == code &&
        other.name == name &&
        other.isoCode == isoCode &&
        other.dialCode == dialCode &&
        other.hintText == hintText &&
        other.lengthNumber == lengthNumber &&
        _listEquals(other.phoneStartsWith, phoneStartsWith);
  }

  @override
  int get hashCode => Object.hash(
    code,
    name,
    isoCode,
    dialCode,
    hintText,
    lengthNumber,
    Object.hashAll(phoneStartsWith),
  );
}

bool _listEquals(List<String> a, List<String> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
