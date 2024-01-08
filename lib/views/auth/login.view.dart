import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/custom_text_form_field.dart';
import 'package:stock_market/providers/auth_provider.dart';
import 'package:stock_market/utils/utils.dart';
import 'package:stock_market/views/constants/routes_names.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final authProvider = context.read<AuthenticationProvider>();
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  // const PageTitle(title: 'Login'),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    textEditingController: _emailController,
                    validator: loginEmailValidator,
                    errorText: authProvider.loginErrorText,
                    hintText: 'email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    textEditingController: _passwordController,
                    validator: loginPasswordValidator,
                    errorText: authProvider.loginErrorText,
                    obscureText: true,
                    hintText: 'password',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        await authProvider.submitSignInForm(
                            _formKey, _emailController, _passwordController);
                        authProvider.clearErrorTexts();
                      },
                      child: const Text('Login')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not registered?'),
                      TextButton(
                          onPressed: () {
                            authProvider.clearErrorTexts();
                            Navigator.pushReplacementNamed(context, signUp);
                          },
                          child: const Text(
                            'Sign up',
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
