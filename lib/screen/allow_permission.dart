import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtrecorder/provider/permission_provider.dart';
import 'package:mtrecorder/screen/homepage.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:mtrecorder/widgets/logo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../widgets/open_setting.dart';

class AllowPermission extends StatefulWidget {
  const AllowPermission({Key? key}) : super(key: key);

  @override
  State<AllowPermission> createState() => _AllowPermissionState();
}

class _AllowPermissionState extends State<AllowPermission> {
  void handleNavigate() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const HomePage()));

  /*checkForPermission() async {
    if (await Permission.storage.status.isGranted) {
      Provider.of<PermissionProvider>(context, listen: false)
          .requestStoragePermission();
    }
  }*/

  @override
  void initState() {
    super.initState();
   // checkForPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: logo(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(child: Image.asset(Strings.storage)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: storageText(),
            ),
          )
        ],
      ),
      bottomNavigationBar: Consumer<PermissionProvider>(
          builder: (context, PermissionProvider provider, child) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(15),
                onPressed: () async {
                  PermissionStatus? storage =
                      await provider.requestStoragePermission();
                  if (storage == null) return;
                  if (storage.isGranted) {
                    handleNavigate();
                  } else {
                    if(mounted) {
                      bool openSetting = await showOpenSetting(
                          context: context, text: storageText());
                      openSetting ? openAppSettings() : null;
                    }
                  }
                },
                child: const Text("ALLOW")));
      }),
      /* floatingActionButton: */ /*FloatingActionButton(
        onPressed: () {
          showOpenSetting(context: context, text: storageText());
        },
      ),*/
    );
  }

  Text storageText() {
    return const Text(
      "To Record videos and Take screenshots, Please allow us to access media on your device",
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
  }
}
