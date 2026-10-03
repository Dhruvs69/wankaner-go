// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get productId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get variant => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call(
      {String productId,
      String name,
      int quantity,
      double price,
      String? variant});
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
    Object? variant = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
          _$OrderItemImpl value, $Res Function(_$OrderItemImpl) then) =
      __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String name,
      int quantity,
      double price,
      String? variant});
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
      _$OrderItemImpl _value, $Res Function(_$OrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
    Object? variant = freezed,
  }) {
    return _then(_$OrderItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl(
      {required this.productId,
      required this.name,
      required this.quantity,
      required this.price,
      this.variant});

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String productId;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final double price;
  @override
  final String? variant;

  @override
  String toString() {
    return 'OrderItem(productId: $productId, name: $name, quantity: $quantity, price: $price, variant: $variant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.variant, variant) || other.variant == variant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, name, quantity, price, variant);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(
      this,
    );
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem(
      {required final String productId,
      required final String name,
      required final int quantity,
      required final double price,
      final String? variant}) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get productId;
  @override
  String get name;
  @override
  int get quantity;
  @override
  double get price;
  @override
  String? get variant;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  String get id => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String? get deliveryPartnerId => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String get orderStatus =>
      throw _privateConstructorUsedError; // PLACED, ACCEPTED, PREPARING, READY, PICKED_UP, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
  String get customerAddress => throw _privateConstructorUsedError;
  double get customerLatitude => throw _privateConstructorUsedError;
  double get customerLongitude => throw _privateConstructorUsedError;
  double get vendorLatitude => throw _privateConstructorUsedError;
  double get vendorLongitude => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get readyAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get pickedUpAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get cancelledAt => throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {String id,
      String customerId,
      String vendorId,
      String? deliveryPartnerId,
      List<OrderItem> items,
      double subtotal,
      double discount,
      double deliveryFee,
      double total,
      String paymentMethod,
      String paymentStatus,
      String orderStatus,
      String customerAddress,
      double customerLatitude,
      double customerLongitude,
      double vendorLatitude,
      double vendorLongitude,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? acceptedAt,
      @TimestampConverter() DateTime? readyAt,
      @TimestampConverter() DateTime? pickedUpAt,
      @TimestampConverter() DateTime? deliveredAt,
      @TimestampConverter() DateTime? cancelledAt});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? vendorId = null,
    Object? deliveryPartnerId = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? discount = null,
    Object? deliveryFee = null,
    Object? total = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? orderStatus = null,
    Object? customerAddress = null,
    Object? customerLatitude = null,
    Object? customerLongitude = null,
    Object? vendorLatitude = null,
    Object? vendorLongitude = null,
    Object? createdAt = freezed,
    Object? acceptedAt = freezed,
    Object? readyAt = freezed,
    Object? pickedUpAt = freezed,
    Object? deliveredAt = freezed,
    Object? cancelledAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryPartnerId: freezed == deliveryPartnerId
          ? _value.deliveryPartnerId
          : deliveryPartnerId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      orderStatus: null == orderStatus
          ? _value.orderStatus
          : orderStatus // ignore: cast_nullable_to_non_nullable
              as String,
      customerAddress: null == customerAddress
          ? _value.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      customerLatitude: null == customerLatitude
          ? _value.customerLatitude
          : customerLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      customerLongitude: null == customerLongitude
          ? _value.customerLongitude
          : customerLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      vendorLatitude: null == vendorLatitude
          ? _value.vendorLatitude
          : vendorLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      vendorLongitude: null == vendorLongitude
          ? _value.vendorLongitude
          : vendorLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readyAt: freezed == readyAt
          ? _value.readyAt
          : readyAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String customerId,
      String vendorId,
      String? deliveryPartnerId,
      List<OrderItem> items,
      double subtotal,
      double discount,
      double deliveryFee,
      double total,
      String paymentMethod,
      String paymentStatus,
      String orderStatus,
      String customerAddress,
      double customerLatitude,
      double customerLongitude,
      double vendorLatitude,
      double vendorLongitude,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? acceptedAt,
      @TimestampConverter() DateTime? readyAt,
      @TimestampConverter() DateTime? pickedUpAt,
      @TimestampConverter() DateTime? deliveredAt,
      @TimestampConverter() DateTime? cancelledAt});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? vendorId = null,
    Object? deliveryPartnerId = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? discount = null,
    Object? deliveryFee = null,
    Object? total = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? orderStatus = null,
    Object? customerAddress = null,
    Object? customerLatitude = null,
    Object? customerLongitude = null,
    Object? vendorLatitude = null,
    Object? vendorLongitude = null,
    Object? createdAt = freezed,
    Object? acceptedAt = freezed,
    Object? readyAt = freezed,
    Object? pickedUpAt = freezed,
    Object? deliveredAt = freezed,
    Object? cancelledAt = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryPartnerId: freezed == deliveryPartnerId
          ? _value.deliveryPartnerId
          : deliveryPartnerId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      orderStatus: null == orderStatus
          ? _value.orderStatus
          : orderStatus // ignore: cast_nullable_to_non_nullable
              as String,
      customerAddress: null == customerAddress
          ? _value.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      customerLatitude: null == customerLatitude
          ? _value.customerLatitude
          : customerLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      customerLongitude: null == customerLongitude
          ? _value.customerLongitude
          : customerLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      vendorLatitude: null == vendorLatitude
          ? _value.vendorLatitude
          : vendorLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      vendorLongitude: null == vendorLongitude
          ? _value.vendorLongitude
          : vendorLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readyAt: freezed == readyAt
          ? _value.readyAt
          : readyAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {required this.id,
      required this.customerId,
      required this.vendorId,
      this.deliveryPartnerId,
      required final List<OrderItem> items,
      required this.subtotal,
      this.discount = 0.0,
      required this.deliveryFee,
      required this.total,
      this.paymentMethod = 'COD',
      this.paymentStatus = 'PENDING',
      this.orderStatus = 'PLACED',
      required this.customerAddress,
      required this.customerLatitude,
      required this.customerLongitude,
      required this.vendorLatitude,
      required this.vendorLongitude,
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.acceptedAt,
      @TimestampConverter() this.readyAt,
      @TimestampConverter() this.pickedUpAt,
      @TimestampConverter() this.deliveredAt,
      @TimestampConverter() this.cancelledAt})
      : _items = items;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final String id;
  @override
  final String customerId;
  @override
  final String vendorId;
  @override
  final String? deliveryPartnerId;
  final List<OrderItem> _items;
  @override
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double subtotal;
  @override
  @JsonKey()
  final double discount;
  @override
  final double deliveryFee;
  @override
  final double total;
  @override
  @JsonKey()
  final String paymentMethod;
  @override
  @JsonKey()
  final String paymentStatus;
  @override
  @JsonKey()
  final String orderStatus;
// PLACED, ACCEPTED, PREPARING, READY, PICKED_UP, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
  @override
  final String customerAddress;
  @override
  final double customerLatitude;
  @override
  final double customerLongitude;
  @override
  final double vendorLatitude;
  @override
  final double vendorLongitude;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? acceptedAt;
  @override
  @TimestampConverter()
  final DateTime? readyAt;
  @override
  @TimestampConverter()
  final DateTime? pickedUpAt;
  @override
  @TimestampConverter()
  final DateTime? deliveredAt;
  @override
  @TimestampConverter()
  final DateTime? cancelledAt;

  @override
  String toString() {
    return 'OrderModel(id: $id, customerId: $customerId, vendorId: $vendorId, deliveryPartnerId: $deliveryPartnerId, items: $items, subtotal: $subtotal, discount: $discount, deliveryFee: $deliveryFee, total: $total, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, orderStatus: $orderStatus, customerAddress: $customerAddress, customerLatitude: $customerLatitude, customerLongitude: $customerLongitude, vendorLatitude: $vendorLatitude, vendorLongitude: $vendorLongitude, createdAt: $createdAt, acceptedAt: $acceptedAt, readyAt: $readyAt, pickedUpAt: $pickedUpAt, deliveredAt: $deliveredAt, cancelledAt: $cancelledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.deliveryPartnerId, deliveryPartnerId) ||
                other.deliveryPartnerId == deliveryPartnerId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.orderStatus, orderStatus) ||
                other.orderStatus == orderStatus) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            (identical(other.customerLatitude, customerLatitude) ||
                other.customerLatitude == customerLatitude) &&
            (identical(other.customerLongitude, customerLongitude) ||
                other.customerLongitude == customerLongitude) &&
            (identical(other.vendorLatitude, vendorLatitude) ||
                other.vendorLatitude == vendorLatitude) &&
            (identical(other.vendorLongitude, vendorLongitude) ||
                other.vendorLongitude == vendorLongitude) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.readyAt, readyAt) || other.readyAt == readyAt) &&
            (identical(other.pickedUpAt, pickedUpAt) ||
                other.pickedUpAt == pickedUpAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        customerId,
        vendorId,
        deliveryPartnerId,
        const DeepCollectionEquality().hash(_items),
        subtotal,
        discount,
        deliveryFee,
        total,
        paymentMethod,
        paymentStatus,
        orderStatus,
        customerAddress,
        customerLatitude,
        customerLongitude,
        vendorLatitude,
        vendorLongitude,
        createdAt,
        acceptedAt,
        readyAt,
        pickedUpAt,
        deliveredAt,
        cancelledAt
      ]);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
      {required final String id,
      required final String customerId,
      required final String vendorId,
      final String? deliveryPartnerId,
      required final List<OrderItem> items,
      required final double subtotal,
      final double discount,
      required final double deliveryFee,
      required final double total,
      final String paymentMethod,
      final String paymentStatus,
      final String orderStatus,
      required final String customerAddress,
      required final double customerLatitude,
      required final double customerLongitude,
      required final double vendorLatitude,
      required final double vendorLongitude,
      @TimestampConverter() final DateTime? createdAt,
      @TimestampConverter() final DateTime? acceptedAt,
      @TimestampConverter() final DateTime? readyAt,
      @TimestampConverter() final DateTime? pickedUpAt,
      @TimestampConverter() final DateTime? deliveredAt,
      @TimestampConverter() final DateTime? cancelledAt}) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  String get id;
  @override
  String get customerId;
  @override
  String get vendorId;
  @override
  String? get deliveryPartnerId;
  @override
  List<OrderItem> get items;
  @override
  double get subtotal;
  @override
  double get discount;
  @override
  double get deliveryFee;
  @override
  double get total;
  @override
  String get paymentMethod;
  @override
  String get paymentStatus;
  @override
  String
      get orderStatus; // PLACED, ACCEPTED, PREPARING, READY, PICKED_UP, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
  @override
  String get customerAddress;
  @override
  double get customerLatitude;
  @override
  double get customerLongitude;
  @override
  double get vendorLatitude;
  @override
  double get vendorLongitude;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get acceptedAt;
  @override
  @TimestampConverter()
  DateTime? get readyAt;
  @override
  @TimestampConverter()
  DateTime? get pickedUpAt;
  @override
  @TimestampConverter()
  DateTime? get deliveredAt;
  @override
  @TimestampConverter()
  DateTime? get cancelledAt;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
