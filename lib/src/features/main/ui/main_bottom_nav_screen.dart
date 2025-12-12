import 'package:flutter/material.dart';

import '../../dashboard/ui/dashboard_page.dart';
import '../../lichday/ui/lich_day_page.dart';
import '../../lophoc/ui/lop_hoc_page.dart';
import '../../hocvien/ui/hoc_vien_page.dart';
import '../../thanhtoan/ui/thanh_toan_page.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    LichDayPage(),
    LopHocPage(),
    HocVienPage(),
    ThanhToanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black54,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 22),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.space_dashboard),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Lịch dạy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Lớp học',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt),
              label: 'Học viên',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Thanh toán',
            ),
          ],
        ),
      ),
    );
  }
}