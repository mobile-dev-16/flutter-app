import 'package:eco_bites/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_event.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_state.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart'; // Import the enum here
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sign_button/sign_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _citizenIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  CuisineType? _selectedCuisineType;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _citizenIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
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
              _buildGoogleSignUpButton(context),
              const SizedBox(height: 16),
              const Text('OR'),
              const SizedBox(height: 16),
              _buildTextField('Name', _nameController),
              _buildTextField('Surname', _surnameController),
              _buildTextField('Citizen ID', _citizenIdController),
              _buildTextField('Email', _emailController),
              _buildTextField('Phone', _phoneController),
              _buildDateField('Birth Date', _birthDateController),
              _buildTextField('Password', _passwordController, obscureText: true),
              const SizedBox(height: 16),
              _buildCuisineDropdown(),
              const SizedBox(height: 32),
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
                          name: _nameController.text,
                          surname: _surnameController.text,
                          citizenId: _citizenIdController.text,
                          phone: _phoneController.text,
                          birthDate: DateFormat('MM/dd/yyyy').parse(_birthDateController.text),
                          favoriteCuisine: _selectedCuisineType ?? CuisineType.other,
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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              controller.text = DateFormat('MM/dd/yyyy').format(pickedDate);
            });
          }
        },
      ),
    );
  }

  Widget _buildCuisineDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<CuisineType>(
        value: _selectedCuisineType,
        items: CuisineType.values.map((CuisineType type) {
          return DropdownMenuItem<CuisineType>(
            value: type,
            child: Text(type.displayName),
          );
        }).toList(),
        onChanged: (CuisineType? value) {
          setState(() {
            _selectedCuisineType = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Favorite Cuisine',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGoogleSignUpButton(BuildContext context) {
    return SignInButton(
      buttonType: ButtonType.google,
      btnColor: Colors.white,
      btnText: 'Sign up with Google',
      width: 200,
      onPressed: () {
        context.read<AuthBloc>().add(SignUpWithGoogleRequested());
      },
      elevation: 0,
    );
  }

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
