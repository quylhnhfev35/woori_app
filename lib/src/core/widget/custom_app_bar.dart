import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  // Tiêu đề dạng text. Nếu truyền [titleWidget] thì title sẽ bị bỏ qua.
  final String? title;

  // Có thể truyền 1 widget custom làm title (vd: logo, row...).
  final Widget? titleWidget;

  // Center title hay không. Nếu null thì dùng mặc định từ theme.
  final bool? centerTitle;

  // Có hiển thị nút back hay không.
  final bool showBackButton;

  // Callback khi bấm nút back. Nếu null thì auto `Navigator.maybePop`.
  final VoidCallback? onBack;

  // Danh sách action ở bên phải AppBar.
  final List<Widget>? actions;

  // Màu nền AppBar. Nếu null dùng theme.
  final Color? backgroundColor;

  // Màu icon / title. Nếu null dùng theme.
  final Color? foregroundColor;

  // Độ đổ bóng. Nếu null dùng mặc định theme.
  final double? elevation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      elevation: elevation,

      centerTitle: centerTitle ?? true,

      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  // CHANGED: giảm kích thước text
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foregroundColor ?? theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: actions,
    );
  }
}