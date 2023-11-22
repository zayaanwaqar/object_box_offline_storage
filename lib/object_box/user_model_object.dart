import 'package:objectbox/objectbox.dart';

@Entity()
class UserModelObject {
  @Id()
  int internalId = 0;

  @Index()
  int userId;
  String? name;
  String? email;
  String? mobile;
  String? roll;

  UserModelObject(
      {required this.internalId,
      required this.userId,
      this.name,
      this.email,
      this.mobile,
      this.roll});
}
