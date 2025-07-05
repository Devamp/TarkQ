import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import '../components/award-container.dart';
import '../globals.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  bool isLoadingSave = false;
  bool isLoadingClear = false;
  String buttonTextSave = 'Save';
  String buttonTextClear = 'Clear';
  bool noAchievementsSelected = true;

  List<String> achievementOptions = [
    'Kappa',
    'Killa Hunter',
    'Snowball',
    'Marathon',
    '1 Prestigious',
    '2 Prestigious',
    'PvE Master',
    'Labs Rat',
    'Gunsmith',
    'Collector',
    'Quest Master',
    'Survivor',
    'Sniper Elite',
    'Boss Hunter',
    'Trader Max',
    'PMC Slayer',
    'Silent Assassin',
    'Looter',
    'Chad',
  ];

  List<String?>? selectedAchievements = ["None", "None", "None", "None"];

  @override
  void initState() {
    super.initState();
    _loadInitialAchievements();
  }

  Future<void> _loadInitialAchievements() async {
    List<String?> achievementsFromDb = [];
    try {
      achievementsFromDb = await userServices.getUserAchievements(
        userServices.getUserEmail(),
      );
    } catch (e) {
      rethrow;
    }

    setState(() {
      selectedAchievements = achievementsFromDb;
      while (selectedAchievements!.length < 4) {
        selectedAchievements!.add("None");
      }
    });
  }

  void _showAchievementPicker(int index) {
    if (selectedAchievements == null) return;

    List<String> availableOptions =
        achievementOptions
            .where(
              (option) =>
                  !selectedAchievements!.contains(option) ||
                  selectedAchievements![index] == option,
            )
            .toList();

    int initialIndex = availableOptions.indexOf(
      selectedAchievements![index] ?? availableOptions.first,
    );

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
                color: Colors.grey.shade800,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Select Achievement',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 16,
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
                child: CupertinoPicker(
                  backgroundColor: Colors.black,
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (int selectedIndex) {
                    setState(() {
                      selectedAchievements![index] =
                          availableOptions[selectedIndex];
                    });
                  },
                  children:
                      availableOptions
                          .map(
                            (e) => Center(
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget achievementContainer(int index) {
    if (selectedAchievements == null) {
      // Show loading spinner while loading achievements
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(color: Colors.lightGreenAccent),
        ),
      );
    }

    String displayText = selectedAchievements![index] ?? "None selected";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AwardContainer(
            icon: getAchievementIconByText(displayText),
            iconText: displayText,
            screenName: "Achievements",
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => _showAchievementPicker(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              foregroundColor: Colors.black,
            ),
            child: Text("Edit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Achievements'),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet(context) ? 32 : 20,
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Colors.lightGreenAccent,
                  size: 30,
                ),
                SizedBox(width: 5),
                Text(
                  'Show Off Achievements',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: isTablet(context) ? 28 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.emoji_events,
                  color: Colors.lightGreenAccent,
                  size: 30,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'You may select up to 4 achievements to display on your account profile.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: isTablet(context) ? 28 : 14,
                ),
              ),
            ),
            Column(
              children: List.generate(
                4,
                (index) => achievementContainer(index),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      (selectedAchievements == null ||
                              isLoadingClear ||
                              selectedAchievements!.every(
                                (item) => item == "None",
                              ))
                          ? () {}
                          : () async {
                            setState(() {
                              isLoadingClear = true;
                              buttonTextClear = 'Clearing...';
                            });
                            await userServices.updateUserAchievements(
                              userServices.getUserEmail(),
                              [],
                            );
                            setState(() {
                              isLoadingClear = false;
                              buttonTextClear = 'Cleared';
                              _loadInitialAchievements();
                            });
                            await Future.delayed(Duration(seconds: 2));
                            if (mounted) {
                              setState(() {
                                buttonTextClear = 'Clear';
                              });
                            }
                          },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child:
                      isLoadingClear
                          ? IntrinsicWidth(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LoadingAnimationWidget.inkDrop(
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ],
                            ),
                          )
                          : IntrinsicWidth(
                            child: Row(
                              children: [
                                !isLoadingClear && buttonTextClear == "Cleared"
                                    ? Padding(
                                      padding: const EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    )
                                    : SizedBox(),
                                Text(
                                  buttonTextClear,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed:
                      (selectedAchievements == null ||
                              isLoadingSave ||
                              selectedAchievements!.every(
                                (item) => item == "None",
                              ))
                          ? () {}
                          : () async {
                            setState(() {
                              isLoadingSave = true;
                              buttonTextSave = 'Saving...';
                            });
                            await userServices.updateUserAchievements(
                              userServices.getUserEmail(),
                              selectedAchievements!,
                            );
                            setState(() {
                              isLoadingSave = false;
                              buttonTextSave = 'Saved';
                            });
                            await Future.delayed(Duration(seconds: 2));
                            if (mounted) {
                              setState(() {
                                buttonTextSave = 'Save';
                              });
                            }
                          },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child:
                      isLoadingSave
                          ? IntrinsicWidth(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LoadingAnimationWidget.inkDrop(
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ],
                            ),
                          )
                          : IntrinsicWidth(
                            child: Row(
                              children: [
                                !isLoadingSave && buttonTextSave == "Saved"
                                    ? Padding(
                                      padding: const EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    )
                                    : SizedBox(),
                                Text(
                                  buttonTextSave,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
