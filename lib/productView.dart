import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class productView extends StatefulWidget {
  int id;
  productView(this.id);
  @override
  _productViewState createState() => _productViewState(id);
}

class _productViewState extends State<productView> {
  int id;
  _productViewState(this.id);
  Map <String , dynamic> map = new Map();
  void fetchProduct()async{
    Uri url = Uri.parse("http://127.0.0.1:8000/productReq");
    http.Response response = await http.post(url,
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
        'product_id': id.toString(),
        }
    )
    );
    setState(() {
      map = json.decode(response.body)[0];

    });

  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: map.isEmpty ?CircularProgressIndicator() : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  Container(
                    color: map.isEmpty || map['image_r'] == "none"|| map['image_g'] == "none"|| map['image_b'] == "none" ? Colors.transparent:Color.fromRGBO(int.parse(map['image_r']), int.parse(map['image_g']), int.parse(map['image_b']), 1),

                    child: map.isNotEmpty ? Image.network(map['image_link'],fit : BoxFit.contain):Center(child: CircularProgressIndicator()),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text( map['name'], style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: MediaQuery.of(context).textScaleFactor*20
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("Product price : " + map['price'].toString(),style: TextStyle(
                              fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).textScaleFactor*18                      ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("Category : " + map['category'].toString(),style: TextStyle(
                              fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).textScaleFactor*18
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: FittedBox(
                            child: Text("Description : " + map['description'].toString(),style: TextStyle(
                                fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).textScaleFactor*18
                            ),
                            overflow: TextOverflow.ellipsis,),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(onPressed: (){
                }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                          Icon(Icons.shopping_bag_outlined, size: 45,),
                    Text("Buy", style: TextStyle(
                      fontSize: 24
                    ),)
                  ],
                )),
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
