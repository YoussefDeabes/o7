import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';

class AuthBackgroundWidget extends StatelessWidget {
  final List<Widget> children;

  const AuthBackgroundWidget({required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage(AssPath.bg),
                fit: BoxFit.fill,
              ),
            ),
          ),

          //contain all widget in auth screen
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children),
            ),
          ),
        ],
      ),
    );
  }
}
