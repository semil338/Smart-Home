import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/models/users.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/widgets/custom_shape.dart';
import 'package:smart_home/widgets/widgets.dart';

Widget showPhoto(Database db, String id, File? file) {
  return SizedBox(
    height: 25.h,
    child: Stack(
      children: [
        ClipPath(
          clipper: CustomShape(),
          child: Container(
            height: 150,
            color: fontColor,
          ),
        ),
        Center(
          child: Column(
            children: [
              StreamBuilder<Users?>(
                  stream: db.getUser(id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFecf5fb),
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                            color: const Color(0xFFecf5fb),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFecf5fb),
                              backgroundImage:
                                  AssetImage("assets/images/user.png"),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFecf5fb),
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                            color: const Color(0xFFecf5fb),
                          ),
                          child: Padding(
                            padding: snapshot.data!.photoURL.isNotEmpty ||
                                    file != null
                                ? const EdgeInsets.all(0)
                                : const EdgeInsets.all(18.0),
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFecf5fb),
                              backgroundImage:
                                  snapshot.data!.photoURL.isNotEmpty &&
                                          file == null
                                      ? CachedNetworkImageProvider(
                                          snapshot.data!.photoURL)
                                      : file == null
                                          ? const AssetImage(
                                              "assets/images/user.png",
                                            )
                                          : FileImage(file) as ImageProvider,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFecf5fb),
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                            color: const Color(0xFFecf5fb),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFecf5fb),
                              backgroundImage:
                                  AssetImage("assets/images/user.png"),
                            ),
                          ),
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ],
    ),
  );
}
