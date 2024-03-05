import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'all_items/bloc/items_bloc.dart';
import 'all_items/view/all_items.dart';
import 'auth/view/auth_view.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // PermissionRequestService().requestNotificationPermission();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCF4Rcpt_doJr0O_5fYZbP8rNQbw9QSb6s",
      appId: "1:585961919777:android:c93ef8e3d0ee33656fda60",
      projectId: "crud-app-3a2e2",
      storageBucket: "crud-app-3a2e2.appspot.com",
      messagingSenderId: '585961919777',
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CRUD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AllItemsScreen()
        // MultiBlocProvider(
        //   providers: [
        //     BlocProvider<ItemBloc>(
        //       create: (context) => ItemBloc(ItemInitialState()),
        //     ),
        //   ],
        //   child: const
        // )
        // const AuthViewScreen(),
        );
  }
}
