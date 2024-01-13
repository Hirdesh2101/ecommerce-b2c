import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'dart:math';

///This class contains the useful string, number manipulation functions.
class UsefulFunctions {
  static String putCommasInNumbers(int rawAmount) {
    String amount = rawAmount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return amount;
  }

  static String nameToAbbreviation(String name, {String separator = ' '}) {
    String abbreviation = name[0].toUpperCase();
    List<String> list = name.split(separator);
    if (list.length > 1) {
      abbreviation += list.last[0].toUpperCase();
    }
    return abbreviation;
  }

  static String toCamelCase(String input) {
    String output = '';
    List<String> list = input.split(' ');

    for (int i = 0; i < list.length; i++) {
      String temp = list[i].replaceFirst(list[i][0], list[i][0].toUpperCase());
      output += temp;
      output += ' ';
    }
    return output;
  }

  static String shortAddress(String address) {
    String shortAddress = address;
    List<String> list = address.split(', ');
    if (list.length > 1) {
      shortAddress = list.last;
    }
    return shortAddress;
  }

  static double roundDoubleWithPrecision(double number, {int decimalUpto = 2}) {
    int fac = pow(10, decimalUpto).toInt();
    double ans = (number * fac).round() / fac;
    return ans;
  }

  static String removeWhiteSpaces(String input) {
    return input.replaceAll(' ', '');
  }

  static String removeSpecialChars(String input) {
    return input.replaceAll(RegExp(r"[^\s\w]"), '');
  }

  static String removeSpecificString(String input, String toRemove,
      {String replaceWith = ''}) {
    return input.replaceAll(toRemove, replaceWith);
  }

  static String trimSpecialChars(String str) {
    str = str.trim();
    if (str.contains('|  |')) {
      str = str.replaceAll('|  |', ' | ').trim();
    }
    if (str[0] == '|') {
      str = str.replaceFirst('|', '').trim();
    }
    if (str.isNotEmpty && str[str.length - 1] == '|') {
      str = str.substring(0, str.length - 1).trim();
    }
    return str;
  }
}

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
