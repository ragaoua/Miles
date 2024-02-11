import 'package:flutter/material.dart';

import 'core/dependency_injection.dart' as di;
import 'features/training_log/presentation/pages/training_log_page.dart';

void main() async {
  di.init();
  runApp(const TrainingLogPage());
}
