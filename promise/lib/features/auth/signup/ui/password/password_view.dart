import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/features/auth/signup/bloc/signup_cubit.dart';

class PasswordView extends StatelessWidget {
  final bool sessionExpiredRedirect;
  final TextEditingController _passwordController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  PasswordView({super.key, this.sessionExpiredRedirect = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (listenerContext, state) {},
        builder: (context, state) {
          if (state is SignupInProgress || state is SignupSuccess) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Password Page'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Password",
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Sign up'),
                      onPressed: () => _onSignUpPressed(context),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _onSignUpPressed(BuildContext context) {
    BlocProvider.of<SignupCubit>(context)
        .onPasswordEntered(_passwordController.text);
    BlocProvider.of<SignupCubit>(context).onUserSignup();
  }
}
