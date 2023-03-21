import 'package:create_reminder/screens/vehicle/add_reminder.dart';
import 'package:create_reminder/screens/vehicle/update_reminder.dart';
import 'package:flutter/material.dart';
import '../../data/sql_helper.dart';
import '../../widget/custom_nodata.dart';

class Detailpage extends StatefulWidget {
  final int id;
  Detailpage({required this.id});

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  List<Map<String, dynamic>> _listofsinglevehicleVehicle = [];
  int? singlevehicleid;
  String? singlevehicletype, singlevehiclenumber;
  static List<Map<String, dynamic>> _listofReminder = [];
  List<DateTime> _listofdatetime = [];

  void initState() {
    getAllReminder();
    getVehicleData();
    getdataindateFormat();
    super.initState();
  }

  void getAllReminder() async {
    final data2 = await SQLHelper.getAllReminderByVehicleId(widget.id);
    setState(() {
      _listofReminder = data2;
    });
  }

  void getVehicleData() async {
    final data = await SQLHelper.getSingleVehicle(widget.id);
    setState(() {
      _listofsinglevehicleVehicle = data;
      singlevehicleid = _listofsinglevehicleVehicle[0]['vehicle_vid'];
      singlevehicletype = _listofsinglevehicleVehicle[0]['vehicle_vtype'];
      singlevehiclenumber = _listofsinglevehicleVehicle[0]['vehicle_vnumber'];
      print(widget.id);
    });
  }

  void getdataindateFormat() async {
    for (int i = 0; i < _listofReminder.length; i++) {
      DateTime temp = DateTime.parse(
          "${_listofReminder[i]['reminder_rdate']} ${_listofReminder[i]['reminder_rtime']}");
      _listofdatetime.add(temp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xfff007dfe),
          elevation: 0.5,
          iconTheme: IconThemeData(
            color: Color(0xfffefefd), //change your color here
          ),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '$singlevehicletype',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xfffefefd)),
            ),
            Text(
              '$singlevehiclenumber',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 12, color: Color(0xfffefefd)),
            ),
          ])),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: _listofReminder.length == 0
                            ? CustomNoData(
                                iconaddress: 'assets/json/noreminderlist.json',
                                maintext: 'No Reminders right now!',
                                description:
                                    "When you add Reminder for vehicle \nyou'll see them here",
                              )
                            : ListView.builder(
                                itemCount: _listofReminder.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.black12,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                    '${_listofReminder[index]['reminder_rname']}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.schedule_rounded,
                                                      size: 18,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        '${_listofReminder[index]['reminder_rtime']} on ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15)),
                                                    Text(
                                                        '${_listofReminder[index]['reminder_rdate']}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.replay,
                                                      size: 18,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        '${_listofReminder[index]['reminder_rrepeat']}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  width: double.infinity,
                                                  child: Divider(
                                                    color: Colors.black,
                                                  )),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          _navigatetoUpdate(
                                                              context,
                                                              _listofReminder[
                                                                      index][
                                                                  'reminder_rid']);
                                                        },
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.5,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .edit_rounded,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xfff007dfe)),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          _showreminderDialog(
                                                              index);
                                                        },
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.4,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .delete_rounded,
                                                                  size: 18,
                                                                  color: Color(
                                                                      0xffffc0303),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text("Remove",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xffffc0303))),
                                                              ],
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          )),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight * 0.95,
            child: FloatingActionButton.extended(
                backgroundColor: Colors.white,
                onPressed: () {
                  _navigateforReminder(context, singlevehicleid);
                },
                icon: Icon(
                  Icons.add,
                  color: Color(0xfff007dfe),
                ),
                label: Text(
                  'Add Reminder',
                  style: TextStyle(color: Color(0xfff007dfe)),
                )),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _navigatetoUpdate(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateReminder(
                id: index,
              )),
    );
    if (!mounted) return;
    getAllReminder();
    getdataindateFormat();
  }

  Future<void> _navigateforReminder(BuildContext context, var index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddReminder(id: index)),
    );
    if (!mounted) return;

    getAllReminder();
  }

  void _showreminderDialog(int index) {
    showDialog(
        context: this.context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: new Text("Delete Reminder"),
            content: new Text("Do you want to Delete Reminder?"),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(00, 00, 08, 08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        child: new Text("Close"),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        SQLHelper.deleteReminder(
                            _listofReminder[index]['reminder_rid']);
                        getAllReminder();
                        Navigator.of(context).pop();
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xffffc0303),
                          ),
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: new Text(
                              "Delete",
                              style: TextStyle(
                                  color: Color(0xffffc0303),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }
}
