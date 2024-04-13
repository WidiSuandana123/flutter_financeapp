

import 'package:flutter/material.dart';
import 'package:flutter_financeapp/pages/dashboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Import halaman-halaman yang dibutuhkan
import 'pages/home.dart';
import 'pages/import_wallet.dart';
import 'pages/create_wallet.dart';
import 'screens/news_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Web3 Crypto Wallet',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          initialRoute: '/',
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/import-wallet':
        return MaterialPageRoute(builder: (context) => const ImportWalletPage());
      case '/create-wallet':
        return MaterialPageRoute(builder: (context) => const CreateWalletPage());
      case '/dashboard':
      return MaterialPageRoute(builder: (context)=> const DashboardPage());
      case 'news-screen':
      return MaterialPageRoute(builder: (context)=> const NewScreen());
      default:
        return MaterialPageRoute(builder: (context) => const HomePage());
    }
  }
}