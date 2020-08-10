import 'package:ark/model/detail_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailRelationTab extends StatefulWidget {
  @override
  DetailRelationTabState createState() => new DetailRelationTabState();
}

class DetailRelationTabState extends State<DetailRelationTab> {
  @override
  Widget build(BuildContext context) {

    DetailModel model=  Provider.of<DetailModel>(context,listen: false);
    return new Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            model.update('傻逼吧你');
          },
          child: Text('修改'),
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}