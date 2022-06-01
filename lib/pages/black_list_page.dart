import 'package:fishpi_flutter/manager/black_list_manager.dart';
import 'package:fishpi_flutter/manager/eventbus_manager.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_dialog.dart';
import 'package:flutter/material.dart';

class BlackListPage extends StatefulWidget {
  BlackListPage({Key? key}) : super(key: key);

  @override
  State<BlackListPage> createState() => _BlackListPageState();
}

class _BlackListPageState extends State<BlackListPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '屏蔽列表',
        backgroundColor: GlobalStyle.mainThemeColor,
      ),
      child: BlackListManager().blackList.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 32),
              child: Text('暂无数据'),
            )
          : Container(
              margin: const EdgeInsets.only(top: 32),
              height: MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(BlackListManager().blackList.length + 1, (index) {
                    if (index == BlackListManager().blackList.length) {
                      return Container(
                        height: 46,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                IWPZDialog.show(
                                  context,
                                  title: '提示',
                                  titleColor: Colors.white,
                                  okColor: Colors.white,
                                  content: '确定要清空屏蔽列表吗？',
                                  backgroundColor: GlobalStyle.mainThemeColor,
                                  onOKTap: () {
                                    setState(() {
                                      eventBus.fire(OnBlackListChangeEvent());
                                      BlackListManager().clearBlackList();
                                    });
                                  },
                                );
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 85, 73),
                                ),
                                child: Text('清空'),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Container(
                      height: 46,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Text(BlackListManager().blackList[index]),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              IWPZDialog.show(
                                context,
                                title: '提示',
                                titleColor: Colors.white,
                                okColor: Colors.white,
                                content: '确定要解除屏蔽${BlackListManager().blackList[index]}吗？',
                                backgroundColor: GlobalStyle.mainThemeColor,
                                onOKTap: () {
                                  setState(() {
                                    eventBus.fire(OnBlackListChangeEvent());
                                    BlackListManager().removeFromBlackList(BlackListManager().blackList[index]);
                                  });
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 85, 73),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('移除'),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
    );
  }
}
