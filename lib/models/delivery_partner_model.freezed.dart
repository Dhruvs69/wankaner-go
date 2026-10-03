// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_partner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeliveryPartnerModel _$DeliveryPartnerModelFromJson(Map<String, dynamic> json) {
  return _DeliveryPartnerModel.fromJson(json);
}

/// @nodoc
mixin _$DeliveryPartnerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  bool get isApproved => throw _privateConstructorUsedError;
  String? get currentOrderId => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  int get totalDeliveries => throw _privateConstructorUsedError;
  double get totalEarnings => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DeliveryPartnerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryPartnerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryPartnerModelCopyWith<DeliveryPartnerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryPartnerModelCopyWith<$Res> {
  factory $DeliveryPartnerModelCopyWith(DeliveryPartnerModel value,
          $Res Function(DeliveryPartnerModel) then) =
      _$DeliveryPartnerModelCopyWithImpl<$Res, DeliveryPartnerModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String phone,
      String? profileImage,
      bool isOnline,
      bool isApproved,
      String? currentOrderId,
      double? latitude,
      double? longitude,
      int totalDeliveries,
      double totalEarnings,
      DateTime? createdAt});
}

/// @nodoc
class _$DeliveryPartnerModelCopyWithImpl<$Res,
        $Val extends DeliveryPartnerModel>
    implements $DeliveryPartnerModelCopyWith<$Res> {
  _$DeliveryPartnerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryPartnerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = null,
    Object? profileImage = freezed,
    Object? isOnline = null,
    Object? isApproved = null,
    Object? currentOrderId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? totalDeliveries = null,
    Object? totalEarnings = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      currentOrderId: freezed == currentOrderId
          ? _value.currentOrderId
          : currentOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      totalDeliveries: null == totalDeliveries
          ? _value.totalDeliveries
          : totalDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      totalEarnings: null == totalEarnings
          ? _value.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryPartnerModelImplCopyWith<$Res>
    implements $DeliveryPartnerModelCopyWith<$Res> {
  factory _$$DeliveryPartnerModelImplCopyWith(_$DeliveryPartnerModelImpl value,
          $Res Function(_$DeliveryPartnerModelImpl) then) =
      __$$DeliveryPartnerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String phone,
      String? profileImage,
      bool isOnline,
      bool isApproved,
      String? currentOrderId,
      double? latitude,
      double? longitude,
      int totalDeliveries,
      double totalEarnings,
      DateTime? createdAt});
}

/// @nodoc
class __$$DeliveryPartnerModelImplCopyWithImpl<$Res>
    extends _$DeliveryPartnerModelCopyWithImpl<$Res, _$DeliveryPartnerModelImpl>
    implements _$$DeliveryPartnerModelImplCopyWith<$Res> {
  __$$DeliveryPartnerModelImplCopyWithImpl(_$DeliveryPartnerModelImpl _value,
      $Res Function(_$DeliveryPartnerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeliveryPartnerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = null,
    Object? profileImage = freezed,
    Object? isOnline = null,
    Object? isApproved = null,
    Object? currentOrderId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? totalDeliveries = null,
    Object? totalEarnings = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$DeliveryPartnerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      currentOrderId: freezed == currentOrderId
          ? _value.currentOrderId
          : currentOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      totalDeliveries: null == totalDeliveries
          ? _value.totalDeliveries
          : totalDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      totalEarnings: null == totalEarnings
          ? _value.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryPartnerModelImpl implements _DeliveryPartnerModel {
  const _$DeliveryPartnerModelImpl(
      {required this.id,
      required this.name,
      required this.phone,
      this.profileImage,
      this.isOnline = false,
      this.isApproved = false,
      this.currentOrderId,
      this.latitude,
      this.longitude,
      this.totalDeliveries = 0,
      this.totalEarnings = 0.0,
      this.createdAt});

  factory _$DeliveryPartnerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryPartnerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String? profileImage;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  @JsonKey()
  final bool isApproved;
  @override
  final String? currentOrderId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey()
  final int totalDeliveries;
  @override
  @JsonKey()
  final double totalEarnings;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'DeliveryPartnerModel(id: $id, name: $name, phone: $phone, profileImage: $profileImage, isOnline: $isOnline, isApproved: $isApproved, currentOrderId: $currentOrderId, latitude: $latitude, longitude: $longitude, totalDeliveries: $totalDeliveries, totalEarnings: $totalEarnings, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryPartnerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.currentOrderId, currentOrderId) ||
                other.currentOrderId == currentOrderId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.totalDeliveries, totalDeliveries) ||
                other.totalDeliveries == totalDeliveries) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      phone,
      profileImage,
      isOnline,
      isApproved,
      currentOrderId,
      latitude,
      longitude,
      totalDeliveries,
      totalEarnings,
      createdAt);

  /// Create a copy of DeliveryPartnerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryPartnerModelImplCopyWith<_$DeliveryPartnerModelImpl>
      get copyWith =>
          __$$DeliveryPartnerModelImplCopyWithImpl<_$DeliveryPartnerModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryPartnerModelImplToJson(
      this,
    );
  }
}

abstract class _DeliveryPartnerModel implements DeliveryPartnerModel {
  const factory _DeliveryPartnerModel(
      {required final String id,
      required final String name,
      required final String phone,
      final String? profileImage,
      final bool isOnline,
      final bool isApproved,
      final String? currentOrderId,
      final double? latitude,
      final double? longitude,
      final int totalDeliveries,
      final double totalEarnings,
      final DateTime? createdAt}) = _$DeliveryPartnerModelImpl;

  factory _DeliveryPartnerModel.fromJson(Map<String, dynamic> json) =
      _$DeliveryPartnerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get phone;
  @override
  String? get profileImage;
  @override
  bool get isOnline;
  @override
  bool get isApproved;
  @override
  String? get currentOrderId;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  int get totalDeliveries;
  @override
  double get totalEarnings;
  @override
  DateTime? get createdAt;

  /// Create a copy of DeliveryPartnerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryPartnerModelImplCopyWith<_$DeliveryPartnerModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
