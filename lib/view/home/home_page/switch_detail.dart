import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/services/realtime.dart';
import 'package:smart_home/widgets/widgets.dart';

class SwitchDetail extends StatelessWidget {
  SwitchDetail({
    Key? key,
    required this.value,
    required this.name,
    required this.url,
    required this.type,
    required this.uid,
    required this.roomId,
    required this.sId,
  }) : super(key: key);
  final String value;
  final String name;
  final String url;
  final String type;
  final String uid;
  final String roomId;
  final String sId;
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = name;
    String val = value == "1" ? "On" : "Off";
    final rb = Provider.of<Realtime>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                try {
                  rb.deleteSwitch(uid, roomId, sId);
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              icon: const Icon(Icons.delete))
        ],
        centerTitle: true,
        title: const Text("Edit"),
        backgroundColor: fontColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SvgPicture.network(
              url,
              height: 10.h,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              // initialValue: name,
              // onEditingComplete: editingComplete,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validateName2,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Switch name",
                prefixIcon: Icon(
                  Icons.device_hub,
                  color: fontColor,
                ),
                enabledBorder: enabledBorder,
                focusedBorder: focusBorder,
                errorBorder: errorBorder,
                focusedErrorBorder: errorBorder,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Type : $type",
              style: const TextStyle(
                  color: fontColor, fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Text(
              "Value : $val",
              style: const TextStyle(
                  color: fontColor, fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(fontColor)),
              onPressed: () {
                try {
                  rb.updateData(
                    data: {"name": nameController.text},
                    roomId: roomId,
                    sId: sId,
                    uid: uid,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
