import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  configureDependencies();
  
  runApp(const EdTechApp());
}
