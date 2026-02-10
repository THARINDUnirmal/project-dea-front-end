import 'package:even_hub/providers/index_change_provider.dart';
import 'package:even_hub/providers/logo_provider.dart';
import 'package:even_hub/screens/about_us_screen.dart';
import 'package:even_hub/screens/all_event_screen.dart';
import 'package:even_hub/screens/contactus_screen.dart';
import 'package:even_hub/screens/home_screen.dart';
import 'package:even_hub/screens/login/auth_screenn.dart';
import 'package:even_hub/screens/login/login_screen.dart';
import 'package:even_hub/screens/login/registater_screen.dart';
import 'package:even_hub/widgets/animated_gradient_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> pagesList = [
    HomeScreen(),
    AllEventScreen(),
    AboutUsScreen(),
    ContactusScreen(),
    AuthScreenn(),
    LoginScreen(),
    RegistaterScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return _desktopLayout(context);
          } else {
            return _mobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _desktopNavbar(context),
          Consumer(
            builder: (context, IndexChangeProvider provider, child) {
              return pagesList[provider.getCurruentIndex];
            },
          ),

          AnimatedGradientFooter(),
        ],
      ),
    );
  }

  Widget _desktopNavbar(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFE0F2FE), Color(0xFFDBEAFE)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/logo.png", width: 150, fit: BoxFit.cover),

          Row(
            children: [
              _navItem("Home", 0),
              _navItem("All Events", 1),
              _navItem("About Us", 2),
              _navItem("Contact Us", 3),
            ],
          ),

          _profileIcon(),
        ],
      ),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", width: 120),
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              Provider.of<IndexChangeProvider>(
                context,
                listen: false,
              ).changePageIndex(index: 4);
            },
            //todo
            child: Consumer(
              builder: (context, LogoProvider provider, child) {
                return CircleAvatar(
                  radius: 22,
                  backgroundImage: provider.getLoginState
                      ? AssetImage("assets/images/loged.png")
                      : NetworkImage(
                          "https://tse4.mm.bing.net/th/id/OIP.EdMU5ST27Athxfdd0gkLCwHaHa",
                        ),
                );
              },
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.asset("assets/images/logo.png", fit: BoxFit.cover),
              ),
            ),
            _drawerItem("Home", 0),
            _drawerItem("All Events", 1),
            _drawerItem("About Us", 2),
            _drawerItem("Contact Us", 3),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, IndexChangeProvider provider, child) {
            return Column(
              children: [
                pagesList[provider.getCurruentIndex],
                AnimatedGradientFooter(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _navItem(String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          Provider.of<IndexChangeProvider>(
            context,
            listen: false,
          ).changePageIndex(index: index);
        },
        child: Consumer(
          builder: (context, IndexChangeProvider value, child) {
            int cIndex = value.getCurruentIndex;
            return Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cIndex == index ? Colors.purpleAccent : Colors.black54,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _drawerItem(String title, int index) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Provider.of<IndexChangeProvider>(
          context,
          listen: false,
        ).changePageIndex(index: index);
        Navigator.pop(context);
      },
    );
  }

  Widget _profileIcon() {
    return GestureDetector(
      onTap: () {
        Provider.of<IndexChangeProvider>(
          context,
          listen: false,
        ).changePageIndex(index: 4);
      },
      child: Consumer(
        builder: (context, LogoProvider provider, child) {
          return CircleAvatar(
            radius: 22,
            backgroundImage: provider.getLoginState
                ? AssetImage("assets/images/loged.png")
                : NetworkImage(
                    "https://tse4.mm.bing.net/th/id/OIP.EdMU5ST27Athxfdd0gkLCwHaHa",
                  ),
          );
        },
      ),
    );
  }
}
