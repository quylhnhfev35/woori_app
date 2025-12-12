class LichHocItem {
  final int thuTrongTuan;
  final String gioBatDau;
  final String gioKetThuc;

  const LichHocItem({
    required this.thuTrongTuan,
    required this.gioBatDau,
    required this.gioKetThuc,
  });

  factory LichHocItem.fromJson(Map<String, dynamic> json) {
    return LichHocItem(
      thuTrongTuan: json['thuTrongTuan'] as int,
      gioBatDau: json['gioBatDau'] as String,
      gioKetThuc: json['gioKetThuc'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'thuTrongTuan': thuTrongTuan,
        'gioBatDau': gioBatDau,
        'gioKetThuc': gioKetThuc,
      };
}

class LopHoc {
  final String? id;
  final String tenLop;
  final String capDo;
  final String? moTa;

  final String? phongTapId;

  final String? giangVienChinhId;
  final List<String> giangVienPhuIds;

  final int? soLuongToiDa;
  final int soLuongHocVienHienTai;

  final List<LichHocItem> lichHoc;

  final int hocPhiMotThang;
  final bool dangMo;

  final String trangThai;

  final DateTime thoiGianKhaiGiang;
  final DateTime? thoiGianKetThuc;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LopHoc({
    this.id,
    required this.tenLop,
    required this.capDo,
    this.moTa,
    this.phongTapId,
    this.giangVienChinhId,
    this.giangVienPhuIds = const [],
    this.soLuongToiDa,
    required this.soLuongHocVienHienTai,
    required this.lichHoc,
    required this.hocPhiMotThang,
    required this.dangMo,
    required this.trangThai,
    required this.thoiGianKhaiGiang,
    this.thoiGianKetThuc,
    this.createdAt,
    this.updatedAt,
  });

  factory LopHoc.fromJson(Map<String, dynamic> json) {
    return LopHoc(
      id: json['_id']?.toString(),
      tenLop: json['tenLop'] ?? '',
      capDo: json['capDo'] ?? '',

      moTa: json['moTa'],
      phongTapId: json['phongTap']?.toString(),

      giangVienChinhId: json['giangVienChinh']?.toString(),
      giangVienPhuIds: (json['giangVienPhu'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],

      soLuongToiDa: json['soLuongToiDa'] as int?,

      soLuongHocVienHienTai:
          (json['soLuongHocVienHienTai'] as num?)?.toInt() ?? 0,

      lichHoc: (json['lichHoc'] as List<dynamic>?)
              ?.map((e) => LichHocItem.fromJson(e))
              .toList() ??
          const [],

      hocPhiMotThang: (json['hocPhiMotThang'] as num).toInt(),

      dangMo: json['dangMo'] as bool? ?? true,

      trangThai: json['trangThai'] ?? '',

      thoiGianKhaiGiang:
          DateTime.parse(json['thoiGianKhaiGiang'] as String),

      thoiGianKetThuc: json['thoiGianKetThuc'] != null
          ? DateTime.parse(json['thoiGianKetThuc'])
          : null,

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
      'tenLop': tenLop,
      'capDo': capDo,
      'moTa': moTa,
      'phongTap': phongTapId,
      'giangVienChinh': giangVienChinhId,
      'giangVienPhu': giangVienPhuIds,
      'soLuongToiDa': soLuongToiDa,
      'soLuongHocVienHienTai': soLuongHocVienHienTai,
      'lichHoc': lichHoc.map((e) => e.toJson()).toList(),
      'hocPhiMotThang': hocPhiMotThang,
      'dangMo': dangMo,
      'trangThai': trangThai,
      'thoiGianKhaiGiang': thoiGianKhaiGiang.toIso8601String(),
      'thoiGianKetThuc': thoiGianKetThuc?.toIso8601String(),
    };
  }
}