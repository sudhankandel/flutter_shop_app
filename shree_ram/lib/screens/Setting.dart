import 'package:flutter/material.dart';
import 'package:shree_ram/models/Category.dart';
import 'package:shree_ram/models/Product.dart';
import 'package:shree_ram/screens/CategoryAdd.dart';
import 'package:shree_ram/screens/Discount.dart';
import 'package:shree_ram/screens/ProductDetail.dart';
import 'package:shree_ram/utils/database_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  DatabaseHelper databaseHelper;
  TextEditingController teSeach = TextEditingController();
  var allProduct = [];
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    databaseHelper.getCount().then((product) {
      setState(() {
        updateListView();
        allProduct = product[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 20),
                      height: categoryHeight,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "HIGHLY SHELL",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 60.0, top: 30.0),
                                child: Text(
                                  countdisplay(2),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 20),
                      height: categoryHeight,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "LESS  SHELL",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60.0, top: 30.0),
                                  child: Text(
                                    countdisplay(1),
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 20),
                      height: categoryHeight,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "TOTAL PRODUCT",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 60.0, top: 30.0),
                                child: Text(
                                  countdisplay(0),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 20),
                      height: categoryHeight,
                      decoration: BoxDecoration(
                          color: Colors.brown[200],
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "TOTAL CATEGORY",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 60.0, top: 30.0),
                                child: Text(
                                  countdisplay(3),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 0,
              ),
              child: Column(children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.productHunt),
                  title: Text("ADD PRODUCT"),
                  onTap: () {
                    navigateToAddproduct(
                        Product('', '', 2, '', '', ''), 'Add Product', false);
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.add_shopping_cart),
                  title: Text("ADD CATEGORY"),
                  onTap: () {
                    navigateToAddCategory(Category(''));
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.control_point_duplicate),
                  title: Text("CALCULATE DISCOUNT"),
                  onTap: () {
                    discount(context);
                  },
                ),
              ]))
        ],
      ),
    );
  }

  String countdisplay(int value) {
    if (allProduct.length == 0) {
      return '0';
    } else {
      return allProduct[value].toString();
    }
  }

  void navigateToAddCategory(Category category) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CategoryAdd(category);
    }));

    if (result == true) {
      updateListView();
    }
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  void navigateToAddproduct(Product product, String title, bool abc) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product, title, abc);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    databaseHelper = DatabaseHelper();
    databaseHelper.getCount().then((product) {
      setState(() {
        allProduct = product[0];
        print(allProduct);
      });
    });
  }
}
