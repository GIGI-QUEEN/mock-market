import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/centered_circular_progress_indicator.dart';
import 'package:stock_market/firebase_options.dart';
import 'package:stock_market/providers/auth_provider.dart';
import 'package:stock_market/theme.dart';
import 'package:stock_market/views/auth/authenticate.view.dart';
import 'package:stock_market/views/auth/login.view.dart';
import 'package:stock_market/views/auth/signup.view.dart';
import 'package:stock_market/constants/routes_names.dart';
import 'package:stock_market/views/home.view.dart';
import 'package:stock_market/views/wallet/wallet.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<FirebaseApp> _fbApp =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: lightTheme,
        routes: {
          signIn: (context) => const LoginView(),
          signUp: (context) => const SignupView(),
          authenticate: (context) => const Authenticate(),
          wallet: (context) => const WalletPage(),
          home: (context) => const HomeView(),
        },
        home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('Not loaded');
                case ConnectionState.waiting:
                  return const CenteredCircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return const Authenticate();
                  } else if (snapshot.hasError) {
                    return const Text('error');
                  } else {
                    return const Text('Not available');
                  }
              }
            }),
      ),
    );
  }
}
