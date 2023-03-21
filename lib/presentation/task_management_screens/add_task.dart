import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protivity_app/core/constant.dart';
import 'package:protivity_app/core/size_config.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../core/util.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _regKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  bool selected = false;

  void _selectDate() {
    showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(1950),
            lastDate: DateTime(2050))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate.toLocal();
        selected = true;
      });
    });
  }

  addtasktofirebase() async {
    final isValid = _regKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    DateTime _todayDate = DateTime.now();

    String uid = user!.uid;

    String dueDate =
        '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
    String time = '${_todayDate.year}-${_todayDate.month}-${_todayDate.day}';
    print(time);

    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection(user.uid).add({
        'title': titleController.text,
        'description': descriptionController.text,
        'time': dueDate,
        'timestamp': time
      });

      String taskId = docRef.id;
      print('here is the Id');
      print(taskId);

      await FirebaseFirestore.instance
          .collection(user.uid)
          .doc(taskId)
          .update({'id': taskId});

      Navigator.pop(context);
      Navigator.pop(context);
      successSnackBar(context: context, message: 'Data Added');
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      failureSnackBar(context: context, message: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 16),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 9, 16),
        title: Text('New Task'),
      ),
      body: Form(
        key: _regKey,
        child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Input task';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        // labelText: 'Title',
                        hintText: 'Task',
                        hintStyle: TextStyle(fontSize: 14),
                        icon: Icon(CupertinoIcons.square_list,
                            color: Colors.blue),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Input description';
                        } else
                          return null;
                      },
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
                  GestureDetector(
                    onTap: () {
                      _selectDate();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(20),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                left: getProportionateScreenWidth(11),
                                right: getProportionateScreenWidth(14)),
                            height: getProportionateScreenHeight(70),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Text(
                                  selected
                                      ? _selectedDate.day.toString() +
                                          '/' +
                                          _selectedDate.month.toString() +
                                          '/' +
                                          _selectedDate.year.toString()
                                      : 'Due Date',
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(16)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(350)),
                  SizedBox(
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
              ),
            )),
      ),
    );
  }
}
