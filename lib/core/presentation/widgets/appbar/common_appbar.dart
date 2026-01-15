import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  CommonAppbar({
    super.key,
    this.title,
    this.leading,
    this.bottom,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return AppBar(

      leading: leading ??
          (canPop
              ? GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                )
              : null),
      actions: actions,
      bottom: bottom,

      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(18),
        ),
      ),
      title: Text(
        title ?? '',
        style: theme.textTheme.titleLarge?.copyWith(fontSize: 16, color: theme.colorScheme.onSurface),
      ),
      flexibleSpace: Container(
        height: kToolbarHeight,
        color: Colors.transparent,
        child: const SizedBox.shrink(),
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      surfaceTintColor: const Color(0xFFF6F6F6),
    );
  }

  @override
  Size get preferredSize => Size(
    double.infinity,
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}
