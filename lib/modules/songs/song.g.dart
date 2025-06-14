// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongImpl _$$SongImplFromJson(Map<String, dynamic> json) => _$SongImpl(
      name: json['name'] as String,
      artistName: json['artistName'] as String,
      albumImageUrl: json['albumImageUrl'] as String,
      previewUrl: json['previewUrl'] as String?,
    );

Map<String, dynamic> _$$SongImplToJson(_$SongImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'artistName': instance.artistName,
      'albumImageUrl': instance.albumImageUrl,
      'previewUrl': instance.previewUrl,
    };
