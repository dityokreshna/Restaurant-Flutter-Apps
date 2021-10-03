// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_data_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantDataListElementAdapter
    extends TypeAdapter<RestaurantDataListElement> {
  @override
  final int typeId = 0;

  @override
  RestaurantDataListElement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantDataListElement(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      pictureId: fields[3] as String,
      city: fields[4] as String,
      rating: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantDataListElement obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.pictureId)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantDataListElementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
