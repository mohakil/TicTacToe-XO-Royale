// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreItem _$StoreItemFromJson(Map<String, dynamic> json) => StoreItem(
  id: json['id'] as String,
  category: $enumDecode(_$StoreItemCategoryEnumMap, json['category']),
  name: json['name'] as String,
  desc: json['desc'] as String,
  premium: json['premium'] as bool,
  locked: json['locked'] as bool,
  priceGems: (json['priceGems'] as num?)?.toInt(),
  priceReal: (json['priceReal'] as num?)?.toDouble(),
  previewAsset: json['previewAsset'] as String?,
);

Map<String, dynamic> _$StoreItemToJson(StoreItem instance) => <String, dynamic>{
  'id': instance.id,
  'category': _$StoreItemCategoryEnumMap[instance.category]!,
  'name': instance.name,
  'desc': instance.desc,
  'priceGems': instance.priceGems,
  'priceReal': instance.priceReal,
  'premium': instance.premium,
  'locked': instance.locked,
  'previewAsset': instance.previewAsset,
};

const _$StoreItemCategoryEnumMap = {
  StoreItemCategory.theme: 'theme',
  StoreItemCategory.board: 'board',
  StoreItemCategory.symbol: 'symbol',
  StoreItemCategory.gems: 'gems',
};
