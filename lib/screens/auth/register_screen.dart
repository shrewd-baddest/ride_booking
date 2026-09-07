import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/Models/input_validators.dart';
import 'package:ride_booking/Models/login_model.dart';
import 'package:ride_booking/Models/user_model.dart';
import 'package:ride_booking/constants/app_colors.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/routes/route_names.dart';
import 'package:ride_booking/widgets/textField.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyForm = GlobalKey<FormState>();

    ref.listen(loginProvider, (previousState, nextState) {
      if (nextState is AsyncData<LoginResponse?>) {
        final loginResponse = nextState.value;
        if (loginResponse!.success == true) {
          // Handle successful registration
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );

          Navigator.pushReplacementNamed(context, RouteNames.login);
        } else {
          // Handle failed registration
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed. Please try again.'),
            ),
          );
        }
      } else if (nextState is AsyncError) {
        final errorResponse = nextState.error;
        // Handle error state
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${errorResponse.toString()}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: keyForm,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Create Account", style: TextTheme.of(context).titleLarge),
                Icon(
                  Icons.person_add,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),

                SizedBox(height: 24),
                CustomTextField(
                  title: "FULL NAME",
                  hintText: "Enter your full name",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  validator: InputValidators.required,
                  controller: _nameController,
                ),

                SizedBox(height: 16),
                CustomTextField(
                  title: "EMAIL",
                  hintText: "you@domain.com",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor,
                  ),
                  validator: InputValidators.email,
                  controller: _emailController,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  title: "PHONE NUMBER",
                  hintText: "+1 123 456 7890",
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Theme.of(context).primaryColor,
                  ),
                  validator: InputValidators.phone,
                  controller: _phoneController,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  title: "PASSWORD",
                  hintText: "Enter your password",
                  obscureText: _obscurePassword,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).primaryColor,
                  ),
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword
                        ? 'Show password'
                        : 'Hide password',
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: InputValidators.password,
                  controller: _passwordController,
                ),
                SizedBox(height: 24),

                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all<Size>(
                        const Size(double.infinity, 48),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 109, 150, 63),
                      ),
                    ),
                    onPressed: () {
                      if (keyForm.currentState!.validate()) {
                        final phone = _phoneController.text.trim();
                        final password = _passwordController.text.trim();
                        ref
                            .read(registerProvider.notifier)
                            .register(
                              User(
                                fullName: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                phoneNumber: phone,
                                password: password,
                              ),
                              'http://10.0.2.2:3000/api/auth/register',
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fix the errors in red'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
