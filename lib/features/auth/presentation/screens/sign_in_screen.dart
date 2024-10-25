
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_medial_app/features/auth/presentation/screens/sign_up_screen.dart';


import '../../../../config/assets.dart';
import '../../../social_post/presentation/screen/social_post_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SIGN IN',style: Theme.of(context).appBarTheme.titleTextStyle,),centerTitle: true,),
      body: ProgressHUD(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            log("state ${state}");
            final progress = ProgressHUD.of(context);
            if(state is AuthLoading){
              progress?.show();
            }
            if(state is Unauthenticated){
              progress?.dismiss();
            }
            if (state is Authenticated) {
              progress?.dismiss();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SocialPostScreen()),
              );
            }
            if(state is AuthError) {
              progress?.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
             child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 15.w),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   SizedBox(height: 40.h,),
                   Image.asset(Assets.signInImage, width: 250.w, height: 250.h),
                   SizedBox(height: 20.h,),
                   TextField(
                     controller: emailController,
                     decoration: const InputDecoration(labelText: 'Email',),
                   ),
                   SizedBox(height: 20.h,),
                   TextField(
                     controller: passwordController,
                     decoration: const InputDecoration(labelText: 'Password'),
                     obscureText: true,
                   ),
                   SizedBox(height: 40.h),
                   BlocBuilder<AuthBloc, AuthState>(
                     builder: (context, state) {
                       if (state is AuthLoading) {
                         return const CircularProgressIndicator();
                       }
                       return ElevatedButton(
                         style: ElevatedButtonTheme.of(context).style,
                         onPressed: () {
                           final email = emailController.text;
                           final password = passwordController.text;
                           context.read<AuthBloc>().add(
                             SignInEvent(email,password),
                           );
                         },
                         child: const Text('Login'),
                       );
                     },
                   ),
                   TextButton(
                     onPressed: () {
                       Navigator.of(context).pushReplacement(
                         MaterialPageRoute(builder: (context) => SignUpScreen()),
                       );
                     },
                     child: Text('Don\'t have an account? Sign up',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                   ),
                 ],
               ),
             ),
          )
        ),
      ),
    );
  }
}
