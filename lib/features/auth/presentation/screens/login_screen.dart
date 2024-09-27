import 'package:eco_bites/features/auth/presentation/bloc/login_bloc.dart';
import 'package:eco_bites/features/auth/presentation/bloc/login_event.dart';
import 'package:eco_bites/features/auth/presentation/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  height: 160,
                ),
              ),
              const SizedBox(height: 16),
              // Username TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Password TextField
              TextField(
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
              const SizedBox(height: 32),
              // Sign In Button
              BlocListener<LoginBloc, LoginState>(
                listener: (BuildContext context, LoginState state) {
                  if (state is LoginSuccess) {
                    Navigator.of(context).pushReplacementNamed('/main');
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5, // Reduce button width
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(
                        LoginSubmitted(username: 'admin', password: 'admin'),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF725C0C),
                      minimumSize: const Size(0, 48), // Adjust minimum height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('Sign in', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Sign Up Button
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5, // Reduce button width
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Sign Up button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF725C0C),
                    minimumSize: const Size(0, 48), // Adjust minimum height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
