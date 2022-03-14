import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/route_generator.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EzDatabase.instance.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: routeRoot,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
