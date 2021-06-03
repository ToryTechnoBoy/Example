
class RandomProduct {
  int id;
  String name;
  String imageLink;
  String product_type;
  RandomProduct({this.id, this.name, this.imageLink, this.product_type});
  
  factory RandomProduct.fromJson(Map<String , dynamic > json){
    return RandomProduct(
      id : json['id'],
      name : json['name'],
      imageLink: json['image_link'],
      product_type: json['product_type']
    );
  }
}

class ProductsMap{

  String key ;
  List<Map> list;

  ProductsMap({this.list, this.key});

  factory ProductsMap.fromJson(Map <String , dynamic>json){
      return ProductsMap(
      );
  }



}