import 'package:shield_neet/Utils/images.dart';

class AvtarModel {
  String image;
  int id;
  AvtarModel({required this.id, required this.image});
}

class UserAvtarModel extends AvtarModel {
  UserAvtarModel({required super.id, required super.image, required this.gender});

  Gender gender;
}

enum Gender {
  unkown,
  male,
  female
}

List<UserAvtarModel> userAvtarModel = [
  UserAvtarModel(id: 1, image: Images.avtar1, gender: Gender.female),
  UserAvtarModel(id: 2, image: Images.avtar2, gender: Gender.male),
  UserAvtarModel(id: 3, image: Images.avtar3, gender: Gender.female),
  UserAvtarModel(id: 4, image: Images.avtar4, gender: Gender.male),
  UserAvtarModel(id: 5, image: Images.avtar5, gender: Gender.male),
  UserAvtarModel(id: 6, image: Images.avtar6, gender: Gender.female),
];
