import 'dart:ui';
import 'package:even_hub/main_screen.dart';
import 'package:even_hub/providers/index_change_provider.dart';
import 'package:even_hub/providers/logo_provider.dart';
import 'package:even_hub/screens/login/registater_screen.dart';
import 'package:even_hub/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  //form key
  final _formKey = GlobalKey<FormState>();
  //TextEditingControllers
  final TextEditingController _userUserContraller = TextEditingController();
  final TextEditingController _userPasswordContraller = TextEditingController();

  //submit button function
  Future<void> _submitUser({
    required String userName,
    required String password,
  }) async {
    try {
      setState(() => isLoading = true);

      bool isSuccess = await AuthService().login(userName, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      Provider.of<IndexChangeProvider>(
        context,
        listen: false,
      ).changePageIndex(index: 4);

      if (isSuccess) {
        Provider.of<LogoProvider>(
          context,
          listen: false,
        ).setLoginState(loginValue: true);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login Done!")));
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Login Details!")),
          );
        }
      }
    } catch (error) {
      print("LOGIN ERROR: $error");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;
        // final bool isTablet = width >= 600 && width < 1100;
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg?auto=compress&cs=tinysrgb&w=1920",
              ),
            ),
          ),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(
                    width: isMobile
                        ? MediaQuery.of(context).size.width * 0.9
                        : MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "Login in to EventHub",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.white,
                                fontSize: isMobile ? 30 : 50,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Unlock a World of Events",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(
                    width: isMobile
                        ? MediaQuery.of(context).size.width * 0.9
                        : MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "Login in to Your Account",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                fieldWidget(
                                  ismobile: isMobile,
                                  context: context,
                                  hintText: "User Name",

                                  isObscureText: false,

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter user Email";
                                    } else {
                                      return null;
                                    }
                                  },

                                  textController: _userUserContraller,
                                ),
                                SizedBox(height: 15),
                                fieldWidget(
                                  ismobile: isMobile,
                                  context: context,
                                  hintText: "Password",

                                  isObscureText: true,

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Password";
                                    } else if (value.length < 6) {
                                      return "Password must need to 6 or more characters!";
                                    } else {
                                      return null;
                                    }
                                  },

                                  textController: _userPasswordContraller,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _submitUser(
                                    userName: _userUserContraller.text.trim(),
                                    password: _userPasswordContraller.text
                                        .trim(),
                                  );
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  color: Color(0xff9046b9),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: isLoading
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "LogIn",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: isMobile ? 15 : 20,
                                              ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Or continue with",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {},
                              child: svgWidget(
                                isMobile: isMobile,
                                svgUrl: "assets/icons/google-icon-logo.svg",
                              ),
                            ),
                            SizedBox(width: 20),
                            InkWell(
                              onTap: () async {},
                              child: svgWidget(
                                isMobile: isMobile,
                                svgUrl: "assets/icons/hat-glasses.svg",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Provider.of<IndexChangeProvider>(
                                context,
                                listen: false,
                              ).changePageIndex(index: 6);
                            },
                            child: Text(
                              "You haven't account? Register",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.blueAccent,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}

Widget fieldWidget({
  required bool ismobile,
  required BuildContext context,
  required String hintText,
  required TextEditingController textController,
  required String? Function(String?)? validator,
  required bool? isObscureText,
}) {
  return SizedBox(
    width: ismobile
        ? MediaQuery.of(context).size.width * 0.65
        : MediaQuery.of(context).size.width * 0.4,
    child: TextFormField(
      obscureText: isObscureText ?? false,
      controller: textController,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.red),
        hintStyle: TextStyle(color: Colors.white),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
