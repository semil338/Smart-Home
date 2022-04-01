import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/view/home/select_device/add_switch/add_switch.dart';
import 'package:smart_home/models/category.dart';
import 'package:smart_home/models/devices.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/widgets/widgets.dart';

class SelectDevice extends StatefulWidget {
  const SelectDevice({Key? key}) : super(key: key);

  @override
  State<SelectDevice> createState() => _SelectDeviceState();
}

class _SelectDeviceState extends State<SelectDevice> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);

    Size size = MediaQuery.of(context).size;

    final itemHeight = (size.height - kToolbarHeight - 24) * 0.34;
    final itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: MenuWidget(),
        iconTheme: const IconThemeData(color: fontColor),
      ),
      backgroundColor: bgColor,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Select Device',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const Text(
              'You can add devices in your home from below ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<List<Category>?>(
                stream: db.getCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Card(
                                color: Colors.blueGrey.shade400,
                                elevation: 5,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Center(
                                    child: Text(
                                      snapshot.data![index].name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder<List<SubCategory>?>(
                                stream: db.getDevices(
                                  snapshot.data![index].id,
                                ),
                                builder: (context, deviceSnapshot) {
                                  if (deviceSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (deviceSnapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (deviceSnapshot.hasData) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio:
                                                (itemWidth / itemHeight),
                                          ),
                                          itemCount:
                                              deviceSnapshot.data!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index1) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddSwitch(
                                                      subCategory:
                                                          deviceSnapshot
                                                              .data![index1],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                // color: Colors.red,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                // height: 100,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height:
                                                            size.height * 0.085,
                                                        width:
                                                            size.width * 0.15,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18)),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: SvgPicture
                                                              .network(
                                                            deviceSnapshot
                                                                .data![index1]
                                                                .iconLink,
                                                            color:
                                                                kPrimaryColor,
                                                            width: size.width *
                                                                0.08,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Expanded(
                                                        child: Text(
                                                          deviceSnapshot
                                                              .data![index1]
                                                              .name,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 9.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return Container();
                                  }
                                }),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
