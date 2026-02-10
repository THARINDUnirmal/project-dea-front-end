import 'package:even_hub/main_screen.dart';
import 'package:even_hub/models/event_model.dart';
import 'package:even_hub/models/user_model.dart';
import 'package:even_hub/providers/logo_provider.dart';
import 'package:even_hub/screens/new_event_add_screen.dart';
import 'package:even_hub/services/api_services.dart';
import 'package:even_hub/services/auth_services.dart';
import 'package:even_hub/services/local_storage_service.dart';
import 'package:even_hub/services/user_services.dart';
import 'package:even_hub/utils/app_messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsereDashboardScreen extends StatefulWidget {
  const UsereDashboardScreen({super.key});

  @override
  State<UsereDashboardScreen> createState() => _UsereDashboardScreenState();
}

class _UsereDashboardScreenState extends State<UsereDashboardScreen> {
  // 1. userData variable එක මෙතනට ගත්තා (State class එකේ මුලට)
  UserModel userData = UserModel(
    userId: 0,
    name: "name",
    email: "email",
    role: "role",
  );

  // 2. initState එක ඇතුළේ async දාන්න බැහැ, ඒ නිසා වෙනම method එකක් call කරනවා
  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  bool isLoading = false;

  // 3. දත්ත ලබාගෙන setState කරන නිවැරදි ක්‍රමය
  Future<void> getCurrentUserDetails() async {
    UserModel data = await LocalStorageService().getUserData();

    if (mounted) {
      setState(() {
        userData = data;
      });
    }
  }

  void _showUpdateForm(BuildContext context, EventModel event) {
    // Initialize controllers with the model's current properties
    final nameController = TextEditingController(text: event.title);
    final descController = TextEditingController(text: event.description);
    final eventImageController = TextEditingController(text: event.imageUrl);
    final ticketPriceController = TextEditingController(
      text: event.ticketPrice.toString(),
    );
    final locationController = TextEditingController(text: event.location);
    final dateController = TextEditingController(text: event.date);
    final startTimeController = TextEditingController(text: event.startTime);
    final endTimeController = TextEditingController(text: event.endTime);
    final contactInfoController = TextEditingController(
      text: event.contactInfo,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool success = await ApiServices().deleteEvent(
                          event.id,
                        );
                        if (success) {
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                // User ID Field - Displayed but NOT changeable
                TextField(
                  controller: TextEditingController(
                    text: event.id.toInt().toString(),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Event ID (Permanent)',
                    prefixIcon: Icon(Icons.lock_outline, size: 20),
                    filled: true,
                  ),
                  readOnly: true,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Event Name'),
                ),
                TextField(
                  maxLines: 2,
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  maxLines: 2,
                  controller: eventImageController,
                  decoration: const InputDecoration(labelText: 'ImegeUrl'),
                ),
                TextField(
                  controller: ticketPriceController,
                  decoration: const InputDecoration(labelText: 'Tiket Price'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Event Location',
                  ),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Event Date(ex:2026-02-07)',
                  ),
                ),
                TextField(
                  controller: startTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Event Start Time(Hours:Minute)',
                  ),
                ),
                TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Event End Time((Hours:Minute))',
                  ),
                ),
                TextField(
                  controller: contactInfoController,
                  decoration: const InputDecoration(
                    labelText: 'Event Contact Info',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),

            // Button එක ඇතුළේ
            // මෙය class එකේ ඉහළින් variable එකක් ලෙස දාන්න
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      print("🔘 Update Button Tapped!"); // Check 6

                      setState(() => isLoading = true);

                      EventModel updatedEvent = EventModel(
                        id: event.id,
                        title: nameController.text,
                        description: descController.text,
                        imageUrl: eventImageController.text,
                        date: dateController.text,
                        ticketPrice: double.parse(ticketPriceController.text),
                        location: locationController.text,
                        userId: event.userId,
                        speakers: event.speakers,
                        startTime: startTimeController.text,
                        endTime: endTimeController.text,
                        contactInfo: contactInfoController.text,
                      );

                      bool success = await ApiServices().updateEvent(
                        updatedEvent,
                      );

                      setState(() => isLoading = false);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("✅ සාර්ථකව යාවත්කාලීන විය!"),
                          ),
                        );
                        Navigator.pop(
                          context,
                          true,
                        ); // කලින් screen එකට ගොස් refresh කරන්න
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "❌ Update එක අසාර්ථකයි. Console බලන්න.",
                            ),
                          ),
                        );
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update Event"),
            ),
          ],
        );
      },
    );
  }

  //user Update

  void _showUserUpdateForm(BuildContext context, UserModel user) {
    final userNameController = TextEditingController(text: user.name);
    final userEmailController = TextEditingController(text: user.email);
    final userRoleController = TextEditingController(text: user.role);
    final userIdController = TextEditingController(
      text: user.userId.toInt().toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Update User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: userIdController,
                      decoration: const InputDecoration(
                        labelText: 'User ID (Permanent)',
                        prefixIcon: Icon(Icons.lock_outline, size: 20),
                        filled: true,
                      ),
                      readOnly: true,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: 'User Name (Permanent)',
                        prefixIcon: Icon(Icons.lock_outline, size: 20),
                        filled: true,
                      ),
                      readOnly: true,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    TextField(
                      controller: userEmailController,
                      decoration: const InputDecoration(
                        labelText: 'User Email',
                      ),
                    ),
                    TextField(
                      controller: userRoleController,
                      decoration: const InputDecoration(
                        labelText: 'User Role (Permanent)',
                        prefixIcon: Icon(Icons.lock_outline, size: 20),
                        filled: true,
                      ),
                      readOnly: true,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setDialogState(() => isLoading = true);

                          Map<String, dynamic> updatedData = {
                            "userName": userNameController.text,
                            "userEmail": userEmailController.text,
                            "role": userRoleController.text,
                          };

                          bool success = await UserServices().updateUser(
                            user.userId.toInt(),
                            updatedData,
                          );
                          SharedPreferences _pref =
                              await SharedPreferences.getInstance();
                          _pref.setString("userName", userNameController.text);
                          _pref.setString(
                            "userEmail",
                            userEmailController.text,
                          );

                          setDialogState(() => isLoading = false);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("✅ සාර්ථකව යාවත්කාලීන විය!"),
                              ),
                            );
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("❌ Update එක අසාර්ථකයි!"),
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Update User"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 1,
                padding: EdgeInsets.all(20),
                color: Colors.black87,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                221,
                                27,
                                27,
                              ),
                            ),
                            onPressed: () async {
                              AppMessages().appAlertMessage(
                                context: context,
                                onPressed: () async {
                                  await AuthService().clearUserData();
                                  Provider.of<LogoProvider>(
                                    context,
                                    listen: false,
                                  ).setLoginState(loginValue: false);
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            child: Text("Log Out"),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Your Dashboard",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.13,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff9046b9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Create New Event",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        InkWell(
                          onTap: () {
                            _showUserUpdateForm(context, userData);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.13,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xffc0c5c5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Eddit Profile",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    partWidget(
                      context: context,
                      title: "Your Account Details",
                      childWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User ID: ${userData.userId}",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "User Name: ${userData.name}",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "User Email: ${userData.email}",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "User Roal: ${userData.role}",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ), //todo : First container
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 1,
                padding: EdgeInsets.all(20),
                color: Colors.black87,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    partWidget(
                      context: context,
                      title: "My Events Activity",
                      childWidget: Column(
                        children: [
                          FutureBuilder<List<EventModel>>(
                            future: ApiServices().getMyEvents(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("දෝෂයකි: ${snapshot.error}"),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "ඔබ තවමත් කිසිදු Event එකක් සාදා නැත.",
                                  ),
                                );
                              }

                              final myEvents = snapshot.data!;
                              return ListView.builder(
                                itemCount: myEvents.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final event = myEvents[index];
                                  return InkWell(
                                    onTap: () {
                                      _showUpdateForm(context, event);
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.event_note,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          event.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Date: ${event.date}\nLocation: ${event.location}",
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget partWidget({
    required BuildContext context,
    required String title,
    required Widget childWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,

          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: childWidget,
        ),
      ],
    );
  }
}
