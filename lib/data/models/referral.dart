import 'dart:convert';
import 'package:tradexpro_flutter/data/models/user.dart';

import '../../utils/number_util.dart';

///final referral = referralFromJson(jsonString);
ReferralData referralFromJson(String str) => ReferralData.fromJson(json.decode(str));

String referralToJson(ReferralData data) => json.encode(data.toJson());

class ReferralData {
  ReferralData({
    this.title,
    this.user,
    this.referrals,
    this.url,
    this.referralLevel,
    this.select,
    this.maxReferralLevel,
    this.totalReward,
    this.monthlyEarningHistories,
    this.countReferrals,
    // this.referrals3,
    // this.referrals2,
    // this.referrals1,
  });

  String? title;
  User? user;
  List<Referral>? referrals;
  String? url;
  Map<String, int>? referralLevel;
  String? select;
  int? maxReferralLevel;
  int? totalReward;
  List<Earning>? monthlyEarningHistories;
  int? countReferrals;

  // List<Referrals1>? referrals1;
  // List<dynamic>? referrals2;
  // List<dynamic>? referrals3;

  factory ReferralData.fromJson(Map<String, dynamic> json) => ReferralData(
        title: json["title"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        referrals: json["referrals"] == null ? null : List<Referral>.from(json["referrals"].map((x) => Referral.fromJson(x))),
        url: json["url"],
        referralLevel: json["referralLevel"] == null ? null : Map.from(json["referralLevel"]).map((k, v) => MapEntry<String, int>(k, v)),
        select: json["select"],
        maxReferralLevel: json["max_referral_level"],
        totalReward: json["total_reward"],
        monthlyEarningHistories:
            json["monthlyEarningHistories"] == null ? null : List<Earning>.from(json["monthlyEarningHistories"].map((x) => Earning.fromJson(x))),
        countReferrals: json["count_referrals"],
        // referrals3: List<dynamic>.from(json["referrals_3"].map((x) => x)),
        // referrals2: List<dynamic>.from(json["referrals_2"].map((x) => x)),
        // referrals1: List<Referrals1>.from(json["referrals_1"].map((x) => Referrals1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "user": user == null ? null : user!.toJson(),
        "referrals": referrals == null ? null : List<dynamic>.from(referrals!.map((x) => x.toJson())),
        "url": url,
        "referralLevel": referralLevel == null ? null : Map.from(referralLevel!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "select": select,
        "max_referral_level": maxReferralLevel,
        "total_reward": totalReward,
        "monthlyEarningHistories": monthlyEarningHistories == null ? null : List<Earning>.from(monthlyEarningHistories!.map((x) => x.toJson())),
        "count_referrals": countReferrals,
        // "referrals_3": List<dynamic>.from(referrals3.map((x) => x)),
        // "referrals_2": List<dynamic>.from(referrals2.map((x) => x)),
        // "referrals_1": List<dynamic>.from(referrals1.map((x) => x.toJson())),
      };
}

class Referral {
  Referral({
    this.id,
    this.fullName,
    this.email,
    this.joiningDate,
    this.level,
  });

  int? id;
  String? fullName;
  String? email;
  DateTime? joiningDate;
  String? level;

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        joiningDate: json["joining_date"] == null ? null : DateTime.parse(json["joining_date"]),
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "joining_date": joiningDate?.toIso8601String(),
        "level": level,
      };
}

class Affiliate {
  Affiliate({
    required this.id,
    this.userId,
    this.code,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int? userId;
  String? code;
  int? status;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Affiliate.fromJson(Map<String, dynamic> json) => Affiliate(
        id: json["id"],
        userId: json["user_id"],
        code: json["code"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "code": code,
        "status": status,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

///final earning = earningFromJson(jsonString);

Earning earningFromJson(String str) => Earning.fromJson(json.decode(str));

String earningToJson(Earning data) => json.encode(data.toJson());

class Earning {
  Earning({
    required this.id,
    this.coinType,
    this.transactionId,
    this.amount,
    this.level,
  });

  int id;
  String? coinType;
  String? transactionId;
  double? amount;
  int? level;

  factory Earning.fromJson(Map<String, dynamic> json) => Earning(
        id: json["id"],
        coinType: json["coin_type"],
        transactionId: json["transaction_id"],
        level: json["level"],
        amount: makeDouble(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coin_type": coinType,
        "transaction_id": transactionId,
        "amount": amount,
        "level": level,
      };
}

// class Referrals1 {
//   Referrals1({
//     this.level1,
//     this.email,
//     this.fullName,
//     this.joiningDate,
//   });
//
//   int level1;
//   String email;
//   String fullName;
//   DateTime joiningDate;
//
//   factory Referrals1.fromJson(Map<String, dynamic> json) => Referrals1(
//         level1: json["level_1"],
//         email: json["email"],
//         fullName: json["full_name"],
//         joiningDate: DateTime.parse(json["joining_date"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "level_1": level1,
//         "email": email,
//         "full_name": fullName,
//         "joining_date": joiningDate.toIso8601String(),
//       };
// }
