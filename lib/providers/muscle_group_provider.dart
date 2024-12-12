import 'package:flutter/foundation.dart';
import '../models/muscle_group_model.dart';

class MuscleGroupProvider extends ChangeNotifier {
  MuscleGroups? _selectedGroup;

  MuscleGroups? get selectedGroup => _selectedGroup;

  void selectGroup(MuscleGroups group) {
    _selectedGroup = group;
    notifyListeners();
  }

  void clearSelection() {
    _selectedGroup = null;
    notifyListeners();
  }

  void setSelectedGroup(MuscleGroups? group) {
    if (_selectedGroup == group) {
      _selectedGroup = null;
    } else {
      _selectedGroup = group;
    }
    notifyListeners();
  }
}
