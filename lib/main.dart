import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:location/location.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? imageFile;
  String dirPath = '';
  var location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee companion'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageFile != null)
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(image: FileImage(imageFile!)),
                    border: Border.all(width: 8, color: Colors.black12),
                    borderRadius: BorderRadius.circular(12.0)),
              )
            else
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 8, color: Colors.black12),
                    borderRadius: BorderRadius.circular(12.0)),
                child: const Text(
                  'Image here',
                  style: TextStyle(fontSize: 26),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        {getImage(source: ImageSource.camera), getLocation()},
                    child: const Text('Capture Image',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        {getImage(source: ImageSource.gallery), getLocation()},
                    child: const Text(
                      'Select Image',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {
    final file =
        await ImagePicker().pickImage(source: source, imageQuality: 100);

    // Map<String, IfdTag> data =
    //     await readExifFromBytes(await imageFile!.readAsBytes());

    // if (data == null || data.isEmpty) {
    //   print("-no exif data");
    //   return;
    // }

    // for (String key in data.keys) {
    //   print("-$key (${data[key]?.tagType}): ${data[key]}");
    // }

    // Uint8List imageData = await imageFile?.originBytes;

    // Uint8List bytes;
    // bytes = await imageFile!.readAsBytes();
    // var tags = await readExifFromBytes(bytes, details: false);
    // print(tags);
    // tags.forEach((key, value) => print("$key : $value"));

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        // dirPath = imageFile!.path;
        // print('path');
        // print(dirPath);
      });
    }
  }

  void getLocation() async {
    var serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var currentLocation = await location.getLocation();
    print("-current location is $currentLocation ");
  }

  // void getPhotoData(List<AssetEntity> photos) async {
  //   for (AssetEntity photo in photos) {
  //     if (photo.type == AssetType.image) {
  //       var date = photo.createDateTime;
  //       var location = photo.latlngAsync();

  //       Uint8List? imageData = await photo.originBytes;
  //       Map<String, IfdTag> data =
  //           await readExifFromBytes(imageData!, details: false);
  //     }
  //   }
  // }
}
