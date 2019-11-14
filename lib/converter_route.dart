//Converter Route..
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scratch_app/unit.dart';
import 'package:meta/meta.dart';

var _padding = EdgeInsets.all(16.0);

/// Converter screen where users can input amounts to convert
///
/// Currently it just displays a list of mock units
///

class ConverterRoute extends StatefulWidget {
  //Color for this Category
  final Color color;

  //Units for this Category
  final List<Unit> units;

  const ConverterRoute({
    @required this.units,
    @required this.color,
  })  : assert(units != null),
        assert(color != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

/// State class for the ConverterRoute
///
class _ConverterRouteState extends State<ConverterRoute> {
  Unit _fromUnit;
  Unit _toUnit;
  double inputValue;
  String _convertedValue = '';
  bool _showValidationError = false;
  List<DropdownMenuItem> _unitMenuItems;

  @override
  void initState() {
    super.initState();
    _setDefaults();
    _createDropDownMenuItems();
  }

  //[Helper Method] to help with setting of the default values n
  void _setDefaults() {
    setState(() {
      _fromUnit = widget.units[0];
      _toUnit = widget.units[1];
    });
  }

  void _createDropDownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(new DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      _unitMenuItems = newItems;
    });
  }

  String _format(double conversion) {
    var outputNumber = conversion.toStringAsPrecision(7);
    //Clear the floating points after the decimal points if there are 0s
    if (outputNumber.contains('.') && outputNumber.endsWith('0')) {
      var i = outputNumber.length - 1;
      while (outputNumber[i] == '0') {
        i--;
      }
      outputNumber = outputNumber.substring(0, i + 1);
    }
    if (outputNumber.endsWith('.')) {
      return outputNumber.substring(0, outputNumber.length - 1);
    }
    return outputNumber;
  }

  void _updateConversion() {
    setState(() {
      _convertedValue =
          _format(inputValue * (_toUnit.conversion / _fromUnit.conversion));
    });
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input == '' || input == null) {
        _convertedValue = '';
      } else {
        //we have to check if the input values
        //are valid for conversion into doubles and to be used for calculations
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error $e');
          _showValidationError = true;
        }
      }
    });
  }

  Unit _getUnit(unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromUnit = _getUnit(unitName);
      if (inputValue != null) {
        _updateConversion();
      }
    });
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toUnit = _getUnit(unitName);
      if (inputValue != null) {
        _updateConversion();
      }
    });
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      //I am coming for this in order to know exactly what happens when I set the decoration of the box
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[400], width: 1.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.grey[50]),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              icon: Icon(Icons.arrow_drop_down),
              value: currentValue,
              items: _unitMenuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Input area and output area for the page we are to design
    var inputArea = Padding(
        padding: _padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              style: Theme.of(context).textTheme.display1,
              decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.display1,
                  errorText:
                      _showValidationError ? 'Invalid number entered' : null,
                  labelText: 'Input',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  )),
              onChanged: _updateInputValue,
              keyboardType: TextInputType.number,
            ),
            //A dropdown to display the units of the page we are in
            _createDropdown(_fromUnit.name, _updateFromConversion),
          ],
        ));

    var arrows = RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.compare_arrows,
          size: 40.0,
          color: Colors.black,
        ));

    var outputArea = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.display1,
                labelText: 'Output',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
            child: Text(_convertedValue,
                style: Theme.of(context).textTheme.display1),
          ),
          _createDropdown(_toUnit.name, _updateToConversion),
        ],
      ),
    );
    return Padding(
        padding: _padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            inputArea,
            arrows,
            outputArea,
          ],
        ));
  }
}
