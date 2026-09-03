import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/Models/input_validators.dart';
import 'package:ride_booking/Models/user_model.dart';
import 'package:ride_booking/riverpods/providers.dart';
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

    ref.listen(registerProvider, (previousState, nextState) {
      if (nextState is AsyncData<String?> && nextState.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else if (nextState is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${nextState.error}')),
        );
      }
    });

    return Form(
      key: keyForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Create Account", style: TextTheme.of(context).titleLarge),
          Icon(
            Icons.person_add,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
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
          CustomTextField(
            title: "PASSWORD",
            hintText: "Enter your password",
            obscureText: true,
            prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
            validator: InputValidators.password,
            controller: _passwordController,
          ),

          ElevatedButton(
            style: ButtonStyle(
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
                      'http://localhost:3000/api/auth/register',
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fix the errors in red')),
                );
              }
            },
            child: Text(
              'Create Account',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
