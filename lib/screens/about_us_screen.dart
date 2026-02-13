import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bool isMobile = width < 600;

        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://images.unsplash.com/photo-1506157786151-b8491531f063?auto=format&fit=crop&w=1920&q=80",
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                Center(
                  child: Container(
                    width: isMobile ? width * 0.95 : width * 0.75,
                    padding: EdgeInsets.all(isMobile ? 20 : 50),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(blurRadius: 20, color: Colors.black26),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About EventHub",
                          style: Theme.of(context).textTheme.headlineLarge!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "EventHub is a modern event management platform designed to simplify event planning for everyone — from small meetups to large-scale experiences. "
                          "Our mission is to empower organizers with powerful tools to create, manage, and promote events effortlessly.",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: Colors.black87, height: 1.6),
                        ),

                        const SizedBox(height: 40),

                        Text(
                          "Meet Our Team",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 25),

                        isMobile
                            ? Column(
                                children: [
                                  ..._teamMembers(context, isMobile),
                                  ..._teamMembers2(context, isMobile),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _teamMembers(context, isMobile),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _teamMembers2(context, isMobile),
                                  ),
                                ],
                              ),

                        const SizedBox(height: 50),

                        Text(
                          "Our Other Projects",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 25),

                        isMobile
                            ? Column(children: _projects(context, isMobile))
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _projects(context, isMobile),
                              ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _teamMembers(BuildContext context, bool isMobile) {
    return [
      profileCard(
        context: context,
        isMobile: isMobile,
        name: "Tharindu Nirmal",
        position: "Founder & Developer",
        imageUrl: "assets/images/user.jpg",
        details: "Flutter | Web | Backend",
      ),
      const SizedBox(width: 25, height: 25),
      profileCard(
        context: context,
        isMobile: isMobile,
        name: "Poora Nyanajith",
        position: "UI/UX Designer",
        imageUrl: "assets/images/Poorna.jpg",
        details: "Design & Branding",
      ),
      const SizedBox(width: 25, height: 25),
      profileCard(
        context: context,
        isMobile: isMobile,
        name: "Nthmi",
        position: "Project Manager",
        imageUrl: "assets/images/Nethmi.jpg",
        details: "Planning & Strategy",
      ),
    ];
  }

  List<Widget> _teamMembers2(BuildContext context, bool isMobile) {
    return [
      profileCard(
        context: context,
        isMobile: isMobile,
        name: "Ruby",
        position: "Founder & Developer",
        imageUrl: "assets/images/Rudy.jpg",
        details: "Backend",
      ),
      const SizedBox(width: 25, height: 25),
      profileCard(
        context: context,
        isMobile: isMobile,
        name: "Team Member",
        position: "UI/UX Designer",
        imageUrl: "assets/images/Kusal.jpg",
        details: "Design & Branding",
      ),
      // const SizedBox(width: 25, height: 25),
      // profileCard(
      //   context: context,
      //   isMobile: isMobile,
      //   name: "Team Member",
      //   position: "Project Manager",
      //   imageUrl: "assets/images/user.jpg",
      //   details: "Planning & Strategy",
      // ),
    ];
  }

  Widget profileCard({
    required bool isMobile,
    required BuildContext context,
    required String imageUrl,
    required String position,
    required String details,
    required String name,
  }) {
    return Container(
      width: isMobile ? double.infinity : 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 45, backgroundImage: AssetImage(imageUrl)),
          const SizedBox(height: 15),
          Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(position, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 5),
          Text(
            details,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }

  List<Widget> _projects(BuildContext context, bool isMobile) {
    return [
      projectCard(
        context: context,
        isMobile: isMobile,
        title: "Budget Tracker",
        description: "Track expenses and incomes easily",
      ),
      projectCard(
        context: context,
        isMobile: isMobile,
        title: "Social Media App",
        description: "Connect people with modern features",
      ),
      projectCard(
        context: context,
        isMobile: isMobile,
        title: "Video Converter",
        description: "Convert videos quickly and easily",
      ),
    ];
  }

  Widget projectCard({
    required bool isMobile,
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return Container(
      width: isMobile ? double.infinity : 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff9046b9), Color(0xff5e2b97)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
