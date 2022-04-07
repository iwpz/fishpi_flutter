import 'package:flutter/material.dart';

class MedalWidget extends StatelessWidget {
  final medal;
  const MedalWidget({Key? key, required this.medal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //url=https://pwl.stackoverflow.wiki/2021/12/ht1-d8149de4.jpg&backcolor=ffffff&fontcolor=ff3030
    List<String> attrs = medal['attr'].toString().split('&');
    String url = attrs[0].replaceAll('url=', '');
    // String backcolor = attrs[1].split('=')[1];
    // String fontcolor = attrs[2].split('=')[1];
    // int backC = int.parse(backcolor, radix: 16) + 0xFF000000;
    // int fontC = int.parse(fontcolor, radix: 16) + 0xFF000000;
    return Container(
      height: 25,
      width: 25,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(image: NetworkImage(url)),
      ),
    );
  }
}
