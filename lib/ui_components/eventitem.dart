import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:securemsg/constants_data/ui_constants.dart';

class EventItem extends StatelessWidget {
  final String titel;
  final String description;
  final String date;
  final String imgurl;
  final Function() edit;
  final Function() info;

  const EventItem(
      {Key? key,
      required this.titel,
      required this.description,
      required this.date,
      required this.imgurl,
      required this.edit,
      required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
        //    color: Colors.white,
        child: Container(
            height: size.height * 0.3,
            child: Column(children: [
              Row(children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: imgurl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            //  height: size.height * 0.01,
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.lightBlueAccent,
                                  value: downloadProgress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: size.height * 0.3,
                        )
                      ],
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                      height: size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            // color: kprimaryColors,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: size.width * 0.001),
                                  child: IconButton(
                                    onPressed: info,
                                    icon: Icon(Icons.info_outline),
                                    hoverColor: Colors.amber,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: size.width * 0.001),
                                  child: IconButton(
                                    onPressed: edit,
                                    icon: Icon(Icons.edit),
                                    hoverColor: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: size.height * 0.02,
                                top: size.height * 0.001),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  titel,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.0125),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.002,
                              right: size.width * 0.003,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: size.width * 0.0105,
                                      color: Colors.black.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: size.height * 0.02),
                                child: Container(
                                  // color: kprimaryColors,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: size.width * 0.001),
                                          child: Text(
                                            'Written date : ' + date,
                                            style: TextStyle(
                                              fontSize: size.width * 0.0105,
                                              color: kscondaryColor
                                                  .withOpacity(0.9),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              ])
            ])));
  }
}
