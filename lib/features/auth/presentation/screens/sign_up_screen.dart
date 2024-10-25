import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_medial_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:social_medial_app/features/social_post/presentation/screen/social_post_screen.dart';


import '../../../../config/assets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SIGN UP',style: Theme.of(context).appBarTheme.titleTextStyle,),centerTitle: true,),
      body: ProgressHUD(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            final progress = ProgressHUD.of(context);
            if(state is AuthLoading){
              progress?.show();
            }
            if(state is Unauthenticated){
              progress?.dismiss();
            }
            if (state is Authenticated) {
              progress?.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User register successfully")),
              );
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
                children: <Widget>[
                  SizedBox(height: 40.h,),
                  Image.asset(Assets.signUpImage, width: 250.w, height: 250.h),
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
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          context.read<AuthBloc>().add(
                            SignUpEvent(email,password),
                          );
                        },
                        child: const Text('Sign Up'),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                    child:Text('Already have an account? Login',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
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
