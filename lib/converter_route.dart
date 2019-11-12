//Converter Route..
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scratch_app/unit.dart';
import 'package:meta/meta.dart';

/// Converter screen where users can input amounts to convert
/// 
/// Currently it just displays a list of mock units
///

class ConverterRoute extends StatefulWidget{
  final ColorSwatch color;
  final List<Unit> units;

  const ConverterRoute({
    @required this.units,
     @required this.color,
  }):assert(units!=null),
  assert(color!= null);
  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}
/// State class for the ConverterRoute
/// 
class _ConverterRouteState extends State<ConverterRoute>{
  @override
  Widget build(BuildContext context){
    //A placeholder for a list of mock units
    final unitsWidgets = widget.units.map((Unit unit){
      //Setting the color for the container
      return Container(color: widget.color,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      child: Column(
          children: <Widget>[
            Text(unit.name,style: Theme.of(context).textTheme.headline,),
            Text('Conversion: ${unit.conversion}',style: Theme.of(context).textTheme.subhead,),
          ],
      ),
      );
    }).toList();
     return ListView(
      children: unitsWidgets,
    );
  }
}