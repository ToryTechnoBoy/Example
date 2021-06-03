import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/RandomProducts.dart';
import 'package:flutter_app/productView.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Welcome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List listAll = [];
  ScrollController scrollController;
  ScrollController _scrollController;
  List e = [];
  List scrollers = [];
  int numOfCols = 3;
  String choice = "default";
  bool isScrolling = false;


  void All()async{
    Uri url = Uri.parse('http://127.0.0.1:8000/sendAll');
    try {
      http.Response response = await http.post(url);

      if(response.statusCode == 200){
      listAll = json.decode(response.body);
    }
    else{
      Future.delayed(Duration(seconds: 1), (){
        All();
      });
    }}
    catch (E) {
      print("d");
      Future.delayed(Duration(seconds: 1) , (){
        All();
        print(listAll.length);
        setState(() {

        });
      });
    }

  }



  Widget mainWidget (BuildContext context){
    final orientation = MediaQuery.of(context).orientation;
    if(choice == "Categorized"){
      return Expanded(
        child: e.length == 0 ?
        Center(child: CircularProgressIndicator())
            :ListView.builder(
            physics:  BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: e.length > 3 ? numOfCols : e.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                            Map.of(e[index]).keys.first,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ListView.builder(
                            controller: scrollers[index],
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: Map.from(e[index]).values.first.length,
                            itemBuilder: (context, i) {
                              return Container(
                                width: MediaQuery.of(context).size.width *
                                    0.4,
                                height:
                                MediaQuery.of(context).size.height *
                                    0.25,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => productView(e[index]
                                            .values
                                            .first[i]['product_id'])));
                                    print(e[index]
                                        .values
                                        .first[i]['product_id']);
                                  },
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              1,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.19,
                                          child: Image.network(
                                            Map.from(e[index])
                                                .values
                                                .first[i]['image_link'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          Map.from(e[index])
                                              .values
                                              .first[i]['name'],
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                        Text(Map.from(e[index])
                                            .values
                                            .first[i]['price'].toString() +" "+Map.from(e[index])
                                            .values
                                            .first[i]['price_sign'].toString() )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    }
    else if(choice == "default" || choice == "Home"){
        return  Expanded(
          child: listAll.isEmpty ? Center(child: CircularProgressIndicator()) : GridView.builder(
            itemCount: listAll.length,
            controller: _scrollController ,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 2),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => productView(listAll[index]['product_id'])) );
                },
                child: new Card(
                  child: new GridTile(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(width: MediaQuery.of(context).size.width*1,height: MediaQuery.of(context).size.height*0.2,child: new Image.network(listAll[index]['image_link'], fit: BoxFit.contain,)),
                        new Text(listAll[index]['name'], overflow: TextOverflow.ellipsis,),
                        new Text(listAll[index]['price'].toString()+ ' '+listAll[index]['price_sign'])
                      ],
                    ), //just for testing, will fill with image later

                  ),
                ),
              );
            },
          ),
        );
    }
    else{
      return Center(
        child: Column(
          children: [
            Container(
              child: Center(
                child: LinearProgressIndicator(),
              ),
            ),
            Container(
              child: Text("Sorry something went wrong"),
            ),
          ],
        ),
      );
    }
}


  Future<List> fetchAll(String u, String type) async {
    Uri url = Uri.parse(u);
    try {
      http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'product_type': type,
        }),
      );
      if (response.statusCode == 200) {
        List list = await json.decode(response.body);
        list.forEach((element) {
          Map<String, List> b = Map.from(element);
          e.add(b);
          scrollers.add(ScrollController());
        });
        setState(() {});
      }
      else{

      }

    } catch (e) {
      Future.delayed(Duration(seconds: 1), (){
        fetchAll(u , type);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    All();
    fetchAll('http://127.0.0.1:8000/random', "all").whenComplete(() {
      _scrollController = new ScrollController();
      scrollController = new ScrollController();
      _scrollController.addListener(() {
        if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
          setState(() {
            print("dsd");
            isScrolling = true;
          });
        }
        else {
          setState(() {
            print("dsd");
            isScrolling = false;
          });
        }
      });
      scrollController.addListener(() {
        if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
          setState(() {
            isScrolling = true;
          });
        }
        else {
          setState(() {
            isScrolling = false;
          });
        }
        if(scrollController.position.atEdge){
          if(scrollController.position.pixels !=0){
            if(e.length > numOfCols){
              if (e.length - numOfCols > 2) {
                setState(() {
                  numOfCols += 2;
                });
              } else {
                setState(() {
                  numOfCols++;
                });
              }
            }
          }
        }
      });
      scrollers.forEach((element) {
        element.addListener(() {
          if (element.position.atEdge) {
            if (element.position.pixels != 0) {
              print(scrollers.indexOf(element));
              print(e[scrollers.indexOf(element)].keys.first);
              setState(() {

              });
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white60,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Search..."), Icon(Icons.search)],
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isScrolling ? 0.0 : 1.0,
              duration: Duration(seconds: 1),
              child: AnimatedContainer(
                duration: Duration(microseconds: 50000),
                height: isScrolling ? 0 : MediaQuery.of(context).size.height*0.08,
                width: MediaQuery.of(context).size.width*1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(onPressed: (){
                      setState(() {
                        choice = "Home";
                      });
                    }, child: Container(child: Text("Home"),

                    decoration: BoxDecoration(
                      border: choice == "Home" || choice == "default" ?
                          Border(bottom: BorderSide(
                            width: 3, color: Colors.blue
                          )):Border(top : BorderSide.none,
                          bottom: BorderSide.none,
                          left: BorderSide.none,
                          right: BorderSide.none
                      )
                    ),

                    ),
                    ),
                    TextButton(onPressed: (){
                      setState(() {
                        choice = "Categorized";
                      });

                    }, child: Container(child: Text("Categorized"),

                      decoration: BoxDecoration(
                          border: choice == "Categorized" ?
                          Border(bottom: BorderSide(
                              width: 3, color: Colors.blue
                          )): Border(top : BorderSide.none,
                            bottom: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none
                          )
                      ),

                    ),
                    ),
                  ],
                ),
              ),
            ),
            mainWidget(context)

          ],
        ),
      ),
    );
  }
}
