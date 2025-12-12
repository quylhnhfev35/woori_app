import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final String title;
  final bool showSearchArea;

  final String userName;
  final String userInitial;

  final String? searchHintText;
  final VoidCallback? onFilterTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onChangePassword;
  final VoidCallback? onLogout;

  const MainHeader({
    super.key,
    required this.title,
    required this.userName,
    required this.userInitial,
    this.showSearchArea = false,
    this.searchHintText,
    this.onFilterTap,
    this.onAddTap,
    this.onChangePassword,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 18),
          // Dòng title + avatar
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              showSearchArea ? 8 : 16,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (details) {
                    _showAccountMenu(context, details.globalPosition);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      userInitial.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (showSearchArea)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: searchHintText ?? 'Tìm kiếm...',
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    child: FilledButton.icon(
                      onPressed: onAddTap,
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showAccountMenu(
    BuildContext context,
    Offset globalPosition,
  ) async {
    const double menuWidth = 140;
    const double avatarRadius = 20;
    const double rightPadding = 16;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Tính vị trí: canh phải, nằm dưới avatar
    final double right = rightPadding + 4;
    final double left = overlay.size.width - menuWidth - right;
    final double top = globalPosition.dy + avatarRadius + 8;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          child: SizedBox(
            width: menuWidth,
            child: Center(
              child: Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363636)
                ),
              ),
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'changePassword',
          child: _AccountMenuItem(
            label: 'Đổi mật khẩu',
            icon: Icons.lock_reset,
            iconBgColor: Colors.blue.shade50,
            iconColor: Colors.blue,
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: _AccountMenuItem(
            label: 'Đăng xuất',
            icon: Icons.logout,
            iconBgColor: Colors.red.shade50,
            iconColor: Colors.red,
          ),
        ),
      ],
    );

    switch (selected) {
      case 'changePassword':
        onChangePassword?.call();
        break;
      case 'logout':
        onLogout?.call();
        break;
      default:
        break;
    }
  }
}

class _AccountMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const _AccountMenuItem({
    required this.label,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(8), // box vuông bo nhẹ
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}