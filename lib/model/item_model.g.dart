// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imgUrl: json['imgUrl'] as String?,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'imgUrl': instance.imgUrl,
    };
