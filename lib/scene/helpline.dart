import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:coronavirus_test/localization.dart';

class HelplineScreen extends StatefulWidget {
  HelplineScreen({Key key}) : super(key: key);

  @override
  _HelplineScreenState createState() => _HelplineScreenState();
}

class _HelplineScreenState extends State {
  bool isLoggedIn = false;
  bool isLoading = true;
  PageController controller = PageController(viewportFraction: 1);

  var stateHelpline = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    var st = await rootBundle.loadString('assets/helpline_state.json');

    this.setState(() {
      stateHelpline = jsonDecode(st);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            AppLocalizations.of(context).translate('helpline_numbers_key'),
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          bottomOpacity: 0.0,
        ),
        body: Container(
            child: ListView.separated(
          itemCount: stateHelpline.length,
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
            );
          },
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${stateHelpline[index]['state']}'),
              subtitle: Text('${stateHelpline[index]['no']}'),
              trailing: IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    var phone = stateHelpline[index]['no'];
                    _makePhoneCall('tel:$phone');
                  }),
            );
          },
        ))));
  }

  _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
