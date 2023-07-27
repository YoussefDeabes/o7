import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/extensions/extensions.dart';

class CancelationPolicyTextWidget extends StatefulWidget {
  final  String bold2;
  final  String? bold1;
  final  String? bold3;
  final  String text2;
  final  String text1;
  final  String? text3;
  final  String? text0;
  const CancelationPolicyTextWidget({Key? key,
      this.bold1,
      this.bold3,
      this.text3,
      this.text0,
      required  this.bold2,
      required  this.text1,
      required  this.text2}) : super(key: key);

  @override
  State<CancelationPolicyTextWidget> createState() => _CancelationPolicyTextWidgetState();
}

class _CancelationPolicyTextWidgetState extends State<CancelationPolicyTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width:context.width * 0.8,
            child: Text.rich(TextSpan(
            style: const TextStyle(fontSize:  13, color: ConstColors.text),
              children: <TextSpan>[
                TextSpan(text: widget.text0??""),

                TextSpan(
                    text: widget.bold1 ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: widget.text1),
                TextSpan(
                    text: widget.bold2,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: widget.text2),
                TextSpan(
                    text: widget.bold3??"",
                    style: const TextStyle(fontWeight: FontWeight.bold)),

                TextSpan(text: widget.text3??""),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
