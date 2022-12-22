import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_input/views/profile_page.dart';

import '../widgets/dialogs.dart';

class MsEmployee extends StatefulWidget {
  const MsEmployee({Key? key}) : super(key: key);

  @override
  _MsEmployeeState createState() => _MsEmployeeState();
}

class HeadClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _MsEmployeeState extends State<MsEmployee> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var txtEmpCode = TextEditingController();
  var txtEmpName = TextEditingController();
  var txtEmpAddress = TextEditingController();

  Widget inputEmployeeCode() {
    return TextFormField(
        cursorColor: Colors.white,
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (String? arg) {
          if (arg == null || arg.isEmpty) {
            return 'Employee Code harus diisi';
          } else {
            return null;
          }
        },
        controller: txtEmpCode,
        onSaved: (String? val) {
          txtEmpCode.text = val!;
        },
        decoration: InputDecoration(
          hintText: 'Masukkan Employee Code',
          hintStyle: const TextStyle(color: Colors.white),
          labelText: "Masukkan Employee Code",
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
        style: const TextStyle(fontSize: 16.0, color: Colors.white));
  }

  Widget inputEmployeeName() {
    return TextFormField(
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      autofocus: false,
      obscureText: false,
      //make decript inputan
      validator: (String? arg) {
        if (arg == null || arg.isEmpty) {
          return 'Employee Name harus diisi';
        } else {
          return null;
        }
      },
      controller: txtEmpName,
      onSaved: (String? val) {
        txtEmpName.text = val!;
      },
      decoration: InputDecoration(
        hintText: 'Masukkan Employee Name',
        hintStyle: const TextStyle(color: Colors.white),
        labelText: "Masukkan Employee Name",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }

  Widget inputEmployeeAddress() {
    return TextFormField(
      cursorColor: Colors.white,
      keyboardType: TextInputType.streetAddress,
      autofocus: false,
      obscureText: false,
      //make decript inputan
      validator: (String? arg) {
        if (arg == null || arg.isEmpty) {
          return 'Password harus diisi';
        } else {
          return null;
        }
      },
      controller: txtEmpAddress,
      onSaved: (String? val) {
        txtEmpAddress.text = val!;
      },
      decoration: InputDecoration(
        hintText: 'Masukkan Alamat',
        hintStyle: const TextStyle(color: Colors.white),
        labelText: "Masukkan Alamat",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(
          FontAwesomeIcons.solidAddressBook,
          color: Colors.white,
        ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }


  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      doLogin(txtEmpCode.text, txtEmpName.text, txtEmpAddress.text);
    }
  }

  doLogin(empCode, empName, empAddress) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();
    Dialogs.loading(context, _keyLoader, "Proses ...");

    try {
      final _baseurl = 'https://api.fahmi-rifai.com/api-shareme/api/master/cprofile';

      final prefs = await SharedPreferences.getInstance();
      // read
      final myToken = prefs.getString('token') ?? '';
      Map<String, String> _header = <String, String>{
        'x-api-key': 'surgika123',
        'Authorization' : myToken
      };

      List<dynamic> ListData = [{"UserName": empCode,"UserAge":empName,"Emails":[empAddress]}];
      var json = jsonEncode(ListData);
       print(json);

      final response = await http.post(Uri.parse(_baseurl),
          headers: _header,
          body: json);

      final output = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                output['message'],
                style: const TextStyle(fontSize: 16),
              )),
        );

        if (output['status'] == true) {
          saveSession(empCode);
        }
        //debugPrint(output['message']);
      } else {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        //debugPrint(output['message']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                output.toString(),
                style: const TextStyle(fontSize: 16),
              )),
        );
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
      Dialogs.popUp(context, '$e');
      debugPrint('$e');
    }
  }

  saveSession(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("email", email);
    await pref.setBool("is_login", true);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ProfilePage(),
      ),
          (route) => false,
    );
  }

  void ceckLogin() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // var islogin = pref.getBool("is_login");
    // if (islogin != null && islogin) {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => const DashboardPage(),
    //     ),
    //         (route) => false,
    //   );
    // }
  }

  @override
  void initState() {
    ceckLogin();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        margin: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent, Color.fromARGB(255, 21, 236, 229)],
            )),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ClipPath(
                clipper: HeadClipper(),
                child: Container(
                  margin: const EdgeInsets.all(0),
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo-white-sm.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  "Master Karyawan",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding:
                  const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      inputEmployeeCode(),
                      const SizedBox(height: 20.0),
                      inputEmployeeName(),
                      const SizedBox(height: 20.0),
                      inputEmployeeAddress()
                    ],
                  )),
              Container(
                padding:
                const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(color: Colors.blue),
                        ),
                        elevation: 10,
                        minimumSize: const Size(200, 58)),
                    onPressed: () => _validateInputs(),
                    icon: const Icon(Icons.arrow_right_alt),
                    label: const Text(
                      "LOG IN",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
