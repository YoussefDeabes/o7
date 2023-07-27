import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';

const String emailLogin = "zainabhossam94@gmail.com";
const String passwordLogin = "Zainab94@";

// TODO :: will be removed

class TherapistModel {
  final String name;
  final String jobTitle;
  final String avatarLink;
  final double rank;
  final List<String> languages;
  final String availability;
  final int yearsOfExperience;
  final List<String> skills;

  TherapistModel({
    required this.name,
    required this.jobTitle,
    required this.avatarLink,
    required this.rank,
    required this.languages,
    required this.availability,
    required this.yearsOfExperience,
    required this.skills,
  });
}

class GroupTherapyModel {
  final String title;
  final String imageLink;
  final String byWhom;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int availableSpots;
  final int price;
  final String currency;
  final String? sessionDate;
  GroupTherapyModel({
    this.sessionDate,
    required this.price,
    required this.currency,
    required this.title,
    required this.imageLink,
    required this.byWhom,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.availableSpots,
  });
}

class WorkShopModel {
  final String title;
  final String imageLink;
  final String byWhom;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int availableSpots;

  WorkShopModel({
    required this.title,
    required this.imageLink,
    required this.byWhom,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.availableSpots,
  });
}

List<WorkShopModel> workShops = [
  WorkShopModel(
    title: "Introduction to art therapy",
    imageLink:
        "http://mindfulartstudio.com/wp-content/uploads/2013/01/What-is-Art-Therapy.jpg",
    byWhom: "Ashraf Adel",
    startDate: DateTime(2022, 5, 22),
    endDate: DateTime(2022, 5, 25),

    startTime: TimeOfDay(hour: 18, minute: 0),
    // DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 21, minute: 0),
    availableSpots: 5,
  ),
  WorkShopModel(
    title:
        "Introduction to Couples therapy From Island City with ice cream changed Month",

    imageLink:
        "https://images-na.ssl-images-amazon.com/images/I/91FcQqiLSdL.jpg",
    byWhom: "Adel Nabil",
    startDate: DateTime(2022, 6, 22),
    endDate: DateTime(2022, 5, 25),

    startTime: TimeOfDay(hour: 18, minute: 0),
    // DateTime(2022, 5, 22),
// DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 21, minute: 0),
    availableSpots: 5,
  ),
  WorkShopModel(
    title: "Ice Cream",
    imageLink:
        "https://images-na.ssl-images-amazon.com/images/I/51edTckV78L._SX353_BO1,204,203,200_.jpg",
    byWhom: "Ashraf Adel",
    startDate: DateTime(2022, 12, 31),
    endDate: DateTime(2023, 1, 2),

    startTime: TimeOfDay(hour: 18, minute: 15),
    // DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 21, minute: 30),
    availableSpots: 0,
  ),
  WorkShopModel(
    title: "Ice Cream",
    imageLink:
        "https://www.rmit.edu.au/content/dam/rmit/au/en/study-with-us/interest-areas/mastheads/art-study-area-julian-clavijo-1920x600.jpg",
    byWhom: "Ashraf Adel",
    startDate: DateTime(2022, 12, 31),
    endDate: DateTime(2023, 1, 2),
    startTime: TimeOfDay(hour: 18, minute: 15),
    endTime: TimeOfDay(hour: 21, minute: 30),
    availableSpots: 0,
  ),
  WorkShopModel(
    title:
        "Introduction to Couples therapy From Island City with ice cream changed Month",

    imageLink:
        "https://images-na.ssl-images-amazon.com/images/I/91FcQqiLSdL.jpg",
    byWhom: "Adel Nabil",
    startDate: DateTime(2022, 6, 22),
    endDate: DateTime(2022, 5, 25),
    startTime: TimeOfDay(hour: 10, minute: 0),
    // DateTime(2022, 5, 22),
    endTime: TimeOfDay(hour: 13, minute: 0),
    availableSpots: 5,
  ),
  WorkShopModel(
    title: "City with ice cream changed Month",

    imageLink:
        "https://images-na.ssl-images-amazon.com/images/I/91FcQqiLSdL.jpg",
    byWhom: "Adel Nabil",
    startDate: DateTime(2022, 6, 22),
    endDate: DateTime(2022, 6, 22),

    startTime: TimeOfDay(hour: 6, minute: 0),
    // DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 9, minute: 0),
    availableSpots: 5,
  ),
];

List<GroupTherapyModel> groupsTherapy = [
  GroupTherapyModel(
    currency: "USD",
    price: 5000,
    title: "Ice Cream",
    imageLink:
        "https://www.rmit.edu.au/content/dam/rmit/au/en/study-with-us/interest-areas/mastheads/art-study-area-julian-clavijo-1920x600.jpg",
    byWhom: "Ashraf Adel",
    startDate: DateTime(2022, 12, 31),
    endDate: DateTime(2023, 1, 2),

    startTime: TimeOfDay(hour: 18, minute: 15),
    // DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 21, minute: 30),
    availableSpots: 0,
  ),
  GroupTherapyModel(
    currency: "EGP",
    price: 20000,
    title:
        "Introduction to Couples therapy From Island City with ice cream changed Month",

    imageLink:
        "https://images-na.ssl-images-amazon.com/images/I/91FcQqiLSdL.jpg",
    byWhom: "Adel Nabil",
    startDate: DateTime(2022, 6, 22),
    endDate: DateTime(2022, 5, 25),

    startTime: TimeOfDay(hour: 18, minute: 0),
    // DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 21, minute: 0),
    availableSpots: 5,
  ),
  GroupTherapyModel(
    currency: "KWD",
    price: 200,
    title: "Ice Cream",
    imageLink:
        "https://images-na.ssl-images-amazon.com/images/I/51edTckV78L._SX353_BO1,204,203,200_.jpg",
    byWhom: "Ashraf Adel",
    startDate: DateTime(2022, 12, 31),
    endDate: DateTime(2023, 1, 2),

    startTime: TimeOfDay(hour: 18, minute: 15),
    // DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 21, minute: 30),
    availableSpots: 0,
  ),
  GroupTherapyModel(
    currency: "EGP",
    price: 20000,
    title: "Introduction to art therapy",
    imageLink:
        "http://mindfulartstudio.com/wp-content/uploads/2013/01/What-is-Art-Therapy.jpg",
    byWhom: "Ashraf Adel",
    startDate: DateTime(2022, 5, 22),
    endDate: DateTime(2022, 5, 25),

    startTime: TimeOfDay(hour: 18, minute: 0),
    // DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 21, minute: 0),
    availableSpots: 5,
  ),
];

List<TherapistModel> therapists = [
  TherapistModel(
    name: "Ashraf Adel",
    jobTitle: "Psychiatrist",
    avatarLink:
        'https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg',
    rank: 4.8,
    languages: ["ar", "en"],
    availability: "Not Available",
    yearsOfExperience: 10,
    skills: ["Anxiety", "stress", "Couples"],
  ),
  TherapistModel(
    name: "Ludwig van Beethoven (1812)",
    jobTitle: "Psychiatrist",
    avatarLink: 'https://static.dw.com/image/45270796_101.jpg',
    rank: 4.8,
    languages: ["ar", "en"],
    availability: "Not Available",
    yearsOfExperience: 10,
    skills: ["Anxiety", "stress", "Couples"],
  ),
  TherapistModel(
    name: "Ivan The Terrible",
    jobTitle: "Psychiatrist",
    avatarLink:
        'https://cdn.britannica.com/00/93300-050-06CA2CE7/Ivan-the-Terrible-portrait-Viktor-Mikhaylovich-Vasnetsov.jpg',
    rank: 4.8,
    languages: ["Ru"],
    availability: "Not Available",
    yearsOfExperience: 10,
    skills: [
      "Anxiety",
      "stress",
      "Couples",
      "Anxiety",
      "Stress",
      "Couples therapy"
    ],
  ),
  TherapistModel(
    name: "Caesar was killed with swords in a grand Senate room",
    jobTitle: "Psychiatrist",
    avatarLink:
        'https://cdn.vox-cdn.com/thumbor/aP0NVihSnNFOdwNRC98gE1Hmlgk=/230x145:1575x1154/1220x813/filters:focal(230x145:1575x1154):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/45894920/deathofcaesar.0.0.jpg',
    rank: 4.8,
    languages: ["ar", "en", "ar", "en", "ar", "en"],
    availability: "Not Available always but sometimes not is not but yes",
    yearsOfExperience: 10,
    skills: ["Anxiety", "stress", "Couples"],
  ),
];

class TherapistProfileModel {
  final String title;
  final String profilePicture;
  final String professionTitle;
  final String cost;
  final String currency;
  final String duration;
  final String experienceYears;
  final String rating;
  final String reviewsNumber;

  TherapistProfileModel(
      {required this.title,
      required this.profilePicture,
      required this.professionTitle,
      required this.cost,
      required this.currency,
      required this.duration,
      required this.experienceYears,
      required this.rating,
      required this.reviewsNumber});
}

TherapistProfileModel therapistProfile = TherapistProfileModel(
  title: 'Prof. Dr. Ashraf Adel',
  profilePicture: AssPath.therapistIcon,
  professionTitle: 'Assistant Professor of Psychiatry, Clinical Assessment',
  cost: '1000',
  currency: 'EGP',
  duration: '50',
  experienceYears: '26',
  rating: '4.9',
  reviewsNumber: '250',
);

class ScheduleModel {
  final List<DateTime> eventsList;
  final List<AvailableTimeByType> availableDatesByType;

  ScheduleModel({required this.eventsList, required this.availableDatesByType});
}

ScheduleModel schedule = ScheduleModel(eventsList: [
  DateTime.utc(2022, 06, 10, 12),
  DateTime.utc(2022, 06, 11, 12)
], availableDatesByType: [
  AvailableTimeByType(
    type: '1 on 1',
    startTime: ['11:00 AM-', '11:00 AM-', '11:00 AM-'],
    endTime: ['11:50 AM', '11:50 AM', '11:50 AM'],
  ),
  AvailableTimeByType(
    type: 'Couple Therapy',
    startTime: ['11:00 AM-', '11:00 AM-', '11:00 AM-'],
    endTime: ['11:50 AM', '11:50 AM', '11:50 AM'],
  ),
  AvailableTimeByType(
    type: 'Drug Review',
    startTime: ['11:00 AM-', '11:00 AM-', '11:00 AM-'],
    endTime: ['11:50 AM', '11:50 AM', '11:50 AM'],
  ),
  AvailableTimeByType(
    type: 'Clinical Assessment',
    startTime: ['11:00 AM-', '11:00 AM-', '11:00 AM-'],
    endTime: ['11:50 AM', '11:50 AM', '11:50 AM'],
  )
]);

class AvailableTimeByType {
  final String type;
  final List<String> startTime;
  final List<String> endTime;

  AvailableTimeByType(
      {required this.type, required this.startTime, required this.endTime});
}

class BioModel {
  final String videoLink;
  final List<String> speakingLangs;
  final List<String> workWith;
  final List<String> experienceWorking;
  final List<String> therapyApproaches;
  final String moreAboutMe;

  BioModel(
      {required this.videoLink,
      required this.speakingLangs,
      required this.workWith,
      required this.experienceWorking,
      required this.therapyApproaches,
      required this.moreAboutMe});
}

BioModel bio = BioModel(
  videoLink: 'https://www.youtube.com/watch?v=nKrpV2RI7-Y',
  speakingLangs: ['English', 'Arabic', 'Español'],
  workWith: ['Children', 'Adolescents', 'Young Adults', 'Adults'],
  experienceWorking: [
    'Depression',
    'Anger Management',
    'ADHD',
    'Sleep disorder',
    'Anxiety',
    'Self-harm',
    'OCD',
    'Parenting Issues',
    'ASD(Autism)'
  ],
  therapyApproaches: [
    'CBT',
    'DBT',
    'Client-centered therapy',
    'Exposure',
    'Emotion focused',
  ],
  moreAboutMe:
      "As an Associate Professor in the Psychiatric Department, at Cairo University, I have earned a Master's Degree working with cancer patients at the Cancer Institute, and have completed a PhD in substance abuse. \n\nAs an Associate Professor in the Psychiatric Department, at Cairo University, I have earned a Master's Degree working with cancer patients at the Cancer Institute, and have completed a PhD in substance abuse.",
);

class ServicesModel {
  final List<PrivateSessions> privateSessions;
  final List<Workshops> workshops;
  final List<GroupTherapy> groupTherapy;

  ServicesModel(
      {required this.privateSessions,
      required this.workshops,
      required this.groupTherapy});
}

ServicesModel servicesModel = ServicesModel(
  privateSessions: [
    PrivateSessions(
      type: '1 on 1 Sessions',
      duration: '50',
      cost: '1000',
      currency: 'EGP',
      imageLink: AssPath.defaultImg,
    ),
    PrivateSessions(
      type: 'Couples Therapy',
      duration: '30',
      cost: '800',
      currency: 'EGP',
      imageLink: AssPath.defaultImg,
    ),
    PrivateSessions(
      type: 'Drug Review',
      duration: '15',
      cost: '200',
      currency: 'EGP',
      imageLink: AssPath.defaultImg,
    ),
  ],
  workshops: [
    Workshops(
        title: 'Introduction to art therapy',
        imageLink:
            'http://mindfulartstudio.com/wp-content/uploads/2013/01/What-is-Art-Therapy.jpg',
        therapistName: 'Ashraf Adel',
        startDate: DateTime.utc(2022, 06, 11, 12),
        endDate: DateTime.utc(2022, 06, 11, 12),
        startTime: const TimeOfDay(hour: 18, minute: 0),
        endTime: const TimeOfDay(hour: 21, minute: 0),
        slotsAvailable: 5),
    Workshops(
        title: 'Introduction to art therapy',
        imageLink:
            'http://mindfulartstudio.com/wp-content/uploads/2013/01/What-is-Art-Therapy.jpg',
        therapistName: 'Ashraf Adel',
        startDate: DateTime.utc(2022, 06, 11, 12),
        endDate: DateTime.utc(2022, 06, 11, 12),
        startTime: const TimeOfDay(hour: 18, minute: 0),
        endTime: const TimeOfDay(hour: 21, minute: 0),
        slotsAvailable: 5),
  ],
  groupTherapy: [
    GroupTherapy(
        title: 'Introduction to art therapy',
        imageLink:
            'http://mindfulartstudio.com/wp-content/uploads/2013/01/What-is-Art-Therapy.jpg',
        therapistName: 'Ashraf Adel',
        startDate: DateTime.utc(2022, 06, 11, 12),
        endDate: DateTime.utc(2022, 06, 11, 12),
        startTime: const TimeOfDay(hour: 18, minute: 0),
        endTime: const TimeOfDay(hour: 21, minute: 0),
        slotsAvailable: 5),
    GroupTherapy(
        title: 'Introduction to art therapy',
        imageLink:
            'http://mindfulartstudio.com/wp-content/uploads/2013/01/What-is-Art-Therapy.jpg',
        therapistName: 'Ashraf Adel',
        startDate: DateTime.utc(2022, 06, 11, 12),
        endDate: DateTime.utc(2022, 06, 11, 12),
        startTime: const TimeOfDay(hour: 18, minute: 0),
        endTime: const TimeOfDay(hour: 21, minute: 0),
        slotsAvailable: 5),
  ],
);

class PrivateSessions {
  final String type;
  final String duration;
  final String cost;
  final String currency;
  final String imageLink;

  PrivateSessions({
    required this.type,
    required this.duration,
    required this.cost,
    required this.currency,
    required this.imageLink,
  });
}

class Workshops {
  final String title;
  final String imageLink;
  final String therapistName;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int slotsAvailable;

  Workshops({
    required this.title,
    required this.imageLink,
    required this.therapistName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.slotsAvailable,
  });
}

class GroupTherapy {
  final String title;
  final String imageLink;
  final String therapistName;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int slotsAvailable;

  GroupTherapy({
    required this.title,
    required this.imageLink,
    required this.therapistName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.slotsAvailable,
  });
}

class ReviewModel {
  final DateTime sessionDate;
  final String rate;
  final String review;

  ReviewModel({
    required this.sessionDate,
    required this.rate,
    required this.review,
  });
}

List<ReviewModel> reviews = [
  ReviewModel(
      sessionDate: DateTime.utc(2022, 06, 11, 12),
      rate: '4.8',
      review:
          """Very friendly, understanding, good listener, intellectual therapist. it was so nice to start my therapy journey with an expert """),
  ReviewModel(
      sessionDate: DateTime.utc(2022, 06, 11, 12),
      rate: '4.8',
      review:
          """Very friendly, understanding, good listener, intellectual therapist. it was so nice to start my therapy journey with an expert """),
  ReviewModel(
      sessionDate: DateTime.utc(2022, 06, 11, 12),
      rate: '4.8',
      review:
          """Very friendly, understanding, good listener, intellectual therapist. it was so nice to start my therapy journey with an expert """),
  ReviewModel(
      sessionDate: DateTime.utc(2022, 06, 11, 12),
      rate: '4.8',
      review:
          """Very friendly, understanding, good listener, intellectual therapist. it was so nice to start my therapy journey with an expert """)
];

class VideosModel {
  final String videoLink;
  final String title;
  final DateTime publishedDate;

  VideosModel({
    required this.title,
    required this.videoLink,
    required this.publishedDate,
  });
}

List<VideosModel> videos = [
  VideosModel(
    title: 'Couples’ Therapy Explained',
    videoLink: 'https://www.youtube.com/watch?v=nKrpV2RI7-Y',
    publishedDate: DateTime.utc(2022, 06, 11, 12),
  ),
  VideosModel(
    title: 'Couples’ Therapy Explained',
    videoLink: 'https://www.youtube.com/watch?v=nKrpV2RI7-Y',
    publishedDate: DateTime.utc(2022, 06, 11, 12),
  ),
  VideosModel(
    title: 'Couples’ Therapy Explained',
    videoLink: 'https://www.youtube.com/watch?v=nKrpV2RI7-Y',
    publishedDate: DateTime.utc(2022, 06, 11, 12),
  ),
  VideosModel(
    title: 'Couples’ Therapy Explained',
    videoLink: 'https://www.youtube.com/watch?v=nKrpV2RI7-Y',
    publishedDate: DateTime.utc(2022, 06, 11, 12),
  ),
];

class BlogsModel {
  final String title;
  final DateTime publishedDate;
  final String duration;

  BlogsModel({
    required this.title,
    required this.publishedDate,
    required this.duration,
  });
}

List<BlogsModel> blogs = [
  BlogsModel(
      title: 'How Deep Is Your Sleep? ',
      publishedDate: DateTime.utc(2022, 06, 11, 12),
      duration: '7'),
  BlogsModel(
      title: 'How Deep Is Your Sleep? ',
      publishedDate: DateTime.utc(2022, 06, 11, 12),
      duration: '7'),
  BlogsModel(
      title: 'How Deep Is Your Sleep? ',
      publishedDate: DateTime.utc(2022, 06, 11, 12),
      duration: '7'),
  BlogsModel(
      title: 'How Deep Is Your Sleep? ',
      publishedDate: DateTime.utc(2022, 06, 11, 12),
      duration: '7'),
];

class UpcomingSessionsModel {
  final String therapistName;
  final String profilePicture;
  final String professionTitle;
  final String duration;
  final String sessionType;
  final TimeOfDay sessionTime;
  final DateTime date;

  UpcomingSessionsModel(
      {required this.therapistName,
      required this.profilePicture,
      required this.professionTitle,
      required this.duration,
      required this.sessionType,
      required this.sessionTime,
      required this.date});
}

List<UpcomingSessionsModel> upcomingList = [
  UpcomingSessionsModel(
      therapistName: 'Ashraf Adel',
      profilePicture:
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
      professionTitle: 'Psychiatrist',
      duration: '50-Minute',
      sessionType: 'One-On-One Session',
      sessionTime: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime.now()),
  UpcomingSessionsModel(
      therapistName: 'Art Therapy Intro.',
      profilePicture:
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
      professionTitle: 'By Carol Hmmal',
      duration: '50-Minute',
      sessionType: 'Workshop',
      sessionTime: const TimeOfDay(hour: 11, minute: 00),
      date: DateTime.now().add(const Duration(seconds: 10))),
  UpcomingSessionsModel(
      therapistName: 'Ashraf Adel',
      profilePicture:
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
      professionTitle: 'Psychiatrist',
      duration: '50-Minute',
      sessionType: 'One-On-One Session',
      sessionTime: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime.now().add(const Duration(seconds: 10))),
];

class PastSessionsModel {
  final String therapistName;
  final String profilePicture;
  final String professionTitle;
  final String duration;
  final String sessionType;
  final TimeOfDay sessionTime;
  final DateTime date;

  PastSessionsModel(
      {required this.therapistName,
      required this.profilePicture,
      required this.professionTitle,
      required this.duration,
      required this.sessionType,
      required this.sessionTime,
      required this.date});
}

List<PastSessionsModel> pastList = [
  PastSessionsModel(
      therapistName: 'Ashraf Adel',
      profilePicture:
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
      professionTitle: 'Psychiatrist',
      duration: '50-Minute',
      sessionType: 'One-On-One Session',
      sessionTime: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime.now()),
  PastSessionsModel(
      therapistName: 'Art Therapy Intro.',
      profilePicture:
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
      professionTitle: 'By Carol Hmmal',
      duration: '50-Minute',
      sessionType: 'Workshop',
      sessionTime: const TimeOfDay(hour: 11, minute: 00),
      date: DateTime.now().add(const Duration(seconds: 10))),
  PastSessionsModel(
      therapistName: 'Ashraf Adel',
      profilePicture:
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
      professionTitle: 'Psychiatrist',
      duration: '50-Minute',
      sessionType: 'One-On-One Session',
      sessionTime: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime.now().add(const Duration(seconds: 10))),
];

/// dummy data for the payment history
class PaymentHistoryModel {
  final String currency;
  final String sessionType;
  final double sessionPrice;
  final String therapistName;
  final DateTime date;
  final int lastTreeNumbersOfCard;
  PaymentHistoryModel({
    required this.currency,
    required this.sessionType,
    required this.sessionPrice,
    required this.therapistName,
    required this.date,
    required this.lastTreeNumbersOfCard,
  });

  PaymentHistoryModel copyWith({
    String? sessionType,
    String? currency,
    double? sessionPrice,
    String? therapistName,
    DateTime? date,
    int? lastTreeNumbersOfCard,
  }) {
    return PaymentHistoryModel(
      sessionType: sessionType ?? this.sessionType,
      currency: currency ?? this.currency,
      sessionPrice: sessionPrice ?? this.sessionPrice,
      therapistName: therapistName ?? this.therapistName,
      date: date ?? this.date,
      lastTreeNumbersOfCard:
          lastTreeNumbersOfCard ?? this.lastTreeNumbersOfCard,
    );
  }
}

class RemoteApi {
  static List<PaymentHistoryModel> allPayment = List.generate(
    20,
    (index) => PaymentHistoryModel(
        currency: "usd",
        sessionType: "one one one",
        sessionPrice: 652,
        therapistName: "Adel Nabil",
        date: DateTime.now().subtract(const Duration(days: 35)),
        lastTreeNumbersOfCard: 692),
  )
    ..addAll(List.generate(
      20,
      (index) => PaymentHistoryModel(
          currency: "Egp",
          sessionType: "Group Therapy",
          sessionPrice: 10000,
          therapistName: "Adel N. Daniel",
          date: DateTime.now().subtract(const Duration(days: 77)),
          lastTreeNumbersOfCard: 111),
    ))
    ..addAll(List.generate(
      15,
      (index) => PaymentHistoryModel(
          currency: "Usd",
          sessionType: "Workshops",
          sessionPrice: 10000,
          therapistName: "Adel Daniel",
          date: DateTime.now().subtract(const Duration(days: 600)),
          lastTreeNumbersOfCard: 111),
    ));

  // static const _pageSize = 5;
  static int pageIndex = 0;
  static Future<List<PaymentHistoryModel>> getCharacterList() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final returnedList =
        allPayment.getRange(pageIndex * 10, pageIndex * 10 + 10).toList();
    pageIndex++;
    return returnedList;
  }
}

///
///
/// Notifications Dummy Data
///

// class NotificationsApi {
//   static List<NotificationModel> allNotifications = List.generate(
//     100,
//     (index) => NotificationModel(
//       title: "title",
//       content:
//           "You have reached your maximum sessions limit for this month. Starting your next session you will be charged for session fees",
//       date: DateTime.now(),
//     ),
//   );

//   // static const _pageSize = 5;
//   static int pageIndex = 0;
//   static Future<List<NotificationModel>> getList() async {
//     await Future.delayed(const Duration(milliseconds: 1000));
//     final returnedList =
//         allNotifications.getRange(pageIndex * 10, pageIndex * 10 + 10).toList();
//     pageIndex++;
//     return returnedList;
//   }
// }

// class NotificationModel {
//   final String title;
//   final String content;
//   final DateTime date;
//   NotificationModel({
//     required this.title,
//     required this.content,
//     required this.date,
//   });

//   Map<String, dynamic> toJson() {
//     return <String, dynamic>{
//       'title': title,
//       'content': content,
//       'date': date.millisecondsSinceEpoch,
//     };
//   }

//   factory NotificationModel.fromJson(Map<String, dynamic> map) {
//     return NotificationModel(
//       title: map['title'] ?? '',
//       content: map['content'] ?? '',
//       date: DateTime.fromMillisecondsSinceEpoch(map['date']),
//     );
//   }
// }
