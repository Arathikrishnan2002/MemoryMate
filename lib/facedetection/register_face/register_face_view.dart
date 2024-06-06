import 'dart:convert';

import 'package:memorymate/facedetection/authenticate_face/scanning_animation/animated_view.dart';
import 'package:memorymate/facedetection/common/utils/extract_face_feature.dart';
import 'package:memorymate/facedetection/common/views/camera_view.dart';
import 'package:memorymate/facedetection/common/views/custom_button.dart';
import 'package:memorymate/facedetection/common/utils/extensions/size_extension.dart';
import 'package:memorymate/facedetection/constants/theme.dart';
import 'package:memorymate/facedetection/model/user_model.dart';
import 'package:memorymate/facedetection/register_face/enter_details_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class RegisterFaceView extends StatefulWidget {
  const RegisterFaceView({Key? key}) : super(key: key);

  @override
  State<RegisterFaceView> createState() => _RegisterFaceViewState();
}

class _RegisterFaceViewState extends State<RegisterFaceView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  String? _image;
  FaceFeatures? _faceFeatures;
  bool isMatching = false;
  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Register Visitor"),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scaffoldTopGradientClr,
              scaffoldBottomGradientClr,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 0.82.sh,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0.04.sh),
              decoration: BoxDecoration(
                color: overlayContainerClr,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.03.sh),
                  topRight: Radius.circular(0.03.sh),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CameraView(
                    onImage: (image) {
                      //image capturing
                      setState(() {
                        _image = base64Encode(image);
                      });
                    },
                    onInputImage: (inputImage) async {
                      setState(() => isMatching = true);
                      _faceFeatures =
                          await extractFaceFeatures(inputImage, _faceDetector);
                      setState(() => isMatching = false);
                      setState(() {});
                    },
                  ),
                  if (isMatching)
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.064.sh),
                        child: const AnimatedView(),
                      ),
                    ),
                  const Spacer(),
                  if (_image != null)
                    CustomButton(
                      text: "Start Registering",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EnterDetailsView(
                              image: _image!,
                              faceFeatures: _faceFeatures!,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
