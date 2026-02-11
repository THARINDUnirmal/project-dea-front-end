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
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,

                  padding: EdgeInsets.all(10),

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
                                fontSize: isMobile ? 40 : 50,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GlassText(
                        cardWidth: 0.5,
                        textWidget: Text(
                          "Plan, organize, and manage your events with ease. Our platform helps you handle everything from scheduling to coordination, all in one place.",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                      ),

                      SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Provider.of<IndexChangeProvider>(
                                context,
                                listen: false,
                              ).changePageIndex(index: 1);
                            },
                            child: Container(
                              width: 200,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xff9046b9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Discover More",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 30),
                      GlassText(
                        cardWidth: 0.2,
                        textWidget: Text(
                          "UpComming Events",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      SizedBox(height: 20),

                      FutureBuilder(
                        future: ApiServices().getAllData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (!snapshot.hasData) {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Column(
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
                                      SizedBox(height: 15),
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                            );
                          } else {
                            List<EventModel> dataList = snapshot.data ?? [];
                            List<EventModel> dataListFirstValues = [];

                            for (EventModel a in dataList) {
                              if (dataListFirstValues.length < 3) {
                                dataListFirstValues.add(a);
                              }
                            }

                            dataListFirstValues.shuffle();
                            return dataList.isEmpty
                                ? Center(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Column(
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
                                            SizedBox(height: 15),
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: dataListFirstValues.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: gridCount,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: isMobile
                                                ? 0.9
                                                : 0.9,
                                          ),
                                      itemBuilder: (context, index) {
                                        final data = dataListFirstValues[index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleDataScreen(
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
                                    ),
                                  );
                          }
                        },
                      ),
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
}
