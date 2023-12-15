import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkNetworkConnectivity() async {
  bool result = await InternetConnectionChecker().hasConnection;
  return result;
}

String getCurrentPathWithoutQuery(BuildContext context) {
  String currentPath = GoRouterState.of(context).uri.toString();
  Uri uri = Uri.parse(currentPath);
  // Rebuild the URI without query parameters
  return Uri(
    // scheme: uri.scheme,
    // userInfo: uri.userInfo,
    // host: uri.host,
    // port: uri.port,
    path: uri.path,
  ).toString();
}

void showSnackBar({
  required BuildContext context,
  required String text,
  VoidCallback? onTapFunction,
  String? actionLabel,
}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.removeCurrentSnackBar();

  final SnackBar snackBar = SnackBar(
    content: Text(text),
    action: onTapFunction != null && actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            textColor: Colors.white,
            onPressed: onTapFunction,
          )
        : null,
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color(0xFF7700C6),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorSnackBar({
  required BuildContext context,
  required String text,
  VoidCallback? onTapFunction,
  String? actionLabel,
}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.removeCurrentSnackBar();

  final SnackBar snackBar = SnackBar(
    content: Text(text),
    action: onTapFunction != null && actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            textColor: Colors.white,
            onPressed: onTapFunction,
          )
        : null,
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color.fromARGB(255, 252, 30, 100),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// void showSnackBar(BuildContext context, String msg, Duration passDuration) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Text(msg),
//     duration: passDuration,
//     behavior: SnackBarBehavior.floating,
//     backgroundColor: const Color(0xFF7700C6),
//     //Text Copied snackbar(in message_card bottomsheet) color : const Color(0xFFA841FC)
//   ));
// }

Future<List<File>> pickImages() async {
  List<File> images = [];

  try {
    FilePickerResult? files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint("Error in picking image : ${e.toString()}");
  }

  return images;
}

Future<File> pickImage() async {
  File image = File("");

  try {
    FilePickerResult? file =
        await FilePicker.platform.pickFiles(type: FileType.image);

    image = File(file!.files[0].path!);

    if (file.files.isNotEmpty) {
      image = File(file.files[0].path!);
    }
  } catch (e) {
    debugPrint("Error in picking image : ${e.toString()}");
  }

  return image;
}
