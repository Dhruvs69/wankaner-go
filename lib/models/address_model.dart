import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String id,
    required String label, // e.g. "Home", "Work"
    required String fullAddress,
    required String city,
    required String pincode,
    @Default(false) bool isDefault,
    @Default(0.0) double lat,
    @Default(0.0) double lng,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
}
