import 'package:even_hub/models/event_model.dart';
import 'package:even_hub/providers/index_change_provider.dart';
import 'package:even_hub/screens/new_event_add_screen.dart';
import 'package:even_hub/screens/single_data_screen.dart';
import 'package:even_hub/services/api_services.dart';
import 'package:even_hub/widgets/card_widget.dart';
import 'package:even_hub/widgets/glass_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1100;

        final int gridCount = isMobile
            ? 1
            : isTablet
            ? 2
            : 3;

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
                const SizedBox(height: 60),

                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassText(
                        cardWidth: 0.65,
                        textWidget: Text(
                          "Event Management Made Effortless",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.white,
                                fontSize: isMobile ? 38 : 50,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      GlassText(
                        cardWidth: 0.55,
                        textWidget: Text(
                          "Plan, organize, and manage your events with ease. Handle everything from scheduling to coordination in one powerful platform.",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: Colors.white70, fontSize: 16),
                        ),
                      ),

                      const SizedBox(height: 30),

                      InkWell(
                        onTap: () {
                          Provider.of<IndexChangeProvider>(
                            context,
                            listen: false,
                          ).changePageIndex(index: 1);
                        },
                        child: Container(
                          width: 200,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xff9046b9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Discover More",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Row(
                        children: [
                          _statCard("120+", "Events"),
                          _statCard("80+", "Users"),
                          _statCard("25+", "Upcoming"),
                        ],
                      ),

                      const SizedBox(height: 60),

                      GlassText(
                        cardWidth: 0.3,
                        textWidget: Text(
                          "Why Choose EventHub?",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          _featureCard(
                            Icons.event_available,
                            "Easy Event Creation",
                          ),
                          _featureCard(Icons.group, "Team Collaboration"),
                          _featureCard(Icons.analytics, "Real-time Analytics"),
                        ],
                      ),

                      const SizedBox(height: 60),

                      GlassText(
                        cardWidth: 0.25,
                        textWidget: Text(
                          "Upcoming Events",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 20),

                      FutureBuilder(
                        future: ApiServices().getAllData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              (snapshot.data as List).isEmpty) {
                            return _emptyState(context);
                          }

                          List<EventModel> dataList = snapshot.data ?? [];
                          dataList.shuffle();
                          final displayList = dataList.take(3).toList();

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: gridCount,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.9,
                                ),
                            itemBuilder: (context, index) {
                              final data = displayList[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleDataScreen(
                                        singleEventData: data,
                                      ),
                                    ),
                                  );
                                },
                                child: CardWidget(
                                  isMobile: isMobile,
                                  cardTitle: data.title,
                                  cardDescription: data.description,
                                  cardImage: data.imageUrl,
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 70),

                      _ctaSection(context),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text(
              "No Events Found",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Create your first event to get started."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewEventAddScreen()),
                );
              },
              child: const Text("Create Event"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ctaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff9046b9), Color(0xff5e2b97)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Text(
            "Ready to Host Your Next Event?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Create, manage, and promote events effortlessly.",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xff9046b9),
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewEventAddScreen()),
              );
            },
            child: const Text("Create Event Now"),
          ),
        ],
      ),
    );
  }
}
