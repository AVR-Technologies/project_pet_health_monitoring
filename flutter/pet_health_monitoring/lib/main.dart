import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
	WidgetsFlutterBinding.ensureInitialized();
	SyncfusionLicense.registerLicense(null);
  runApp(MaterialApp(
		title: 'Pet health',
		debugShowCheckedModeBanner: false,
		theme: ThemeData(
			textTheme: GoogleFonts.montserratTextTheme(),
			primaryColor: Colors.indigo[500],
		),
		home: LoginPage(),
	));
}


//Give network permission in AndroidManifest.xml
//<uses-permission android:name="android.permission.INTERNET" />