import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/no_shadow_scroll_behavior.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomPanel;
  final Color? backgroundColor;
  final bool? scaleWithKeyboard;
  const BasePage({
    Key? key,
    required this.child,
    this.appBar,
    this.bottomPanel,
    this.backgroundColor = Colors.white,
    this.scaleWithKeyboard = false,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: widget.appBar,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.scaleWithKeyboard,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ScrollConfiguration(
            behavior: NoShadowScrollBehavior(),
            child: Column(
              children: [
                Expanded(child: widget.child),
                widget.bottomPanel == null
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            GlobalStyle.normalShadow,
                          ],
                        ),
                        child: SafeArea(child: widget.bottomPanel!),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
