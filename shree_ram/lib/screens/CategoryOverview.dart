import 'package:flutter/material.dart';
import 'package:shree_ram/models/Category.dart';
import 'package:shree_ram/models/Product.dart';
import 'package:shree_ram/screens/CategoryAdd.dart';
import 'package:shree_ram/screens/ProductDetail.dart';
import 'package:shree_ram/utils/database_helper.dart';

class CategoryOverview extends StatefulWidget {
  Category category;
  CategoryOverview(this.category);
  @override
  _CategoryOverviewState createState() => _CategoryOverviewState(this.category);
}

class _CategoryOverviewState extends State<CategoryOverview> {
  Category category;
  _CategoryOverviewState(this.category);

  DatabaseHelper databaseHelper;
  TextEditingController teSeach = TextEditingController();
  var allProduct = [];
  var items = List();
  var allCategory = [];
  var item = List();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    databaseHelper.getProductbycat(category.categoryname).then((product) {
      setState(() {
        updateListView();
        allProduct = product;
        items = allProduct;
      });
    });

    databaseHelper.getProductMapList().then((category) {
      setState(() {
        updateListView();
        allCategory = category;
        item = allCategory;
      });
    });
  }

  void filterSeach(String query) async {
    var dummySearchList = allProduct;
    if (query.isNotEmpty) {
      var dummyListData = List();
      dummySearchList.forEach((item) {
        var product = Product.fromMapObject(item);
        if (product.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items = [];
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items = [];
        items = allProduct;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.categoryname),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              Navigator.pop(context, true);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                debugPrint('FAB clicked');
                navigationtoAddcat(category);
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filterSeach(value);
                });
              },
              controller: teSeach,
              decoration: InputDecoration(
                  hintText: 'Search...',
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  )),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, position) {
                Product product = Product.fromMapObject(items[position]);
                return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: getPriorityColor(product.priority),
                          child: getPriorityIcon(product.priority),
                        ),
                        title: Text(
                          product.name,
                        ),
                        subtitle: Text(product.category),
                        onTap: () {
                          debugPrint("ListTile Tapped");

                          _onButtonPressed(
                              product.name,
                              product.category,
                              product.description,
                              product.buyprice,
                              product.shellprice,
                              product);
                        },
                        trailing: Text(product.date)));
              },
            ),
          )
        ],
      ),
    );
  }

// Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

// Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void navigateToDetail(Product product, String title, bool abc) async {
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
    databaseHelper.getProductbycat(category.categoryname).then((product) {
      setState(() {
        allProduct = product;
        items = allProduct;
      });
    });
  }

  void navigationtoAddcat(Category category) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CategoryAdd(category);
    }));

    if (result == true) {
      updatecat();
      updateListView();
    }
  }

  void updatecat() {
    databaseHelper = DatabaseHelper();
    databaseHelper.getCategoryMaplist().then((category) {
      setState(() {
        allCategory = category;
        item = allCategory;
      });
    });
  }

  void _onButtonPressed(
      name, category, description, buyprice, shellprice, product) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 380,
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    'Product Details',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text(
                      'Name : ' + name,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text(
                      'Category : ' + category,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text(
                      'Description : ' + description,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.schedule),
                    title: Text(
                      'Buy Price : ' + buyprice,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text(
                      'Shell Price :' + shellprice,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  _buildDivider(),
                  RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Edit',
                      textScaleFactor: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop();
                        navigateToDetail(product, 'Edit Note', true);
                        debugPrint("Save button clicked");
                      });
                    },
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 2.0,
      color: Colors.grey.shade300,
    );
  }
}
