import 'package:even_hub/models/event_model.dart';
import 'package:even_hub/models/speaker_model.dart';
import 'package:flutter/material.dart';

class SingleDataScreen extends StatelessWidget {
  final EventModel singleEventData;
  const SingleDataScreen({super.key, required this.singleEventData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe9ecf1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        singleEventData.imageUrl,
                        width: double.infinity,
                        height: isMobile ? 250 : 400,
                        fit: BoxFit.fill,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: isMobile
                          ? _mobileLayout(context)
                          : _desktopLayout(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: _mainContent(context)),
        const SizedBox(width: 20),
        Expanded(flex: 3, child: _sideContent(context)),
      ],
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        _mainContent(context),
        const SizedBox(height: 30),
        _sideContent(context),
      ],
    );
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          singleEventData.title,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          singleEventData.description,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Colors.black54),
        ),

        const SizedBox(height: 25),

        _dateCard(context),

        const SizedBox(height: 25),

        SizedBox(
          height: 45,
          width: 160,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff9046b9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text("Buy Ticket"),
          ),
        ),

        const SizedBox(height: 40),

        Text(
          "Speakers",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 20),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: singleEventData.speakers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 3,
          ),
          itemBuilder: (context, index) {
            final SpeakerModel speaker = singleEventData.speakers[index];
            return _speakerCard(context, speaker);
          },
        ),
      ],
    );
  }

  Widget _sideContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoCard(
          title: "Ticket Price",
          value: "Rs. ${singleEventData.ticketPrice}",
        ),
        const SizedBox(height: 20),
        _locationCard(context),
        const SizedBox(height: 20),
        _organizerCard(),
      ],
    );
  }

  Widget _dateCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Text(
            "${singleEventData.date} | ${singleEventData.startTime} - ${singleEventData.endTime}",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _speakerCard(BuildContext context, SpeakerModel speaker) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(speaker.imageUrl),
          ),
          const SizedBox(width: 15),
          Text(
            speaker.name,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _locationCard(BuildContext context) {
    return _infoCard(title: "Location", value: singleEventData.location);
  }

  Widget _organizerCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Image.asset(
        "assets/images/logo.png",
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }
}
