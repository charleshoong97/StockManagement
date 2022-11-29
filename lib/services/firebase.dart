import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase _database = FirebaseDatabase.instance;

// FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
// FirebaseDatabase database_2 = FirebaseDatabase.instanceFor(app: secondaryApp);

Future<bool> writeSpecificExistData(
    {required dynamic data, required String path}) async {
  DatabaseReference ref = _database.ref(path);

  try {
    await ref.set(data);
  } catch (e) {
    print("Error : " + e.toString());
    return false;
  }

  return true;
}

Future<bool> writeSpecificNewData(
    {required dynamic data, required String path}) async {
  DatabaseReference ref = _database.ref(path);

  try {
    await ref.update(data);
  } catch (e) {
    print(e);
    return false;
  }

  return true;
}

Future<bool> writeNewObjectData(
    {required Map<String, dynamic> data, required String path}) async {
  try {
    final newKey = _database.ref().child(path).push().key;

    final Map<String, Map> updates = {};
    updates['$path/$newKey'] = data;

    _database.ref().update(updates);
  } catch (e) {
    print(e);
    return false;
  }

  return true;
}

Future<dynamic> readData({required String path}) async {
  DatabaseReference ref = _database.ref(path);

  try {
    final snapshot = await ref.get();
    if (snapshot.exists) {
      print(snapshot.value);
      return snapshot.value;
    } else {
      print('No data available.');
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<dynamic> listenData(
    {required String path, required Function func}) async {
  DatabaseReference ref = _database.ref(path);

  try {
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      func(data);
    });
  } catch (e) {
    print(e);
  }
}
