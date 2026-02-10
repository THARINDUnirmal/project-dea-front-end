import 'dart:ui';
import 'package:even_hub/main_screen.dart';
import 'package:even_hub/models/user_model.dart';
import 'package:even_hub/providers/index_change_provider.dart';
import 'package:even_hub/providers/logo_provider.dart';
import 'package:even_hub/services/auth_services.dart';
import 'package:even_hub/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RegistaterScreen extends StatefulWidget {
  const RegistaterScreen({super.key});

  @override
  State<RegistaterScreen> createState() => _RegistaterScreenState();
}

class _RegistaterScreenState extends State<RegistaterScreen> {
  bool isLoading = false;
  //form key
  final _formKey = GlobalKey<FormState>();
  //TextEditingControllers
  final TextEditingController _userNameContraller = TextEditingController();
  final TextEditingController _userEmailContraller = TextEditingController();
  final TextEditingController _userPasswordContraller = TextEditingController();
  final TextEditingController _userConfiremPasswordContraller =
      TextEditingController();

  //submit button function
  Future<void> _submitUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      bool success = await AuthService().register(name, email, password);

      if (success) {
        //navigate the auth screen
        Provider.of<IndexChangeProvider>(
          context,
          listen: false,
        ).changePageIndex(index: 4);

        Provider.of<LogoProvider>(
          context,
          listen: false,
        ).setLoginState(loginValue: true);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User Register Successfully!")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to Register User!")));
      }
    } catch (error) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1100;
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
                          "Join EventHub Today!",
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
                          "Create Your Account",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              fieldRowWidget(
                                ismobile: isMobile,
                                context: context,
                                hintText1: "User Name",
                                hintText2: "Email Address",
                                isObscureText1: false,
                                isObscureText2: false,
                                validator1: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter user name";
                                  } else {
                                    return null;
                                  }
                                },
                                validator2: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Email";
                                  } else {
                                    return null;
                                  }
                                },
                                textController1: _userNameContraller,
                                textController2: _userEmailContraller,
                              ),
                              SizedBox(height: 15),
                              fieldRowWidget(
                                ismobile: isMobile,
                                context: context,
                                hintText1: "Password",
                                hintText2: "Confirem Password",
                                isObscureText1: true,
                                isObscureText2: true,
                                validator1: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Password";
                                  } else if (value.length < 6) {
                                    return "Password must need to 6 or more characters!";
                                  } else {
                                    return null;
                                  }
                                },
                                validator2: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Confirem Password";
                                  } else if (_userPasswordContraller.text
                                          .trim() !=
                                      value.trim()) {
                                    return "Password and Confirem Passowrd not match!";
                                  } else {
                                    return null;
                                  }
                                },
                                textController1: _userPasswordContraller,
                                textController2:
                                    _userConfiremPasswordContraller,
                              ),
                            ],
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
                                    name: _userNameContraller.text.trim(),
                                    email: _userEmailContraller.text.trim(),
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
                                          "Register",
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
                              onTap: () async {
                                // await AuthServices().googleSignInWeb();

                                // UserModel newUser = UserModel(
                                //   userId: AuthServices().getCurruntUser!.uid,
                                //   name:
                                //       AuthServices()
                                //           .getCurruntUser!
                                //           .displayName ??
                                //       "Google User",
                                //   email:
                                //       AuthServices().getCurruntUser!.email ??
                                //       "No Email",
                                //   role: "User",
                                // );

                                // await UserServices().registerUser(newUser);

                                // Provider.of<IndexChangeProvider>(
                                //   context,
                                //   listen: false,
                                // ).changePageIndex(index: 4);
                              },
                              child: svgWidget(
                                isMobile: isMobile,
                                svgUrl: "assets/icons/google-icon-logo.svg",
                              ),
                            ),
                            SizedBox(width: 20),
                            InkWell(
                              onTap: () async {
                                // await AuthServices().loginAsAnonymously();

                                // UserModel newUser = UserModel(
                                //   userId: AuthServices().getCurruntUser!.uid,
                                //   name:
                                //       AuthServices()
                                //           .getCurruntUser!
                                //           .displayName ??
                                //       "Anonymous User",
                                //   email:
                                //       AuthServices().getCurruntUser!.email ??
                                //       "No Email",
                                //   role: "User",
                                // );

                                // await UserServices().registerUser(newUser);

                                // Provider.of<IndexChangeProvider>(
                                //   context,
                                //   listen: false,
                                // ).changePageIndex(index: 4);
                              },
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
                              ).changePageIndex(index: 5);
                            },
                            child: Text(
                              "Already have account? LogIn",
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

Widget svgWidget({required String svgUrl, required bool isMobile}) {
  return Container(
    width: isMobile ? 50 : 60,
    height: isMobile ? 50 : 60,
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black)],
    ),
    child: Center(child: SvgPicture.asset(svgUrl)),
  );
}

Widget fieldRowWidget({
  required bool ismobile,
  required BuildContext context,
  required String hintText1,
  required String hintText2,
  required TextEditingController textController1,
  required TextEditingController textController2,
  required String? Function(String?)? validator1,
  required String? Function(String?)? validator2,
  required bool? isObscureText1,
  required bool? isObscureText2,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        width: ismobile
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width * 0.23,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          obscureText: isObscureText1 ?? false,
          controller: textController1,
          validator: validator1,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.red),
            hintText: hintText1,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      SizedBox(
        width: ismobile
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width * 0.23,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          obscureText: isObscureText2 ?? false,
          controller: textController2,
          validator: validator2,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.red),
            hintText: hintText2,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    ],
  );
}
