import 'package:blog_app/services/crud.dart';
import 'package:blog_app/views/create_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CrudMethods crudMethods = new CrudMethods();
  Stream blogStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    crudMethods.getData().then((result){
      setState(() {
        blogStream = result;
      });
    });
  }

  Widget BlogList() {
    return Container(
      child: blogStream != null ? SingleChildScrollView(
        child: Column(
          children: [
            // ListView.builder(
            //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //   itemCount: blogSnapshot.docs.length,
            //   shrinkWrap: true,
            //   physics: ClampingScrollPhysics(),
            //   scrollDirection: Axis.vertical,
            //   itemBuilder: (context, index){
            //     return BlogTile(
            //         imgUrl: blogSnapshot.docs[index].data()['imageUrl'],
            //         title: blogSnapshot.docs[index].data()['title'],
            //         desc: blogSnapshot.docs[index].data()['description'],
            //         authName: blogSnapshot.docs[index].data()['authorname']);
            //   },
            // ),
            StreamBuilder(
              stream: blogStream,
              builder: (context, snapshot){
                return snapshot.data != null ? ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index){
                        return BlogTile(
                            imgUrl: snapshot.data.docs[index].data()['imageUrl'],
                            title: snapshot.data.docs[index].data()['title'],
                            desc: snapshot.data.docs[index].data()['description'],
                            authName: snapshot.data.docs[index].data()['authorname']);
                      },
                    ) : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
            ),
          ],
        ),
      ) : Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter', style: TextStyle(
              fontSize: 22,

            )),
            Text('Blog', style: TextStyle(
              fontSize: 22,
              color: Colors.blue,
            ))
          ],
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlogList(),
        // padding: EdgeInsets.symmetric(horizontal: 4),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CreateBlog(),
                  ));
                },
                child: Icon(Icons.add)
            )
          ],
        ),
      ),
    );
  }
}


class BlogTile extends StatelessWidget {
  String imgUrl, title, desc, authName;
  BlogTile({@required this.imgUrl, @required this.title, @required this.desc, @required this.authName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      height: 175,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
              child: CachedNetworkImage(imageUrl: imgUrl, width: MediaQuery.of(context).size.width,fit: BoxFit.cover,),
          ),
          Container(
            height: 175,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.4),
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                SizedBox(height: 4),
                Text(authName, textAlign: TextAlign.center,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




















