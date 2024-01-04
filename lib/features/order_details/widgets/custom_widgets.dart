import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomWidget {
  static Widget onlyBorderedTextField({
    String hint = '',
    TextEditingController? textController,
    bool isInt = false,
    bool isMultiline = false,
    Function(String)? onChanged,
    isEnabled = true,
  }) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
          color: isEnabled ? Colors.white : Colors.grey[300],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          enabled: isEnabled,
          onChanged: onChanged,
          style: GoogleFonts.lato(
            color: Colors.black87,
            fontSize: 17,
          ),
          maxLines: isMultiline ? 3 : 1,
          minLines: isMultiline ? 3 : 1,
          controller: textController,
          textCapitalization: TextCapitalization.words,
          keyboardType: isInt
              ? TextInputType.number
              : isMultiline
                  ? TextInputType.multiline
                  : TextInputType.text,
          inputFormatters: isInt
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  //Below is to allow only 2 digits after decimal
                  // FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                ]
              : [],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.lato(
                color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 17),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: !isEnabled,
            fillColor: Colors.grey[300],
          ),
        ));
  }

  static Widget spaceBetweenText(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        Text(
          '${value > 0 ? '+ ' : '- '}${GlobalVariables.rupeeSymbol}${value.abs()}',
          style: GoogleFonts.lato(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  //Bordered icon is used in customer profile screen
  static Widget borderedIcon(
    IconData icon, {
    double size = 30,
    Color backgroundColor = Colors.white,
    double padding = 10,
  }) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Icon(
        icon,
        size: size,
        color: Colors.black87,
      ),
    );
  }
}
