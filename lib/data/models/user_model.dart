
import 'package:tudu/domain/enities/user_entity.dart';

class UserModel {
  final String id;
  final String name;

  UserModel({
    required this.id,
    required this.name
  });


  UserEntity toEntity(){
    return UserEntity(id: id, name: name);
  }

  UserModel fromEntity(UserEntity user){
    return UserModel(id: user.id, name: user.name);
  }
}