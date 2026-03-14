import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Stream of data from a specific node, e.g., 'sensors' or 'ArchiSRI-System'
  // I'll assume the data is under a top-level node.
  // If the user said "called ArchiSRI-System", it might be the project name or a node name.
  // I'll start by listening to the root or a likely node.
  Stream<DatabaseEvent> getSensorDataStream() {
    return _database.onValue;
  }

  // Example method to get data from a specific path
  Stream<DatabaseEvent> getDataStream(String path) {
    return _database.child(path).onValue;
  }
}
