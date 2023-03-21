import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protivity_app/constant.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../util.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    DateTime _todayDate = DateTime.now();

    String uid = user!.uid;

    String dueDate = '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}';
    String time = '${_todayDate.year}-${_todayDate.month}-${_todayDate.day}';
    print(time);
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': dueDate,
      'timestamp': time
    });
    Navigator.pop(context);
    successSnackBar(context: context, message: 'Data Added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 16),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 9, 16),
        title: Text('New Task'),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    // labelText: 'Title',
                    hintText: 'Task',
                    hintStyle: TextStyle(fontSize: 14),
                    icon: Icon(CupertinoIcons.square_list, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    // labelText: 'Description',
                    hintText: 'Description',
                    hintStyle: TextStyle(fontSize: 14),
                    icon: Icon(CupertinoIcons.bubble_left_bubble_right,
                        color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Text(
                    '${_dateTime.day}-${_dateTime.month}-${_dateTime.year   }',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  MaterialButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.purple.shade100;
                      return Theme.of(context).primaryColor;
                    })),
                    child: Text(
                      'Add Task',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {
                      addtasktofirebase();
                    },
                  ))
            ],
          )),
    );
  }
}
