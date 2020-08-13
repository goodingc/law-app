import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'the_city.dart';

class LawFirm extends TheCityEntity {
  final String name;
  final String logoUrl;
  final LawFirmCircle circle;

  LawFirm({
    @required id,
    @required this.name,
    @required this.logoUrl,
    this.circle
  }) : super(id: id);
}

final lawFirms = [
  LawFirm(
      id: 0,
      name: 'Allen & Overy',
      logoUrl:
          'https://pbs.twimg.com/profile_images/1199241480705052673/YhbT1l-Z_400x400.jpg',
    circle: LawFirmCircle.gold
  ),
  LawFirm(
      id: 0,
      name: 'Allen & Overy',
      logoUrl:
      'https://pbs.twimg.com/profile_images/1199241480705052673/YhbT1l-Z_400x400.jpg',
      circle: LawFirmCircle.silver
  ),
  LawFirm(
      id: 0,
      name: 'Allen & Overy',
      logoUrl:
      'https://pbs.twimg.com/profile_images/1199241480705052673/YhbT1l-Z_400x400.jpg',
      circle: LawFirmCircle.blue
  ),
  LawFirm(
      id: 0,
      name: 'Allen & Overy',
      logoUrl:
      'https://pbs.twimg.com/profile_images/1199241480705052673/YhbT1l-Z_400x400.jpg'
  ),
  LawFirm(
      id: 1,
      name: 'Clifford Chance',
      logoUrl:
          'https://pbs.twimg.com/profile_images/880383546472398851/Tn4yCdgg_400x400.jpg',
      circle: LawFirmCircle.gold),
  LawFirm(
      id: 2,
      name: 'Freshfields',
      logoUrl: 'https://ssl.freshfields.com/timeline/img/1993-250years.png',
      circle: LawFirmCircle.gold),
  LawFirm(
      id: 3,
      name: 'Linklaters',
      logoUrl:
          'https://pbs.twimg.com/profile_images/1278241509398261760/CCmuE3Nx_400x400.jpg',
      circle: LawFirmCircle.gold),
  LawFirm(
      id: 4,
      name: 'Slaughter and May',
      logoUrl:
          'https://pbs.twimg.com/profile_images/1176845997831593986/e064ZlOk_400x400.jpg',
      circle: LawFirmCircle.gold)
];

enum LawFirmCircle {
  gold,
  silver,
  blue
}

