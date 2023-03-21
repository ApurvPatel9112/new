import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // Database Name and version details
  static final _databaseName = 'db_reminder.db';
  static final _databaseVersion = 1;

  // Tables
  static final table_login = 'table_login';
  static final table_vehicle = 'table_vehicle';
  static final table_reminder = 'table_reminder';
  static final table_reminder_insurance = 'table_reminder_insurance';
  static final table_insurance = 'table_insurance';

  // Login Data variable
  static final login_uid = 'login_uid';
  static final login_uemail = 'login_uemail';
  static final login_upassword = 'login_upassword';

  // vehicle Data variable
  static final vehicle_vid = 'vehicle_vid';
  static final vehicle_login_id = 'vehicle_login_id';
  static final vehicle_vtype = 'vehicle_vtype';
  static final vehicle_vnumber = 'vehicle_vnumber';
  static final vehicle_vmodel = 'vehicle_vmodel';
  static final vehicle_vcompany = 'vehicle_vcompany';

  // insurance Data variable
  static final insurance_iid = 'insurance_iid';
  static final insurance_login_id = 'insurance_login_id';
  static final insurance_company = 'insurance_company';
  static final insurance_type = 'insurance_type';
  static final insurance_members = 'insurance_members';
  static final insurance_date = 'insurance_date';
  static final insurance_premium = 'insurance_premium';
  static final insurance_sum = 'insurance_sum';
  static final insurance_term = 'insurance_term';

  // Reminder Data variable
  static final reminder_rid = 'reminder_rid';
  static final reminder_vehicle_id = 'reminder_vehicle_id';
  static final reminder_rname = 'reminder_rname';
  static final reminder_rdate = 'reminder_rdate';
  static final reminder_rtime = 'reminder_rtime';
  static final reminder_rrepeat = 'reminder_rrepeat';
  static final reminder_rtimestamp = 'reminder_rtimestamp';

  // Reminder Data variable for insurance
  static final reminder_iid = 'reminder_iid';
  static final reminder_insurance_id = 'reminder_insurance_id';
  static final reminder_iname = 'reminder_iname';
  static final reminder_idate = 'reminder_idate';
  static final reminder_itime = 'reminder_itime';
  static final reminder_irepeat = 'reminder_irepeat';
  static final reminder_itimestamp = 'reminder_itimestamp';

  //  Open Database and call all table creation functions
  static Future<sql.Database> db() async {
    return sql.openDatabase('$_databaseName', version: _databaseVersion,
        onCreate: (sql.Database database, int version) async {
      await createTableLogin(database);
      await createTableVehicle(database);
      await createTableReminder(database);
      await createTableReminderInsurance(database);
      await createTableInsurance(database);
    });
  }

  // Login Part
  // Create Login Table
  static Future<void> createTableLogin(sql.Database database) async {
    await database.execute('''
        CREATE TABLE $table_login(
        $login_uid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $login_uemail TEXT NOT NULL UNIQUE,
        $login_upassword TEXT
        );
        ''');
    print('Login Table is Created');
  }

// Insert data into Login Table
  static Future<int> addIntoTableLogin(
    String useremail,
    String userpassword,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      login_uemail: useremail,
      login_upassword: userpassword,
    };
    final id = await db.insert(table_login, data);
    print('$data');
    return id;
  }

  // to get all Data from Table Login
  static Future<List<Map<String, dynamic>>> getLoginData() async {
    final db = await SQLHelper.db();
    return db.query(table_login, orderBy: 'login_uid');
  }

  // to get single data from Table Login
  static Future<List<Map<String, dynamic>>> getUserfromLogin(int id) async {
    final db = await SQLHelper.db();
    return db.query(table_login,
        where: 'login_uid=?', whereArgs: [id], limit: 1);
  }

  // to get all reminders from specific vehicleId
  static Future<List<Map<String, dynamic>>> getAllVehiclesbyLoginid(
      int id) async {
    final db = await SQLHelper.db();
    return await db.rawQuery('''
    SELECT * FROM $table_vehicle WHERE $vehicle_login_id = $id
    ''');
  }

  // to get all reminders from specific InsuranceId
  static Future<List<Map<String, dynamic>>> getAllInsurancebyLoginid(
      int id) async {
    final db = await SQLHelper.db();
    return await db.rawQuery('''
    SELECT * FROM $table_insurance WHERE $insurance_login_id = $id
    ''');
  }

  // Vehicle Part
  // Create Vehicle table
  static Future<void> createTableVehicle(sql.Database database) async {
    await database.execute('''CREATE TABLE $table_vehicle(
      $vehicle_vid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $vehicle_login_id INTEGER NOT NULL,
      $vehicle_vtype TEXT NOT NULL,
      $vehicle_vnumber TEXT NOT NULL,
      $vehicle_vcompany TEXT,
      $vehicle_vmodel TEXT,
      FOREIGN KEY($vehicle_vid) REFERENCES $table_login($login_uid)
    );
    ''');
    print('Vehicle Table is Created');
  }

  // Create Insurance table
  static Future<void> createTableInsurance(sql.Database database) async {
    await database.execute('''CREATE TABLE $table_insurance(
      $insurance_iid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $insurance_login_id INTEGER NOT NULL,
      $insurance_company TEXT NOT NULL,
      $insurance_type TEXT NOT NULL,
      $insurance_members INTEGER NOT NULL,
      $insurance_date TEXT,
      $insurance_premium INTEGER NOT NULL,
      $insurance_sum INTEGER NOT NULL,
      $insurance_term INTEGER NOT NULL,
      FOREIGN KEY($insurance_iid) REFERENCES $table_login($login_uid)
    );
    ''');
    print('Insurance Table is Created');
  }

  // Insert data into vehicle Table
  static Future<int> addIntoTableVehicle(
    int vehicleloginid,
    String vehicletype,
    String vehiclenumber,
    String vehiclemodel,
    String vehiclecompany,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      vehicle_login_id: vehicleloginid,
      vehicle_vtype: vehicletype,
      vehicle_vnumber: vehiclenumber,
      vehicle_vmodel: vehiclemodel,
      vehicle_vcompany: vehiclecompany,
    };
    final id = await db.insert(table_vehicle, data);
    print('$data');
    return id;
  }

  // Insert data into insurance Table
  static Future<int> addIntoTableInsurance(
    int insuranceloginid,
    String insuranceCompany,
    String insuranceType,
    String insuranceMembers,
    String insuranceDate,
    String insurancePremium,
    String insuranceSum,
    String insuranceTerm,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      insurance_login_id: insuranceloginid,
      insurance_company: insuranceCompany,
      insurance_type: insuranceType,
      insurance_members: insuranceMembers,
      insurance_date: insuranceDate,
      insurance_premium: insurancePremium,
      insurance_sum: insuranceSum,
      insurance_term: insuranceTerm,
    };
    final id = await db.insert(table_insurance, data);
    print('$data');
    return id;
  }

  // to get all Data from Table Vehicle
  static Future<List<Map<String, dynamic>>> getVehicles() async {
    final db = await SQLHelper.db();
    return db.query(table_vehicle, orderBy: 'vehicle_vid');
  }

  // to get single data from Table Vehicle
  static Future<List<Map<String, dynamic>>> getSingleVehicle(int id) async {
    final db = await SQLHelper.db();
    return db.query(table_vehicle,
        where: ' vehicle_vid=?', whereArgs: [id], limit: 1);
  }

  //delete any single data of Table Vehicle
  static Future<void> deleteVehicle(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(table_vehicle, where: 'vehicle_vid = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }

  // to get all Data from insurance Login
  static Future<List<Map<String, dynamic>>> getInsurances() async {
    final db = await SQLHelper.db();
    return db.query(table_insurance, orderBy: 'insurance_iid');
  }

  // to get single data from Table Login
  static Future<List<Map<String, dynamic>>> getSingleInsurance(int id) async {
    final db = await SQLHelper.db();
    return db.query(table_insurance,
        where: 'insurance_iid=?', whereArgs: [id], limit: 1);
  }

  // to get all Data from Table Insurance
  static Future<List<Map<String, dynamic>>> getInsuranceReminders() async {
    final db = await SQLHelper.db();
    return db.query(table_reminder_insurance, orderBy: 'reminder_iid');
  }

  //update any single data of Table Vehicle
  static Future<int> updateVehicle(
    int vehicleid,
    int vehicleloginid,
    String vehicletype,
    String vehiclenumber,
    String vehiclemodel,
    String vehiclecompany,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      vehicle_login_id: vehicleloginid,
      vehicle_vtype: vehicletype,
      vehicle_vnumber: vehiclenumber,
      vehicle_vmodel: vehiclemodel,
      vehicle_vcompany: vehiclecompany,
    };

    final result = await db.update(table_vehicle, data,
        where: 'vehicle_vid = ?', whereArgs: [vehicleid]);
    return result;
  }

  //update existing insurance function
  static Future<int> updateInsurance(
    int insurance_id,
    int insuranceloginid,
    String insurancecompany,
    String insurancetype,
    String insurancemembers,
    String insurancedate,
    String insurancepremium,
    String insurancesum,
    String insuranceterm,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      insurance_login_id: insuranceloginid,
      insurance_company: insurancecompany,
      insurance_type: insurancetype,
      insurance_members: insurancemembers,
      insurance_date: insurancedate,
      insurance_premium: insurancepremium,
      insurance_sum: insurancesum,
      insurance_term: insuranceterm,
    };

    final result = await db.update(table_insurance, data,
        where: 'insurance_iid = ?', whereArgs: [insurance_id]);
    return result;
  }

  // Reminder Part
  // Create Reminder Table
  static Future<void> createTableReminder(sql.Database database) async {
    await database.execute('''
      CREATE TABLE $table_reminder(
      $reminder_rid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $reminder_vehicle_id INTEGER NOT NULL,
      $reminder_rname TEXT NOT NULL,
      $reminder_rdate TEXT,
      $reminder_rtime TEXT,
      $reminder_rrepeat TEXT,
      $reminder_rtimestamp TEXT,
      FOREIGN KEY($reminder_rid) REFERENCES $table_vehicle($vehicle_vid)
      );
    ''');
    print('Reminder Table is Created');
  }

  // Create Reminder Table for insurance
  static Future<void> createTableReminderInsurance(
      sql.Database database) async {
    await database.execute('''
      CREATE TABLE $table_reminder_insurance(
      $reminder_iid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $reminder_insurance_id INTEGER NOT NULL,
      $reminder_iname TEXT NOT NULL,
      $reminder_idate TEXT,
      $reminder_itime TEXT,
      $reminder_irepeat TEXT,
      $reminder_itimestamp TEXT,
      FOREIGN KEY($reminder_iid) REFERENCES $table_insurance($insurance_iid)
      );
    ''');
    print('Reminder Table Insurance is Created');
  }

  //add data to reminder table of insurance
  static Future<int> addIntoTableReminderInsurance(
      int reminder_insuranceid,
      String remindertext,
      String reminderdate,
      String remindertime,
      String reminderrepeat,
      String remindertimestamp) async {
    final db = await SQLHelper.db();
    final data = {
      reminder_insurance_id: reminder_insuranceid,
      reminder_iname: remindertext,
      reminder_idate: reminderdate,
      reminder_itime: remindertime,
      reminder_irepeat: reminderrepeat,
      reminder_itimestamp: remindertimestamp
    };
    final id = await db.insert(table_reminder_insurance, data);
    print('$data');
    return id;
  }

  // to get all Data from Table Reminder
  static Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await SQLHelper.db();
    return db.query(table_reminder, orderBy: 'reminder_rid');
  }

  // to get single data from Table Vehicle
  static Future<List<Map<String, dynamic>>> getSingleReminder(int id) async {
    final db = await SQLHelper.db();
    return db.query(table_reminder,
        where: 'reminder_rid =?', whereArgs: [id], limit: 1);
  }

  // to get all reminders from specific vehicleId
  static Future<List<Map<String, dynamic>>> getAllReminderByVehicleId(
      int id) async {
    final db = await SQLHelper.db();
    return await db.rawQuery('''
    SELECT * FROM $table_reminder WHERE $reminder_vehicle_id = $id ORDER BY $reminder_rid DESC
    ''');
  }

// Insert data into Table Reminder
  static Future<int> addIntoTableReminder(
      int reminder_vehicleid,
      String remindertext,
      String reminderdate,
      String remindertime,
      String reminderrepeat,
      String remindertimestamp) async {
    final db = await SQLHelper.db();
    final data = {
      reminder_vehicle_id: reminder_vehicleid,
      reminder_rname: remindertext,
      reminder_rdate: reminderdate,
      reminder_rtime: remindertime,
      reminder_rrepeat: reminderrepeat,
      reminder_rtimestamp: remindertimestamp
    };
    final id = await db.insert(table_reminder, data);
    print('$data');
    return id;
  }

  //update any single data of Table Reminder
  static Future<int> updateReminder(
    int reminderid,
    int updated_reminder_vehicleid,
    String updated_remindertext,
    String updated_reminderdate,
    String updated_remindertime,
    String updated_reminderrepeat,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      reminder_vehicle_id: updated_reminder_vehicleid,
      reminder_rname: updated_remindertext,
      reminder_rdate: updated_reminderdate,
      reminder_rtime: updated_remindertime,
      reminder_rrepeat: updated_reminderrepeat,
    };

    final result = await db.update(table_reminder, data,
        where: 'reminder_rid = ?', whereArgs: [reminderid]);
    return result;
  }

  //delete any single data of Table Vehicle
  static Future<void> deleteReminder(int id) async {
    final db = await SQLHelper.db();
    try {
      await db
          .delete(table_reminder, where: 'reminder_rid = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }

  // to get single data from Table Insurance
  static Future<List<Map<String, dynamic>>> getSingleReminderInsurance(
      int id) async {
    final db = await SQLHelper.db();
    return db.query(table_reminder_insurance,
        where: 'reminder_iid =?', whereArgs: [id], limit: 1);
  }

  //to delete an insurance
  static Future<void> deleteInsurance(int id) async {
    final db = await SQLHelper.db();
    try {
      await db
          .delete(table_insurance, where: 'insurance_iid = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }

  // to get all reminders from specific InsuranceId
  static Future<List<Map<String, dynamic>>> getAllReminderByInsuranceId(
      int id) async {
    final db = await SQLHelper.db();
    return await db.rawQuery('''
    SELECT * FROM $table_reminder_insurance WHERE $reminder_insurance_id = $id
    ''');
  }

  //update reminder of insurance section
  static Future<int> updateReminderInsurance(
    int reminderid,
    int updated_reminder_insuranceid,
    String updated_remindertext,
    String updated_reminderdate,
    String updated_remindertime,
    String updated_reminderrepeat,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      reminder_insurance_id: updated_reminder_insuranceid,
      reminder_iname: updated_remindertext,
      reminder_idate: updated_reminderdate,
      reminder_itime: updated_remindertime,
      reminder_irepeat: updated_reminderrepeat,
    };

    final result = await db.update(table_reminder_insurance, data,
        where: 'reminder_iid = ?', whereArgs: [reminderid]);
    return result;
  }

  //delete any single data of Table insurance
  static Future<void> deleteReminderInsurance(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(table_reminder_insurance,
          where: 'reminder_iid = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }
}
