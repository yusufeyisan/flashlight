import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_torch/flutter_torch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashligth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Yeon Sung"),
      home: MyHomePage(title: 'Flashligth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color textColor = new Color.fromARGB(255, 112, 112, 112);
  final Color backgroundColor = new Color.fromARGB(255, 255, 205, 41);
  final Color circleSwitchBackgroundColor =
      new Color.fromARGB(255, 255, 205, 41);
  final Color circleSwitchBorderColor = new Color.fromARGB(255, 229, 143, 43);
  final Color switchHubBackgrounColor = new Color.fromARGB(255, 255, 244, 208);
  final Color switchHubBorderColor = new Color.fromARGB(255, 211, 164, 11);
  final Color switchHubShadowColor = new Color.fromARGB(255, 214, 172, 34);

  final double switchHubBorderOffsetOFF = 10;
  final double switchHubBorderOffsetON = -10;
  double switchHubBorderOffset = 10;

  static const buttonTitleOn = "ON";
  static const buttonTitleOff = "OFF";

  @override
  void initState() {
    super.initState();
    initTorchState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        shadowColor: switchHubShadowColor,
        title: Text(
          "Flashlight",
          style: TextStyle(color: textColor, fontSize: 30),
        ),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: buildswitchHubContainer(),
      ),
    );
  }

  flashlightSwither(String button) {
    setState(() {
      switch (button) {
        case buttonTitleOff:
          switchHubBorderOffset = switchHubBorderOffsetOFF;
          FlutterTorch.turnOff();
          break;
        case buttonTitleOn:
          switchHubBorderOffset = switchHubBorderOffsetON;
          FlutterTorch.turnOn();
          break;
        default:
      }
    });
  }

  Container buildswitchHubContainer() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCircleContainer(buttonTitleOff, EdgeInsets.only(top: 15)),
          Container(
            height: 3,
            color: switchHubBorderColor,
          ),
          buildCircleContainer(buttonTitleOn, EdgeInsets.only(bottom: 15))
        ],
      ),
      decoration: buildSwitchHubBoxDecoration(),
      height: 250,
      width: 116,
    );
  }

  BoxDecoration buildSwitchHubBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(58),
      border: Border.all(color: switchHubBorderColor, width: 3),
      color: switchHubBackgrounColor,
      boxShadow: [
        BoxShadow(
          color: switchHubShadowColor.withOpacity(1),
          spreadRadius: 3,
          blurRadius: 10,
          offset:
              Offset(0, switchHubBorderOffset), // changes position of shadow
        )
      ],
    );
  }

  Container buildCircleContainer(
      String buttonTitle, EdgeInsetsGeometry margin) {
    return Container(
      margin: margin,
      height: 85,
      width: 85,
      child: Center(
        child: FlatButton(
          onPressed: () {
            flashlightSwither(buttonTitle);
          },
          child: Text(
            buttonTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: circleSwitchBorderColor, width: 3),
        color: circleSwitchBackgroundColor,
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initTorchState() async {
    bool deviceHasLamb = false;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceHasLamb = await FlutterTorch.hasLamp;
    } on PlatformException {
      deviceHasLamb = false;
    }

    setState(() {
      if (deviceHasLamb) {
        switchHubBorderOffset = switchHubBorderOffsetOFF;
        FlutterTorch.turnOff();
      }
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }
}
