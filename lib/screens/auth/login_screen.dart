import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ride_booking/Models/input_validators.dart';
import 'package:ride_booking/Models/login_model.dart';
import 'package:ride_booking/Models/user_model.dart';
import 'package:ride_booking/constants/app_colors.dart';
import 'package:ride_booking/riverpods/providers.dart';
import 'package:ride_booking/routes/route_names.dart';
import 'package:ride_booking/widgets/textField.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (previousState, nextState) async {
      if (!mounted) return;

      if (nextState is AsyncData<LoginResponse?>) {
        final loginResponse = nextState.value;

        if (loginResponse == null) {
          return;
        }

        if (loginResponse.success == true) {
          // Handle successful login
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful!')));
          await storage.write(
            key: 'token',
            value: loginResponse.data?['token'],
          );
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.home,
            (route) => false,
          );
        } else {
          // Handle failed login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.')),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.local_taxi,
                    size: 100,
                    color: const Color.fromARGB(255, 109, 150, 63),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back to Ride Booking',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color.fromARGB(255, 219, 223, 217),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please login to book your next ride',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    title: 'Phone Number',
                    controller: _phoneController,
                    hintText: '712 345 456',
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    validator: InputValidators.phone,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    title: 'Password',
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
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
                  ),
                  const SizedBox(height: 24),
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
                        if (_formKey.currentState!.validate()) {
                          final phone = _phoneController.text.trim();
                          final password = _passwordController.text.trim();
                          ref
                              .read(loginProvider.notifier)
                              .login(
                                User(
                                  fullName: '',
                                  phoneNumber: phone,
                                  password: password,
                                ),
                                'http://10.0.2.2:3000/api/auth/login',
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
                        'Login',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New to RideSwift?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'create account',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(
                                    255,
                                    109,
                                    150,
                                    63,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
