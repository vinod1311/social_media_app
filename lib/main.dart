
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_medial_app/features/social_post/presentation/bloc/social_post_bloc.dart';
import 'package:social_medial_app/splash_screen.dart';
import 'config/theme/theme_data_style.dart';
import 'config/config_injection.dart';
import 'core/utils/shared_prefrence_helper.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/social_post/domain/usecases/create_social_post_usecase.dart';
import 'features/social_post/domain/usecases/fetch_post_usecase.dart';
import 'features/social_post/domain/usecases/like_post_usecase.dart';


void main() async{

  //------ widget binding
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  //-------DI configure
  configureDependencies();

  //-------init SharedPreferencesHelper
  await SharedPreferencesHelper.init();

  //------- device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);


  runApp(
    //---------- list of all bloc provider
    MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(
              signInUseCase: locator<SignInUseCase>(),
              signUpUseCase: locator<SignUpUseCase>(),
              signOutUseCase: locator<SignOutUseCase>(),
              getCurrentUserUseCase: locator<GetCurrentUserUseCase>(),
            )..add(CheckAuthStatusEvent()),
          ),
          BlocProvider(
            create: (_) => SocialPostBloc(
              createSocialPostUsecase: locator<CreateSocialPostUsecase>(),
              fetchPostsUsecase: locator<FetchPostsUsecase>(),
              likePostsUsecase: locator<LikePostsUsecase>(),
            ),
          ),
        ],
    child: const MyApp())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context,child){
          return MaterialApp(
            title: 'Social Media APP',
            debugShowCheckedModeBanner: false,
            theme: ThemeDataStyle.light,
            darkTheme: ThemeDataStyle.dark,
            themeMode: ThemeMode.system,
            home: const SplashScreen(),
          );
        }
    );
  }
}






