import 'package:flutter/material.dart';
import 'package:woori_app/src/features/main/ui/widgets/main_header.dart';

import 'widgets/chip_filter.dart';

class LopHocPage extends StatelessWidget {
  const LopHocPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fakeClasses = List.generate(8, (index) => index);

    return Column(
      children: [
        MainHeader(
          title: 'Lớp học',
          userName: 'Quý Đuổi',
          userInitial: 'Q',
          showSearchArea: true,
          searchHintText: 'Tìm kiếm lớp...',
          onFilterTap: () {
            // TODO: mở bottom sheet filter
          },
          onAddTap: () {
            // TODO: mở màn tạo lớp mới
          },
        ),
        SizedBox(
          height: 40,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: const [
              ChipFilter(label: 'Tất cả', selected: true),
              ChipFilter(label: 'Thiếu nhi'),
              ChipFilter(label: 'Căn bản'),
              ChipFilter(label: 'Trung cấp'),
              ChipFilter(label: 'Nâng cao'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: fakeClasses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: const Text('Lớp Thiếu nhi A'),
                  subtitle: const Text('Cấp độ: Thiếu nhi • GV: Nguyễn Văn A'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('HV hiện tại: 18'),
                      SizedBox(height: 4),
                      Chip(
                        label: Text('Đang diễn ra'),
                        backgroundColor: Color(0xFFE8F5E9),
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: mở chi tiết lớp (danh sách HV, lịch buổi, đăng ký học)
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
                // TODO: mở màn tạo lớp mới
              },
              icon: const Icon(Icons.add),
              label: const Text('Tạo lớp mới'),
            ),
          ),
        ),
      ],
    );
  }
}
