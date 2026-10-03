// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) {
  return _CouponModel.fromJson(json);
}

/// @nodoc
mixin _$CouponModel {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get discountType =>
      throw _privateConstructorUsedError; // 'percentage' or 'fixed'
  double get discountValue => throw _privateConstructorUsedError;
  double get minOrderAmount => throw _privateConstructorUsedError;
  double? get maxDiscountAmount => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  int get usageLimit => throw _privateConstructorUsedError;
  int get timesUsed => throw _privateConstructorUsedError;
  String? get vendorId =>
      throw _privateConstructorUsedError; // If null, applies to all vendors
  bool get isFirstOrderOnly => throw _privateConstructorUsedError;

  /// Serializes this CouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponModelCopyWith<CouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponModelCopyWith<$Res> {
  factory $CouponModelCopyWith(
          CouponModel value, $Res Function(CouponModel) then) =
      _$CouponModelCopyWithImpl<$Res, CouponModel>;
  @useResult
  $Res call(
      {String id,
      String code,
      String discountType,
      double discountValue,
      double minOrderAmount,
      double? maxDiscountAmount,
      @TimestampConverter() DateTime? expiryDate,
      int usageLimit,
      int timesUsed,
      String? vendorId,
      bool isFirstOrderOnly});
}

/// @nodoc
class _$CouponModelCopyWithImpl<$Res, $Val extends CouponModel>
    implements $CouponModelCopyWith<$Res> {
  _$CouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? minOrderAmount = null,
    Object? maxDiscountAmount = freezed,
    Object? expiryDate = freezed,
    Object? usageLimit = null,
    Object? timesUsed = null,
    Object? vendorId = freezed,
    Object? isFirstOrderOnly = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      minOrderAmount: null == minOrderAmount
          ? _value.minOrderAmount
          : minOrderAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiscountAmount: freezed == maxDiscountAmount
          ? _value.maxDiscountAmount
          : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usageLimit: null == usageLimit
          ? _value.usageLimit
          : usageLimit // ignore: cast_nullable_to_non_nullable
              as int,
      timesUsed: null == timesUsed
          ? _value.timesUsed
          : timesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      isFirstOrderOnly: null == isFirstOrderOnly
          ? _value.isFirstOrderOnly
          : isFirstOrderOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CouponModelImplCopyWith<$Res>
    implements $CouponModelCopyWith<$Res> {
  factory _$$CouponModelImplCopyWith(
          _$CouponModelImpl value, $Res Function(_$CouponModelImpl) then) =
      __$$CouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String discountType,
      double discountValue,
      double minOrderAmount,
      double? maxDiscountAmount,
      @TimestampConverter() DateTime? expiryDate,
      int usageLimit,
      int timesUsed,
      String? vendorId,
      bool isFirstOrderOnly});
}

/// @nodoc
class __$$CouponModelImplCopyWithImpl<$Res>
    extends _$CouponModelCopyWithImpl<$Res, _$CouponModelImpl>
    implements _$$CouponModelImplCopyWith<$Res> {
  __$$CouponModelImplCopyWithImpl(
      _$CouponModelImpl _value, $Res Function(_$CouponModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? minOrderAmount = null,
    Object? maxDiscountAmount = freezed,
    Object? expiryDate = freezed,
    Object? usageLimit = null,
    Object? timesUsed = null,
    Object? vendorId = freezed,
    Object? isFirstOrderOnly = null,
  }) {
    return _then(_$CouponModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      minOrderAmount: null == minOrderAmount
          ? _value.minOrderAmount
          : minOrderAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiscountAmount: freezed == maxDiscountAmount
          ? _value.maxDiscountAmount
          : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usageLimit: null == usageLimit
          ? _value.usageLimit
          : usageLimit // ignore: cast_nullable_to_non_nullable
              as int,
      timesUsed: null == timesUsed
          ? _value.timesUsed
          : timesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      isFirstOrderOnly: null == isFirstOrderOnly
          ? _value.isFirstOrderOnly
          : isFirstOrderOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponModelImpl implements _CouponModel {
  const _$CouponModelImpl(
      {required this.id,
      required this.code,
      required this.discountType,
      required this.discountValue,
      this.minOrderAmount = 0.0,
      this.maxDiscountAmount,
      @TimestampConverter() this.expiryDate,
      this.usageLimit = 0,
      this.timesUsed = 0,
      this.vendorId,
      this.isFirstOrderOnly = false});

  factory _$CouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponModelImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String discountType;
// 'percentage' or 'fixed'
  @override
  final double discountValue;
  @override
  @JsonKey()
  final double minOrderAmount;
  @override
  final double? maxDiscountAmount;
  @override
  @TimestampConverter()
  final DateTime? expiryDate;
  @override
  @JsonKey()
  final int usageLimit;
  @override
  @JsonKey()
  final int timesUsed;
  @override
  final String? vendorId;
// If null, applies to all vendors
  @override
  @JsonKey()
  final bool isFirstOrderOnly;

  @override
  String toString() {
    return 'CouponModel(id: $id, code: $code, discountType: $discountType, discountValue: $discountValue, minOrderAmount: $minOrderAmount, maxDiscountAmount: $maxDiscountAmount, expiryDate: $expiryDate, usageLimit: $usageLimit, timesUsed: $timesUsed, vendorId: $vendorId, isFirstOrderOnly: $isFirstOrderOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.minOrderAmount, minOrderAmount) ||
                other.minOrderAmount == minOrderAmount) &&
            (identical(other.maxDiscountAmount, maxDiscountAmount) ||
                other.maxDiscountAmount == maxDiscountAmount) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.usageLimit, usageLimit) ||
                other.usageLimit == usageLimit) &&
            (identical(other.timesUsed, timesUsed) ||
                other.timesUsed == timesUsed) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.isFirstOrderOnly, isFirstOrderOnly) ||
                other.isFirstOrderOnly == isFirstOrderOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      discountType,
      discountValue,
      minOrderAmount,
      maxDiscountAmount,
      expiryDate,
      usageLimit,
      timesUsed,
      vendorId,
      isFirstOrderOnly);

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      __$$CouponModelImplCopyWithImpl<_$CouponModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponModelImplToJson(
      this,
    );
  }
}

abstract class _CouponModel implements CouponModel {
  const factory _CouponModel(
      {required final String id,
      required final String code,
      required final String discountType,
      required final double discountValue,
      final double minOrderAmount,
      final double? maxDiscountAmount,
      @TimestampConverter() final DateTime? expiryDate,
      final int usageLimit,
      final int timesUsed,
      final String? vendorId,
      final bool isFirstOrderOnly}) = _$CouponModelImpl;

  factory _CouponModel.fromJson(Map<String, dynamic> json) =
      _$CouponModelImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get discountType; // 'percentage' or 'fixed'
  @override
  double get discountValue;
  @override
  double get minOrderAmount;
  @override
  double? get maxDiscountAmount;
  @override
  @TimestampConverter()
  DateTime? get expiryDate;
  @override
  int get usageLimit;
  @override
  int get timesUsed;
  @override
  String? get vendorId; // If null, applies to all vendors
  @override
  bool get isFirstOrderOnly;

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
