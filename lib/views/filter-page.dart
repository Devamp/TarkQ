import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../globals.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String mapValue = 'Any';
  String goalValue = 'Any';
  String partySizeValue = 'Any';
  String contactMethodValue = 'Any';
  String pmcLevelValue = 'Any';
  String gameModeValue = 'Any';
  String skillRatingValue = 'Any';
  String regionValue = 'Any';
  bool isLoading = false;

  static const List<String> gameModeOptions = <String>['PVP', 'PVE'];

  static const List<String> skillRatingOptions = <String>[
    'New',
    'Intermediate',
    'Experienced',
    'Tarkov Veteran',
  ];

  static const List<String> mapOptions = <String>[
    'Any',
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
    'Any',
    'Questing',
    'Farming Rubles',
    'PVP',
  ];

  static const List<String> partySizeOptions = <String>[
    'Any',
    '2',
    '3',
    '4',
    '5',
  ];

  static const List<String> contactMethodOptions = <String>[
    'Any',
    'Discord',
    'Tarkov Username',
  ];

  static const List<String> regionOptions = <String>[
    'North America',
    'Europe',
    'Latin America',
    'Asia',
    'Australia',
    'Other',
  ];

  static final List<String> pmcLevelOptions =
      <String>['Any'] + List.generate(79, (index) => (index + 1).toString());

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
      case "Min PMC Level":
        return pmcLevelValue;
      case "Game Mode":
        return gameModeValue;
      case "Skill Rating":
        return skillRatingValue;
      case "Region":
        return regionValue;
      default:
        return 'Any';
    }
  }

  void updateSelectedValue(String keyText, String value) {
    setState(() {
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
        case "Min PMC Level":
          pmcLevelValue = value;
          break;
        case "Game Mode":
          gameModeValue = value;
          break;
        case "Skill Rating":
          skillRatingValue = value;
        case "Region":
          regionValue = value;
          break;
      }
    });
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
      case "Min PMC Level":
        return pmcLevelOptions;
      case "Game Mode":
        return gameModeOptions;
      case "Skill Rating":
        return skillRatingOptions;
      case "Region":
        return regionOptions;
      default:
        return [];
    }
  }

  void _showCupertinoPicker(String keyText) {
    List<String> options = getPickerOptions(keyText);
    int initialIndex = options.indexOf(getSelectedValue(keyText));
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
                      updateSelectedValue(keyText, options[index]);
                    },
                    children:
                        options
                            .map(
                              (String option) => Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: Colors.lightGreenAccent,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget filterField(IconData icon, String keyText) {
    String selectedValue = getSelectedValue(keyText);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          SizedBox(width: 5),
          Text(
            '$keyText:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(width: 5),
          GestureDetector(
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tune,
                        color: Colors.lightGreenAccent,
                        size: 35,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Ticket Filters',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        color: Colors.redAccent,
                        icon: const Icon(Icons.cancel_outlined, size: 26),
                        onPressed: () async {
                          Navigator.of(context).pop(context);
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Apply unique ticket filters below to find exactly what you are looking for.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isTablet(context) ? 28 : 14,
                    ),
                  ),
                  SizedBox(height: 15),
                  filterField(Icons.location_on_outlined, 'Map'),
                  filterField(Icons.flag, 'Goal'),
                  filterField(Icons.compare_arrows_rounded, 'Game Mode'),
                  filterField(Icons.star, 'Skill Rating'),
                  filterField(Icons.diversity_3_rounded, 'Max Party Size'),
                  filterField(Icons.contacts, 'Contact Method'),
                  filterField(Icons.equalizer, 'Min PMC Level'),
                  filterField(Icons.public, 'Region'),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Reset filters by just clicking the button below.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isTablet(context) ? 28 : 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });

                        Map<String, String> filters = {
                          'map': mapValue,
                          'goal': goalValue,
                          'partySize': partySizeValue,
                          'contactMethod': contactMethodValue,
                          'pmcLevel': pmcLevelValue,
                          'gameMode': gameModeValue,
                          'skillRating': skillRatingValue,
                          'region': regionValue,
                        };

                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context, filters);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
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
                                    'Applying...',
                                    style: TextStyle(
                                      fontSize: isTablet(context) ? 24 : 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                              : Text(
                                'Apply Filters',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
