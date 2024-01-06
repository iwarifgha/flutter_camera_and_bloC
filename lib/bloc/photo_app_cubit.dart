import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_and_bloc/bloc/photo_app_state.dart';

class PhotoAppCubit extends Cubit<PhotoAppState> {
  PhotoAppCubit() : super(const SelectProfilePhotoState());



  openCamera() async {
    //get available cameras
    final cameras = await availableCameras();
    //get a camera controller
    final cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg
    );
    //initialize camera
    await cameraController.initialize();
    emit (CameraState(
        controller: cameraController,
        camera: cameraController.description
    ));
  }

  takePicture() async {
    final currentState = state as CameraState;
    final controller = currentState.controller;

    //take a picture with the given controller
    final rawFile = await controller.takePicture();
    final picture = File(rawFile.path);
    emit (PreviewState(file: picture));
  }

  switchCameraOptions({
    required CameraController cameraController,
    bool? isBackCam,
    ResolutionPreset? resolutionPreset
  }) async {

    final camera = await availableCameras();
    cameraController = CameraController(
        isBackCam == false ? camera.last : camera.first,
        resolutionPreset ?? ResolutionPreset.high
    );

    await cameraController.initialize();
    emit(CameraState(
        controller: cameraController,
        camera: cameraController.description
    ));

  }
  selectPhoto({
    required File file
  }){
    emit (SelectProfilePhotoState(file: file));
  }
}