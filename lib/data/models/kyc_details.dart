import 'dart:convert';

///final kycDetails = kycDetailsFromJson(jsonString);
KycDetails kycDetailsFromJson(String str) => KycDetails.fromJson(json.decode(str));

String kycDetailsToJson(KycDetails data) => json.encode(data.toJson());

class KycDetails {
  KycDetails({
    this.nid,
    this.passport,
    this.driving,
    this.voter,
  });

  KycObject? nid;
  KycObject? passport;
  KycObject? driving;
  KycObject? voter;

  factory KycDetails.fromJson(Map<String, dynamic> json) => KycDetails(
        nid: json["nid"] == null ? null : KycObject.fromJson(json["nid"]),
        passport: json["passport"] == null ? null : KycObject.fromJson(json["passport"]),
        driving: json["driving"] == null ? null : KycObject.fromJson(json["driving"]),
        voter: json["voter"] == null ? null : KycObject.fromJson(json["voter"]),
      );

  Map<String, dynamic> toJson() => {
        "nid": nid == null ? null : nid!.toJson(),
        "passport": passport == null ? null : passport!.toJson(),
        "driving": driving == null ? null : driving!.toJson(),
        "voter": voter == null ? null : voter!.toJson(),
      };
}

class KycObject {
  KycObject({
    this.frontImage,
    this.backImage,
    this.selfieImage,
    this.status,
  });

  String? frontImage;
  String? backImage;
  String? selfieImage;
  String? status;

  factory KycObject.fromJson(Map<String, dynamic> json) => KycObject(
        frontImage: json["front_image"],
        backImage: json["back_image"],
        selfieImage: json["selfie"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "front_image": frontImage,
        "back_image": backImage,
        "selfie": selfieImage,
        "status": status,
      };
}
