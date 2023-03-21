import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protivity_app/core/size_config.dart';
import 'package:protivity_app/core/util.dart';

class UpdateTask extends StatefulWidget {
  final String title;
  final String desc;
  final String dueDate;
  final String timeStamp;
  final String taskId;

  const UpdateTask(
      {required this.desc,
      required this.taskId,
      required this.dueDate,
      required this.timeStamp,
      required this.title});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
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

  updateTask() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    DateTime _todayDate = DateTime.now();
    final user = FirebaseAuth.instance.currentUser!;

    String dueDate =
        '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
    String time = '${_todayDate.year}-${_todayDate.month}-${_todayDate.day}';
    print(time);
    await FirebaseFirestore.instance
        .collection(user.uid)
        .doc(widget.taskId)
        .update({
      'description': descriptionController.text,
      'title': titleController.text,
      'time': dueDate,
      'timestamp': time
    });
    successSnackBar(context: context, message: 'Task Updated Successfully');

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 16),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 9, 16),
        title: Text('Edit Task'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(20),
            horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    // labelText: 'Title',
                    hintText: widget.title,
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
                    hintText: widget.desc,
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
                                  : widget.dueDate,
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(16)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(400)),
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
                      'Update',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {
                      updateTask();
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
