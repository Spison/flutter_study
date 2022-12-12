import 'package:flutter_study/data/services/database.dart';

import '../../domain/models/user.dart';

class DataService {
  Future cuUser(User user) async {
    await DB.instance.createUpdate(user);
  }
}
