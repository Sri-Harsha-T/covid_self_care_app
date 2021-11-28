import 'package:covid_self_care_app/animations/widget_enter_anim.dart';
import 'package:flutter/material.dart';
import 'package:covid_self_care_app/ui/widgets/info_card_with_image.dart';
import 'package:covid_self_care_app/data/models/info_card_model.dart';

class HowCoronaSpreads extends StatelessWidget {
  final String title;
  final List<InfoCardModel> infoList;
  const HowCoronaSpreads({required Key key, required this.title, required this.infoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
            color: Colors.black.withBlue(100),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: InfoCardWithImage(
                imageSrc: infoList[0].imageSrc,
                title: infoList[0].title,
                cardColor: infoList[0].cardColor, key: ObjectKey("icwi"),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: InfoCardWithImage(
                imageSrc: infoList[1].imageSrc,
                title: infoList[1].title,
                cardColor: infoList[1].cardColor, key: ObjectKey("icwi2"),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: InfoCardWithImage(
                imageSrc: infoList[2].imageSrc,
                title: infoList[2].title,
                cardColor: infoList[2].cardColor, key: ObjectKey("icwi3"),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: InfoCardWithImage(
                imageSrc: infoList[3].imageSrc,
                title: infoList[3].title,
                cardColor: infoList[3].cardColor, key: ObjectKey("icwi4"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
