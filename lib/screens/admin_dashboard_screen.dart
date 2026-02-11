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

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  UserModel userData = UserModel(
    userId: 0,
    name: "name",
    email: "email",
    role: "role",
  );
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  Future<void> getCurrentUserDetails() async {
    UserModel data = await LocalStorageService().getUserData();

    if (mounted) {
      setState(() {
        userData = data;
      });
    }
  }

  void _showUpdateForm(BuildContext context, EventModel event) {
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

                TextField(
                  controller: TextEditingController(
                    text: event.userId.toInt().toString(),
                  ),
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
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      print("🔘 Update Button Tapped!");

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
                          const SnackBar(content: Text("Update Done!")),
                        );
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to Update!")),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await UserServices().deleteUser(
                              user.userId.toInt(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("✅ User Delete!")),
                            );
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    ),
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
                      decoration: const InputDecoration(labelText: 'User Name'),
                    ),
                    TextField(
                      controller: userEmailController,
                      decoration: const InputDecoration(
                        labelText: 'User Email',
                      ),
                    ),
                    TextField(
                      controller: userRoleController,
                      decoration: const InputDecoration(labelText: 'User Role'),
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
                          print("🔘 Update Button Tapped!");

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
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
                        backgroundColor: const Color.fromARGB(255, 221, 27, 27),
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
                "Admin Dashboard",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.13,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      color: Color(0xffc0c5c5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "View All Event",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              partWidget(
                context: context,
                title: "Account Details",
                childWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User ID: ${userData.userId}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "User Name: ${userData.name}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "User Email: ${userData.email}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "User Roal: ${userData.role}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(height: 20),
              partWidget(
                context: context,
                title: "All User Details",
                childWidget: Column(
                  children: [
                    FutureBuilder<List<dynamic>>(
                      future: UserServices().getAllUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else {
                          final List<UserModel> users = (snapshot.data as List)
                              .map((data) => UserModel.fromJson(data))
                              .toList();

                          return ListView.builder(
                            itemCount: users.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final user = users[index];

                              return InkWell(
                                onTap: () {
                                  _showUserUpdateForm(context, user);
                                },
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text(
                                    user.name.isEmpty ? "No Name" : user.name,
                                  ),
                                  subtitle: Text(user.email),
                                  trailing: Text(
                                    user.role,
                                    style: TextStyle(
                                      color: user.role == 'ADMIN'
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
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
                title: "All Events Activity",
                childWidget: Column(
                  children: [
                    FutureBuilder<List<EventModel>>(
                      future: ApiServices().getAllData(),
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
                            child: Text("ඔබ තවමත් කිසිදු Event එකක් සාදා නැත."),
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
                                  trailing: const Icon(Icons.arrow_forward_ios),
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
              SizedBox(height: 30),
            ],
          ),
        ),
      ],
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
