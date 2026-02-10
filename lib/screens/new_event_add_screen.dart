import 'dart:ui';

import 'package:even_hub/main_screen.dart';
import 'package:even_hub/models/event_model.dart';
import 'package:even_hub/models/speaker_model.dart';
import 'package:even_hub/models/user_model.dart';
import 'package:even_hub/providers/guest_provider.dart';
import 'package:even_hub/providers/index_change_provider.dart';
import 'package:even_hub/services/api_services.dart';
import 'package:even_hub/services/local_storage_service.dart';
import 'package:even_hub/widgets/add_event_firlds.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewEventAddScreen extends StatefulWidget {
  const NewEventAddScreen({super.key});

  @override
  State<NewEventAddScreen> createState() => _NewEventAddScreenState();
}

class _NewEventAddScreenState extends State<NewEventAddScreen> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  //userLogged?
  bool isUserLogin = false;

  //stroe userData
  UserModel currentUser = UserModel(
    userId: 000,
    name: "name",
    email: "email",
    role: "role",
  );

  Future<void> getUserData() async {
    UserModel data = await LocalStorageService().getUserData();
    bool login = await LocalStorageService().isUserLoggedIn();
    setState(() {
      currentUser = data;
      isUserLogin = login;
    });
  }

  //formKey
  final _formKey = GlobalKey<FormState>();

  //Value Notifiers
  final ValueNotifier<DateTime> _dateNotifer = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> _startTimeNotifer = ValueNotifier(
    TimeOfDay.now(),
  );
  final ValueNotifier<TimeOfDay> _endTimeNotifer = ValueNotifier(
    TimeOfDay.now(),
  );

  //TextEditing Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _eventImageUrlController =
      TextEditingController();
  final TextEditingController _eventTicketPriceController =
      TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _contactDetailsController =
      TextEditingController();
  final TextEditingController _guestImageUrlController =
      TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _eventImageUrlController.dispose();
    _eventTicketPriceController.dispose();
    _eventLocationController.dispose();
    _contactDetailsController.dispose();
    _guestNameController.dispose();
    _guestImageUrlController.dispose();
    _dateNotifer.dispose();
    _startTimeNotifer.dispose();
    _endTimeNotifer.dispose();
    super.dispose();
  }

  List<SpeakerModel> tempSpeckerList = [];
  Future<void> _submitEvent() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_dateNotifer.value);

    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      _startTimeNotifer.value.hour,
      _startTimeNotifer.value.minute,
    );
    String formattedStartTime = DateFormat('HH:mm').format(dt);

    final dt2 = DateTime(
      now.year,
      now.month,
      now.day,
      _endTimeNotifer.value.hour,
      _endTimeNotifer.value.minute,
    );
    String formattedEndTime = DateFormat('HH:mm').format(dt2);

    EventModel newEvent = EventModel(
      id: 0,
      title: _titleController.text,
      description: _descriptionController.text,
      imageUrl: _eventImageUrlController.text,
      date: formattedDate,
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      ticketPrice: double.parse(_eventTicketPriceController.text),
      location: _eventLocationController.text,
      userId: currentUser.userId,
      speakers: tempSpeckerList,
      contactInfo: _contactDetailsController.text,
    );

    ApiServices service = ApiServices();
    bool success = await service.createEvent(newEvent);

    _titleController.clear();
    _descriptionController.clear();
    _eventImageUrlController.clear();
    _eventTicketPriceController.clear();
    _eventLocationController.clear();
    _contactDetailsController.clear();

    if (success) {
      setState(() {
        Provider.of<GuestProvider>(context, listen: false).getGuestList.clear();
        tempSpeckerList.clear();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Event Added Successfully!")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      Provider.of<IndexChangeProvider>(
        context,
        listen: false,
      ).changePageIndex(index: 1);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to Add Event!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    //Show date picker
    Future<void> showDate(BuildContext conetext) async {
      DateTime? pick = await showDatePicker(
        initialDate: _dateNotifer.value,
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
      );

      if (pick != null && pick != _dateNotifer.value) {
        _dateNotifer.value = pick;
      }
    }

    //Show time picker

    Future<void> showtime(BuildContext context, bool isStartTime) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? _startTimeNotifer.value
            : _endTimeNotifer.value,
      );

      if (picked != null) {
        if (isStartTime) {
          _startTimeNotifer.value = picked;
        } else {
          _endTimeNotifer.value = picked;
        }
      }
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final bool isMobile = width < 600;
          final bool isTablet = width >= 600 && width < 1100;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1541701494587-cb58502866ab?auto=format&fit=crop&w=4096&q=100",
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                        child: Container(
                          width: isMobile
                              ? MediaQuery.of(context).size.width * 0.8
                              : MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.04),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: isMobile ? 90 : 100,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "Add Event",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AddEventFirlds(
                                        filedContraller: _titleController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please Enter Title!";
                                          } else {
                                            return null;
                                          }
                                        },
                                        topicTitle: "Title",
                                        hintText: "Enter Event Title",
                                      ),

                                      SizedBox(height: 20),
                                      AddEventFirlds(
                                        filedContraller:
                                            _eventImageUrlController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please Enter Image Url!";
                                          } else {
                                            return null;
                                          }
                                        },
                                        topicTitle: "Image URL",
                                        hintText: "Enter Image URL",
                                      ),

                                      SizedBox(height: 20),
                                      Text(
                                        "Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: isMobile
                                            ? MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.55
                                            : MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.2,
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.black45,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ValueListenableBuilder(
                                              valueListenable: _dateNotifer,
                                              builder: (context, date, child) =>
                                                  Text(
                                                    "Date : ${date.toString().split(" ")[0]}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  showDate(context),
                                              icon: Icon(
                                                Icons.calendar_month_sharp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Time",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(height: 10),
                                      isMobile
                                          ? Column(
                                              children: [
                                                Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.55,
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            _startTimeNotifer,
                                                        builder:
                                                            (
                                                              context,
                                                              time,
                                                              child,
                                                            ) => Text(
                                                              "Time : ${time.format(context)}",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () =>
                                                            showtime(
                                                              context,
                                                              true,
                                                            ),
                                                        icon: Icon(
                                                          Icons
                                                              .timelapse_rounded,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.55,
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            _endTimeNotifer,
                                                        builder:
                                                            (
                                                              context,
                                                              time,
                                                              child,
                                                            ) => Text(
                                                              "End : ${time.format(context)}",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () =>
                                                            showtime(
                                                              context,
                                                              false,
                                                            ),
                                                        icon: Icon(
                                                          Icons
                                                              .timelapse_rounded,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.2,
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            _startTimeNotifer,
                                                        builder:
                                                            (
                                                              context,
                                                              time,
                                                              child,
                                                            ) => Text(
                                                              "Start : ${time.format(context)}",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () =>
                                                            showtime(
                                                              context,
                                                              true,
                                                            ),
                                                        icon: Icon(
                                                          Icons
                                                              .timelapse_rounded,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.2,
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            _endTimeNotifer,
                                                        builder:
                                                            (
                                                              context,
                                                              time,
                                                              child,
                                                            ) => Text(
                                                              "End : ${time.format(context)}",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () =>
                                                            showtime(
                                                              context,
                                                              false,
                                                            ),
                                                        icon: Icon(
                                                          Icons
                                                              .timelapse_rounded,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                      SizedBox(height: 20),
                                      AddEventFirlds(
                                        filedContraller: _descriptionController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please Enter Description!";
                                          } else {
                                            return null;
                                          }
                                        },
                                        topicTitle: "Description",
                                        hintText: "Enter Description",
                                        maxLines: 5,
                                      ),
                                      SizedBox(height: 20),

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: isMobile
                                                ? MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.3
                                                : MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.2,
                                            child: AddEventFirlds(
                                              filedContraller:
                                                  _guestNameController,
                                              topicTitle: "Guests",
                                              hintText: "Enter Guests Name",
                                            ),
                                          ),
                                          SizedBox(width: 5),

                                          SizedBox(
                                            width: isMobile
                                                ? MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.3
                                                : MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.2,
                                            child: AddEventFirlds(
                                              filedContraller:
                                                  _guestImageUrlController,
                                              topicTitle: "Guests Image Url",
                                              hintText: "Enter Image Url",
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {
                                              if (_guestNameController
                                                      .text
                                                      .isEmpty ||
                                                  _guestImageUrlController
                                                      .text
                                                      .isEmpty) {
                                                return;
                                              } else {
                                                SpeakerModel
                                                newGuest = SpeakerModel(
                                                  name: _guestNameController
                                                      .text
                                                      .trim(),
                                                  imageUrl:
                                                      _guestImageUrlController
                                                          .text
                                                          .trim(),
                                                );
                                                Provider.of<GuestProvider>(
                                                  context,
                                                  listen: false,
                                                ).addNewGuest(
                                                  guestData: newGuest,
                                                );

                                                //add to temp list
                                                setState(() {
                                                  tempSpeckerList.add(newGuest);
                                                });
                                                _guestNameController.clear();
                                                _guestImageUrlController
                                                    .clear();
                                              }
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                      //todo: ListView builder
                                      Consumer(
                                        builder: (context, GuestProvider provider, child) {
                                          return SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.4,
                                            child: ListView.builder(
                                              itemCount:
                                                  provider.getGuestList.length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                SpeakerModel singleGuest =
                                                    provider
                                                        .getGuestList[index];
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                    top: 5,
                                                    bottom: 5,
                                                  ),
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.25,
                                                  height: 60,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadiusGeometry.circular(
                                                                    10,
                                                                  ),
                                                              child:
                                                                  Image.network(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    singleGuest
                                                                        .imageUrl,
                                                                  ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 20),
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.2,
                                                            child: Text(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              singleGuest.name,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Provider.of<
                                                                    GuestProvider
                                                                  >(
                                                                    context,
                                                                    listen:
                                                                        false,
                                                                  )
                                                                  .deleteGuestData(
                                                                    deleteData:
                                                                        singleGuest,
                                                                  );

                                                              //delete from temp
                                                              setState(() {
                                                                tempSpeckerList
                                                                    .remove(
                                                                      singleGuest,
                                                                    );
                                                              });
                                                            },
                                                            icon: Icon(
                                                              Icons.delete,
                                                              size: 30,
                                                              color: Colors
                                                                  .redAccent,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),

                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: isMobile
                                                    ? MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.3
                                                    : MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.2,
                                                child: AddEventFirlds(
                                                  filedContraller:
                                                      _eventTicketPriceController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please Enter Ticket Price!";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  topicTitle: "Ticket Price",
                                                  hintText:
                                                      "Enter Ticket Price",
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: isMobile
                                                    ? MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.3
                                                    : MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.2,
                                                child: AddEventFirlds(
                                                  filedContraller:
                                                      _eventLocationController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please Enter Location!";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  topicTitle: "Location",
                                                  hintText: "Enter Location",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      AddEventFirlds(
                                        filedContraller:
                                            _contactDetailsController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please Enter Contact Information!";
                                          } else {
                                            return null;
                                          }
                                        },
                                        topicTitle: "Contact Details",
                                        hintText: "Enter Contact Details",
                                      ),
                                      SizedBox(height: 40),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (isUserLogin) {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  await _submitEvent();
                                                }
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Please Login Before Add Event!",
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 45,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff9046b9),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Add Event",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                              height: 45,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.04,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Cancel",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
