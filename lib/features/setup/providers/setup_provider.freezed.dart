// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setup_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameSetup {

 GameMode get mode; String get player1Name; String get player2Name; FirstMove get firstMove; Difficulty get difficulty; BoardSize get boardSize; WinCondition get winCondition;
/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameSetupCopyWith<GameSetup> get copyWith => _$GameSetupCopyWithImpl<GameSetup>(this as GameSetup, _$identity);

  /// Serializes this GameSetup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSetup&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.player1Name, player1Name) || other.player1Name == player1Name)&&(identical(other.player2Name, player2Name) || other.player2Name == player2Name)&&(identical(other.firstMove, firstMove) || other.firstMove == firstMove)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.boardSize, boardSize) || other.boardSize == boardSize)&&(identical(other.winCondition, winCondition) || other.winCondition == winCondition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,player1Name,player2Name,firstMove,difficulty,boardSize,winCondition);

@override
String toString() {
  return 'GameSetup(mode: $mode, player1Name: $player1Name, player2Name: $player2Name, firstMove: $firstMove, difficulty: $difficulty, boardSize: $boardSize, winCondition: $winCondition)';
}


}

/// @nodoc
abstract mixin class $GameSetupCopyWith<$Res>  {
  factory $GameSetupCopyWith(GameSetup value, $Res Function(GameSetup) _then) = _$GameSetupCopyWithImpl;
@useResult
$Res call({
 GameMode mode, String player1Name, String player2Name, FirstMove firstMove, Difficulty difficulty, BoardSize boardSize, WinCondition winCondition
});




}
/// @nodoc
class _$GameSetupCopyWithImpl<$Res>
    implements $GameSetupCopyWith<$Res> {
  _$GameSetupCopyWithImpl(this._self, this._then);

  final GameSetup _self;
  final $Res Function(GameSetup) _then;

/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? player1Name = null,Object? player2Name = null,Object? firstMove = null,Object? difficulty = null,Object? boardSize = null,Object? winCondition = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GameMode,player1Name: null == player1Name ? _self.player1Name : player1Name // ignore: cast_nullable_to_non_nullable
as String,player2Name: null == player2Name ? _self.player2Name : player2Name // ignore: cast_nullable_to_non_nullable
as String,firstMove: null == firstMove ? _self.firstMove : firstMove // ignore: cast_nullable_to_non_nullable
as FirstMove,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,boardSize: null == boardSize ? _self.boardSize : boardSize // ignore: cast_nullable_to_non_nullable
as BoardSize,winCondition: null == winCondition ? _self.winCondition : winCondition // ignore: cast_nullable_to_non_nullable
as WinCondition,
  ));
}

}


/// Adds pattern-matching-related methods to [GameSetup].
extension GameSetupPatterns on GameSetup {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameSetup() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameSetup value)  $default,){
final _that = this;
switch (_that) {
case _GameSetup():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameSetup value)?  $default,){
final _that = this;
switch (_that) {
case _GameSetup() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameMode mode,  String player1Name,  String player2Name,  FirstMove firstMove,  Difficulty difficulty,  BoardSize boardSize,  WinCondition winCondition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameSetup() when $default != null:
return $default(_that.mode,_that.player1Name,_that.player2Name,_that.firstMove,_that.difficulty,_that.boardSize,_that.winCondition);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameMode mode,  String player1Name,  String player2Name,  FirstMove firstMove,  Difficulty difficulty,  BoardSize boardSize,  WinCondition winCondition)  $default,) {final _that = this;
switch (_that) {
case _GameSetup():
return $default(_that.mode,_that.player1Name,_that.player2Name,_that.firstMove,_that.difficulty,_that.boardSize,_that.winCondition);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameMode mode,  String player1Name,  String player2Name,  FirstMove firstMove,  Difficulty difficulty,  BoardSize boardSize,  WinCondition winCondition)?  $default,) {final _that = this;
switch (_that) {
case _GameSetup() when $default != null:
return $default(_that.mode,_that.player1Name,_that.player2Name,_that.firstMove,_that.difficulty,_that.boardSize,_that.winCondition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameSetup implements GameSetup {
  const _GameSetup({this.mode = GameMode.local, this.player1Name = 'Player 1', this.player2Name = 'Player 2', this.firstMove = FirstMove.random, this.difficulty = Difficulty.medium, this.boardSize = BoardSize.threeByThree, this.winCondition = WinCondition.threeInRow});
  factory _GameSetup.fromJson(Map<String, dynamic> json) => _$GameSetupFromJson(json);

@override@JsonKey() final  GameMode mode;
@override@JsonKey() final  String player1Name;
@override@JsonKey() final  String player2Name;
@override@JsonKey() final  FirstMove firstMove;
@override@JsonKey() final  Difficulty difficulty;
@override@JsonKey() final  BoardSize boardSize;
@override@JsonKey() final  WinCondition winCondition;

/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameSetupCopyWith<_GameSetup> get copyWith => __$GameSetupCopyWithImpl<_GameSetup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameSetupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameSetup&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.player1Name, player1Name) || other.player1Name == player1Name)&&(identical(other.player2Name, player2Name) || other.player2Name == player2Name)&&(identical(other.firstMove, firstMove) || other.firstMove == firstMove)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.boardSize, boardSize) || other.boardSize == boardSize)&&(identical(other.winCondition, winCondition) || other.winCondition == winCondition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,player1Name,player2Name,firstMove,difficulty,boardSize,winCondition);

@override
String toString() {
  return 'GameSetup(mode: $mode, player1Name: $player1Name, player2Name: $player2Name, firstMove: $firstMove, difficulty: $difficulty, boardSize: $boardSize, winCondition: $winCondition)';
}


}

/// @nodoc
abstract mixin class _$GameSetupCopyWith<$Res> implements $GameSetupCopyWith<$Res> {
  factory _$GameSetupCopyWith(_GameSetup value, $Res Function(_GameSetup) _then) = __$GameSetupCopyWithImpl;
@override @useResult
$Res call({
 GameMode mode, String player1Name, String player2Name, FirstMove firstMove, Difficulty difficulty, BoardSize boardSize, WinCondition winCondition
});




}
/// @nodoc
class __$GameSetupCopyWithImpl<$Res>
    implements _$GameSetupCopyWith<$Res> {
  __$GameSetupCopyWithImpl(this._self, this._then);

  final _GameSetup _self;
  final $Res Function(_GameSetup) _then;

/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? player1Name = null,Object? player2Name = null,Object? firstMove = null,Object? difficulty = null,Object? boardSize = null,Object? winCondition = null,}) {
  return _then(_GameSetup(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GameMode,player1Name: null == player1Name ? _self.player1Name : player1Name // ignore: cast_nullable_to_non_nullable
as String,player2Name: null == player2Name ? _self.player2Name : player2Name // ignore: cast_nullable_to_non_nullable
as String,firstMove: null == firstMove ? _self.firstMove : firstMove // ignore: cast_nullable_to_non_nullable
as FirstMove,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,boardSize: null == boardSize ? _self.boardSize : boardSize // ignore: cast_nullable_to_non_nullable
as BoardSize,winCondition: null == winCondition ? _self.winCondition : winCondition // ignore: cast_nullable_to_non_nullable
as WinCondition,
  ));
}


}

// dart format on
