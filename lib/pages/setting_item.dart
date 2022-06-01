import 'package:fishpi_flutter/style/global_style.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Function? onTap;
  const SettingItem({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: 46,
        padding: const EdgeInsets.only(left: 16, right: 10),
        child: Row(
          children: [
            Text(title),
            Expanded(
                child: Container(
              color: Color(0x01000000),
            )),
            Icon(
              Icons.keyboard_arrow_right,
              color: GlobalStyle.mainThemeColor,
            ),
          ],
        ),
      ),
    );
  }
}
