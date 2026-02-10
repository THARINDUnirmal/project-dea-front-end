import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final bool isMobile;
  final String cardTitle;
  final String cardImage;
  final String cardDescription;
  const CardWidget({
    super.key,
    required this.cardTitle,
    required this.cardImage,
    required this.cardDescription,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 30, bottom: 30),
      width: MediaQuery.of(context).size.width * 0.16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(
              cardImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          SizedBox(height: 10),
          Text(cardTitle, style: TextStyle(color: Colors.black)),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Text(
                    cardDescription,
                    overflow: TextOverflow.ellipsis,
                    maxLines: isMobile ? 2 : 3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 15),
                width: isMobile
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                  color: Color(0xff9046b9),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    "Veiw Details",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
