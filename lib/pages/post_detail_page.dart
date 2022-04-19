import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PostDetailPage extends StatefulWidget {
  final item;
  PostDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  var postInfo;
  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  void _loadPostData() async {
    var res = await Api.getPostInfo(widget.item['oId']);
    if (res['code'] == 0) {
      setState(() {
        postInfo = res['data']['article'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '帖子内容',
      ),
      child: postInfo == null
          ? Container()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      postInfo['articleTitleEmoj'],
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        CachedNetworkImage(imageUrl: postInfo['articleAuthorThumbnailURL48'], height: 40, width: 40),
                        const SizedBox(width: 10),
                        Text(
                          '${postInfo['articleAuthor']['userNickname']}（${postInfo['articleAuthor']['userName']}）',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
                        ),
                        Expanded(child: Container()),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                postInfo['timeAgo'],
                                style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.remove_red_eye, color: Color(0xFFCCCCCC), size: 16),
                                  const SizedBox(width: 5),
                                  Text(
                                    postInfo['articleViewCntDisplayFormat'] == null ||
                                            postInfo['articleViewCntDisplayFormat'].toString().isEmpty
                                        ? postInfo['articleViewCount'].toString()
                                        : postInfo['articleViewCntDisplayFormat'].toString(),
                                    style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Html(data: postInfo['articleContent']),
                    Container(
                      margin: EdgeInsets.only(left: 20, bottom: 10, top: 30),
                      child: Text('精选评论：'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: postInfo['articleNiceComments'].length,
                        itemBuilder: (context, index) {
                          var commentItem = postInfo['articleNiceComments'][index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: CachedNetworkImage(
                                  imageUrl: commentItem['commenter']['userAvatarURL'],
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                children: [
                                  Container(
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${commentItem['commenter']['userNickname']}',
                                          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${commentItem['commenter']['userName']}',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                                        ),
                                        Text(
                                          '${commentItem['timeAgo']}',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Html(data: commentItem['commentContent']),
                                ],
                              )),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, bottom: 10, top: 30),
                      child: Text('评论：'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: postInfo['articleComments'].length,
                        itemBuilder: (context, index) {
                          var commentItem = postInfo['articleComments'][index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: CachedNetworkImage(
                                  imageUrl: commentItem['commenter']['userAvatarURL'],
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                children: [
                                  Container(
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${commentItem['commenter']['userNickname']}',
                                          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${commentItem['commenter']['userName']}',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                                        ),
                                        Text(
                                          '${commentItem['timeAgo']}',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Html(data: commentItem['commentContent']),
                                ],
                              )),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
