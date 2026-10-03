const fs = require('fs');
let text = fs.readFileSync('lib/features/customer/models/order_model.dart', 'utf-8');

text = text.replace('final String? deliveryOtp;', 'final String? deliveryOtp;\n  final double? deliveryLat;\n  final double? deliveryLng;');
text = text.replace('this.deliveryOtp,', 'this.deliveryOtp,\n    this.deliveryLat,\n    this.deliveryLng,');
text = text.replace("if (deliveryOtp != null) 'delivery_otp': deliveryOtp,", "if (deliveryOtp != null) 'delivery_otp': deliveryOtp,\n      if (deliveryLat != null) 'delivery_lat': deliveryLat,\n      if (deliveryLng != null) 'delivery_lng': deliveryLng,");
text = text.replace("deliveryOtp: map['delivery_otp'] ?? map['deliveryOtp'],", "deliveryOtp: map['delivery_otp'] ?? map['deliveryOtp'],\n      deliveryLat: map['delivery_lat'] != null ? (map['delivery_lat'] as num).toDouble() : null,\n      deliveryLng: map['delivery_lng'] != null ? (map['delivery_lng'] as num).toDouble() : null,");

fs.writeFileSync('lib/features/customer/models/order_model.dart', text, 'utf-8');
console.log('OrderModel updated');
