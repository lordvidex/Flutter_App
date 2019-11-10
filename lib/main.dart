import 'package:flutter/material.dart';
import 'package:scratch_app/category_route.dart';

void main() => runApp(UnitConverterApp());

class UnitConverterApp extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      home: CategoryRoute());
  }
}
