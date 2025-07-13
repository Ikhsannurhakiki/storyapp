import 'package:flutter/material.dart';

import 'flavor_config.dart';
import 'main.dart';

void main() {
  FlavorConfig(
    flavor: FlavorType.dev,
    color: Colors.orange,
    values: const FlavorValues(titleApp: "Development App"),
  );

  mainApp();
}
