import 'package:flutter/material.dart';
import 'package:woori_app/src/features/main/ui/widgets/main_header.dart';

import 'widgets/chip_filter.dart';

class HocVienPage extends StatelessWidget {
  const HocVienPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: data từ HocVien
    final fakeStudents = List.generate(20, (index) => index);

    return Column(
      children: [
        MainHeader(
          title: 'Học viên',
          userName: 'Quý Đuổi',
          userInitial: 'Q',
          showSearchArea: true,
          searchHintText: 'Tìm theo tên / SĐT...',
          onFilterTap: () {
            // TODO: filter trạng thái HV
          },
          onAddTap: () {
            // TODO: mở form thêm học viên
          },
        ),
        SizedBox(
          height: 40,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: const [
              ChipFilter(label: 'Đang học', selected: true),
              ChipFilter(label: 'Tạm nghỉ'),
              ChipFilter(label: 'Nghỉ hẳn'),
              ChipFilter(label: 'Hoàn thành'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: fakeStudents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: const Text('Nguyễn Văn B'),
                  subtitle: const Text('Đai: Vàng • Lớp: Thiếu nhi A'),
                  trailing: const Chip(
                    label: Text('Đang học'),
                    backgroundColor: Color(0xFFE3F2FD),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    // TODO: mở profile học viên (lớp, điểm danh, thanh toán)
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                // TODO: mở form thêm học viên
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Thêm học viên'),
            ),
          ),
        ),
      ],
    );
  }
}