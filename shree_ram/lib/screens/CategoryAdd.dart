import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shree_ram/models/Category.dart';
import 'package:shree_ram/screens/HomePage.dart';
import 'package:shree_ram/screens/ProductAdd.dart';
import 'package:shree_ram/utils/database_helper.dart';

class CategoryAdd extends StatefulWidget {
  final Category category;
  CategoryAdd(this.category);
  @override
  _CategoryAddState createState() => _CategoryAddState(this.category);
}

class _CategoryAddState extends State<CategoryAdd> {
  DatabaseHelper helper = DatabaseHelper();
  Category category;
  _CategoryAddState(this.category);
  TextEditingController categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    categoryController.text = category.categoryname;
    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          Navigator.pop(context, true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Category Add'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  Navigator.pop(context, true);
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: categoryController,
                    onChanged: (value) {
                      // debugPrint('Something changed in Title Text Field');
                      updateName();
                    },
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.plus),
                      labelText: 'Category Name',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _save();
                              debugPrint("Save button clicked");
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _delete();
                              debugPrint("Delete button clicked");
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _save() async {
    moveToLastScreen();
    int result;
    print(category.categoryname);
    if (category.id != null) {
      // Case 1: Update operation
      result = await helper.updateCategory(category);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertCategory(category);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'category add successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Category');
    }
  }

  void _delete() async {
    movetoHome();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (category.id == null) {
      _showAlertDialog('Status', 'No category was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result =
        await helper.deletecategory(category.id, category.categoryname);
    if (result != 0) {
      _showAlertDialog('Status', 'Category Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void updateName() {
    category.categoryname = categoryController.text;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void movetoHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }
}
