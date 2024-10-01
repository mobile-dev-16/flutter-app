import 'package:eco_bites/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_event.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_button/sign_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDDF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 180,
                ),
              ),
              const SizedBox(height: 16),
              // Google Sign Up Button using SignInButton package
              _buildGoogleSignUpButton(context),
              const SizedBox(height: 16),
              const Text('OR'),
              const SizedBox(height: 16),
              // Email TextField
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password TextField
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Register Button
              BlocListener<AuthBloc, AuthState>(
                listener: (BuildContext context, AuthState state) {
                  if (state is AuthLoading) {
                    _showLoadingDialog(context);
                  } else if (state is AuthAuthenticated) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/main',
                      (Route<dynamic> route) => false,
                    );
                  } else if (state is AuthError) {
                    Navigator.pop(context); // Close loading dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        SignUpRequested(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF725C0C),
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Navigate back to Login Screen
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to LoginScreen
                },
                child: const Text('Already have an account? Log in here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Google Sign Up Button using SignInButton package
  Widget _buildGoogleSignUpButton(BuildContext context) {
    return SignInButton(
      buttonType: ButtonType.google,
      btnColor: Colors.white,
      btnText: 'Sign up with Google',
      width: 200,  // Adjust the width for the Google button
      onPressed: () {
        context.read<AuthBloc>().add(SignUpWithGoogleRequested());
      },
      elevation: 0,
    );
  }

  // Loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
