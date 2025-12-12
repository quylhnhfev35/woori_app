import 'package:flutter/material.dart';
import 'package:woori_app/src/features/main/ui/widgets/main_header.dart';

import 'widgets/dashboard_stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fakeTodaySessions = List.generate(3, (index) => index);

    return  Column(
      children: [
        const MainHeader(
          title: 'Trang chủ',
          userName: 'Quý Đuổi',
          userInitial: 'Q',
          showSearchArea: false,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Lớp đang diễn ra',
                        value: '8',
                        icon: Icons.school,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Học viên đang học',
                        value: '125',
                        icon: Icons.people,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Doanh thu tháng này',
                        value: '120.000.000₫',
                        icon: Icons.attach_money,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Buổi hôm nay',
                        value: '5',
                        icon: Icons.event,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Buổi tập hôm nay', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: điều hướng sang tab Lịch dạy
                      },
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Xem lịch'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  itemCount: fakeTodaySessions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.fitness_center),
                        ),
                        title: const Text('Lớp Thiếu nhi A'),
                        subtitle: const Text('18:00 - 19:30 • GV: Nguyễn Văn A'),
                        trailing: Chip(
                          label: const Text('Dự kiến'),
                          backgroundColor: Colors.blue.shade50,
                          labelStyle: const TextStyle(color: Colors.blue),
                        ),
                        onTap: () {
                          // TODO: mở chi tiết buổi tập + điểm danh
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}