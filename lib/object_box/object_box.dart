import 'package:object_box_practice/object_box/objectbox.g.dart';
import 'package:object_box_practice/object_box/user_model_object.dart';

class ObjectBox {
  final Store store;
  late final Box<UserModelObject> userModelObjectBox;

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  closeStore() {
    store.close();
  }

  ObjectBox._create(this.store) {
    userModelObjectBox = Box<UserModelObject>(store);
  }

  addUser(UserModelObject userModelObject) {
    userModelObjectBox.put(userModelObject);
  }

  List<UserModelObject>? getData() {
    final box = store.box<UserModelObject>();
    final existing = box.getAll();
    if (existing.isNotEmpty) {
      return existing;
    }
    return null;
  }

  deleteData() {
    userModelObjectBox.removeAll();
  }
}
