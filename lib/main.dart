import 'package:champion_footballer/Utils/packages.dart';
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
          fontFamilyFallback: const ['Inter-Bold']).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: SplashScreen(),
    );
  }
}
