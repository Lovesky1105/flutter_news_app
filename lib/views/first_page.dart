import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/views/homepage.dart';
import 'package:newsapplication/views/login_page.dart';
import 'package:newsapplication/views/register_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  void loginCallback(BuildContext context) {
    // Code to handle the login callback
    // For simplicity, this example directly navigates to the home page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                key: UniqueKey(),
              )),
    );
  }

  void registerCallback(BuildContext context) {
    // Code to handle the login callback
    // For simplicity, this example directly navigates to the home page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(onTap: () => loginCallback(context))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20, // Increase the font size
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText("Welcome"),
                    RotateAnimatedText("欢迎"),
                    RotateAnimatedText("いらっしゃいませ"),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "To News",
                style: TextStyle(color: Colors.orange[900]),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'News',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15,),
            Text(
              'Find our application we will always updating new news',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 100),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginPage(onTap: () => loginCallback(context)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Set the border radius
                      ),
                      minimumSize: Size(300, 40), // Set the minimum size
                      backgroundColor: Colors.blue, // Set the button color
                    ),
                    icon: Icon(Icons.login), // Add the login icon
                    label: Text("Login"),
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the register page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage(
                                onTap: () => registerCallback(context))),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Set the border radius
                      ),
                      minimumSize: Size(300, 40), // Set the minimum size
                      backgroundColor: Colors.green, // Set the button color
                    ),
                    icon: Icon(Icons.app_registration), // Add the register icon
                    label: Text("Register"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
