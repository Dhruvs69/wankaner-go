import 'package:freezed_annotation/freezed_annotation.dart';
import 'address_model.dart';
import 'timestamp_converter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String phone,
    String? email,
    required String role, // 'customer', 'vendor', 'delivery', 'admin'
    String? profileImage,
    @Default(true) bool isActive,
    // ignore: invalid_annotation_target
    @JsonKey(name: "is_online") int? isOnline,
    List<AddressModel>? savedAddresses,
    String? fcmToken,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}