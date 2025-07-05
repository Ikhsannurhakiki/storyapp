import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../style/colors/app_colors.dart';
import '../style/typography/story_app_text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isObscure = true;
  bool isLoading = false;
  bool isButtonEnabled = true;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _usernameFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();

  Future<void> register() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.register(
      usernameController.text,
      emailController.text,
      passwordController.text,
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    final ScaffoldMessengerState scaffoldMessengerState = ScaffoldMessenger.of(
      context,
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/register.jpg"),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Create Your Chapter!",
                      style: StoryAppTextStyles.headlineLarge,
                    ),
                    SizedBox(height: 25),

                    SizedBox(
                      height: 70,
                      child: TextFormField(
                        key: _usernameFieldKey,
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Oops! You forgot your username.';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters long.';
                          }
                          return null;
                        },
                        style: StoryAppTextStyles.bodyLargeBold,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: StoryAppTextStyles.labelLarge,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.orange,
                              width: 4,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: AppColors.lightTeal.color,
                              width: 3,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                      ),
                    ),
                    TextFormField(
                      key: _emailFieldKey,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Oops! You forgot your email.';
                        }
                        final isValid = RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                        ).hasMatch(value);
                        return isValid
                            ? null
                            : 'That email looks a bit off. Fix it?';
                      },
                      style: StoryAppTextStyles.bodyLargeBold,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: StoryAppTextStyles.labelLarge,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 4,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: AppColors.lightTeal.color,
                            width: 3,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                    Column(
                      children: [
                        SizedBox(height: 8),
                        TextFormField(
                          key: _passwordFieldKey,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Oops, password is empty!';
                            }
                            if (value.length < 8) {
                              return 'Too short! Try 8+ characters.';
                            }
                            return null;
                          },
                          obscureText: isObscure,
                          style: StoryAppTextStyles.bodyLargeBold,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: StoryAppTextStyles.titleMedium,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 4,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.lightTeal.color,
                                width: 3,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.darkTeal.color,
                              ),
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                            ),
                            suffixIconColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        if (_usernameFieldKey.currentState!.validate() &&
                            _emailFieldKey.currentState!.validate() &&
                            _passwordFieldKey.currentState!.validate()) {
                          register();
                          scaffoldMessengerState.showSnackBar(
                            SnackBar(content: Text(authWatch.message)),
                          );
                          context.go('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        elevation: 7,
                        backgroundColor: AppColors.lightTeal.color,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: authWatch.isLoadingRegister
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Jump In',
                              style: StoryAppTextStyles.titleMedium,
                            ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        "Already joined? Jump back in!",
                        style: StoryAppTextStyles.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
