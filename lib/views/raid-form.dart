import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tark_q/services/data-access.dart';
import 'package:tark_q/services/user-services.dart';
import 'package:flutter/services.dart';

import '../globals.dart';

class RaidForm extends StatefulWidget {
  const RaidForm({super.key});

  @override
  State<RaidForm> createState() => _RaidFormState();
}

class _RaidFormState extends State<RaidForm> {
  String mapValue = 'Streets of Tarkov';
  String goalValue = 'Questing';
  String partySizeValue = '2';
  String contactMethodValue = 'Discord';
  String pmcFactionValue = 'BEAR';
  String pmcLevelValue = '1';
  String gameModeValue = 'PVP';
  String userHoursValue = '100+';
  String skillRatingValue = 'New';

  bool isLoading = false;
  final _contactIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final DataAccess dataAccess = DataAccess.instance;
  final UserServices userServices = UserServices.instance;

  @override
  void dispose() {
    _contactIdController.dispose();
    super.dispose();
  }

  static const List<String> gameModeOptions = <String>['PVP', 'PVE'];

  static const List<String> userHoursOptions = <String>[
    'under 50',
    '100+',
    '100+',
    '500+',
    '1000+',
    '1500+',
    '2000+',
    '5000+',
    '8000+',
    '10000+',
  ];

  static const List<String> skillRatingOptions = <String>[
    'New',
    'Intermediate',
    'Experienced',
    'Tarkov Veteran',
  ];

  static const List<String> mapOptions = <String>[
    'Shoreline',
    'Customs',
    'Reserve',
    'Interchange',
    'Streets of Tarkov',
    'Woods',
    'Lighthouse',
    'Factory',
    'The Lab',
    'Ground Zero',
  ];

  static const List<String> goalOptions = <String>[
    'Questing',
    'Farming Rubles',
    'PVP',
    'Other',
  ];

  static const List<String> partySizeOptions = <String>['2', '3', '4', '5'];

  static const List<String> contactMethodOptions = <String>[
    'Discord',
    'Tarkov Username',
  ];

  static final List<String> pmcLevelOptions = List.generate(
    79,
    (index) => (index + 1).toString(),
  );

  static const List<String> pmcFactionOptions = <String>['BEAR', 'USEC'];

  String getSelectedValue(String keyText) {
    switch (keyText) {
      case "Map":
        return mapValue;
      case "Goal":
        return goalValue;
      case "Max Party Size":
        return partySizeValue;
      case "Contact Method":
        return contactMethodValue;
      case "PMC Faction":
        return pmcFactionValue;
      case "PMC Level":
        return pmcLevelValue;
      case "Mode":
        return gameModeValue;
      case "In-Game Hours":
        return userHoursValue;
      case "Skill Rating":
        return skillRatingValue;
      default:
        return '';
    }
  }

  void updateSelectedValue(String keyText, String value) {
    switch (keyText) {
      case "Map":
        mapValue = value;
        break;
      case "Goal":
        goalValue = value;
        break;
      case "Max Party Size":
        partySizeValue = value;
        break;
      case "Contact Method":
        contactMethodValue = value;
        break;
      case "PMC Faction":
        pmcFactionValue = value;
        break;
      case "PMC Level":
        pmcLevelValue = value;
        break;
      case "Mode":
        gameModeValue = value;
        break;
      case "In-Game Hours":
        userHoursValue = value;
        break;
      case "Skill Rating":
        skillRatingValue = value;
        break;
    }
  }

  List<String> getPickerOptions(String keyText) {
    switch (keyText) {
      case "Map":
        return mapOptions;
      case "Goal":
        return goalOptions;
      case "Max Party Size":
        return partySizeOptions;
      case "Contact Method":
        return contactMethodOptions;
      case "PMC Faction":
        return pmcFactionOptions;
      case "PMC Level":
        return pmcLevelOptions;
      case "Mode":
        return gameModeOptions;
      case "In-Game Hours":
        return userHoursOptions;
      case "Skill Rating":
        return skillRatingOptions;
      default:
        return [];
    }
  }

  void _showCupertinoPicker(String keyText) {
    List<String> options = getPickerOptions(keyText);
    String currentValue = getSelectedValue(keyText);
    int initialIndex = options.indexOf(currentValue);
    if (initialIndex == -1) initialIndex = 0;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade600, width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Select $keyText',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    CupertinoButton(
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.lightGreenAccent),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: CupertinoPicker(
                    backgroundColor: Colors.black,
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: initialIndex,
                    ),
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        updateSelectedValue(keyText, options[index]);
                      });
                    },
                    children:
                        options.map<Widget>((String option) {
                          return Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: Colors.lightGreenAccent,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget formField(
    IconData icon,
    String keyText,
    String valueText,
    String section,
  ) {
    String selectedValue = getSelectedValue(keyText);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: isTablet(context) ? 24 : 16),
          SizedBox(width: 5),
          Text(
            '$keyText:',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: isTablet(context) ? 20 : 16,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 5),
          section == 'Raid'
              ? GestureDetector(
                onTap: () => _showCupertinoPicker(keyText),
                child: Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade600),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedValue,
                        style: TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.lightGreenAccent,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              )
              : Text(
                valueText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
        ],
      ),
    );
  }

  Widget generalInfo() {
    return Column(
      children: [
        formField(Icons.person, 'User', userServices.getUsername(), 'General'),
        formField(
          Icons.sports_kabaddi,
          'Mode',
          userServices.getUsername(),
          'Raid',
        ),
        formField(
          Icons.hourglass_bottom,
          'In-Game Hours',
          userServices.getUsername(),
          'Raid',
        ),
        formField(
          Icons.star,
          'Skill Rating',
          userServices.getUsername(),
          'Raid',
        ),
        formField(Icons.contrast, 'PMC Faction', 'BEAR', 'Raid'),
        formField(Icons.equalizer, 'PMC Level', '48', 'Raid'),
      ],
    );
  }

  Widget raidInfo() {
    return Column(
      children: [
        formField(Icons.location_on_outlined, 'Map', 'Shoreline', 'Raid'),
        formField(Icons.flag, 'Goal', 'Questing', 'Raid'),
        formField(Icons.diversity_3_rounded, 'Max Party Size', '3', 'Raid'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              color: Colors.red,
              icon: const Icon(Icons.cancel_outlined, size: 30),
              onPressed: () async {
                Navigator.of(context).pop(context);
              },
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Raid Ticket',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet(context) ? 40 : 35,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'Create and submit a raid ticket with your raid preference.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isTablet(context) ? 20 : 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withAlpha(75),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      'General Details',
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: isTablet(context) ? 40 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                generalInfo(),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withAlpha(75),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      'Raid Details',
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: isTablet(context) ? 40 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                raidInfo(),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withAlpha(75),
                          width: 1.0,
                        ),
                      ),
                    ),

                    child: Text(
                      'Contact Details',
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: isTablet(context) ? 40 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                formField(Icons.contacts, 'Contact Method', 'Discord', 'Raid'),
                Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      color: Colors.redAccent,
                      size: isTablet(context) ? 24 : 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Discord or Tarkov Id:',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: isTablet(context) ? 20 : 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: _contactIdController,
                    keyboardType: TextInputType.text,
                    maxLength: 15,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      LengthLimitingTextInputFormatter(20),
                    ],
                    style: const TextStyle(color: Colors.lightGreenAccent),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black,
                      hintText: "Enter your discord or tarkov username...",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.redAccent,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Discord or Tarkov username';
                      }
                      if (value.contains(' ')) {
                        return 'Spaces are not allowed';
                      }
                      return null;
                    },
                  ),
                ),
                Divider(height: 20, color: Colors.white),
                Center(
                  child: Text(
                    'Please verify your discord or tarkov username again before submitting.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isTablet(context) ? 20 : 14,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        if (userServices.getNumRaidTickets() < 3) {
                          // Create the ticket
                          Map<String, dynamic> ticketData = {
                            'username': userServices.getUsername(),
                            'gameMode': gameModeValue,
                            'userHours': userHoursValue,
                            'skillRating': skillRatingValue,
                            'pmcFaction': pmcFactionValue,
                            'pmcLevel': pmcLevelValue,
                            'map': mapValue,
                            'goal': goalValue,
                            'maxPartySize': partySizeValue,
                            'contactMethod': contactMethodValue,
                            'contactId': _contactIdController.text,
                            'createdAt': Timestamp.now(),
                          };

                          await dataAccess.createRaidTicket(
                            ticketData,
                            userServices.getUserEmail(),
                          );

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });

                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Limit reached'),
                                  titleTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                  content: Text(
                                    'You cannot have more than 3 active tickets at a time. Please delete an existing ticket.',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: IntrinsicWidth(
                      child:
                          isLoading
                              ? Row(
                                children: [
                                  LoadingAnimationWidget.inkDrop(
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Processing...',
                                    style: TextStyle(
                                      fontSize: isTablet(context) ? 24 : 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                              : Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: isTablet(context) ? 28 : 22,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Submit Ticket',
                                    style: TextStyle(
                                      fontSize: isTablet(context) ? 24 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
