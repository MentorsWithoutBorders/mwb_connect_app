import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mwb_connect_app/utils/colors.dart';
import 'package:mwb_connect_app/utils/constants.dart';
import 'package:mwb_connect_app/core/models/lesson_model.dart';
import 'package:mwb_connect_app/core/viewmodels/connect_with_mentor_view_model.dart';
import 'package:mwb_connect_app/ui/widgets/button_loader_widget.dart';

class CancelNextLessonDialog extends StatefulWidget {
  const CancelNextLessonDialog({Key key})
    : super(key: key);  

  @override
  State<StatefulWidget> createState() => _CancelNextLessonDialogState();
}

class _CancelNextLessonDialogState extends State<CancelNextLessonDialog> {
  ConnectWithMentorViewModel _connectWithMentorProvider;
  bool _isCancelingNextLesson = false;

  Widget _showCancelNextLessonDialog() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 15.0),
      child: Wrap(
        children: <Widget>[
          _showTitle(),
          _showText(),
          _showButtons()
        ]
      )
    );
  }

  Widget _showTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: Text(
          'connect_with_mentor.cancel_lesson'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        )
      ),
    );
  }

  Widget _showText() {
    if (!_connectWithMentorProvider.isNextLesson) {
      return SizedBox.shrink();
    }    
    Lesson nextLesson = _connectWithMentorProvider.nextLesson;
    DateTime nextLessonDateTime = nextLesson.dateTime;  
    DateFormat dateFormat = DateFormat(AppConstants.dateFormatLesson);
    DateFormat timeFormat = DateFormat(AppConstants.timeFormatLesson);
    DateTime now = DateTime.now();
    String name = nextLesson.mentor.name;
    String subfield = nextLesson.subfield.name.toLowerCase();
    String date = dateFormat.format(nextLessonDateTime);
    String time = timeFormat.format(nextLessonDateTime);
    String timeZone = now.timeZoneName;
    String at = 'common.at'.tr();
    String text = 'connect_with_mentor.cancel_lesson_text'.tr(args: [subfield, name, date, time, timeZone]);
    String firstPart = text.substring(0, text.indexOf(subfield));
    String secondPart = text.substring(text.indexOf(subfield) + subfield.length, text.indexOf(name));

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.DOVE_GRAY,
            height: 1.5
          ),
          children: <TextSpan>[
            TextSpan(
              text: firstPart
            ),
            TextSpan(
              text: subfield
            ),
            TextSpan(
              text: secondPart
            ),
            TextSpan(
              text: name,
              style: const TextStyle(
                color: AppColors.TANGO
              ) 
            ),
            TextSpan(
              text: ' ' + 'common.on'.tr() + ' '
            ),
            TextSpan(
              text: date,
              style: const TextStyle(
                color: AppColors.TANGO
              ) 
            ),
            TextSpan(
              text: ' ' + at + ' '
            ),
            TextSpan(
              text: time + ' ' + timeZone,
              style: const TextStyle(
                color: AppColors.TANGO
              ) 
            ),
            TextSpan(
              text: '?'
            ),
          ],
        )
      ),
    );
  }
  
  Widget _showButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 12.0, 25.0, 12.0),
            child: Text('common.no_abort'.tr(), style: const TextStyle(color: Colors.grey))
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: AppColors.MONZA,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
          ),
          child: !_isCancelingNextLesson ? Text(
            'common.yes_cancel'.tr(),
            style: const TextStyle(color: Colors.white)
          ) : SizedBox(
            width: 70.0,
            child: ButtonLoader(),
          ),
          onPressed: () async {
            await _cancelNextLesson();
            Navigator.pop(context);
          },
        )
      ]
    );
  }
  
  Future<void> _cancelNextLesson() async {  
    _setIsCancelingNextLesson(true);
    await _connectWithMentorProvider.cancelNextLesson(isSingleLesson: true);
  }
  
  void _setIsCancelingNextLesson(bool isCanceling) {
    setState(() {
      _isCancelingNextLesson = isCanceling;
    });  
  }    
  
  @override
  Widget build(BuildContext context) {
    _connectWithMentorProvider = Provider.of<ConnectWithMentorViewModel>(context);

    return _showCancelNextLessonDialog();
  }
}