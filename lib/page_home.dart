import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'page_addClass.dart';
import 'mydrawer.dart';

class ClassPage extends StatefulWidget {

  ClassPage({@required this.refreshApp});
  final refreshApp;
  @override
  _ClassPageState createState() => new _ClassPageState();
}

class _ClassPageState extends State<ClassPage>{

  int selectSex=2;
  int randomTrue=0;
  int selectNum=1;

  int groupNum=2;
  int groupRandom=0;

  int week=0;

  String temp="15";
  String tag="晴";
  Widget _drawer;

  //welcome
  int all =0;
  int should=0;
  int sign=0;
  String classRoom="无课";
  //courseList
  int courseLength=0;

  @override
  void initState() {
    super.initState();
    _drawer=MyDrawer();
    if(DataProvider.todayWeek==-1){
      DateTime now = new DateTime.now();
      week=now.weekday;
    }
    var url = "http://wthrcdn.etouch.cn/weather_mini?city=台中";
    http.readBytes(url).then((repo){
      String rePo=utf8.decode(repo);
      JsonDecoder jsonDecoder=new JsonDecoder();
      Map<String, dynamic> res=jsonDecoder.convert(rePo);
      Map<String, dynamic> data=res["data"];
      List<dynamic> tags=data["forecast"];
      tag=tags[0]["type"];
      temp=data["wendu"];
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(DataProvider.refreshHome){
      classRoom=DataProvider.courseList[(DataProvider.showCourseRow-1)*5+DataProvider.todayWeek-1]["className"];
      print("Refresh home");
      all=DataProvider.showStudents.length;
      should=all;
      sign=all;
      int allLeave=0;
      int allAbsence=0;
      DataProvider.showStudents.forEach((e){
        if(!e.notLeave)//请假时应到人数减一
          allLeave+=1;
        if(!e.notAbsence)
          allAbsence+=1;
      });
      should=all-allLeave;
      sign=all-allAbsence;
      courseLength=DataProvider.todayCourseList.length;
      DataProvider.refreshHome=false;
    }


    return Scaffold(
      drawer: _drawer,
      appBar:
      PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child:
          AppBar(
              elevation: 2,
              titleSpacing: 20,
              centerTitle:false,
              title: Text(Config.barCate[1],style: new TextStyle(fontFamily: Config.font,)),
              actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(Icons.add),
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AddClassPage();
                        });
                  },
                )
              ]
          )
      ),
      backgroundColor:Config.appBackground,
      body: ListView(
            children: <Widget>[
              _buildWelcome(0,"寧寧"),
              _buildCourseList(1,'f'),
              _buildGroup(2,"hello"),
              _buildSelect(3,"你好"),
            ]
        ),
    );
  }

  Widget _buildWelcome(int index,String username){
    return  Card(
      clipBehavior: Clip.antiAlias,
      color: Config.itemColors[index],
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(10,10,10,2),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 6)),
          Row(children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 25)),
            Expanded(
              child: Text(DataProvider.year.toString()+" 年 "+DataProvider.month.toString()+" 月 "+DataProvider.day.toString()+" 號",style: TextStyle(fontSize: 16),textAlign: TextAlign.start,),
              flex: 2,
            ),
            Expanded(
                child: Text("歡迎您：$username ",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
                flex: 2),
            Padding(padding: EdgeInsets.only(right: 25))
          ]
          ),
          Padding(padding: EdgeInsets.only(top: 3)),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color:Colors.blue,
            height: 1,
          ),
          Row(children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 15),),
            Expanded(
              child: Text(classRoom+"    总人数：$all人\n应到：$should      已到：$sign",textAlign: TextAlign.start,),
              flex: 2,
            ),
            Text("臺中\n$temp℃"),
            Expanded(
              child:IconButton(
                  icon:_buildIcon(),
                  onPressed: () {
                  },
                ),
              flex:0
              ),
            Padding(padding: EdgeInsets.only(right: 15),)
          ],),
          Padding(padding: EdgeInsets.only(bottom: 5.0),)
        ],
      ),
    );
  }

  Icon _buildIcon(){
    switch(tag){
      case "晴":return Icon(Icons.wb_sunny,size: 40,color: Colors.yellow,);
      case "阴":return Icon(Icons.wb_cloudy,size: 40,color: Colors.grey,);
      case "多云":return Icon(Icons.wb_cloudy,size: 40,color: Colors.white,);
      case "中雨":
      case "大雨":
      case "小雨":return Icon(Icons.add,size: 40,color: Colors.yellow,);
    }
    return Icon(Icons.wb_sunny,size: 40,color: Colors.yellow,);
  }

  Widget _buildCourseList(int index,String username){
    String todayCourse='';
    DataProvider.todayCourseList.forEach((row){
      todayCourse+="第$row节 : "+DataProvider.courseList[(row-1)*5+DataProvider.todayWeek-1]["className"]+'    '+DataProvider.courseList[(row-1)*5+DataProvider.todayWeek-1]["courseName"]+'\n';
    });
    String da=Config.weekDays[week];
    return  Card(
      clipBehavior: Clip.antiAlias,
      color: Config.itemColors[index],
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(10,10,10,0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 6)),
          Row(children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 25)),
            Expanded(
              child: Text("$da",style: TextStyle(fontSize: 16),textAlign: TextAlign.start,),
              flex: 7,
            ),
            Expanded(
                child: Text("今日共：$courseLength节 ",style: TextStyle(fontSize: 16),textAlign: TextAlign.left,),
                flex: 10),
            Padding(padding: EdgeInsets.only(right: 25))
          ]
          ),
          Padding(padding: EdgeInsets.only(top: 3)),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color:Colors.blue,
            height: 1,
          ),
          Row(children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 15),),
            Expanded(
              child: Text(todayCourse,textAlign: TextAlign.start,),
              flex: 2,
            ),
//            Text("臺中\n10.5'C"),
            Expanded(
                child:Container(
                  height: 50,
                ),
                flex:0
            ),
            Padding(padding: EdgeInsets.only(right: 15),)
          ],),
          Padding(padding: EdgeInsets.only(bottom: 5.0),)
        ],
      ),
    );
  }

  Widget _buildGroup(int index,String username){
    return  Card(
      clipBehavior: Clip.antiAlias,
      color: Config.itemColors[index],
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(10,10,10,0),
      child:Row(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("分\n組",style: TextStyle(fontSize:18 ),textAlign: TextAlign.start,),
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          color:Colors.green,
          width: 1,
          height: 60,
        ),
        Expanded(
            child:
            Column(children: <Widget>[
              Row(children: <Widget>[
                Radio(
                    value: 0,
                    groupValue: groupRandom,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (T){
                      setState(() {
                        groupRandom=T;
                      });
                    }
                ),
                Text("绝对随机"),
              ],
              ),
              Row(children: <Widget>[
                Radio(
                    value: 1,
                    groupValue: groupRandom,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (T){
                      setState(() {
                        groupRandom=T;
                      });
                    }
                ),
                Text("均衡成績"),
              ],
              ),
            ],
            ),
            flex:0
        ),
        Container(
          margin: EdgeInsets.only(left: 6,right: 5),
          color:Colors.green,
          width: 1,
          height: 60,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text("小組人数"),
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonHideUnderline(
                  child:DropdownButton(
                    items: selectNumberItem(2,10),
                    value: groupNum,//下拉菜单选择完之后显示给用户的值
                    onChanged: (T){//下拉菜单item点击之后的回调
                      setState(() {
                        groupNum=T;
                      });
                    },
                    style: TextStyle(//设置文本框里面文字的样式
                        color: Colors.blue
                    ),
                    iconSize: 25.0,//设置三角标icon的大小
                  ),
                ),
              )
            ],
          ),
              flex: 0,
        ),
        Expanded(
          child: Container(),
          flex: 1,
        ),
        Expanded(
            child:IconButton(
              color: Colors.black,
              icon: Icon(Icons.people,size: 35,color: Colors.blue,),
              onPressed: () {
              },
            ),
            flex:0
        ),
        Padding(padding: EdgeInsets.only(right: 15),)
      ],
      ),
    );
  }

  Widget _buildSelect(int index,String username){
    return  Card(
      clipBehavior: Clip.antiAlias,
      color: Config.itemColors[index],
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(10,8,10,0),
      child: Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("隨\n機\n檢\n查",style: TextStyle(fontSize:18 ),textAlign: TextAlign.start,),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              color:Colors.pink,
              width: 1,
              height: 100,
            ),
            Expanded(
              child:
                Column(children: <Widget>[
                      Row(children: <Widget>[
                          Radio(
                              value: 0,
                              groupValue: selectSex,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onChanged: (T){
                                setState(() {
                                  selectSex=T;
                                });
                              }
                          ),
                          Text("男生"),
                        ],
                      ),
                      Row(children: <Widget>[
                        Radio(
                            value: 1,
                            groupValue: selectSex,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onChanged: (T){
                              setState(() {
                                selectSex=T;
                              });
                            }
                        ),
                        Text("女生"),
                      ],
                      ),
                      Row(children: <Widget>[
                        Radio(
                            value: 2,
                            groupValue: selectSex,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onChanged: (T){
                              setState(() {
                                selectSex=T;
                              });
                            }
                        ),
                        Text("全體"),
                      ],
                      ),
                    ],
                ),
                flex:0
            ),
            Expanded(
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Row(children: <Widget>[
                    Radio(
                        value: 0,
                        groupValue: randomTrue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (T){
                          setState(() {
                            randomTrue=T;
                          });
                        }
                    ),
                    Text("绝对随机"),
                  ],
                  ),
                  Row(children: <Widget>[
                    Radio(
                        value: 1,
                        groupValue: randomTrue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (T){
                          setState(() {
                            randomTrue=T;
                          });
                        }
                    ),
                    Text("成绩加权"),
                  ],
                  ),
                  Row(children: <Widget>[
                    Radio(
                        value: 2,
                        groupValue: randomTrue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (T){
                          setState(() {
                            randomTrue=T;
                          });
                        }
                    ),
                    Text("全體"),
                  ],
                  ),
                ],
                ),
                flex:0
            ),
            Container(
              margin: EdgeInsets.only(left: 6,right: 5),
              color:Colors.pink,
              width: 1,
              height: 100,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text("抽取人数"),
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonHideUnderline(
                       child:DropdownButton(
                        items: selectNumberItem(1,all),
                        value: selectNum,//下拉菜单选择完之后显示给用户的值
                        onChanged: (T){//下拉菜单item点击之后的回调
                          setState(() {
                            selectNum=T;
                          });
                        },
                        style: TextStyle(//设置文本框里面文字的样式
                            color: Colors.blue
                        ),
                        iconSize: 25.0,//设置三角标icon的大小
                      ),
                    ),
                )
                ],
              ),
              flex: 0,
            ),
            Expanded(
              child: Container(),
              flex: 1,
            ),
            Expanded(
                child:IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.send,size: 35,color: Colors.blue,),
                  onPressed: () {
                  },
                ),
                flex:0
            ),
            Padding(padding: EdgeInsets.only(right: 15),)
          ],
        ),
    );
  }

  List<DropdownMenuItem> selectNumberItem(int start,int end){
    List<DropdownMenuItem> items=new List();
    if(start>end){
      end=start;
    }
    for(;start<=end;start++){
      DropdownMenuItem dropdownMenuItem=new DropdownMenuItem(
        child:new Text("$start",),
        value: start,
      );
      items.add(dropdownMenuItem);
    }
    return items;
  }

}
