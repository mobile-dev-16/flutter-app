import 'package:eco_bites/core/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:eco_bites/core/utils/analytics_service.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_event.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/diet_type.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_event.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _citizenIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  CuisineType? _favoriteCuisine;
  DietType? _dietType;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<ProfileBloc>().add(LoadProfileEvent(userId));
      logUserRetention(
        userId,
        0,
      ); // Log user retention with 0 days since last visit
    }
  }

  // ignore: unused_element
  Future<void> _saveProfile(UserProfile updatedProfile) async {
    final InternetConnectionBloc internetConnectionBloc =
        context.read<InternetConnectionBloc>();
    if (internetConnectionBloc.state is DisconnectedInternet) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('cachedProfile', updatedProfile.toMap().toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No internet connection. Your data will be saved when you are online.',
            ),
          ),
        );
      }
    } else {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        context.read<ProfileBloc>().add(
              UpdateProfileEvent(
                userId: userId,
                updatedProfile: updatedProfile,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (BuildContext context, ProfileState state) {
            if (state is ProfileLoaded && state.isUpdated) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your data has been saved successfully.'),
                  ),
                );
              }
            } else if (state is ProfileError) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            }
          },
          builder: (BuildContext context, ProfileState state) {
            if (state is ProfileLoaded && !_isInitialized) {
              final UserProfile profile = state.profile;

              // Cargar los valores en los controladores y variables solo la primera vez
              _nameController.text = profile.name;
              _surnameController.text = profile.surname;
              _citizenIdController.text = profile.citizenId;
              _emailController.text = profile.email;
              _phoneController.text = profile.phone;
              _birthDateController.text =
                  DateFormat('MM/dd/yyyy').format(profile.birthDate);
              _favoriteCuisine = profile.favoriteCuisine;
              _dietType = profile.dietType;
              _isInitialized = true;
            }

            return Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/support');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Need help?'),
                ),
                const SizedBox(height: 24),
                Text(
                  '¡Hi, ${_nameController.text}!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'You can edit your favorite cuisine and diet type.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildReadOnlyTextField('Name', _nameController),
                _buildReadOnlyTextField('Surname', _surnameController),
                _buildReadOnlyTextField('Citizen ID', _citizenIdController),
                _buildReadOnlyTextField('Email', _emailController),
                _buildReadOnlyTextField('Phone', _phoneController),
                _buildReadOnlyDateField('Birth date', _birthDateController),
                _buildCuisineDropdown(),
                _buildDietDropdown(),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final String? userId =
                          FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null) {
                        final UserProfile updatedProfile = UserProfile(
                          userId: userId,
                          name: _nameController.text,
                          surname: _surnameController.text,
                          citizenId: _citizenIdController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          birthDate: DateFormat('MM/dd/yyyy')
                              .parse(_birthDateController.text),
                          favoriteCuisine:
                              _favoriteCuisine ?? CuisineType.other,
                          dietType: _dietType ?? DietType.none,
                        );

                        final InternetConnectionBloc internetConnectionBloc =
                            context.read<InternetConnectionBloc>();
                        if (internetConnectionBloc.state is DisconnectedInternet) {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('cachedProfile', updatedProfile.toMap().toString());
                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No internet connection. Your data will be saved when you are online.',
                                ),
                              ),
                            );
                          }
                        } else {
                          context.read<ProfileBloc>().add(
                                UpdateProfileEvent(
                                  userId: userId,
                                  updatedProfile: updatedProfile,
                                ),
                              );
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () async {
                    context.read<AuthBloc>().add(SignOutRequested());
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label:
                      const Text('Logout', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildReadOnlyTextField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildReadOnlyDateField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildCuisineDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<CuisineType>(
        value: _favoriteCuisine,
        decoration: const InputDecoration(
          labelText: 'Favorite Cuisine',
          border: OutlineInputBorder(),
        ),
        items: CuisineType.values.map((CuisineType type) {
          return DropdownMenuItem<CuisineType>(
            value: type,
            child: Text(type.displayName),
          );
        }).toList(),
        onChanged: (CuisineType? newValue) {
          setState(() {
            _favoriteCuisine = newValue;
          });
        },
      ),
    );
  }

  Widget _buildDietDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<DietType>(
        value: _dietType,
        decoration: const InputDecoration(
          labelText: 'Diet Type',
          border: OutlineInputBorder(),
        ),
        items: DietType.values.map((DietType type) {
          return DropdownMenuItem<DietType>(
            value: type,
            child: Text(type.displayName),
          );
        }).toList(),
        onChanged: (DietType? newValue) {
          setState(() {
            _dietType = newValue;
          });
        },
      ),
    );
  }
}
