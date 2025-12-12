class Mapper {
  static String convertCapDo(String value) {
    switch (value) {
      case 'thieu_nhi':
        return 'Thiếu nhi';
      case 'can_ban':
        return 'Căn bản';
      case 'trung_cap':
        return 'Trung cấp';
      case 'nang_cao':
        return 'Nâng cao';
      default:
        return value;
    }
  }

  static String convertTrangThaiLop(String value) {
    switch (value) {
      case 'chua_bat_dau':
        return 'Chưa bắt đầu';
      case 'dang_dien_ra':
        return 'Đang diễn ra';
      case 'da_hoan_thanh':
        return 'Đã hoàn thành';
      case 'da_huy':
        return 'Đã hủy';
      default:
        return value;
    }
  }
  
  static String convertTTBuoiTap(String value) {
    switch (value) {
      case 'du_kien':
        return 'Dự kiến';
      case 'da_dien_ra':
        return 'Đã diễn ra';
      case 'huy':
        return 'Hủy';
      default:
        return value;
    }
  }
}