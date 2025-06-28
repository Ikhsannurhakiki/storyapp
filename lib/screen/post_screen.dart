import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/main_provider.dart';

class PostScreen extends StatelessWidget{
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath = context.read<MainProvider>().imagePath;
    return Scaffold(

    );
  }

}