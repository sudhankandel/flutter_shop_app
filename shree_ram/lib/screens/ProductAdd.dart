import 'package:flutter/material.dart';
import 'package:shree_ram/models/Category.dart';
import 'package:shree_ram/models/Product.dart';
import 'package:shree_ram/screens/CategoryOverview.dart';
import 'package:shree_ram/screens/ProductDetail.dart';
import 'package:shree_ram/utils/database_helper.dart';

class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  DatabaseHelper databaseHelper;
  TextEditingController teSeach = TextEditingController();
  var allCategory = [];
  var items = List();
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    databaseHelper.getProductMapList().then((category) {
      setState(() {
        updateListView();
        allCategory = category;
        items = allCategory;
      });
    });
  }

  void filterSeach(String query) async {
    var dummySearchList = allCategory;
    if (query.isNotEmpty) {
      var dummyListData = List();
      dummySearchList.forEach((item) {
        var category = Category.fromMapObject(item);
        if (category.categoryname.toLowerCase().contains(query.toLowerCase())) {
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
        items = allCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CATEEGORY WISE PRODUCT'),
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
                Category category = Category.fromMapObject(items[position]);
                return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(category.categoryname.toString()),
                      onTap: () {
                        debugPrint("ListTile Tapped");
                        navigateToCategoryOverview(category);
                      },
                    ));
              },
            ),
          )
        ],
      ),
    );
  }

  void navigateToCategoryOverview(Category category) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CategoryOverview(category);
    }));

    if (result == true) {
      updateListView();
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
    databaseHelper.getCategoryMaplist().then((category) {
      setState(() {
        allCategory = category;
        items = allCategory;
      });
    });
  }
}
