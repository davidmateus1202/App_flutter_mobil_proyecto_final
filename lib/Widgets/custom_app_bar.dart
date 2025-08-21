import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  const CustomAppBar({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon = const Icon(Icons.arrow_back_ios_new),
    this.color = Colors.white,
    this.iconButton = const IconButton(onPressed: null, icon: Icon(Icons.person_add_alt_1)),
    this.showIconButton = false,

  });

  final String title;
  final Function onPressed;
  final Icon icon;
  final Color color;
  final IconButton iconButton;
  final bool showIconButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          icon: icon,
          onPressed: () => onPressed(),
        ),
      ),
      actions: [
        if (showIconButton)
          iconButton
      ],
    );
  }
}