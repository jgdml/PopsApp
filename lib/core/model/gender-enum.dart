enum GenderEnum {
  M,
  F,
  O,
}

extension GenderEnumExtension on GenderEnum {

  static const Map<GenderEnum, String> values = {
    GenderEnum.M: 'M',
    GenderEnum.F: 'F',
    GenderEnum.O: 'O',
  };

  static const Map<GenderEnum, String> descriptions = {
    GenderEnum.M: 'Male',
    GenderEnum.F: 'Female',
    GenderEnum.O: 'Other',
  };

  String? get value => values[this];
  String? get description => descriptions[this];

  static GenderEnum? fromRaw(String raw) =>
      values.entries.firstWhere((e) => e.value == raw).key;
}
