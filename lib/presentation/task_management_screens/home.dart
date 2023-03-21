import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:protivity_app/core/size_config.dart';
import 'package:protivity_app/presentation/onboarding_screens/sign_up.dart';
import 'package:protivity_app/presentation/task_management_screens/update_task.dart';

import '../../core/util.dart';
import 'add_task.dart';
import 'description.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 16),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 9, 16),
        automaticallyImplyLeading: false,
        title: Center(child: Text('My Todo List')),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUp())));
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(user.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasError) {
                return Text(
                  'Eror',
                  style: TextStyle(color: Colors.white),
                );
              } else {
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        String taskId = data['id'];
                        String title = data['title'];
                        String desc = data['description'];
                        String dueDate = data['time'];
                        String time = data['timestamp'];

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateTask(
                                    desc: desc,
                                    taskId: taskId,
                                    dueDate: dueDate,
                                    timeStamp: time,
                                    title: title)));
                      },
                      child: Container(
                          padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(20),
                              bottom: getProportionateScreenHeight(10),
                              top: getProportionateScreenHeight(10)),
                          margin: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(10),
                              vertical: getProportionateScreenHeight(10)),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: getProportionateScreenWidth(250),
                                height: getProportionateScreenHeight(100),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data['title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(10),
                                    ),
                                    Text(
                                      data['description'],
                                      style: TextStyle(),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(15),
                                    ),
                                    Text(
                                      'Due Date :  ${data['time']}',
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final user =
                                        FirebaseAuth.instance.currentUser!;
                                    String taskId = data['id'];

                                    await FirebaseFirestore.instance
                                        .collection(user.uid)
                                        .doc(taskId)
                                        .delete();
                                    successSnackBar(
                                        context: context,
                                        message: 'Task Deleted');
                                  },
                                  icon: Icon(
                                      Icons.check_box_outline_blank_outlined))
                            ],
                          )),
                    );
                  }).toList(),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTask()));
          }),
    );
  }
}
