import 'package:even_hub/models/event_model.dart';
import 'package:even_hub/screens/new_event_add_screen.dart';
import 'package:even_hub/screens/single_data_screen.dart';
import 'package:even_hub/services/api_services.dart';
import 'package:even_hub/widgets/card_widget.dart';
import 'package:even_hub/widgets/glass_text.dart';
import 'package:flutter/material.dart';

class AllEventScreen extends StatefulWidget {
  const AllEventScreen({super.key});

  @override
  State<AllEventScreen> createState() => _AllEventScreenState();
}

class _AllEventScreenState extends State<AllEventScreen> {
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
                const SizedBox(height: 30),

                Container(
                  width: width * (isMobile ? 0.95 : 0.8),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassText(
                        cardWidth: 0.25,
                        textWidget: Text(
                          "Explore Events",
                          style: Theme.of(context).textTheme.headlineLarge!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      GlassText(
                        cardWidth: 0.4,
                        textWidget: Text(
                          "Discover, join, and manage amazing experiences",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: Colors.white70),
                        ),
                      ),

                      const SizedBox(height: 25),

                      isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [_createButton(context)],
                            )
                          : Row(children: [_createButton(context)]),

                      const SizedBox(height: 35),

                      GlassText(
                        cardWidth: 0.18,
                        textWidget: Text(
                          "All Events",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: isMobile
                        ? double.infinity
                        : MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: FutureBuilder(
                      future: ApiServices().getAllData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        if (!snapshot.hasData ||
                            (snapshot.data as List).isEmpty) {
                          return _emptyState(context);
                        }

                        List<EventModel> allData = snapshot.data ?? [];

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allData.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridCount,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: isMobile ? 0.9 : 1,
                              ),
                          itemBuilder: (context, index) {
                            final data = allData[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SingleDataScreen(singleEventData: data),
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

  Widget _createButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewEventAddScreen()),
        );
      },
      child: Container(
        height: 48,
        width: 220,
        decoration: BoxDecoration(
          color: const Color(0xff9046b9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            "Start Your Event",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy, size: 60),
          const SizedBox(height: 15),
          const Text(
            "No Events Available",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text("Create your first event and get started."),
          const SizedBox(height: 25),
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
    );
  }
}
