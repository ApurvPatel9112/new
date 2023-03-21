import 'package:create_reminder/screens/insurance/update_insurance.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../data/sql_helper.dart';
import '../../widget/appbarwidget.dart';
import '../../widget/custom_nodata.dart';
import '../../widget/last_insurance_date.dart';
import '../../widget/next_premium_date.dart';
import 'add_premium_insurance.dart';
import 'detail_page_insurance.dart';

class InsuranceDetails extends StatefulWidget {
  //get id from home screen
  int? id;
  InsuranceDetails({this.id});

  @override
  State<InsuranceDetails> createState() => _InsuranceDetailsState();
}

class _InsuranceDetailsState extends State<InsuranceDetails> {
  List<Map<String, dynamic>> _listofInsurance = []; //list of insurances add
  List<Map<String, dynamic>> _getlistofusers = []; //list of users
  int? globalUserId;
  int dueDays = 1;

  //naviagate to add premium insurance page
  Future<void> _navigateforResult(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PremiumInsurance(uniqueinsuranceid: globalUserId)),
    );
    if (!mounted) return;
    getAllInsurances();
  }

  //navigate to update insurance page
  Future<void> _navigatetoUpdate(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateInsurance(
                id: index,
              )),
    );
    if (!mounted) return;
    getAllInsurances();
  }

  void updateID(int vid) {
    globalUserId = vid;
    print(globalUserId);
  }

  void getSingleUser() async {
    final data = await SQLHelper.getUserfromLogin(widget.id!);
    print('User Details');
    print(data);
    setState(() {
      _getlistofusers = data;
      String uid = _getlistofusers[0]['login_uid'].toString();
      print(widget.id);
      final int userid = int.parse(uid);
      updateID(userid);
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSingleUser();
      getAllInsurances();
      print('number of items ${_listofInsurance.length}');
    });
  }

  //calculate days interval from next premium date
  int dueDaysCount(int index) {
    int days = DateTime.parse(
                NextPremiumDate(_listofInsurance[index]['insurance_date']))
            .difference(DateTime.now())
            .inDays +
        1;
    while (days > 365) {
      days = days - 365;
    }
    return days;
  }

  //function to get all insurances
  void getAllInsurances() async {
    final data = await SQLHelper.getAllInsurancebyLoginid(widget.id!);
    print("Insurance Details: ");
    print('$data');
    setState(() {
      _listofInsurance = data;
    });
  }

  //dialog box for confirmation of delete
  void _showDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete Insurance"),
          content: new Text("Do you want to Delete Insurance?"),
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
                      SQLHelper.deleteInsurance(
                          _listofInsurance[index]['insurance_iid']);
                      getAllInsurances();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar("Insurance List"),
        body: _listofInsurance.length == 0
            ? CustomNoData(
                iconaddress: 'assets/json/no_insurance.json',
                maintext: 'No Insurances right now!',
                description: "When you add Insurance\nyou'll see them here",
              )
            : ListView.builder(
                itemCount: _listofInsurance.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailpageInsurance(
                                    id: _listofInsurance[index]
                                        ['insurance_iid'])));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black12,
                          ),
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Text(
                                        '${_listofInsurance[index]['insurance_company']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 7.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Members:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                        '${_listofInsurance[index]['insurance_members']}'),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                    ),
                                    Text(
                                      dueDaysCount(index).toString() +
                                          ' days are due!',
                                      style: dueDaysCount(index) >= 10
                                          ? TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            )
                                          : TextStyle(
                                              fontSize: 15,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: Container(
                                    child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Type:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                            '${_listofInsurance[index]['insurance_type']}'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Start Date:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                            '${_listofInsurance[index]['insurance_date']}'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Term(in years):',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                            '${_listofInsurance[index]['insurance_term']}'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Next Premium Date:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text(NextPremiumDate(
                                            _listofInsurance[index]
                                                ['insurance_date'])),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Last Insurance Date:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text(LastInsuranceDate(
                                            _listofInsurance[index]
                                                ['insurance_date'],
                                            _listofInsurance[index]
                                                ['insurance_term'])),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Sum Insured:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                            '${_listofInsurance[index]['insurance_sum']}'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Premium Amount:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                            '${_listofInsurance[index]['insurance_premium']}'),
                                      ],
                                    ),
                                  ],
                                )),
                              )),
                              SizedBox(
                                height: 7,
                              ),
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
                                              _listofInsurance[index]
                                                  ['insurance_iid']);
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
                                                      color:
                                                          Color(0xfff007dfe)),
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
                                                        color: Color(
                                                            0xffffc0303))),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
                  backgroundColor: Color(0xfff007dfe),
                  onPressed: () {
                    _navigateforResult(context);
                  },
                  icon: Icon(
                    Icons.add,
                    color: Color(0xfffefefd),
                  ),
                  label: Text(
                    'Add Insurance',
                    style: TextStyle(color: Color(0xfffefefd)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
