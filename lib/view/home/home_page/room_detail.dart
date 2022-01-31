import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/models/rooms.dart';
import 'package:smart_home/services/realtime.dart';
import 'package:smart_home/view/home/home_page/switch_detail.dart';
import 'package:smart_home/widgets/widgets.dart';

class RoomDetail extends StatelessWidget {
  const RoomDetail({Key? key, required this.uId, required this.room})
      : super(key: key);
  final String uId;
  final Room room;

  @override
  Widget build(BuildContext context) {
    final rb = Provider.of<Realtime>(context, listen: false);
    return Scaffold(
      // backgroundColor: const Color(0xFFecf5fb),
      backgroundColor: bgColor,
      appBar: AppBar(
        // toolbarHeight: 100,
        flexibleSpace: Container(
          color: Colors.black.withOpacity(0.7),
          child: Opacity(
            opacity: 0.5,
            child: CachedNetworkImage(
              placeholder: (context, url) {
                return Container();
              },
              errorWidget: (context, url, error) {
                return Container();
              },
              fit: BoxFit.fill,
              imageUrl: room.iconLink,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        // elevation: 3,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          room.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<Event>(
        stream: rb.number(uId, room.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: CircleAvatar(
                                  radius: 5.h,
                                  child: Container(
                                    height: 6.h,
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(),
                                ),
                              )
                            ],
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              decoration: ShapeDecoration(
                                color: Colors.grey[400]!,
                                shape: const RoundedRectangleBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.snapshot.value != null) {
              return GridView.builder(
                itemCount: snapshot.data!.snapshot.value.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  Map<Object?, Object?> map = snapshot.data!.snapshot.value;

                  List l1 = map.values.toList();
                  List l2 = map.keys.toList();
                  String key = l2[index].toString();
                  String name = l1[index]['name'].toString();
                  String url = l1[index]['iconLink'].toString();
                  String value = l1[index]['value'].toString();
                  String type = l1[index]['type'].toString();

                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SwitchDetail(
                            name: name,
                            url: url,
                            value: value,
                            type: type,
                            roomId: room.id,
                            uid: uId,
                            sId: key,
                          ),
                        ));
                      },
                      child: Card(
                        // color: bgColor,
                        // shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 5.h,
                                    child: SvgPicture.network(
                                      url,
                                      color: type == "Button"
                                          ? value == "1"
                                              ? Colors.orange
                                              : Colors.grey
                                          : Colors.orange,
                                      height: 6.h,
                                    ),
                                  ),
                                  type == "Button"
                                      ? SizedBox(
                                          width: 15.w,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CupertinoSwitch(
                                              activeColor:
                                                  Colors.orange.shade300,
                                              trackColor: Colors.grey,
                                              thumbColor: Colors.white,
                                              value:
                                                  value == '1' ? true : false,
                                              onChanged: (value) {
                                                _updateValue(value, rb, key);
                                              },
                                            ),
                                            // child: Switch.adaptive(
                                            //   activeColor:
                                            //       Colors.orange.shade300,
                                            //   trackColor:
                                            //       MaterialStateProperty.all(
                                            //           Colors.grey),
                                            //   thumbColor:
                                            //       MaterialStateProperty.all(
                                            //           Colors.white),
                                            //   value:
                                            //       value == '1' ? true : false,
                                            //   onChanged: (value) {
                                            //     _updateValue(value, rb, key);
                                            //   },
                                            // ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Text(value),
                                        ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 3.h,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                name,
                                style: const TextStyle(
                                    color: fontColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  "Nothing to show!",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300),
                ),
              );
            }
          } else {
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300),
              ),
            );
          }
        },
      ),
    );
  }

  _updateValue(bool value, Realtime rb, String sId) {
    String val = value ? "1" : "0";
    try {
      rb.setValueField(
        uid: uId,
        roomId: room.id,
        sId: sId,
        value: val,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
