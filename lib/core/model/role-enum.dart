// ignore_for_file: constant_identifier_names
enum RoleEnum {
  ROLE_ADMIN,
  ROLE_USER,
  ROLE_ICEMAN,
}

extension RoleEnumEnumExtension on RoleEnum {

  static const Map<RoleEnum, String> values = {
    RoleEnum.ROLE_ADMIN: 'ROLE_ADMIN',
    RoleEnum.ROLE_USER: 'ROLE_USER',
    RoleEnum.ROLE_ICEMAN: 'ROLE_ICEMAN',
  };

  String? get value => values[this];

  static RoleEnum? fromRaw(String raw) =>
      values.entries.firstWhere((e) => e.value == raw).key;
}