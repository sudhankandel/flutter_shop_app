import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

TextEditingController noofproduct = TextEditingController();
TextEditingController result = TextEditingController();
TextEditingController amount = TextEditingController();
TextEditingController discper = TextEditingController();

discount(context) {
  // Disc dc = Disc();
  // noofproduct.text = dc.noproduct.toString();
  return Alert(
    context: context,
    title: "Discount Calculate",
    content: Column(
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            print('sth change');
            noofproduct.text = value;
            updatevalue(noofproduct.text, amount.text, discper.text);
          },
          decoration: InputDecoration(
            icon: Icon(Icons.confirmation_number),
            labelText: 'No Of Product',
          ),
        ),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            amount.text = value;
            updatevalue(noofproduct.text, amount.text, discper.text);
          },
          decoration: InputDecoration(
            icon: Icon(Icons.attach_money),
            labelText: 'Amount',
          ),
        ),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            discper.text = value;
            updatevalue(noofproduct.text, amount.text, discper.text);
          },
          decoration: InputDecoration(
            icon: Icon(FontAwesomeIcons.percentage),
            labelText: 'Discount Percentage',
          ),
        ),
        TextField(
          focusNode: new AlwaysDisabledFocusNode(),
          controller: result,
          onChanged: (value) {},
          decoration: InputDecoration(
            icon: Icon(FontAwesomeIcons.spider),
            labelText: 'Result',
          ),
        ),
      ],
    ),
    // buttons: [
    //   DialogButton(
    //     onPressed: () {
    //       reset();
    //     },
    //     child: Text(
    //       "RESET",
    //       style: TextStyle(color: Colors.white, fontSize: 20),
    //     ),
    //   )
    // ]
  ).show();
}

updatevalue(String nopro, String amt, String dicper) {
  if (nopro == '' || amt == '' || dicper == '') {
    result.text = '';
  } else {
    result.text = ((int.parse(nopro) * int.parse(amt)) -
            (int.parse(nopro) * (int.parse(amt) * int.parse(dicper)) / 100))
        .toString();
  }

  // return noofproduct;
}

reset() {
  result.text = '';
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
