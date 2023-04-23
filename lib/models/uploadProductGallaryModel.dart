// To parse this JSON data, do
//
//     final UploadImage = UploadImageFromJson(jsonString);

import 'dart:convert';

UploadImage UploadImageFromJson(String str) => UploadImage.fromJson(json.decode(str));

String UploadImageToJson(UploadImage data) => json.encode(data.toJson());

class UploadImage {
  UploadImage({
    required this.status,
    required this.productImage,
    required this.message,
  });

  String status;
  String productImage;
  String message;

  factory UploadImage.fromJson(Map<String, dynamic> json) => UploadImage(
        status: json["status"],
        productImage: json["product_image"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "product_image": productImage,
        "message": message,
      };
}
