import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mwb_connect_app/core/models/user_model.dart';
import 'package:mwb_connect_app/utils/keys.dart';
import 'package:mwb_connect_app/utils/utils.dart';
import 'package:mwb_connect_app/utils/colors.dart';
import 'package:mwb_connect_app/core/viewmodels/profile_view_model.dart';
import 'package:mwb_connect_app/ui/views/profile/widgets/label_widget.dart';
import 'package:mwb_connect_app/ui/widgets/dropdown_widget.dart';

class Lessons extends StatefulWidget {
  const Lessons({Key key})
    : super(key: key); 

  @override
  State<StatefulWidget> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  ProfileViewModel _profileProvider;
  LessonsAvailability _lessonsAvailability;

  Widget _showLessons() {
    return Wrap(
      children: [
        _showTitle(),
        Container(
          padding: const EdgeInsets.only(left: 3.0),
          child: Wrap(
            children: [
              Label(text: 'profile.min_interval_lessons'.tr()),
              _showMinInterval(),
              Label(text: 'profile.max_students_lessons'.tr()),
              _showMaxStudents()
            ]
          )
        )
      ]
    );
  }

  Widget _showTitle() {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, bottom: 18.0),
      child: Text(
        'profile.lessons'.tr(),
        style: const TextStyle(
          color: AppColors.TANGO,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }  

  Widget _showMinInterval() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: Row(
        children: [
          Container(
            width: 50.0,
            height: 45.0,
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Dropdown(
              key: const Key(AppKeys.minIntervalDropdown),
              dropdownMenuItemList: _buildNumbers(),
              onTapped: _unfocus,
              onChanged: _changeMinInterval,
              value: _lessonsAvailability.minInterval
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0)
          ),
          Container(
            width: 100.0,
            height: 45.0,
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Dropdown(
              key: const Key(AppKeys.minIntervalUnitDropdown),
              dropdownMenuItemList: _buildMinIntervalUnitsDropdown(),
              onTapped: _unfocus,
              onChanged: _changeMinIntervalUnit,
              value: _profileProvider.getPeriodUnitPlural(_lessonsAvailability.minIntervalUnit, _lessonsAvailability.minInterval)
            ),
          ),
        ]
      ),
    );
  }

  Widget _showMaxStudents() {
    return Row(
      children: [
        Container(
          width: 50.0,
          height: 45.0,
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Dropdown(
            key: const Key(AppKeys.maxStudentsDropdown),
            dropdownMenuItemList: _buildNumbers(),
            onTapped: _unfocus,
            onChanged: _changeMaxStudents,
            value: _lessonsAvailability.maxStudents
          ),
        )
      ]
    );
  }  

  List<DropdownMenuItem<int>> _buildNumbers() {
    final List<DropdownMenuItem<int>> items = [];
    for (int i = 1; i < 10; i++) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(i.toString()),
      ));
    }
    return items;
  }
  
  List<DropdownMenuItem<String>> _buildMinIntervalUnitsDropdown() {
    final List<DropdownMenuItem<String>> items = [];
    for (final String periodUnit in Utils.periodUnits) {
      items.add(DropdownMenuItem(
        value: _profileProvider.getPeriodUnitPlural(periodUnit, _lessonsAvailability.minInterval),
        child: Text(_profileProvider.getPeriodUnitPlural(periodUnit, _lessonsAvailability.minInterval)))
      );
    }
    return items;
  }
  
  void _changeMinInterval(int number) {
    _setSelectedMinInterval(number);
    _updateLessonsAvailability();
  }
  
  void _setSelectedMinInterval(int number) {
    setState(() {
      _lessonsAvailability.minInterval = number;
    });
  }
  
  void _changeMinIntervalUnit(String unit) {
    _setSelectedMinIntervalUnit(unit);
    _updateLessonsAvailability();
  }
  
  void _setSelectedMinIntervalUnit(String unit) {
    setState(() {
      _lessonsAvailability.minIntervalUnit = _profileProvider.getPeriodUnitPlural(unit, _lessonsAvailability.minInterval);
    });
  }

  void _changeMaxStudents(int number) {
    _setSelectedMaxStudents(number);
    _updateLessonsAvailability();
  }

  void _setSelectedMaxStudents(int number) {
    setState(() {
      _lessonsAvailability.maxStudents = number;
    });
  }  

  void _unfocus() {
    _profileProvider.shouldUnfocus = true;
  }
  
  void _setLessonsAvailability() {
    setState(() {
      _lessonsAvailability = _profileProvider.user.lessonsAvailability;
    });
  }

  void _updateLessonsAvailability() {
    _lessonsAvailability.minIntervalUnit = _profileProvider.getPeriodUnitSingular(_lessonsAvailability.minIntervalUnit, _lessonsAvailability.minInterval);
    _profileProvider.updateLessonsAvailability(_lessonsAvailability);
  }

  @override
  Widget build(BuildContext context) {
    _profileProvider = Provider.of<ProfileViewModel>(context);
    _setLessonsAvailability();

    return _showLessons();
  }
}