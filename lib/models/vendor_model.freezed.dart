// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VendorModel _$VendorModelFromJson(Map<String, dynamic> json) {
  return _VendorModel.fromJson(json);
}

/// @nodoc
mixin _$VendorModel {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'restaurant', 'grocery', 'general'
  String? get description => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  bool get isOpen => throw _privateConstructorUsedError;
  String? get openingTime => throw _privateConstructorUsedError;
  String? get closingTime => throw _privateConstructorUsedError;
  double get minimumOrder => throw _privateConstructorUsedError;
  double get commissionPercentage => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  bool get isApproved => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VendorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorModelCopyWith<VendorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorModelCopyWith<$Res> {
  factory $VendorModelCopyWith(
          VendorModel value, $Res Function(VendorModel) then) =
      _$VendorModelCopyWithImpl<$Res, VendorModel>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String type,
      String? description,
      String phone,
      String address,
      double latitude,
      double longitude,
      String? image,
      bool isOpen,
      String? openingTime,
      String? closingTime,
      double minimumOrder,
      double commissionPercentage,
      double rating,
      int reviewCount,
      bool isApproved,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$VendorModelCopyWithImpl<$Res, $Val extends VendorModel>
    implements $VendorModelCopyWith<$Res> {
  _$VendorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? phone = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? image = freezed,
    Object? isOpen = null,
    Object? openingTime = freezed,
    Object? closingTime = freezed,
    Object? minimumOrder = null,
    Object? commissionPercentage = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? isApproved = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      openingTime: freezed == openingTime
          ? _value.openingTime
          : openingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closingTime: freezed == closingTime
          ? _value.closingTime
          : closingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      minimumOrder: null == minimumOrder
          ? _value.minimumOrder
          : minimumOrder // ignore: cast_nullable_to_non_nullable
              as double,
      commissionPercentage: null == commissionPercentage
          ? _value.commissionPercentage
          : commissionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VendorModelImplCopyWith<$Res>
    implements $VendorModelCopyWith<$Res> {
  factory _$$VendorModelImplCopyWith(
          _$VendorModelImpl value, $Res Function(_$VendorModelImpl) then) =
      __$$VendorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String type,
      String? description,
      String phone,
      String address,
      double latitude,
      double longitude,
      String? image,
      bool isOpen,
      String? openingTime,
      String? closingTime,
      double minimumOrder,
      double commissionPercentage,
      double rating,
      int reviewCount,
      bool isApproved,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$VendorModelImplCopyWithImpl<$Res>
    extends _$VendorModelCopyWithImpl<$Res, _$VendorModelImpl>
    implements _$$VendorModelImplCopyWith<$Res> {
  __$$VendorModelImplCopyWithImpl(
      _$VendorModelImpl _value, $Res Function(_$VendorModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? phone = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? image = freezed,
    Object? isOpen = null,
    Object? openingTime = freezed,
    Object? closingTime = freezed,
    Object? minimumOrder = null,
    Object? commissionPercentage = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? isApproved = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VendorModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      openingTime: freezed == openingTime
          ? _value.openingTime
          : openingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closingTime: freezed == closingTime
          ? _value.closingTime
          : closingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      minimumOrder: null == minimumOrder
          ? _value.minimumOrder
          : minimumOrder // ignore: cast_nullable_to_non_nullable
              as double,
      commissionPercentage: null == commissionPercentage
          ? _value.commissionPercentage
          : commissionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorModelImpl implements _VendorModel {
  const _$VendorModelImpl(
      {required this.id,
      required this.ownerId,
      required this.name,
      required this.type,
      this.description,
      required this.phone,
      required this.address,
      required this.latitude,
      required this.longitude,
      this.image,
      this.isOpen = false,
      this.openingTime,
      this.closingTime,
      this.minimumOrder = 0.0,
      this.commissionPercentage = 10.0,
      this.rating = 0.0,
      this.reviewCount = 0,
      this.isApproved = false,
      this.createdAt,
      this.updatedAt});

  factory _$VendorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorModelImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String name;
  @override
  final String type;
// 'restaurant', 'grocery', 'general'
  @override
  final String? description;
  @override
  final String phone;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? image;
  @override
  @JsonKey()
  final bool isOpen;
  @override
  final String? openingTime;
  @override
  final String? closingTime;
  @override
  @JsonKey()
  final double minimumOrder;
  @override
  @JsonKey()
  final double commissionPercentage;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final bool isApproved;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VendorModel(id: $id, ownerId: $ownerId, name: $name, type: $type, description: $description, phone: $phone, address: $address, latitude: $latitude, longitude: $longitude, image: $image, isOpen: $isOpen, openingTime: $openingTime, closingTime: $closingTime, minimumOrder: $minimumOrder, commissionPercentage: $commissionPercentage, rating: $rating, reviewCount: $reviewCount, isApproved: $isApproved, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.openingTime, openingTime) ||
                other.openingTime == openingTime) &&
            (identical(other.closingTime, closingTime) ||
                other.closingTime == closingTime) &&
            (identical(other.minimumOrder, minimumOrder) ||
                other.minimumOrder == minimumOrder) &&
            (identical(other.commissionPercentage, commissionPercentage) ||
                other.commissionPercentage == commissionPercentage) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        ownerId,
        name,
        type,
        description,
        phone,
        address,
        latitude,
        longitude,
        image,
        isOpen,
        openingTime,
        closingTime,
        minimumOrder,
        commissionPercentage,
        rating,
        reviewCount,
        isApproved,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      __$$VendorModelImplCopyWithImpl<_$VendorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorModelImplToJson(
      this,
    );
  }
}

abstract class _VendorModel implements VendorModel {
  const factory _VendorModel(
      {required final String id,
      required final String ownerId,
      required final String name,
      required final String type,
      final String? description,
      required final String phone,
      required final String address,
      required final double latitude,
      required final double longitude,
      final String? image,
      final bool isOpen,
      final String? openingTime,
      final String? closingTime,
      final double minimumOrder,
      final double commissionPercentage,
      final double rating,
      final int reviewCount,
      final bool isApproved,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$VendorModelImpl;

  factory _VendorModel.fromJson(Map<String, dynamic> json) =
      _$VendorModelImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get name;
  @override
  String get type; // 'restaurant', 'grocery', 'general'
  @override
  String? get description;
  @override
  String get phone;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get image;
  @override
  bool get isOpen;
  @override
  String? get openingTime;
  @override
  String? get closingTime;
  @override
  double get minimumOrder;
  @override
  double get commissionPercentage;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  bool get isApproved;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
