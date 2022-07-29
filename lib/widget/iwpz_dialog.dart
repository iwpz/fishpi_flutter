import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:flutter/material.dart';

class IWPZDialog {
  static void show(
    BuildContext context, {
    String title = '', //标题
    Color titleColor = Colors.black,
    String content = '', //正文，如果有contentWidget，则无视
    Widget? contentWidget, //正文widget
    bool showCancelWidget = false,
    Widget? cancelWidget,
    bool showCancel = true, //是否显示取消
    bool tapToDismiss = true, //点击空白处关闭
    bool cancelToDismiss = true, //点击取消是否关闭
    double height = 220, //宽度
    double width = 400, //高度
    Color backgroundColor = Colors.white,
    Color okColor = Colors.black,
    Function? onOKTap, //onOK
    Function? onCancelTap, //onCancel
  }) {
    showDialog(
        context: context,
        barrierDismissible: tapToDismiss,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              if (tapToDismiss) {
                NavigatorTool.pop(context);
              }
            },
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {},
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: backgroundColor,
                    ),
                    padding: const EdgeInsets.only(top: 32, left: 10, right: 10),
                    height: height,
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title.isEmpty
                            ? Container()
                            : Container(
                                margin: const EdgeInsets.only(bottom: 20, left: 10),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: titleColor,
                                  ),
                                ),
                              ),
                        contentWidget != null
                            ? Expanded(
                                child: Container(
                                  child: contentWidget,
                                ),
                              )
                            : content.isEmpty
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      content,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                        SizedBox(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              showCancel
                                  ? Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (onCancelTap != null) {
                                            onCancelTap();
                                          }
                                          if (cancelToDismiss) {
                                            NavigatorTool.pop(context);
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '取消',
                                            style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : showCancelWidget
                                      ? cancelWidget ?? Container()
                                      : Container(),
                              showCancel || showCancelWidget
                                  ? Container(
                                      width: 1,
                                      height: 30,
                                      color: const Color(0x4DFFFFFF),
                                    )
                                  : Container(),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    if (onOKTap != null) {
                                      onOKTap();
                                    }
                                    NavigatorTool.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '确定',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: okColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
