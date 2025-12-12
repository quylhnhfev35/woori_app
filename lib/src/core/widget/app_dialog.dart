import 'package:flutter/material.dart';

// Option trả về từ dialog (OK / Cancel).
enum Option {
  ok,
  cancel,
}

// Dùng để show các dialog confirm / thông báo trong app.
class AppDialog {
  final BuildContext context;

  const AppDialog(this.context);

  /// Dialog confirm generic, dùng lại cho nhiều trường hợp.
  ///
  /// Trả về:
  /// - [Option.ok]
  /// - [Option.cancel]
  /// - null nếu người dùng bấm ra ngoài để đóng dialog.
  Future<Option?> showDialogConfirm(
    String content, {
    String? textCancel,
    String? textOK,
    String? title,
    Widget? titleW,
    ImageProvider? image,
  }) async {
    return _showDialogApp(
      _DialogConfirm(
        content: content,
        textCancel: textCancel,
        textOK: textOK,
        title: title,
        titleW: titleW,
        image: image,
      ),
    );
  }

  /// Dialog confirm dành riêng cho việc kích hoạt TouchID / FaceID
  /// sau khi đăng nhập thành công.
  Future<Option?> showBiometricConfirm({
    required bool isFaceId, // true = FaceID, false = TouchID (vân tay)
  }) {
    final color = Theme.of(context).colorScheme.primary;

    return showDialogConfirm(
      'Đăng nhập dễ dàng và nhanh chóng bằng TouchID hoặc FaceID trên thiết bị của bạn.',
      textOK: 'Kích hoạt',
      textCancel: 'Để sau',
      titleW: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isFaceId
              ? Icon(Icons.face_6_rounded, size: 50, color: color)
              : Icon(Icons.fingerprint, size: 50, color: color),
          const SizedBox(height: 20),
          Text(
            'Đăng nhập tài khoản',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<Option?> _showDialogApp(Widget dialog) async {
    return showDialog<Option>(
      context: context,
      barrierDismissible: true, // cho phép tap ra ngoài để đóng dialog
      builder: (BuildContext ctx) => dialog,
    );
  }
}

/// Widget SimpleDialog confirm giống code mẫu bạn gửi.
class _DialogConfirm extends StatelessWidget {
  const _DialogConfirm({
    required this.content,
    this.textCancel,
    this.textOK,
    this.title,
    this.titleW,
    this.image,
  });

  final String content;
  final String? textCancel;
  final String? textOK;
  final String? title;
  final Widget? titleW;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      children: <Widget>[
        const SizedBox(height: 10),
        if (image != null)
          Image(image: image!, width: 90, height: 90, fit: BoxFit.contain),
        if (image != null) const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: titleW ??
                Text(
                  title ?? 'Thông báo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: primary,
                  ),
                ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _DialogButtons(
            textCancel: textCancel,
            textOK: textOK,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _DialogButtons extends StatelessWidget {
  const _DialogButtons({
    this.textCancel,
    this.textOK,
  });

  final String? textCancel;
  final String? textOK;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    final hasCancel = textCancel != null && textCancel!.isNotEmpty;
    final hasOk = textOK != null && textOK!.isNotEmpty;

    if (!hasCancel && !hasOk) {
      // fallback 1 nút OK
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(Option.ok),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('OK'),
        ),
      );
    }

    return Row(
      children: [
        if (hasCancel)
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(Option.cancel),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(textCancel!),
            ),
          ),
        if (hasCancel && hasOk) const SizedBox(width: 12),
        if (hasOk)
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(Option.ok),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(textOK!),
            ),
          ),
      ],
    );
  }
}