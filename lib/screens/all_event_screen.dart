import 'package:even_hub/models/event_model.dart';
import 'package:even_hub/screens/new_event_add_screen.dart';
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
          child: Column(
            children: [
              const SizedBox(height: 50),
              Container(
                width: width * (isMobile ? 0.95 : 0.8),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassText(
                      cardWidth: 0.2,
                      textWidget: Text(
                        "Explore Events",
                        style: Theme.of(context).textTheme.headlineLarge!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    GlassText(
                      cardWidth: 0.3,
                      textWidget: Text(
                        "Discover Your Next Experience",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ACTION ROW (RESPONSIVE)
                    isMobile
                        ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewEventAddScreen(),
                                    ),
                                  );
                                },
                                child: _createButton(context),
                              ),
                              const SizedBox(height: 10),
                              // _searchField(),
                            ],
                          )
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewEventAddScreen(),
                                    ),
                                  );
                                },
                                child: _createButton(context),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),

                    const SizedBox(height: 30),
                    GlassText(
                      cardWidth: 0.15,
                      textWidget: Text(
                        "What’s Coming Up",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: isMobile
                      ? double.infinity
                      : MediaQuery.of(context).size.width * 0.8,
                  height: isMobile
                      ? MediaQuery.of(context).size.width * 0.8
                      : MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 102, 96, 96),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FutureBuilder(
                    future: ApiServices().getAllData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  offset: Offset(1, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else if (!snapshot.hasData) {
                        return Text(
                          "No Data Found!",
                          style: TextStyle(color: Colors.black),
                        );
                      } else {
                        List<EventModel> allData = snapshot.data ?? [];
                        return allData.isEmpty
                            ? Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromARGB(
                                      255,
                                      141,
                                      134,
                                      134,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "No Data Found!\nYou Can Add Event Data",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: 20),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewEventAddScreen(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Color(0xff9046b9),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Create New Event",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
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
                                        //todo
                                      },
                                      child: CardWidget(
                                        isMobile: isMobile,
                                        cardTitle: data.title,
                                        cardDescription: data.description,
                                        cardImage: data.imageUrl,
                                      ),
                                    );
                                  },
                                ),
                              );
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _createButton(BuildContext context) {
    return Container(
      height: 45,
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xff9046b9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          "Start Your Event",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
