import 'package:flutter/material.dart';
import 'package:flutter_app/component/drawer_menu.dart';
import './views/new_page.dart';
import './route/fade_route.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

void main() {
  // 设置日志输出级别
  Logger.root.level = Level.ALL;
  // 设置输出格式
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
  });
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new MyHomePage(title: '首页'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 1;
  String weather = "";

  final Logger log = new Logger("Main");

  void _incrementCounter() {
    log.info("当前按钮值: $_counter");
    setState(() {
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getHttp() async {
    try {
      Response response;
      response = await Dio().get(
          "https://restapi.amap.com/v3/weather/weatherInfo",
          data: {
            "key": "42167db31cf6a8ff6eeced37d5433a68",
            "city": "140105", // 城市编码:小店区
            "extensions": "all", //base:返回实况天气 all:返回预报天气
            "output": "JSON" //返回格式: JSON、XML
          });
      setState(() {
        weather = response.toString();
      });
      return print(response);
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[ //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      drawer: new DrawerMenu(), //抽屉
      bottomNavigationBar: BottomNavigationBar( // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('发现')),
          BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('学习')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.amber,
        onTap: _onItemTapped,
      ),
      floatingActionButton: new FloatingActionButton( //浮动按钮
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'You have pushed the button this many times:',
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  child: Text("下一页"),
                  color: Colors.amber,
                  onPressed: () {
                    //导航到新的路由
                    Navigator.push(context,
                        new FadeRoute(builder: (context) {
                          return new NewRoute();
                        }));
                  },
                ),
                new FlatButton(
                    onPressed: () {
                      this.getHttp();
                    },
                    child: Text("获取天气信息"),
                  color: Colors.blue,
                ),
                new FlatButton(
                    onPressed: () {
                      setState(() {
                        weather = "";
                      });
                    },
                    child: Text("清空数据"),
                  color: Colors.deepOrangeAccent,
                )
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(weather)
              ],
            )
          ],
        ),
      ),
    );
  }

}
