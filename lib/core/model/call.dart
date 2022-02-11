// ignore_for_file: constant_identifier_names
import 'package:intl/intl.dart';
import 'package:pops_app/core/model/status-enum.dart';
import 'package:pops_app/core/model/user.dart';

class Call {
  static const String ID = 'id';
  static const String ACTIVE = 'active';
  static const String RECEIVER = 'receiver';
  static const String CALLER = 'caller';
  static const String START_TIME = 'startTime';
  static const String END_TIME = 'endTime';
  static const String STATUS = 'status';

  String? id;
  bool? active;
  User? receiver;
  User? caller;
  DateTime? startTime;
  DateTime? endTime;
  StatusEnum? status;

  Call({
    this.id,
    this.active,
    this.receiver,
    this.caller,
    this.startTime,
    this.endTime,
    this.status,
  });

  static Call fromJson(Map<String, dynamic> json) => Call(
        id: json[ID] as String?,
        active: json[ACTIVE] as bool?,
        receiver: json[RECEIVER] != null ? User.fromJson(json[RECEIVER]) : null,
        caller: json[CALLER] != null ? User.fromJson(json[CALLER]) : null,
        startTime: json[START_TIME] != null
            ? DateTime.parse(json[START_TIME]).toLocal()
            : json[START_TIME],
        endTime: json[END_TIME] != null
            ? DateTime.parse(json[END_TIME]).toLocal()
            : json[END_TIME],
        status: json[STATUS] != null
            ? StatusEnum.values.where((a) => a.value == json[STATUS]).first
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      ACTIVE: active,
      RECEIVER: receiver != null ? receiver!.toJson() : receiver,
      CALLER: caller != null ? caller!.toJson() : caller,
      START_TIME: startTime != null
          ? DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS').format(startTime!)
          : startTime,
      END_TIME: endTime != null
          ? DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS').format(endTime!)
          : endTime,
      STATUS: status,
    };
  }
}
