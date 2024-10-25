import 'package:equatable/equatable.dart';

import '../../../../core/utils/common_method.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends  UserEntity{


  const UserModel({
    required super.uid,
    required super.email,
    //required super.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      //username: json['username'],
    );
  }

  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      //username: generateRandomUsername(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      //'username': username,
    };
  }

  @override
  List<Object?> get props => [uid,email];
}