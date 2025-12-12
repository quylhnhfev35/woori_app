import 'package:woori_app/src/core/models/lop_hoc.dart';

class BuoiTap {
  final String? id;

  final String lopHocId;

  final LopHoc? lopHoc;
  
  final DateTime ngay;

  final String? gioBatDau;
  final String? gioKetThuc;

  final String? giangVienPhuTrachId;

  final String trangThai;

  final String? ghiChu;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BuoiTap({
    this.id,
    required this.lopHocId,
    required this.ngay,
    this.lopHoc,
    this.gioBatDau,
    this.gioKetThuc,
    this.giangVienPhuTrachId,
    required this.trangThai,
    this.ghiChu,
    this.createdAt,
    this.updatedAt,
  });

  factory BuoiTap.fromJson(Map<String, dynamic> json) {
    final dynamic lopHocField = json['lopHoc'];

    String lopHocId = '';
    LopHoc? lopHoc;

    if (lopHocField is String) {
      lopHocId = lopHocField;
    } else if (lopHocField is Map<String, dynamic>) {
      lopHoc = LopHoc.fromJson(lopHocField);
      lopHocId = lopHoc.id ?? '';
    }

    return BuoiTap(
      id: json['_id']?.toString(),
      lopHocId: lopHocId,
      lopHoc: lopHoc,
      ngay: DateTime.parse(json['ngay']),

      gioBatDau: json['gioBatDau'],
      gioKetThuc: json['gioKetThuc'],

      giangVienPhuTrachId: json['giangVienPhuTrach']?.toString(),

      trangThai: json['trangThai'] ?? 'du_kien',

      ghiChu: json['ghiChu'],

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'lopHoc': lopHocId,
      'ngay': ngay.toIso8601String(),

      'gioBatDau': gioBatDau,
      'gioKetThuc': gioKetThuc,

      'giangVienPhuTrach': giangVienPhuTrachId,

      'trangThai': trangThai,
      'ghiChu': ghiChu,
    };
  }
}