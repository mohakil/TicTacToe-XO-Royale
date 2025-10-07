import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store_item.g.dart';

enum StoreItemCategory { theme, board, symbol, gems }

@JsonSerializable()
@immutable
class StoreItem {
  const StoreItem({
    required this.id,
    required this.category,
    required this.name,
    required this.desc,
    required this.premium,
    required this.locked,
    this.priceGems,
    this.priceReal,
    this.previewAsset,
  });

  final String id;
  final StoreItemCategory category;
  final String name;
  final String desc;
  final int? priceGems;
  final double? priceReal;
  final bool premium;
  final bool locked;
  final String? previewAsset;

  // Backward compatibility getters for tests
  String get itemId => id;
  int get quantity => 1; // Default quantity for store items

  factory StoreItem.fromJson(Map<String, dynamic> json) =>
      _$StoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemToJson(this);

  // Copy with method for immutable updates
  StoreItem copyWith({
    String? id,
    StoreItemCategory? category,
    String? name,
    String? desc,
    int? priceGems,
    double? priceReal,
    bool? premium,
    bool? locked,
    String? previewAsset,
  }) => StoreItem(
    id: id ?? this.id,
    category: category ?? this.category,
    name: name ?? this.name,
    desc: desc ?? this.desc,
    priceGems: priceGems ?? this.priceGems,
    priceReal: priceReal ?? this.priceReal,
    premium: premium ?? this.premium,
    locked: locked ?? this.locked,
    previewAsset: previewAsset ?? this.previewAsset,
  );

  bool get isPurchasable => !locked && (priceGems != null || priceReal != null);
  bool get isGemPurchase => priceGems != null && !locked;
  bool get isRealMoneyPurchase => priceReal != null && !locked;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          category == other.category &&
          name == other.name &&
          desc == other.desc &&
          priceGems == other.priceGems &&
          priceReal == other.priceReal &&
          premium == other.premium &&
          locked == other.locked &&
          previewAsset == other.previewAsset;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    category,
    name,
    desc,
    priceGems,
    priceReal,
    premium,
    locked,
    previewAsset,
  );

  @override
  String toString() =>
      'StoreItem(id: $id, category: $category, name: $name, desc: $desc, priceGems: $priceGems, priceReal: $priceReal, premium: $premium, locked: $locked, previewAsset: $previewAsset)';
}
