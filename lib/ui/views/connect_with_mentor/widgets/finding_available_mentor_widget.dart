import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mwb_connect_app/utils/colors.dart';
import 'package:mwb_connect_app/ui/views/connect_with_mentor/widgets/cancel_lesson_request_dialog_widget.dart';
import 'package:mwb_connect_app/ui/widgets/animated_dialog_widget.dart';

class FindingAvailableMentor extends StatefulWidget {
  const FindingAvailableMentor({Key key})
    : super(key: key); 

  @override
  State<StatefulWidget> createState() => _FindingAvailableMentorState();
}

class _FindingAvailableMentorState extends State<FindingAvailableMentor> {

  Widget _showFindingAvailableMentorCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: Card(
        elevation: 3.0,
        margin: const EdgeInsets.only(bottom: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ), 
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              _showText(),
              _showCancelButton()
            ]
          )
        ),
      ),
    );
  }

  Widget _showText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50.0, 25.0, 50.0, 35.0),
      child: Text(
        'connect_with_mentor.finding_available_mentor'.tr(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          color: AppColors.DOVE_GRAY,
          height: 1.5
        )
      ),
    ); 
  }

  Widget _showCancelButton() {
    return Center(
      child: Container(
        height: 30.0,
        margin: const EdgeInsets.only(bottom: 10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 1.0,
            primary: AppColors.MONZA,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            padding: const EdgeInsets.fromLTRB(30.0, 3.0, 30.0, 3.0),
          ), 
          child: Text('common.cancel'.tr(), style: const TextStyle(color: Colors.white)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AnimatedDialog(
                widgetInside: CancelLessonRequestDialog()
              ),
            ); 
          }
        ),
      ),
    );
  }  

  @override
  Widget build(BuildContext context) {
    return _showFindingAvailableMentorCard();
  }
}