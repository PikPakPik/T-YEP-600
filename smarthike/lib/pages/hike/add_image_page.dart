import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/services/hike_service.dart';

class AddImagePage extends StatefulWidget {
  final Hike hike;
  const AddImagePage({super.key, required this.hike});

  @override
  AddImagePageState createState() => AddImagePageState();
}

class AddImagePageState extends State<AddImagePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  late ApiService apiService;
  late Hike hike;
  late HikeService hikeService;

  @override
  void initState() {
    super.initState();
    hike = widget.hike;
    hikeService = Provider.of<HikeService>(context, listen: false);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de l\'image : $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      Fluttertoast.showToast(
        msg: LocaleKeys.hike_files_image_no_selected.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    File file = File(_imageFile!.path);

    try {
      final response = await hikeService.uploadHikeImage(hike.id, file);
      if (response == "hike.image.uploaded") {
        Fluttertoast.showToast(
          msg: LocaleKeys.hike_files_image_uploaded.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      } else {
        Fluttertoast.showToast(
          msg: response,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de l\'image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      appBar: AppBar(
        title: Text('${LocaleKeys.hike_files_add.tr()} ${hike.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageFile != null)
              Image.file(
                File(_imageFile!.path),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 300,
                width: double.infinity,
                color: Constants.fourthColor,
                child: Icon(
                  Icons.photo,
                  size: 100,
                  color: Constants.secondaryColor,
                ),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  backgroundColor: Colors.white,
                  icon: Icons.camera,
                  text: LocaleKeys.hike_files_camera.tr(),
                  textColor: Constants.secondaryColor,
                  width: MediaQuery.of(context).size.width * 0.20,
                ),
                CustomButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  backgroundColor: Colors.white,
                  icon: Icons.photo_library,
                  text: LocaleKeys.hike_files_gallery.tr(),
                  textColor: Constants.secondaryColor,
                  width: MediaQuery.of(context).size.width * 0.20,
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_imageFile != null)
              CustomButton(
                onPressed: () => _uploadImage(),
                backgroundColor: Colors.white,
                icon: Icons.save,
                text: LocaleKeys.hike_files_upload.tr(),
                textColor: Constants.secondaryColor,
                width: MediaQuery.of(context).size.width * 0.50,
              ),
          ],
        ),
      ),
    );
  }
}
