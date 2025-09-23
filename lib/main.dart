import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Views/Auth/authmain.dart'; // Ensure AuthScreen is imported
import 'package:champion_footballer/Views/Start%20Page/mainstartpage.dart'; // Import MainStartPage
import 'package:champion_footballer/Services/RiverPord%20Provider/ref_provider.dart'; // Import authCheckProvider
import 'package:flutter/material.dart'; // Import Material
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:toastification/toastification.dart';

void main() {
  runApp(
    ProviderScope(
      child: ToastificationWrapper(
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final authState = ref.watch(authCheckProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Champion Footballer',
      theme: ThemeData(
        fontFamily: "Inter",
        primaryColor: kPrimaryColor,
        colorScheme: theme.currentColorScheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        useMaterial3: true,
        fontFamilyFallback: const ['Inter-Bold'],
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: authState.when(
        data: (isLoggedIn) {
          print("[MyApp - authState.when(data)] isLoggedIn: $isLoggedIn"); 
          if (isLoggedIn) {
            return const DashboardScreen2();
          } else {
            return const AuthScreen();
          }
        },
        loading: () {
          print("[MyApp - authState.when(loading)] Checking auth status...");
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        error: (err, stack) {
          print("[MyApp - authState.when(error)] Error checking auth status: $err");
          return const AuthScreen();
        },
      ),
    );
  }
}
