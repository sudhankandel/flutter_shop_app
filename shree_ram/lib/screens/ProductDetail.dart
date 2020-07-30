import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram/models/Product.dart';
import 'package:shree_ram/utils/database_helper.dart';

class ProductDetail extends StatefulWidget {
  final appBarTitle;
  final Product product;
  bool abc;
  ProductDetail(this.product, this.appBarTitle, this.abc);
  @override
  _ProductDetailState createState() =>
      _ProductDetailState(this.product, this.appBarTitle, this.abc);
}

class _ProductDetailState extends State<ProductDetail> {
  static var _priorities = ['High', 'Low'];
  DatabaseHelper databaseHelper = DatabaseHelper();
  String appBarTitle;
  Product product;
  bool abc;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController buypriceController = TextEditingController();
  TextEditingController shellpriceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  _ProductDetailState(this.product, this.appBarTitle, this.abc);

  var selectvalue;
  var _category = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    _loadcategory();
    print(abc);
  }

  _loadcategory() async {
    databaseHelper = DatabaseHelper();
    var categorys = await databaseHelper.getCategoryMaplist();
    categorys.forEach((category) {
      setState(() {
        // print(category['categoryname']);
        _category.add(DropdownMenuItem(
          child: Text(category['categoryname']),
          value: category['categoryname'],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    nameController.text = product.name;
    descriptionController.text = product.description;
    buypriceController.text = product.buyprice;
    shellpriceController.text = product.shellprice;
    categoryController.text = product.category;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // First element
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriorityAsString(product.priority),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      }),
                ),
                ListTile(
                    title: DropdownButtonFormField(
                  items: _category,
                  value: updateCategory(),
                  onChanged: (values) {
                    setState(() {
                      product.category = values;
                    });
                  },
                  hint: Text('Category'),
                )),

                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      updateName();
                      debugPrint('Something changed in Title Text Field');
                    },
                    decoration: InputDecoration(
                        labelText: 'name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      updateDescription();
                      debugPrint('Something changed in Description Text Field');
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: buypriceController,
                    style: textStyle,
                    onChanged: (value) {
                      updateBuyprice();
                    },
                    decoration: InputDecoration(
                        labelText: 'Buyp rice',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: shellpriceController,
                    style: textStyle,
                    onChanged: (value) {
                      updateShellprice();
                    },
                    decoration: InputDecoration(
                        labelText: 'Shell price',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          splashColor: Colors.red[200],
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
                          splashColor: Colors.red[200],
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

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  updateCategory() {
    if (abc == true) {
      if (product.category == '') {
        return selectvalue;
      } else {
        return product.category;
      }
    } else {
      return selectvalue;
    }
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        product.priority = 1;
        break;
      case 'Low':
        product.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  void updateName() {
    product.name = nameController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    product.description = descriptionController.text;
  }

  void updateBuyprice() {
    product.buyprice = buypriceController.text;
  }

  void updateShellprice() {
    product.shellprice = shellpriceController.text;
  }

  void _save() async {
    moveToLastScreen();
    print("Category is " + product.category);
    product.date = DateFormat.yMMMd().format(DateTime.now());
    print("Category is " + product.category);
    int result;
    if (product.id != null) {
      // Case 1: Update operation
      result = await databaseHelper.updateProduct(product);
    } else {
      // Case 2: Insert Operation
      result = await databaseHelper.insertProduct(product);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Product Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (product.id == null) {
      _showAlertDialog('Status', 'No Product was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteProduct(product.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Product Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }
}
