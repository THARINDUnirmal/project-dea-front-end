import 'package:even_hub/services/contact_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactusScreen extends StatefulWidget {
  const ContactusScreen({super.key});

  @override
  State<ContactusScreen> createState() => _ContactusScreenState();
}

class _ContactusScreenState extends State<ContactusScreen> {
  //formKey
  final _formKey = GlobalKey<FormState>();
  //Text EditingControllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bodyController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1100;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://images.unsplash.com/photo-1506157786151-b8491531f063?auto=format&fit=crop&w=1920&q=80",
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Center(
                  child: Container(
                    width: isMobile
                        ? double.infinity
                        : MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Contact Us",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 30),
                        isMobile
                            ? Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Send us a message",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: 30),

                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              TextFormField(
                                                controller: _nameController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Your Name!";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                enabled: true,
                                                readOnly: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  hintText: "Your name",
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _subjectController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Subject!";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                enabled: true,
                                                readOnly: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  hintText: "Subject",
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _bodyController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Your Message!";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                maxLines: 5,
                                                enabled: true,
                                                readOnly: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  hintText: "Your Message",
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    await ContactServices()
                                                        .openGmail(
                                                          name: _nameController
                                                              .text
                                                              .trim(),
                                                          subject:
                                                              _subjectController
                                                                  .text
                                                                  .trim(),
                                                          body: _bodyController
                                                              .text
                                                              .trim(),
                                                        );

                                                    _nameController.clear();
                                                    _subjectController.clear();
                                                    _bodyController.clear();
                                                  }
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff9046b9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 10,
                                                        color: Colors.black38,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Sent Message",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "our Information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: 30),
                                        Text(
                                          "123 Event Hub lane,Sri Lanka\nPhone : +94 703 814 047\nEmail : Support@eventhub.com",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        SizedBox(height: 50),
                                        Text(
                                          "Follow us",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await ContactServices()
                                                    .openWhatsApp();
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/icons8-whatsapp.svg",
                                                width: 40,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            InkWell(
                                              onTap: () async {
                                                await ContactServices()
                                                    .openPhoneCall();
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/phone-forwarded.svg",
                                                width: 30,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            SvgPicture.asset(
                                              "assets/icons/youtube.svg",
                                              width: 40,
                                            ),
                                            SizedBox(width: 5),
                                            SvgPicture.asset(
                                              "assets/icons/instagram.svg",
                                              width: 40,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 100),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Send us a message",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: 30),
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller: _nameController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Your Name!";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                enabled: true,
                                                readOnly: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  hintText: "Your name",
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller: _subjectController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Subject!";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                enabled: true,
                                                readOnly: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  hintText: "Subject",
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _bodyController,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please Enter Your Message!";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                maxLines: 5,
                                                enabled: true,
                                                readOnly: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  hintText: "Your Message",
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    await ContactServices()
                                                        .openGmail(
                                                          name: _nameController
                                                              .text
                                                              .trim(),
                                                          subject:
                                                              _subjectController
                                                                  .text
                                                                  .trim(),
                                                          body: _bodyController
                                                              .text
                                                              .trim(),
                                                        );

                                                    _nameController.clear();
                                                    _subjectController.clear();
                                                    _bodyController.clear();
                                                  }
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff9046b9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 10,
                                                        color: Colors.black38,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Sent Message",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "our Information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: 30),
                                        Text(
                                          "123 Event Hub lane,Sri Lanka\nPhone : +94 703 814 047\nEmail : Support@eventhub.com",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        SizedBox(height: 50),
                                        Text(
                                          "Follow us",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await ContactServices()
                                                    .openWhatsApp();
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/icons8-whatsapp.svg",
                                                width: 40,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            InkWell(
                                              onTap: () async {
                                                await ContactServices()
                                                    .openPhoneCall();
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/phone-forwarded.svg",
                                                width: 30,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            SvgPicture.asset(
                                              "assets/icons/youtube.svg",
                                              width: 40,
                                            ),
                                            SizedBox(width: 5),
                                            SvgPicture.asset(
                                              "assets/icons/instagram.svg",
                                              width: 40,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 100),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
