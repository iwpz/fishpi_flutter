import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WindMoonItem extends StatefulWidget {
  var data;
  WindMoonItem({Key? key, required this.data}) : super(key: key);

  @override
  State<WindMoonItem> createState() => _WindMoonItemState();
}

class _WindMoonItemState extends State<WindMoonItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 10, top: 10),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.only(right: 10),
                child: Image.network(widget.data['breezemoonAuthorThumbnailURL48']),
              ),
              Text(widget.data['breezemoonAuthorName']),
            ],
          ),
        ),
        // Container(
        //   margin: const EdgeInsets.only(left: 20),
        //   child: Text(widget.data['breezemoonContent'].toString().replaceAll('<p>', '').replaceAll('</p>', '')),
        // ),
        Html(
          key: Key(widget.data['oId']),
          data: widget.data['breezemoonContent'],
        ),
        Container(
          // height: 40,
          margin: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // height: 30,
                // width: 30,
                margin: const EdgeInsets.only(right: 10),
                child: Text(widget.data['timeAgo']),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Text(widget.data['breezemoonCity']),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
