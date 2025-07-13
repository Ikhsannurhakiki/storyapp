import 'package:flutter/material.dart';

import 'flavor_config.dart';
import 'main.dart';


void main() {
  FlavorConfig(
    flavor: FlavorType.prod,
    color: Colors.blueGrey,
    values: const FlavorValues(
      titleApp: "Production App",
    ),
  );

  mainApp();
}