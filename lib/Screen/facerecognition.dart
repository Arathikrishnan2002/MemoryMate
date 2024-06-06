import 'package:flutter/material.dart';
import 'package:memorymate/facedetection/authenticate_face/authenticate_face_view.dart';
import 'package:memorymate/facedetection/common/views/custom_button.dart';
import 'package:memorymate/facedetection/common/utils/custom_snackbar.dart';
import 'package:memorymate/facedetection/common/utils/extensions/size_extension.dart';
import 'package:memorymate/facedetection/common/utils/screen_size_util.dart';
import 'package:memorymate/facedetection/constants/theme.dart';
import 'package:firebase_core/firebase_core.dart';

class FaceRecognitionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: FaceReg1(),
      ),
    );
  }
}

class FaceReg1 extends StatelessWidget {
  const FaceReg1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeUtilContexts(context);

    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Visitor Verification",
            style: TextStyle(
              color: textColor,
              fontSize: 0.033.sh,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.07.sh),
          CustomButton(
            text: "Verify Visitor",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AuthenticateFaceView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void initializeUtilContexts(BuildContext context) {
    ScreenSizeUtil.context = context;
    CustomSnackBar.context = context;
  }
}
