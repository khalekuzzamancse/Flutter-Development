import 'package:flutter/material.dart';

Widget  richTextBuilderDemo() {

 return  
  RichTextBuilder()
    .addText(text: "Something ", style: const TextStyle(color: Colors.blue, fontSize: 20))
    .addText(text: "else ", style: const TextStyle(color: Colors.red, fontSize: 24))
    .addText(text: "entirely.", style: const TextStyle(color: Colors.green, fontSize: 18))
    .build();

}



class RichTextBuilder {
  final List<TextSpan> _spans = [];

  // Method to add text with style
  RichTextBuilder addText({required String text, TextStyle? style}) {
    _spans.add(TextSpan(text: text, style: style));
    return this;
  }

  // Build method to construct the RichText widget
  RichText build() {
    return RichText(
      text: TextSpan(children: _spans),
      // Add other RichText properties as needed, set to their default values
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      softWrap: true,
      overflow: TextOverflow.clip,
      maxLines: null, // Default to null which means no limit
      locale: null,
      strutStyle: null,
      textWidthBasis: TextWidthBasis.parent,
      textHeightBehavior: null,
    );
  }
}


