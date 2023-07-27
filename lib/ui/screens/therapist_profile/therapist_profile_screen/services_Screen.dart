import 'package:flutter/material.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/group_therapy_and_workshops_card.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ServicesScreen extends StatefulWidget {
  final ServicesModel services;
  final double width;

  const ServicesScreen({Key? key, required this.services, required this.width})
      : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with Translator {
  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _getHeaderText(translate(LangKeys.privateSessions)),
          _getPrivateSessionsList(),
          _getHeaderText(translate(LangKeys.workshops)),
          _getWorkshops(),
          _getHeaderText(translate(LangKeys.groupTherapy)),
          _getGroupTherapy()
        ]));
  }

  //Get header
  Widget _getHeaderText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text,
          style: const TextStyle(
              color: ConstColors.app,
              fontWeight: FontWeight.w500,
              fontSize: 16)),
    );
  }

  //Get Private sessions cards
  Widget _getPrivateSessionsList() {
    return ListView.builder(
        itemCount: widget.services.privateSessions.length,
        padding: const EdgeInsets.only(bottom: 13),
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: SizedBox(
                height: 80,
                child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: ConstColors.disabled)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              CircleAvatar(
                                  // foregroundColor: ConstColors.disabled,
                                  backgroundColor: ConstColors.disabled,
                                  foregroundImage: AssetImage(widget.services
                                      .privateSessions[index].imageLink)),
                              const SizedBox(width: 20),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        widget.services.privateSessions[index]
                                            .type,
                                        style: const TextStyle(
                                            color: ConstColors.app,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                    Text(
                                        widget.services.privateSessions[index]
                                                .duration +
                                            translate(LangKeys.minutes),
                                        style: const TextStyle(
                                            color: ConstColors.textGrey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12))
                                  ])
                            ]),
                            Text(
                                widget.services.privateSessions[index].cost +
                                    widget.services.privateSessions[index]
                                        .currency,
                                style: const TextStyle(
                                    color: ConstColors.app,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14))
                          ],
                        ))))));
  }

  //Get workshops
  Widget _getWorkshops() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: widget.services.workshops.length,
      itemBuilder: (context, index) => GroupTherapyAndWorkshopsCard(
          title: widget.services.workshops[index].title,
          byWhom: widget.services.workshops[index].therapistName,
          imageUrl: widget.services.workshops[index].imageLink,
          startDate: widget.services.workshops[index].startDate,
          endDate: widget.services.workshops[index].endDate,
          startTime: widget.services.workshops[index].startTime,
          endTime: widget.services.workshops[index].endTime,
          numberOfSpotsAvailable:
              widget.services.workshops[index].slotsAvailable),
    );
  }

  //Get groupTherapy
  Widget _getGroupTherapy() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: widget.services.groupTherapy.length,
      itemBuilder: (context, index) => GroupTherapyAndWorkshopsCard(
          title: widget.services.groupTherapy[index].title,
          byWhom: widget.services.groupTherapy[index].therapistName,
          imageUrl: widget.services.groupTherapy[index].imageLink,
          startDate: widget.services.groupTherapy[index].startDate,
          endDate: widget.services.groupTherapy[index].endDate,
          startTime: widget.services.groupTherapy[index].startTime,
          endTime: widget.services.groupTherapy[index].endTime,
          numberOfSpotsAvailable:
              widget.services.groupTherapy[index].slotsAvailable),
    );
  }
}
