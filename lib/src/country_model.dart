class CountryModel {
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

  factory CountryModel.initialModel() {
    return const CountryModel(
      code: 85,
      name: 'Jordan',
      isoCode: 'JO',
      dialCode: '+962',
      hintText: '77-XXXXXXX',
      lengthNumber: 9,
      phoneStartsWith: ["77", "78", "79"],
    );
  }
}
