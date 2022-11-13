import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zune/src/models/tflite/recognition.dart';
import 'package:zune/src/providers/recognition_provider.dart';
import 'package:zune/src/providers/ui_provider.dart';
import 'package:zune/src/providers/loc_provider.dart';

import 'package:zune/src/screens/loading_screens/splash_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();

  Hive.registerAdapter(RecognitionAdapter());

  await Hive.openBox<Recognition>('recognition');

  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UiProvider()),
          ChangeNotifierProvider(create: (_) => LocProvider(), lazy: false),
          ChangeNotifierProvider(create: (_) => RecognitionProvider(), lazy: false),
        ],
        child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Zune', initialRoute: '/', routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => SplashScreen(),
        }),
      ),
    );
  }
}



/*
TODO:

- [X] Local cache to save custom objects
- [X] Show in different colors those that are saved and those that are not
- [ ] That the click has the associated action
- [ ] Let the user search


*/


















/*
rm -Rf build
rm -Rf .dart_tool
rm .packages
rm -Rf ios/Pods
rm -Rf ios/.symlinks      
rm -Rf ios/Flutter/Flutter.framework
rm -Rf ios/Flutter/Flutter.podspec  
rm -Rf /Users/victorxirauguardans/Library/Developer/Xcode/DerivedData
pod cache clean --all  
cd ios
pod deintegrate
pod setup
arch -x86_64 pod install         
cd ..
flutter clean -v
flutter pub get
flutter build ipa

*/
