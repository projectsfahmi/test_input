import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:test_input/views/dashboard.dart';

import '../models/user_model.dart';
import '../widgets/dialogs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late UserModel userModel = new UserModel(
    "FAHMI",
    18,
    new List<String>.empty(growable: true),
  );

  @override
  void initState() {
    super.initState();

    userModel.emails.add("");
  }


  doLogin(jsonOutput) async {
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


      // List<dynamic> ListData = [{"UserName":"FAHMI","UserAge":18,"Emails":["WILIS@GMAIL.COM","FAHMI@GMAIL.COM"]}];
      // List<dynamic> ListData = [jsonEncode(userModel.toJson())];
      // var json = jsonEncode(ListData);

      var json = jsonEncode([userModel.toJson()]);
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
          saveSession("2016010807");
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
        builder: (BuildContext context) => const DashboardPage(),
      ),
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Form"),
        backgroundColor: Colors.redAccent,
      ),
      body: _uiWidget(),
    );
  }

  Widget _uiWidget() {
    return new Form(
      key: globalFormKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: FormHelper.inputFieldWidgetWithLabel(
                  context,
                  "name",
                  "User Name Input",
                  "",
                      (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return 'User Name can\'t be empty.';
                    }

                    return null;
                  },
                      (onSavedVal) => {
                    this.userModel.userName = onSavedVal,
                  },
                  initialValue: this.userModel.userName,
                  obscureText: false,
                  borderFocusColor: Theme.of(context).primaryColor,
                  prefixIconColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 2,
                  paddingLeft: 0,
                  paddingRight: 0,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.web),
                  fontSize: 13,
                  labelFontSize: 13,
                  onChange: (val) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: FormHelper.inputFieldWidgetWithLabel(
                  context,
                  "name",
                  "Age",
                  "",
                      (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return 'Age can\'t be empty.';
                    }

                    return null;
                  },
                      (onSavedVal) => {
                    this.userModel.userAge = int.parse(onSavedVal),
                  },
                  initialValue: this.userModel.userAge.toString(),
                  obscureText: false,
                  borderFocusColor: Theme.of(context).primaryColor,
                  prefixIconColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 2,
                  paddingLeft: 0,
                  paddingRight: 0,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.web),
                  fontSize: 13,
                  labelFontSize: 13,
                  onChange: (val) {},
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Email Address(s)",
                      textAlign: TextAlign.left,
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  emailsContainerUI(),
                  new Center(
                    child: FormHelper.submitButton(
                      "Save",
                          () async {
                        if (validateAndSave()) {
                          // print(this.userModel.toJson());
                          doLogin([jsonEncode(userModel.toJson())]);
                          // print(jsonEncode(userModel.toJson()));
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailsContainerUI() {
    return ListView.separated(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: this.userModel.emails.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Row(children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: emailUI(index),
              ),
            ]),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget emailUI(index) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: FormHelper.inputFieldWidget(
              context,
              "email_$index",
              "",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Email ${index + 1} can\'t be empty.';
                }

                return null;
              },
                  (onSavedVal) => {
                this.userModel.emails[index] = onSavedVal,
              },
              initialValue: this.userModel.emails[index],
              obscureText: false,
              borderFocusColor: Theme.of(context).primaryColor,
              prefixIconColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              borderRadius: 2,
              paddingLeft: 0,
              paddingRight: 0,
              showPrefixIcon: true,
              prefixIcon: Icon(Icons.web),
              fontSize: 13,
              onChange: (val) {},
            ),
          ),
          Visibility(
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.green,
                ),
                onPressed: () {
                  addEmailControl();
                },
              ),
            ),
            visible: index == this.userModel.emails.length - 1,
          ),
          Visibility(
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  removeEmailControl(index);
                },
              ),
            ),
            visible: index > 0,
          )
        ],
      ),
    );
  }

  void addEmailControl() {
    setState(() {
      this.userModel.emails.add("");
    });
  }

  void removeEmailControl(index) {
    setState(() {
      if (this.userModel.emails.length > 1) {
        this.userModel.emails.removeAt(index);
      }
    });
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
