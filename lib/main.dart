import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Detail.dart';
import 'Provider.dart';
import 'model.dart';

void main() {
  runApp(ChangeNotifierProvider<menuDataProvider>(
      create: (_) => menuDataProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool isOnline = true;
  TextEditingController _searchController = TextEditingController();

  Future getNews(String data) async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=$data&apiKey=eb0dd195d0e44cafae75d3ebb28fa34e"));
    print(
        "https://newsapi.org/v2/everything?q=$data&apiKey=eb0dd195d0e44cafae75d3ebb28fa34e");

    if (response.statusCode == 200) {
      var dataresponse = jsonDecode(response.body);
      // var result=  Apimodel.fromJson(dataresponse);
      print("datarespons0e$dataresponse");
      return dataresponse;
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  //
  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isOnline = false;
      });
    } else {
      setState(() {
        isOnline = true;
      });
    }
  }

  void searchNews(String query) {
    if (query.isNotEmpty) {
      getNews(query);
    }
  }

  var queryInput = "technology";

  @override
  Widget build(BuildContext context) {
    var currentQuery = queryInput;

    var userDataProvider = Provider.of<menuDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'News',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Lastest News'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('settings'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextField(
                controller: _searchController,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        queryInput = _searchController.text;
                      });
                    },
                  ),
                ),
                onSubmitted: (String value) {
                  setState(() {
                    queryInput = value;
                  });
                },
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                    future: getNews(currentQuery),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        var data = snapshot.data;
                        List Article = data["articles"];
                        return ListView.builder(
                          itemCount: Article.length,
                          itemBuilder: (BuildContext context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    userDataProvider.Detailspage(
                                        Articles.fromJson(Article[index]));
                                    // Navigate to the next page with selected article details
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NextPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Article[index]['urlToImage'] != null
                                        ? Image.network(Article[index]
                                                ['urlToImage']
                                            .toString())
                                        : Placeholder(),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              Article[index]['source'] !=
                                                          null &&
                                                      Article[index]['source']
                                                              ['name'] !=
                                                          null
                                                  ? Article[index]['source']
                                                          ['name']
                                                      .toString()
                                                  : 'Source Not Available',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        Article[index]["title"].toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(Article[index]["description"]
                                          .toString()),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return Center(child: Text('No data available'));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
