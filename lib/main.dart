import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/centered_circular_progress_indicator.dart';
import 'package:stock_market/firebase_options.dart';
import 'package:stock_market/providers/auth_provider.dart';
import 'package:stock_market/providers/stock_data_provider.dart';
import 'package:stock_market/theme.dart';
import 'package:stock_market/views/auth/authenticate.view.dart';
import 'package:stock_market/views/auth/login.view.dart';
import 'package:stock_market/views/auth/signup.view.dart';
import 'package:stock_market/views/constants/routes_names.dart';
import 'package:stock_market/views/home.view.dart';
import 'package:stock_market/views/wallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<FirebaseApp> _fbApp =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final networkService = NetworkService();

  @override
  Widget build(BuildContext context) {
    //  networkService.fetchStockData("WRB");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
        ChangeNotifierProvider<StocksDataProvider>(
            create: (_) => StocksDataProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: lightTheme,
        routes: {
          signIn: (context) => const LoginView(),
          signUp: (context) => const SignupView(),
          authenticate: (context) => const Authenticate(),
          wallet: (context) => const WalletPage(),
          home: (context) => HomeView(),
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
