class PhongTapSummary {
  const PhongTapSummary({
    required this.soLopDangDienRa,
    required this.tongHocVienDangHoc,
    required this.tongBuoiTapHomNay,
  });

  final int soLopDangDienRa;
  final int tongHocVienDangHoc;
  final int tongBuoiTapHomNay;

  factory PhongTapSummary.fromJson(Map<String, dynamic> json) {
    return PhongTapSummary(
      soLopDangDienRa: (json['soLopDangDienRa'] as num?)?.toInt() ?? 0,
      tongHocVienDangHoc: (json['tongHocVienDangHoc'] as num?)?.toInt() ?? 0,
      tongBuoiTapHomNay: (json['tongBuoiTapHomNay'] as num?)?.toInt() ?? 0,
    );
  }
}