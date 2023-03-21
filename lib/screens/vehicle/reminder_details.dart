import 'package:create_reminder/data/sql_helper.dart';
import 'package:create_reminder/screens/vehicle/update_vehicle.dart';
import 'package:flutter/material.dart';
import '../../widget/appbarwidget.dart';
import '../../widget/custom_nodata.dart';
import '../../widget/custom_row.dart';
import 'add_vehicle.dart';
import 'detail_page.dart';

class ReminderDetails extends StatefulWidget {
  // get userid from home
  int? userid;
  ReminderDetails({this.userid});

  @override
  State<ReminderDetails> createState() => _ReminderDetailsState();
}

class _ReminderDetailsState extends State<ReminderDetails> {
  // fetch list of vehicles
  List<Map<String, dynamic>> _listofvehicle = [];

  void initState() {
    // getAllVehicles to _listofvehicle
    getAllVehicle();
    super.initState();
  }

  void getAllVehicle() async {
    // display list of vehicles of particular user
    final data = await SQLHelper.getAllVehiclesbyLoginid(widget.userid!);
    setState(() {
      // fetch list of vehicles in list
      _listofvehicle = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Vehicle List"),
      body: _listofvehicle.length == 0
          ? CustomNoData(
              iconaddress: 'assets/json/no_vehicle.json',
              maintext: 'No Vehicles right now!',
              description: "When you add Vehicles you'll see them here",
            )
          : ListView.builder(
              itemCount: _listofvehicle.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detailpage(
                                    id: _listofvehicle[index]['vehicle_vid'],
                                  )));
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 7.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_listofvehicle[index]['vehicle_vtype']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7.0),
                              child: Row(
                                children: [
                                  Text(
                                      '${_listofvehicle[index]['vehicle_vnumber']}')
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: Column(
                                children: [
                                  CustomRow(
                                    title: 'Vehicle Company :',
                                    titledata:
                                        '${_listofvehicle[index]['vehicle_vcompany']}',
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  CustomRow(
                                    title: 'Vehicle Model :',
                                    titledata:
                                        '${_listofvehicle[index]['vehicle_vmodel']}',
                                  ),
                                ],
                              ),
                            )),
                            Container(
                                width: double.infinity,
                                child: Divider(
                                  color: Colors.black,
                                )),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _navigatetoUpdate(
                                            context,
                                            _listofvehicle[index]
                                                ['vehicle_vid']);
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.edit_rounded,
                                                size: 18,
                                                color: Colors.blueAccent,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Color(0xfff007dfe)),
                                              ),
                                            ],
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showDialog(index);
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.delete_rounded,
                                                size: 18,
                                                color: Color(0xffffc0303),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text("Remove",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xffffc0303))),
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
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight * 0.95,
            child: FloatingActionButton.extended(
                backgroundColor: Colors.white,
                onPressed: () {
                  _navigateforResult(context);
                },
                icon: Icon(
                  Icons.add,
                  color: Color(0xfff007dfe),
                ),
                label: Text(
                  'Add Vehicle',
                  style: TextStyle(color: Color(0xfff007dfe)),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateforResult(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddVehicle(uniquevehicleid: widget.userid),
        ));
    if (!mounted) return;
    getAllVehicle();
  }

  Future<void> _navigatetoUpdate(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateVehicle(
                id: index,
              )),
    );
    if (!mounted) return;

    getAllVehicle();
  }

  void _showDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete Vehicle"),
          content: new Text("Do you want to Delete Vehicle?"),
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
                      SQLHelper.deleteVehicle(
                          _listofvehicle[index]['vehicle_vid']);
                      getAllVehicle();
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
      },
    );
  }
}
