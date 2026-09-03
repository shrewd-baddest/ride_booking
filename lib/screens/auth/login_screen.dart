import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/Models/input_validators.dart';
import 'package:ride_booking/Models/user_model.dart';
import 'package:ride_booking/riverpods/providers.dart';
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

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (previousState, nextState) {
      if (nextState is AsyncData<String?>) {
        final loginResponse = nextState.value;
        if (loginResponse != null) {
          // Handle successful login
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful!')));
          // Navigate to the next screen or perform other actions
        } else {
          // Handle failed login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.')),
          );
        }
      } else if (nextState is AsyncError) {
        // Handle error state
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${nextState.error}')));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_taxi,
                    size: 100,
                    color: const Color.fromARGB(255, 109, 150, 63),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back to Ride Booking',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
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
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: InputValidators.password,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyle(
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
                              'http://localhost:3000/api/auth/login',
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New to RideSwift?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'create account',
                          style: Theme.of(context).textTheme.labelLarge,
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
