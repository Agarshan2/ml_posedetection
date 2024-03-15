import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  static List<Map<String, dynamic>> rightHipValues = [];
  static List<Map<String, dynamic>> leftHipValues = [];

  PosePainter(
      this.poses, this.imageSize, this.rotation, this.cameraLensDirection);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    for (final hipValue in rightHipValues) {
      canvas.drawCircle(
        Offset(
          translateX(
            hipValue['x'],
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          ),
          translateY(
            hipValue['y'],
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          ),
        ),
        1,
        paint,
      );
    }

    // for (final hipValue in leftHipValues) {
    //   canvas.drawCircle(
    //     Offset(
    //       translateX(
    //         hipValue['x'],
    //         size,
    //         imageSize,
    //         rotation,
    //         cameraLensDirection,
    //       ),
    //       translateY(
    //         hipValue['y'],
    //         size,
    //         imageSize,
    //         rotation,
    //         cameraLensDirection,
    //       ),
    //     ),
    //     1,
    //     paint,
    //   );
    // }


    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        if (landmark.type == PoseLandmarkType.rightHip) {
          rightHipValues.add({'x': landmark.x, 'y': landmark.y});

          canvas.drawCircle(
              Offset(
                translateX(
                  landmark.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  landmark.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
              ),
              5,
              paint);
        } else if (landmark.type == PoseLandmarkType.leftHip) {
          leftHipValues.add({'x': landmark.x, 'y': landmark.y});

          canvas.drawCircle(
              Offset(
                translateX(
                  landmark.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  landmark.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
              ),
              5,
              paint);
        }

        canvas.drawCircle(
            Offset(
              translateX(
                landmark.x,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateY(
                landmark.y,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
            ),
            1,
            paint);
      });

      // print('left hip values: $leftHipValues');
      // print('right hip values: $rightHipValues');



      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            paintType);
      }

      // Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, rightPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      // Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, paint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          paint);

      // Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, leftPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, leftPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }

  getRightHipValues() {
    return rightHipValues;
  }

  getLeftHipValues() {
    return leftHipValues;
  }
}
