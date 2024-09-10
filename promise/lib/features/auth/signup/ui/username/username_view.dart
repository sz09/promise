import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/features/auth/router/auth_router_delegate.dart';
import 'package:promise/features/auth/signup/bloc/signup_cubit.dart';

class UsernameView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  UsernameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (listenerContext, state) {
          if (state is AwaitPasswordInput) {
            context.read<AuthRouterDelegate>().setSignupPasswordNavState();
          }
        },
        builder: (context, state) {
          if (state is SignupInProgress || state is SignupSuccess) {
            return const CircularProgressIndicator();
          } else {
            _usernameController.text = (state as AwaitUserInput).username;
            _emailController.text = (state).email;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sign Up Page'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Username",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Next'),
                      onPressed: () => _onNextPressed(context),
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

  void _onNextPressed(BuildContext context) {
    var signupCubitContext = BlocProvider.of<SignupCubit>(context);
    signupCubitContext.onUsernameEntered(_usernameController.text, _emailController.text);
  }
}
