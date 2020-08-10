import 'package:ark/common/sp_constant.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/routers/routers.dart';
import 'package:ark/ui/project_list.dart';
import 'package:ark/utils/utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'mine.dart';

class MainProject extends StatefulWidget {
  @override
  MainProjectState createState() => new MainProjectState();
}

class MainProjectState extends State<MainProject> {
  int _current = 0;
  List<Widget> list = List<Widget>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Image.asset(
                Utils.getImgPath('ic_desk_normal'),
                width: 17,
                height: 17,
              ),
              title: Text('桌面'),
              activeIcon: Image.asset(
                Utils.getImgPath('ic_desk_selected'),
                width: 34,
                height: 34,
              )),
          BottomNavigationBarItem(
              icon: Image.asset(Utils.getImgPath('ic_mine_normal'),
                  width: 17, height: 17),
              title: Text('我的'),
              activeIcon: Image.asset(
                Utils.getImgPath('ic_mine_selected'),
                width: 34,
                height: 34,
              ))
        ],
        onTap: (int index) {
          setState(() {
            _current = index;
            if(_current==0){

            }
          });
        },
        fixedColor: Colors.blue,
      ),
      body: list[_current],
    );
  }

  @override
  void initState() {
    super.initState();
    list.add(new ProjectListPage());
    list.add(new Mine());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
