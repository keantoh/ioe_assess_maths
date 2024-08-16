import 'package:math_assessment/src/api/child_api.dart';
import 'package:math_assessment/src/models/child.dart';

class ChildService {
  Future<List<Child>> fetchChildren(String userId) async {
    return await getChildren(userId);
  }

  // Other methods for interacting with the data source
}
