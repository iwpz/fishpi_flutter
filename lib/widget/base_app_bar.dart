import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? centerWidget;
  final bool? isModal;
  final bool? showBack;
  final Widget? rightWidget;
  final String? rightTitle;
  final Function? onRightTap;
  final Color? backgroundColor;
  final bool? showBottomShadow;
  final Color? contentColor;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  const BaseAppBar({
    Key? key,
    this.title,
    this.centerWidget,
    this.isModal = false,
    this.showBack = true,
    this.rightWidget,
    this.rightTitle,
    this.onRightTap,
    this.backgroundColor = GlobalStyle.mainThemeColor,
    this.showBottomShadow = true,
    this.contentColor = Colors.white,
    this.actions = const [],
    this.bottom,
  }) : super(key: key);

  @override
  _BaseAppBarState createState() => _BaseAppBarState();

  @override
  Size get preferredSize => _PreferredAppBarSize(56, bottom?.preferredSize.height);
}

class _BaseAppBarState extends State<BaseAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor!,
      shadowColor: widget.showBottomShadow == true ? Colors.black : Colors.transparent,
      centerTitle: true,
      bottom: widget.bottom,
      leading: widget.showBack == true
          ? GestureDetector(
              onTap: () {
                NavigatorTool.pop(context);
              },
              child: widget.isModal == true
                  ? Container(
                      margin: const EdgeInsets.only(left: 20, top: 20),
                      child: Text('取消', style: TextStyle(fontSize: 16, color: widget.contentColor)),
                    )
                  : Icon(
                      Icons.arrow_back,
                      color: widget.contentColor,
                    ),
            )
          : Container(),
      title: widget.title != null
          ? Text(
              widget.title == null ? '' : widget.title!,
              style: TextStyle(color: widget.contentColor, fontSize: 17),
            )
          : widget.centerWidget == null
              ? Container()
              : widget.centerWidget!,
      actions: widget.actions!.isNotEmpty
          ? widget.actions
          : [
              widget.rightTitle != null
                  ? GestureDetector(
                      onTap: () {
                        if (widget.onRightTap != null) {
                          widget.onRightTap!();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: Text(
                          widget.rightTitle!,
                          style: TextStyle(fontSize: 16, color: widget.contentColor),
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

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
    : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}