import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageViewPage extends StatefulWidget {
  final String imageUrl;
  ImageViewPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorTool.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.black,
                child: ExtendedImage.network(
                  widget.imageUrl,
                  mode: ExtendedImageMode.gesture,
                  cache: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        var fileName = widget.imageUrl.split('/').last;
                        var response =
                            await Dio().get(widget.imageUrl, options: Options(responseType: ResponseType.bytes));
                        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
                            quality: 60, name: fileName);
                        Fluttertoast.showToast(msg: '保存成功');
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 40,
                      )),
                  SizedBox(width: 40),
                  IconButton(
                      onPressed: () async {
                        var facePacksRes = await Api.getFacePack();
                        if (facePacksRes['code'] == 0) {
                          List<dynamic> facePackList = json.decode(facePacksRes['data']);
                          facePackList.add(widget.imageUrl);
                          print(facePackList);
                          var res = await Api.addFacePack(facePackList);
                          if (res['code'] == 0) {
                            Fluttertoast.showToast(msg: '已添加到表情收藏!');
                          }
                        }
                        // print(facePackList);
                        // print(facePacksRes);
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 40,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
