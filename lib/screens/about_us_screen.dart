import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;
        //final bool isTablet = width >= 600 && width < 1100;

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
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.all(isMobile ? 20 : 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About Us",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.black,
                                fontSize: isMobile ? 30 : 50,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "EventHub is designed tont to simpiify simpiify event manneryone, from small meet-up to laugh amencrabe throple experiences. Our mision 'te hliade We helpe itieipds organizers worldwide",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Meet Our Team",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 20),
                        //todo: Team Members
                        isMobile
                            ? Center(
                                child: Column(
                                  children: [
                                    profileCard(
                                      context: context,
                                      ismobile: isMobile,
                                      name: "Tharindu",
                                      imageUrl: "assets/images/user.jpg",
                                      possition: "CEO",
                                      otherDetails: "None",
                                    ),
                                    SizedBox(height: 20),
                                    profileCard(
                                      context: context,
                                      ismobile: isMobile,
                                      name: "Tharindu",
                                      imageUrl: "assets/images/user.jpg",
                                      possition: "CEO",
                                      otherDetails: "None",
                                    ),
                                    SizedBox(height: 20),
                                    profileCard(
                                      context: context,
                                      ismobile: isMobile,
                                      name: "Tharindu",
                                      imageUrl: "assets/images/user.jpg",
                                      possition: "CEO",
                                      otherDetails: "None",
                                    ),
                                    SizedBox(height: 20),
                                    profileCard(
                                      context: context,
                                      ismobile: isMobile,
                                      name: "Tharindu",
                                      imageUrl: "assets/images/user.jpg",
                                      possition: "CEO",
                                      otherDetails: "None",
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  profileCard(
                                    context: context,
                                    ismobile: isMobile,
                                    name: "Tharindu",
                                    imageUrl: "assets/images/user.jpg",
                                    possition: "CEO",
                                    otherDetails: "None",
                                  ),
                                  SizedBox(width: 30),
                                  profileCard(
                                    ismobile: isMobile,
                                    context: context,
                                    name: "Tharindu",
                                    imageUrl: "assets/images/user.jpg",
                                    possition: "CEO",
                                    otherDetails: "None",
                                  ),
                                  SizedBox(width: 30),
                                  profileCard(
                                    ismobile: isMobile,
                                    context: context,
                                    name: "Tharindu",
                                    imageUrl: "assets/images/user.jpg",
                                    possition: "CEO",
                                    otherDetails: "None",
                                  ),
                                ],
                              ),
                        SizedBox(height: 50),
                        Text(
                          "Our Other Projects",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        //todo: projects
                        SizedBox(height: 20),
                        isMobile
                            ? Center(
                                child: Column(
                                  children: [
                                    projectCard(
                                      context: context,
                                      isMobile: isMobile,
                                      description: "No Description",
                                      title: "No Title",
                                    ),
                                    SizedBox(height: 20),
                                    projectCard(
                                      context: context,
                                      isMobile: isMobile,
                                      description: "No Description",
                                      title: "No Title",
                                    ),
                                    SizedBox(height: 20),
                                    projectCard(
                                      context: context,
                                      isMobile: isMobile,
                                      description: "No Description",
                                      title: "No Title",
                                    ),
                                    SizedBox(height: 20),
                                    projectCard(
                                      context: context,
                                      isMobile: isMobile,
                                      description: "No Description",
                                      title: "No Title",
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  projectCard(
                                    context: context,
                                    isMobile: isMobile,
                                    description: "No Description",
                                    title: "No Title",
                                  ),
                                  SizedBox(width: 20),
                                  projectCard(
                                    context: context,
                                    isMobile: isMobile,
                                    description: "No Description",
                                    title: "No Title",
                                  ),
                                  SizedBox(width: 20),
                                  projectCard(
                                    context: context,
                                    isMobile: isMobile,
                                    description: "No Description",
                                    title: "No Title",
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

  Widget profileCard({
    required bool ismobile,
    required BuildContext context,
    required String imageUrl,
    required String possition,
    required String otherDetails,
    required String name,
  }) {
    return Container(
      width: ismobile
          ? MediaQuery.of(context).size.width * 0.5
          : MediaQuery.of(context).size.width * 0.15,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black26,
            offset: Offset(1, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(50),
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            possition,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            otherDetails,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget projectCard({
    required bool isMobile,
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return Container(
      width: isMobile
          ? MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 245, 77, 97),
            Color.fromARGB(255, 112, 79, 241),
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black26,
            offset: Offset(1, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 40),
              SizedBox(width: 10),
              Text(
                textAlign: TextAlign.center,
                title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white60,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
