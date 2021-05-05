import 'package:firulapp/components/dtos/event_item.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/agenda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../mixins/validator_mixins.dart';
import '../../provider/activity.dart';
import '../../components/default_button.dart';
import '../../components/input_text.dart';
import '../../components/dialogs.dart';
import '../../size_config.dart';

class ActivityFormScreen extends StatefulWidget {
  static const routeName = "/activity_form";

  @override
  _ActivityFormScreenState createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen>
    with ValidatorMixins {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final df = new DateFormat('dd-MM-yyyy');
  ActivityItem _activity = new ActivityItem();
  DateTime _activityDate;
  TimeOfDay _activityTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _activityDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    final TimeOfDay _selectedTime24Hour = await showTimePicker(
      context: context,
      initialTime: _activityTime,
    );
    if (pickedDate != null && pickedDate != _activityDate) {
      setState(() {
        _activityDate = pickedDate;
        _activity.activityDate = _activityDate.toIso8601String();
      });
    }
    if (_selectedTime24Hour != null && _activityTime != _selectedTime24Hour) {
      setState(() {
        _activityTime = _selectedTime24Hour;
        _activity.activityTime = _activityTime.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context).settings.arguments as EventItem;
    _activityDate = event.date;
    if (event.eventId != null) {
      _activity = Provider.of<Activity>(
        context,
        listen: false,
      ).getLocalActivityById(event.eventId);
      _activityDate = DateTime.parse(_activity.activityDate);
      _activityTime = TimeOfDay(
        hour: int.parse(_activity.activityTime.split(":")[0]),
        minute: int.parse(_activity.activityTime.split(":")[1]),
      );
    } else {
      _activity.activityDate = _activityDate.toIso8601String();
      _activity.activityTime = "${_activityTime.hour}:${_activityTime.minute}";
    }
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Actividad"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeConfig.wp(4.5),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${DateFormat('dd-MM-yyyy').format(_activityDate)} ${_activityTime.hour}:${_activityTime.minute}",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today_outlined),
                                  onPressed: () => _selectDate(context),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildTitleFormField(
                              "Título de la actividad",
                              "Ingrese el título de la actividad",
                              TextInputType.name,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildDetailFormField(
                              "Detalle de la actividad",
                              "Ingrese el detalle de la actividad",
                              TextInputType.multiline,
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            Row(
                              children: [
                                CupertinoSwitch(
                                  value: _activity.reminder,
                                  onChanged: (value) {
                                    setState(() {
                                      _activity.reminder = value;
                                    });
                                  },
                                ),
                                Text(
                                  "Recordatorio",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            DefaultButton(
                              text: "Guardar",
                              color: Constants.kPrimaryColor,
                              press: () async {
                                final isOK = _formKey.currentState.validate();
                                if (isOK) {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await Provider.of<Activity>(
                                      context,
                                      listen: false,
                                    ).saveActivity(_activity);
                                    Provider.of<Agenda>(context, listen: false)
                                        .fetchEvents();
                                    Navigator.pop(context);
                                  } catch (error) {
                                    Dialogs.info(
                                      context,
                                      title: 'ERROR',
                                      content: error.response.data["message"],
                                    );
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                            ),
                            event.eventId != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                          height: SizeConfig
                                              .getProportionateScreenHeight(
                                                  25)),
                                      DefaultButton(
                                        text: "Borrar",
                                        color: Colors.white,
                                        press: () async {
                                          final response = await Dialogs.alert(
                                            context,
                                            "¿Estás seguro que desea eliminar?",
                                            "Se borrará el registro de esta vacuna",
                                            "Cancelar",
                                            "Aceptar",
                                          );
                                          if (response) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            try {
                                              await Provider.of<Activity>(
                                                context,
                                                listen: false,
                                              ).delete(_activity);
                                              Provider.of<Agenda>(context,
                                                      listen: false)
                                                  .fetchEvents();
                                              Navigator.pop(context);
                                            } catch (error) {
                                              Dialogs.info(
                                                context,
                                                title: 'ERROR',
                                                content: error
                                                    .response.data["message"],
                                              );
                                            }
                                          }
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: SizeConfig
                                            .getProportionateScreenHeight(25),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height:
                                        SizeConfig.getProportionateScreenHeight(
                                            25),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildTitleFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _activity.activityTitle,
      onChanged: (newValue) => _activity.activityTitle = newValue,
    );
  }

  Widget buildDetailFormField(String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _activity.detail,
      maxLines: 10,
      onChanged: (newValue) => _activity.detail = newValue,
    );
  }
}
