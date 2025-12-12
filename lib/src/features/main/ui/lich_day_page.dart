import 'package:flutter/material.dart';
import 'package:woori_app/src/features/main/ui/widgets/main_header.dart';

class LichDayPage extends StatelessWidget {
  const LichDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fakeSessions = List.generate(10, (index) => index);

    return Column(
      children: [
        MainHeader(
          title: 'Lịch dạy',
          userName: 'Quý Đuổi',
          userInitial: 'Q',
          showSearchArea: true,
          searchHintText: 'Tìm buổi / lớp...',
          onFilterTap: () {
            // TODO: filter buổi theo lớp / GV / trạng thái
          },
          onAddTap: () {
            // TODO: tạo buổi dạy mới
          },
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: fakeSessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Lớp Thiếu nhi A'),
                  subtitle: const Text('18:00 - 19:30 • Phòng 101'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(
                        label: const Text('Dự kiến'),
                        backgroundColor: Colors.blue.shade50,
                        labelStyle: const TextStyle(color: Colors.blue),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: mở màn điểm danh buổi này
                        },
                        child: const Text('Điểm danh'),
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: mở chi tiết buổi tập
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}