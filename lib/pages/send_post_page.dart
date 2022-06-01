import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class SendPostPage extends StatefulWidget {
  final int type;
  const SendPostPage({Key? key, required this.type}) : super(key: key);

  @override
  State<SendPostPage> createState() => _SendPostPageState();
}

class _SendPostPageState extends State<SendPostPage> {
  HtmlEditorController contentController = HtmlEditorController();
  HtmlEditorController rewardController = HtmlEditorController();

  TextEditingController rewardPointController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController markController = TextEditingController();
  bool enableReward = false;

  @override
  void initState() {
    if (widget.type == 1) {
      markController.text += '机要,';
    }
    rewardPointController.text = '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    // 0:帖子,5:问答,3:思绪,1:机要(附加机要标签),2:同城广播
    if (widget.type == 0) {
      title = '发帖子';
    } else if (widget.type == 5) {
      title = '发问答';
    } else if (widget.type == 3) {
      title = '发思绪';
    } else if (widget.type == 1) {
      title = '发机要';
    } else if (widget.type == 2) {
      title = '发同城广播';
    }
    return BasePage(
      appBar: BaseAppBar(
        title: title,
        backgroundColor: GlobalStyle.mainThemeColor,
        rightTitle: '发送',
        onRightTap: () async {
          if (markController.text.isEmpty) {
            Fluttertoast.showToast(msg: '加标签啊亲！');
            return;
          }
          String content = await contentController.getText();
          if (enableReward) {
            String rewardContent = await rewardController.getText();
            if (rewardContent.isEmpty) {
              Fluttertoast.showToast(msg: '您这是来白嫖了？');
            } else if (int.parse(rewardPointController.text) <= 0) {
              Fluttertoast.showToast(msg: '您这是不想赚钱了？');
            } else {
              await Api.sendPost(
                title: titleController.text,
                content: content,
                tags: markController.text,
                type: widget.type,
                rewardContent: rewardContent,
                rewardPoint: int.parse(rewardPointController.text),
              );
            }
          } else {
            await Api.sendPost(
              title: titleController.text,
              content: content,
              tags: markController.text,
              type: widget.type,
            );
          }
          NavigatorTool.pop(context);
          // if(res['code'] == 0)
        },
      ),
      scaleWithKeyboard: true,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFCECECE))),
                ),
                child: IWPZTextField(
                  hintText: '标题',
                  maxLines: 1,
                  controller: titleController,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: HtmlEditor(
                  controller: contentController,
                  callbacks: Callbacks(onInit: () {}),
                  htmlEditorOptions: const HtmlEditorOptions(
                    darkMode: false,
                  ),
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    defaultToolbarButtons: [
                      FontSettingButtons(fontName: false, fontSizeUnit: false),
                      FontButtons(
                        clearAll: false,
                        strikethrough: false,
                        superscript: false,
                        subscript: false,
                      ),
                      ListButtons(
                        listStyles: false,
                      ),
                      ParagraphButtons(
                        textDirection: false,
                        lineHeight: false,
                        caseConverter: false,
                      ),
                    ],
                  ),
                  otherOptions: OtherOptions(height: MediaQuery.of(context).size.height),
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFCECECE))),
                ),
                child: IWPZTextField(
                  hintText: '标签(逗号分隔,最多4个,每个最长9字符)',
                  maxLines: 1,
                  controller: markController,
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    const Text('启用打赏:'),
                    Checkbox(
                      value: enableReward,
                      onChanged: (value) {
                        setState(() {
                          enableReward = !enableReward;
                        });
                      },
                    ),
                    enableReward ? const Text('打赏积分:') : Container(),
                    enableReward
                        ? SizedBox(
                            height: 40,
                            width: 100,
                            child: IWPZTextField(
                              hintText: '积分值',
                              maxLines: 1,
                              controller: rewardPointController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              enableReward
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: HtmlEditor(
                        controller: rewardController,
                        callbacks: Callbacks(onInit: () {
                          // _getMeetingRecordData();
                        }),
                        htmlEditorOptions: const HtmlEditorOptions(
                          darkMode: false,
                        ),
                        htmlToolbarOptions: const HtmlToolbarOptions(
                          defaultToolbarButtons: [
                            FontSettingButtons(fontName: false, fontSizeUnit: false),
                            FontButtons(
                              clearAll: false,
                              strikethrough: false,
                              superscript: false,
                              subscript: false,
                            ),
                            ListButtons(
                              listStyles: false,
                            ),
                            ParagraphButtons(
                              textDirection: false,
                              lineHeight: false,
                              caseConverter: false,
                            ),
                          ],
                        ),
                        otherOptions: OtherOptions(height: MediaQuery.of(context).size.height),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
