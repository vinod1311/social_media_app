import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_medial_app/core/utils/shared_prefrence_helper.dart';
import 'package:social_medial_app/features/auth/presentation/screens/sign_in_screen.dart';


import 'config/assets.dart';
import 'features/social_post/presentation/screen/social_post_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;

  //------init method
  @override
  void initState() {
    super.initState();
    timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      navigateToHome(context);
    });
  }

  // ---- method for navigating to home screen
  void navigateToHome(BuildContext context) async {
    bool isUserLoggedIn = await SharedPreferencesHelper.getIsUserLoggedIn();
    timer = Timer(
      const Duration(seconds: 2),
          () async{
            if(isUserLoggedIn){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SocialPostScreen()),
              );
            }else{
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            }

      },
    );
  }

  //------dispose method
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  //------build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.splashImage, width: 250.w, height: 250.h),
            SizedBox(height: 20.h),
            Text(
              'Social Media App',
              style: Theme.of(context).textTheme.displayMedium,
            )
          ],
        ),
      ),
    );
  }
}