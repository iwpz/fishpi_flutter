import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isModal;
  final bool? showBack;
  final Widget? rightWidget;
  final String? rightTitle;
  final Function? onRightTap;
  BaseAppBar({
    Key? key,
    this.title,
    this.isModal = false,
    this.showBack = true,
    this.rightWidget,
    this.rightTitle,
    this.onRightTap,
  }) : super(key: key);

  @override
  _BaseAppBarState createState() => _BaseAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _BaseAppBarState extends State<BaseAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: GlobalStyle.mainThemeColor,
      centerTitle: true,
      leading: widget.showBack == true
          ? GestureDetector(
              onTap: () {
                NavigatorTool.pop(context);
              },
              child: widget.isModal == true
                  ? Container(
                      margin: EdgeInsets.only(left: 20, top: 20),
                      child: Text('取消', style: TextStyle(fontSize: 16, color: Colors.white)),
                    )
                  : Container(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
            )
          : Container(),
      title: Text(
        widget.title == null ? '' : widget.title!,
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
      actions: [
        widget.rightTitle != null
            ? GestureDetector(
                onTap: () {
                  if (widget.onRightTap != null) {
                    widget.onRightTap!();
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(right: 20, top: 20),
                  child: Text(
                    widget.rightTitle!,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            : widget.rightWidget != null
                ? widget.rightWidget!
                : Container(),
      ],
    );
  }
}
