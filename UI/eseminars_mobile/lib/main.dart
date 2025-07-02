import 'package:eseminars_mobile/layouts/master_screen.dart';
import 'package:eseminars_mobile/providers/auth_provider.dart';
import 'package:eseminars_mobile/providers/categories_provider.dart';
import 'package:eseminars_mobile/providers/feedback_provider.dart';
import 'package:eseminars_mobile/providers/korisnici_provider.dart';
import 'package:eseminars_mobile/providers/lecturers_provider.dart';
import 'package:eseminars_mobile/providers/materials_provider.dart';
import 'package:eseminars_mobile/providers/notifications_provider.dart';
import 'package:eseminars_mobile/providers/reservations_provider.dart';
import 'package:eseminars_mobile/providers/seminar_provider.dart';
import 'package:eseminars_mobile/providers/sponsorsSeminars_provider.dart';
import 'package:eseminars_mobile/providers/sponsors_provider.dart';
import 'package:eseminars_mobile/providers/wishlist_provider.dart';
import 'package:eseminars_mobile/screens/registration_screen.dart';
import 'package:eseminars_mobile/utils/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<KorisniciProvider>(create: (_) => KorisniciProvider()),
    ChangeNotifierProvider<NotificationsProvider>(create: (_) => NotificationsProvider()),
    ChangeNotifierProvider<CategoriesProvider>(create: (_) => CategoriesProvider()),
    ChangeNotifierProvider<SeminarsProvider>(create: (_) => SeminarsProvider()),
    ChangeNotifierProvider<ReservationsProvider>(create: (_) => ReservationsProvider()),
    ChangeNotifierProvider<WishlistProvider>(create: (_) => WishlistProvider()),
    ChangeNotifierProvider<FeedbackProvider>(create: (_) => FeedbackProvider()),
    ChangeNotifierProvider<LecturersProvider>(create: (_) => LecturersProvider()),
    ChangeNotifierProvider<MaterialsProvider>(create: (_) => MaterialsProvider()),
    ChangeNotifierProvider<SponsorsseminarsProvider>(create: (_) => SponsorsseminarsProvider()),
    ChangeNotifierProvider<SponsorsProvider>(create: (_) => SponsorsProvider()),
  ],child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/5227136.jpg"),
            fit: BoxFit.cover,
            ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 340),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  spreadRadius: 4
                )
              ] 
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30,),
                Text("eSeminars",style: GoogleFonts.poppins(fontSize: 34,fontWeight: FontWeight.bold),),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(controller: _email,decoration: InputDecoration(suffixIcon: Icon(CupertinoIcons.person),labelText: "Email",border: OutlineInputBorder()),),
                ),
                _errorMessage == null? SizedBox.shrink(): Text(_errorMessage!,style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(controller: _password,obscureText: true,decoration: InputDecoration(labelText: "Password",suffixIcon: Icon(Icons.password),border: OutlineInputBorder()),),
                ),
                _errorMessage == null? SizedBox.shrink(): Text(_errorMessage!,style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed: () async{
                  setState(() {
                      _errorMessage = null;
                    });
                    if(_email.text.isEmpty || _password.text.isEmpty){
                      setState(() {
                        _errorMessage = "Incorect data";
                      });
                      return;
                    }
                  KorisniciProvider provider = new KorisniciProvider();
                  try {
                      var user = await provider.login(_email.text, _password.text);
                    
                    if(user == null){
                      setState(() {
                        _errorMessage = "Incorect data";
                      });
                      return;
                    }
                    AuthProvider.email = _email.text;
                    AuthProvider.password = _password.text;
                    UserSession.currentUser = user;

                    if(UserSession.currentUser?.ulogaNavigation?.naziv == "Korisnik"){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MasterScreen()));
                    } else if(UserSession.currentUser?.ulogaNavigation?.naziv == "Organizator"){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MasterScreen()));
                    }else{
                      setState(() {
                        _errorMessage = "Incorect data";
                      });
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                }, child: Text("Login"),style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(300, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )
                ),),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationScreen()));
                }, child: Text("Don’t have an account? Sign up")),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
