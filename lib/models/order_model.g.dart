// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      productId: json['productId'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      variant: json['variant'] as String?,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
      'variant': instance.variant,
    };

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      vendorId: json['vendorId'] as String,
      deliveryPartnerId: json['deliveryPartnerId'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String? ?? 'COD',
      paymentStatus: json['paymentStatus'] as String? ?? 'PENDING',
      orderStatus: json['orderStatus'] as String? ?? 'PLACED',
      customerAddress: json['customerAddress'] as String,
      customerLatitude: (json['customerLatitude'] as num).toDouble(),
      customerLongitude: (json['customerLongitude'] as num).toDouble(),
      vendorLatitude: (json['vendorLatitude'] as num).toDouble(),
      vendorLongitude: (json['vendorLongitude'] as num).toDouble(),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      acceptedAt: const TimestampConverter().fromJson(json['acceptedAt']),
      readyAt: const TimestampConverter().fromJson(json['readyAt']),
      pickedUpAt: const TimestampConverter().fromJson(json['pickedUpAt']),
      deliveredAt: const TimestampConverter().fromJson(json['deliveredAt']),
      cancelledAt: const TimestampConverter().fromJson(json['cancelledAt']),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'vendorId': instance.vendorId,
      'deliveryPartnerId': instance.deliveryPartnerId,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'deliveryFee': instance.deliveryFee,
      'total': instance.total,
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
      'orderStatus': instance.orderStatus,
      'customerAddress': instance.customerAddress,
      'customerLatitude': instance.customerLatitude,
      'customerLongitude': instance.customerLongitude,
      'vendorLatitude': instance.vendorLatitude,
      'vendorLongitude': instance.vendorLongitude,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'acceptedAt': const TimestampConverter().toJson(instance.acceptedAt),
      'readyAt': const TimestampConverter().toJson(instance.readyAt),
      'pickedUpAt': const TimestampConverter().toJson(instance.pickedUpAt),
      'deliveredAt': const TimestampConverter().toJson(instance.deliveredAt),
      'cancelledAt': const TimestampConverter().toJson(instance.cancelledAt),
    };
