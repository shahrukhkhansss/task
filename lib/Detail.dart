import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider.dart';
import 'model.dart';

class NextPage extends StatelessWidget {


  NextPage();

  @override
  Widget build(BuildContext context) {
    var userDataProvider =
    Provider.of<menuDataProvider>(context);
    Articles articles = userDataProvider.Details!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text('News',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ), // Set app title
        //leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  articles.title.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.01),
              Center(child: Container(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
                  child: Image.network(articles.urlToImage.toString()))),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.01),
              Center(
                child: Text(
                  'Author: ${articles.author ?? 'Unknown'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).size.height*0.01),
              Center(
                child: Text(
                  articles.publishedAt.toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.01),
              Text("Description:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Text(
                articles.description.toString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.01),
              Text("Content:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Text(
                articles.content.toString(),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}