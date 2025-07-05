import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/style/typography/story_app_text_styles.dart';

import '../provider/auth_provider.dart';
import '../style/colors/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;
  bool isPasswordFieldVisible = false;
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();

  Future<void> login() async {
    final authProvider = context.read<AuthProvider>();
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    final isLoggedIn = await authProvider.login(
      emailController.text,
      passwordController.text,
    );

    final message = authProvider.message;
    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (isLoggedIn) {
<<<<<<< HEAD
      goRouter.go('/home');
=======
      navigator.go('/home');
>>>>>>> c91276863fb05f4c01eac9f46b8a603fe1c3067e
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
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
              Image.asset("assets/images/login.jpg"),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Lets Begin!",
                      style: StoryAppTextStyles.headlineLarge,
                    ),
                    SizedBox(height: 25),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
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
                          ),
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          enabled: !isPasswordFieldVisible,
                        ),
                        Positioned(
                          right: 12,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordFieldVisible =
                                    !isPasswordFieldVisible;
                              });
                            },
                            child: !isPasswordFieldVisible
                                ? const SizedBox.shrink()
                                : Icon(
                                    Icons.edit,
                                    color: AppColors.darkTeal.color,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 300),
                      firstChild: SizedBox(
                        width: double.infinity,
                        child: Container(),
                      ),
                      secondChild: Column(
                        children: [
                          SizedBox(height: 8),
                          TextFormField(
                            key: _passwordFieldKey,
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Oops, password is empty!';
                              }
                              if (value.length < 6) {
                                return 'Too short! Try 6+ characters.';
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
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
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
                      crossFadeState: isPasswordFieldVisible
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (!isPasswordFieldVisible) {
                            if (_emailFieldKey.currentState!.validate()) {
                              isPasswordFieldVisible = !isPasswordFieldVisible;
                            }
                          } else {
                            if (_passwordFieldKey.currentState!.validate()) {
                              login();
                            }
                          }
                        });
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
                      child: authWatch.isLoadingLogin
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : (!isPasswordFieldVisible
                                ? Text(
                                    'Continue',
                                    style: StoryAppTextStyles.titleMedium,
                                  )
                                : Text(
                                    'Jump In',
                                    style: StoryAppTextStyles.titleMedium,
                                  )),
                    ),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: Text(
                        "New here? Join the story!",
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
