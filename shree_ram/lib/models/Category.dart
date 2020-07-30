class Category {
  int _id;
  String _categoryname;

  Category(this._categoryname);
  Category.withid(this._id, this._categoryname);

  int get id => _id;
  String get categoryname => _categoryname;

  set categoryname(String newcategory) {
    this._categoryname = newcategory;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['categoryname'] = _categoryname;
    return map;
  }

  Category.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._categoryname = map['categoryname'];
  }
}
