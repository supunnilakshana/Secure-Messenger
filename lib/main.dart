import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';
import 'package:securemsg/pages/Home/homescreen.dart';
import 'package:securemsg/pages/welcome_screen/welcome_screen.dart';
import 'package:securemsg/service/auth/google/GoogleSignAuth.dart';
import 'package:securemsg/service/local/localdb_handeler.dart';
import 'package:securemsg/test/testscreen.dart';

import 'constants_data/themedata.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // int a = await LocalDbHandeler.getFsecureStatus();
  // print(a);
  // await LocalDbHandeler.updateFsecurestatus(0);
  // a = await LocalDbHandeler.getFsecureStatus();
  // print(a);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Secure-Messenger',
          debugShowCheckedModeBanner: false,

          //  themeMode:ThemeMode.system,
          theme: ThemeClass.darkTheme,
          // darkTheme: ThemeClass.darkTheme,
          // theme: ThemeData(
          //   primarySwatch: Colors.deepPurplea,
          //   visualDensity: VisualDensity.adaptivePlatformDensity,
          // ),
          home: WelcomeScreen(),
        ),
      );
}

// initdata()async{
// bool firstRun = await IsFirstRun.isFirstRun();

// }
