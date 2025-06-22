import 'package:flutter/material.dart';

class AwardContainer extends StatelessWidget {
  final Widget icon;
  final String iconText;
  final String screenName;

  const AwardContainer({
    super.key,
    required this.icon,
    required this.iconText,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: screenName == "Achievements" ? 75 : 75,
          width: screenName == "Achievements" ? 200 : 75,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            border: Border.all(color: Colors.amber, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              screenName == "Achievements"
                  ? Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        iconText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                      ),
                    ],
                  )
                  : SizedBox(),
            ],
          ),
        ),
        screenName == "Profile"
            ? Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: SizedBox(
                width: 75,
                child: Text(
                  iconText.contains("Prestigious") ? "Prestigious" : iconText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                ),
              ),
            )
            : SizedBox(),
      ],
    );
  }
}
