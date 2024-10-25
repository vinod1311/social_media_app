import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:social_medial_app/features/social_post/data/data_sources/social_post_data_source.dart';
import 'package:social_medial_app/features/social_post/data/repository/social_post_repository_impl.dart';
import 'package:social_medial_app/features/social_post/domain/repository/social_post_repository.dart';
import 'package:social_medial_app/features/social_post/domain/usecases/create_social_post_usecase.dart';
import 'package:social_medial_app/features/social_post/domain/usecases/fetch_post_usecase.dart';
import 'package:social_medial_app/features/social_post/domain/usecases/like_post_usecase.dart';
import '../core/resources/network/network_service.dart';
import '../features/auth/data/data_sources/firebase_auth_data_source.dart';
import '../features/auth/data/repository/auth_repository_impl.dart';
import '../features/auth/domain/repository/auth_repository.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/sign_in_usecase.dart';
import '../features/auth/domain/usecases/sign_out_usecase.dart';
import '../features/auth/domain/usecases/sign_up_usecase.dart';


final GetIt locator = GetIt.instance;

void configureDependencies() {
  // Register FirebaseAuth
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register FireBase Auth Data Sources
  locator.registerLazySingleton<FirebaseAuthDataSource>(
        () => FirebaseAuthDataSource(locator<FirebaseAuth>()),
  );

  // Register Auth Repositories
  locator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(locator<FirebaseAuthDataSource>()),
  );

  // Register Sign In Use Cases
  locator.registerFactory<SignInUseCase>(
        () => SignInUseCase(locator<AuthRepository>()),
  );

  // Register Sign Up Use Cases
  locator.registerFactory<SignUpUseCase>(
        () => SignUpUseCase(locator<AuthRepository>()),
  );

  // Register Sign Out Use Cases
  locator.registerFactory<SignOutUseCase>(
        () => SignOutUseCase(locator<AuthRepository>()),
  );

  // Register Sign Out Use Cases
  locator.registerFactory<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase(locator<AuthRepository>()),
  );

  locator.registerLazySingleton<SocialPostDataSource>(() => SocialPostDataSource(firestore: FirebaseFirestore.instance));

  locator.registerLazySingleton<SocialPostRepository>(
        () => SocialPostRepositoryImpl(locator<SocialPostDataSource>()),
  );

  locator.registerFactory<FetchPostsUsecase>(
        () => FetchPostsUsecase(repository: locator<SocialPostRepository>()),
  );

  locator.registerFactory<LikePostsUsecase>(
        () => LikePostsUsecase(repository: locator<SocialPostRepository>()),
  );

  locator.registerFactory<CreateSocialPostUsecase>(
        () => CreateSocialPostUsecase(repository: locator<SocialPostRepository>()),
  );



  locator.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    baseUrl: '',
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 3000),
  )));

  locator.registerLazySingleton<NetworkService>(() => NetworkService(locator<Dio>()));


}