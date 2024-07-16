import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketlist/pages/market_list.dart';
import 'package:marketlist/services/categ_controller.dart';
import 'package:marketlist/services/item_controller.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    CategController.getData();
    ItemController.getData();
    NavigationStateSharedPreferences.savePageState('list');
    NavigationStateSharedPreferences.saveProductPageState('notSelected');

    // Adicionar imagens à galeria via EmulatorAPI.addImageToGallery('assets/images/temp/img');

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MarketListScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: Center(
        child: SvgPicture.asset('assets/images/marketproducts.svg'),
      ),
    );
  }
}
