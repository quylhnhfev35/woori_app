import 'package:flutter/material.dart';
import 'package:woori_app/src/features/main/ui/widgets/main_header.dart';

import 'widgets/dashboard_stat_card.dart';

class ThanhToanPage extends StatelessWidget {
  const ThanhToanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fakePayments = List.generate(15, (index) => index);

    return Column(
      children: [
        MainHeader(
          title: 'Thanh toán',
          userName: 'Quý Đuổi',
          userInitial: 'Q',
          showSearchArea: true,
          searchHintText: 'Tìm phiếu / học viên...',
          onFilterTap: () {
            // TODO: filter trạng thái, tháng...
          },
          onAddTap: () {
            // TODO: mở form tạo thanh toán
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: DashboardStatCard(
                  title: 'Tổng thu',
                  value: '45.000.000₫',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DashboardStatCard(
                  title: 'Chờ xác nhận',
                  value: '5 phiếu',
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: fakePayments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: const Text('Nguyễn Văn B • Lớp Thiếu nhi A'),
                  subtitle: const Text('Tháng 12/2025 • Tiền mặt'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        '1.200.000₫',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 4),
                      Chip(
                        label: Text('Đã thanh toán'),
                        backgroundColor: Color(0xFFE8F5E9),
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: xem / chỉnh sửa phiếu thanh toán
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
                // TODO: mở form tạo thanh toán mới
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm thanh toán'),
            ),
          ),
        ),
      ],
    );
  }
}