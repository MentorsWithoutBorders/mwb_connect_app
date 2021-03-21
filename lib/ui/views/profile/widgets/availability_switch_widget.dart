import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:mwb_connect_app/utils/keys.dart';
import 'package:mwb_connect_app/utils/colors.dart';
import 'package:mwb_connect_app/core/viewmodels/profile_view_model.dart';

class AvailabilitySwitch extends StatefulWidget {
  const AvailabilitySwitch({Key key})
    : super(key: key); 

  @override
  State<StatefulWidget> createState() => _AvailabilitySwitchState();
}

class _AvailabilitySwitchState extends State<AvailabilitySwitch> {
  ProfileViewModel _profileProvider;

  Widget _showAvailabilitySwitch() {
    final TargetPlatform platform = Theme.of(context).platform;
    final double paddingTop = platform == TargetPlatform.android ? 15.0 : 10.0; 
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(5.0, paddingTop, 20.0, 5.0),
            child: const Text(
              'I\'m currently available',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.DOVE_GRAY
              ),
            )
          )
        ),
        // Android
        if (platform == TargetPlatform.android) Switch(
          key: Key(AppKeys.isAvailableSwitchAndroid),
          value: _profileProvider.profile.user.isAvailable,
          onChanged: (bool value){
            _profileProvider.setIsAvailable(value);
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green
        ),
        // iOS
        if (platform == TargetPlatform.iOS) Transform.scale( 
          scale: 0.8,
          child: CupertinoSwitch(
            key: Key(AppKeys.isAvailableSwitchiOS),            
            value: _profileProvider.profile.user.isAvailable,
            onChanged: (bool value){
              _profileProvider.setIsAvailable(value);
            }
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _profileProvider = Provider.of<ProfileViewModel>(context);      

    return _showAvailabilitySwitch();
  }
}