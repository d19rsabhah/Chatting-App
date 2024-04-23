import 'package:chatting_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool search = false;

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value){
    if(value.length == 0){
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedValue = value.subString(0, 1).toUpperCase() + value.substring(1);
    if(queryResultSet.isEmpty && value.length == 1){
      DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        for(int i = 0; i < docs.docs.length; ++i){
          queryResultSet.add(docs.docs[i].data());
        }
      });
    }else{
      tempSearchStore = [];
      queryResultSet.forEach((element) { if(element['username'].startsWith(capitalizedValue)){
        setState(() {
          tempSearchStore.add(element);
        });
      }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    search? Expanded(child: TextField(
                      onChanged: (value){
                        initiateSearch(value.toUpperCase());
                      },

                      decoration: InputDecoration(border: InputBorder.none,
                        hintText: 'Search Users', hintStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)
                      ), style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),
                    )):
                    Text(
                      "Chat-App",
                      style: TextStyle(
                          color: Color(0xffc199cd),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            search = true;
                            setState(() {

                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color(0xFF3a2144),
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(
                              Icons.search,
                              color: Color(0xffc199cd),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                height: search
                    ? MediaQuery.of(context).size.height / 1.19
                    : MediaQuery.of(context).size.height / 1.14,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                   search ? ListView(
                     // padding: EdgeInsets.only(left: 10.0, right: 10.0),
                     // primary: false,
                     // shrinkWrap: true,
                     // children: tempSearchStore.map((element){
                     //   return buildResultCard(element);
                     // }).toList()
                   ) : Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                          //  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifier()));
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset(
                              "assets/images/prof.jpg",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Rishav Das",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Hello, What's up!",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),],
                        ),
                        Text(
                          "01:52 P.M.",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 11.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                "assets/images/prof.jpg",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.0,
                                ),
        
                                    Text(
                                      "Rishav Das",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                Text(
                                  "Thank You!",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                     //   Spacer(),
                        Text(
                          "02:12 P.M.",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
