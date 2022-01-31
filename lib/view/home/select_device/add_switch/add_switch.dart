import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/models/devices.dart';
import 'package:smart_home/models/rooms.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/services/realtime.dart';
import 'package:smart_home/widgets/widgets.dart';

class AddSwitch extends StatefulWidget {
  const AddSwitch({Key? key, required this.subCategory}) : super(key: key);
  final SubCategory subCategory;

  @override
  _AddSwitchState createState() => _AddSwitchState();
}

class _AddSwitchState extends State<AddSwitch> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void validate(Map<String, dynamic> data) {
    if (selectedRoom != null) {
      if (formKey.currentState!.validate()) {
        final db = Provider.of<Realtime>(context, listen: false);
        final auth = Provider.of<AuthBase>(context, listen: false);
        debugPrint(auth.user!.uid);
        debugPrint(roomId);
        try {
          db.setData(auth.user!.uid, roomId!, data);
          // Navigator.popUntil(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } catch (e) {
          debugPrint(e.toString());
        }
        debugPrint("valid");
      }
    } else {
      showAlertDialog(context,
          title: "Alert",
          content: "Please select a room",
          defaultActionText: "Ok");
    }
  }

  // int _value = 1;
  final nameController = TextEditingController();
  String? roomId, selectedRoom;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFecf5fb),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: fontColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Adding ${widget.subCategory.name}",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: nameController,
                    // focusNode: model.nameFocusNode,
                    validator: validateName2,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromRGBO(55, 59, 94, 1),
                      ),
                      hintText: "Enter Name",
                      enabledBorder: enabledBorder,
                      focusedBorder: focusBorder,
                      errorBorder: errorBorder,
                      focusedErrorBorder: errorBorder,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // ----- Dropdown button code -----
                StreamBuilder<List<Room>?>(
                    stream: db.getRooms("room"),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List<DropdownMenuItem> roomItem = [];
                        for (int i = 0; i < snapshot.data!.length; i++) {
                          Room room = snapshot.data![i];
                          roomItem.add(
                            DropdownMenuItem<dynamic>(
                              child: Center(child: Text(room.name)),
                              value: room.name,
                            ),
                          );
                        }
                        return Center(
                          child: Container(
                            width: 100.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 1,
                                    color: fontColor,
                                    style: BorderStyle.solid)),
                            padding: const EdgeInsets.all(8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<dynamic>(
                                alignment: AlignmentDirectional.center,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                                items: roomItem,
                                onChanged: (val) {
                                  for (var room in snapshot.data!) {
                                    if (val == room.name) {
                                      roomId = room.id;
                                    }
                                  }
                                  debugPrint(roomId);
                                  setState(() {
                                    selectedRoom = val;
                                  });
                                },
                                value: selectedRoom,
                                iconSize: 20.sp,
                                hint: Center(
                                    child: Text(
                                  "Select a room",
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily,
                                      fontSize: 18),
                                )),
                                isExpanded: true,
                                elevation: 5,
                                focusColor: bgColor,
                                dropdownColor: Colors.indigo.shade100,
                                style: TextStyle(
                                  color: fontColor,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                const SizedBox(
                  height: 60,
                ),
                // ----- Button code -----
                GestureDetector(
                  onTap: () {
                    final data = {
                      "name": nameController.text,
                      "iconLink": widget.subCategory.iconLink,
                      "type": widget.subCategory.type,
                      "value": "0"
                    };
                    validate(data);
                  },
                  child: Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      borderOnForeground: false,
                      color: fontColor,
                      shadowColor: fontColor,
                      elevation: 5,
                      child: SizedBox(
                        height: 7.h,
                        width: 50.w,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                "Add Device",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.2,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
