class Product {
  int _id;
  String _name;
  String _description;
  String _date;
  int _priority;
  String _buyprice;
  String _shellprice;
  String _category;

  Product(this._name, this._date, this._priority, this._buyprice,
      this._shellprice, this._category,
      [this._description]);
  Product.withid(this._id, this._name, this._date, this._priority,
      this._buyprice, this._shellprice, this._category,
      [this._description]);

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;
  String get buyprice => _buyprice;
  String get shellprice => _shellprice;
  String get category => _category;

  set name(String newname) {
    this._name = newname;
  }

  set description(String newdescription) {
    this._description = newdescription;
  }

  set date(String newdate) {
    this._date = newdate;
  }

  set priority(int newpriority) {
    if (newpriority >= 1 && newpriority <= 2) this._priority = newpriority;
  }

  set buyprice(String newbuyprice) {
    this._buyprice = newbuyprice;
  }

  set shellprice(String newshellprice) {
    this._shellprice = newshellprice;
  }

  set category(String newcategory) {
    this._category = newcategory;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    map['buyprice'] = _buyprice;
    map['shellprice'] = _shellprice;
    map['category'] = _category;

    return map;
  }

  // Extract a Note object from a Map object
  Product.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
    this._buyprice = map['buyprice'];
    this.shellprice = map['shellprice'];
    this._category = map['category'];
  }
}
