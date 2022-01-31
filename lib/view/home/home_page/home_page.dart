import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/models/rooms.dart';
import 'package:smart_home/models/users.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/services/realtime.dart';
import 'package:smart_home/view/home/home_page/room_detail.dart';
import 'package:smart_home/view/home/notification/notification.dart';
import 'package:smart_home/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          StreamBuilder<Users?>(
              stream: db.getUser(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    backgroundColor: Color(0xFFecf5fb),
                    child: Icon(
                      Icons.account_circle,
                      size: 40,
                      color: fontColor,
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  return SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFecf5fb),
                        backgroundImage: snapshot.data!.photoURL.isNotEmpty
                            ? CachedNetworkImageProvider(
                                snapshot.data!.photoURL)
                            : null,
                        child: snapshot.data!.photoURL.isEmpty
                            ? const Icon(
                                Icons.account_circle,
                                size: 40,
                                color: fontColor,
                              )
                            : null,
                      ),
                    ),
                  );
                } else {
                  return const CircleAvatar(
                    backgroundColor: Color(0xFFecf5fb),
                    child: Icon(
                      Icons.account_circle,
                      size: 40,
                      color: fontColor,
                    ),
                  );
                }
              }),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notifications()),
            );
          },
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        // title: const Text(
        //   'Smart Home',
        //   style: TextStyle(color: Colors.black),
        // ),
      ),
      backgroundColor: const Color(0xFFecf5fb),
      //backgroundColor: Colors.black.withOpacity(0.1),
      body: Column(
        children: <Widget>[
          showUserName(db),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.topLeft,
            child: const Text("Have a good Day!"),
          ),
          showRooms(db),
        ],
      ),
    );
  }

  Widget showUserName(Database db) {
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 5),
      child: Row(
        children: <Widget>[
          Text(
            'Hello, ',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.normal),
          ),
          StreamBuilder<Users?>(
            stream: db.getUser(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Expanded(
                  child: Text(
                    snapshot.data!.name,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("");
              } else {
                return const Text("");
              }
            },
          ),
        ],
      ),
    );
  }

  Widget showRooms(Database db) {
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;
    final rb = Provider.of<Realtime>(context, listen: false);

    return Expanded(
      child: StreamBuilder<List<Room>?>(
          stream: db.getRooms('room'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RoomDetail(
                              uId: id,
                              room: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 20.h,
                        width: 100.w,
                        padding:
                            EdgeInsets.symmetric(horizontal: 2.h, vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                width: MediaQuery.of(context).size.width,
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
                                    imageUrl: snapshot.data![index].iconLink,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].name,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    StreamBuilder<Event>(
                                      stream: rb.number(
                                          id, snapshot.data![index].id),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                            "0 device",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                          );
                                        }
                                        if (snapshot.data!.snapshot.exists) {
                                          return Text(
                                            "${snapshot.data!.snapshot.value!.length} device",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                          );
                                        } else {
                                          return const Text(
                                            "0 device",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
              return ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 20.h,
                      width: 100.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.h, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[400]!,
                          highlightColor: Colors.grey[100]!,
                          // period: Duration(seconds: 2),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              color: Colors.grey[400]!,
                              shape: const RoundedRectangleBorder(),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text("Something went wrong,Try Again!!"),
              );
            }
          }),
    );
  }
}
