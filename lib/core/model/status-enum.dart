enum StatusEnum { A, P, I }

extension StatusEnumExtension on StatusEnum {
  static const Map<StatusEnum, String> values = {StatusEnum.A: 'A', StatusEnum.P: 'P', StatusEnum.I: 'I'};

  static const Map<StatusEnum, String> descriptions = {
    StatusEnum.A: 'ACTIVE',
    StatusEnum.P: 'PENDING',
    StatusEnum.I: 'INACTIVE'
  };

  String? get value => values[this];
  String? get description => descriptions[this];

  static StatusEnum? fromRaw(String raw) => values.entries.firstWhere((e) => e.value == raw).key;
}
