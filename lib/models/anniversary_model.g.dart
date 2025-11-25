// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anniversary_model.dart';

class AnniversaryTypeAdapter extends TypeAdapter<AnniversaryType> {
  @override
  final int typeId = 0;

  @override
  AnniversaryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnniversaryType.birthday;
      case 1:
        return AnniversaryType.anniversary;
      case 2:
        return AnniversaryType.countdown;
      case 3:
        return AnniversaryType.life;
      case 4:
        return AnniversaryType.work;
      default:
        return AnniversaryType.anniversary;
    }
  }

  @override
  void write(BinaryWriter writer, AnniversaryType obj) {
    switch (obj) {
      case AnniversaryType.birthday:
        writer.writeByte(0);
        break;
      case AnniversaryType.anniversary:
        writer.writeByte(1);
        break;
      case AnniversaryType.countdown:
        writer.writeByte(2);
        break;
      case AnniversaryType.life:
        writer.writeByte(3);
        break;
      case AnniversaryType.work:
        writer.writeByte(4);
        break;
    }
  }
}

class ReminderSettingAdapter extends TypeAdapter<ReminderSetting> {
  @override
  final int typeId = 1;

  @override
  ReminderSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderSetting(
      enabled: fields[0] as bool,
      daysBefore: fields[1] as int,
      hour: fields[2] as int,
      minute: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderSetting obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.enabled)
      ..writeByte(1)
      ..write(obj.daysBefore)
      ..writeByte(2)
      ..write(obj.hour)
      ..writeByte(3)
      ..write(obj.minute);
  }
}

class AnniversaryModelAdapter extends TypeAdapter<AnniversaryModel> {
  @override
  final int typeId = 2;

  @override
  AnniversaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnniversaryModel(
      id: fields[0] as String,
      title: fields[1] as String,
      date: fields[2] as DateTime,
      type: fields[3] as AnniversaryType,
      reminder: fields[4] as ReminderSetting,
      colorValue: fields[5] as int?,
      iconName: fields[6] as String?,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AnniversaryModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.reminder)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.iconName)
      ..writeByte(7)
      ..write(obj.createdAt);
  }
}

