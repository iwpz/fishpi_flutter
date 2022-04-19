import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostListItem extends StatefulWidget {
  final postItem;
  final Function? onTap;
  PostListItem({Key? key, required this.postItem, this.onTap}) : super(key: key);

  @override
  State<PostListItem> createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  @override
  Widget build(BuildContext context) {
    Widget item = GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(widget.postItem);
        }
      },
      child: Container(
        height: 90,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: widget.postItem['articleThumbnailURL'].toString().isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.postItem['articleThumbnailURL'],
                    )
                  : Container(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24, child: Text(widget.postItem['articleTitle'])),
                  Expanded(
                    child: Text(
                      widget.postItem['articlePreviewContent'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CachedNetworkImage(imageUrl: widget.postItem['articleAuthorThumbnailURL20']),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.postItem['articleAuthor']['userNickname']}（${widget.postItem['articleAuthor']['userName']}）',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
                        ),
                        const Icon(Icons.remove_red_eye, color: Color(0xFFCCCCCC), size: 16),
                        const SizedBox(width: 5),
                        Text(
                          widget.postItem['articleViewCntDisplayFormat'] == null ||
                                  widget.postItem['articleViewCntDisplayFormat'].toString().isEmpty
                              ? widget.postItem['articleViewCount'].toString()
                              : widget.postItem['articleViewCntDisplayFormat'].toString(),
                          style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC)),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Text(
                          widget.postItem['timeAgo'],
                          style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
    return widget.postItem['articleStickRemains'] > 0
        ? ClipRect(
            child: Banner(
                textDirection: TextDirection.rtl,
                location: BannerLocation.topEnd,
                color: const Color(0xFFDD0000),
                message: '置顶',
                child: item))
        : item;
  }
}
