import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Routes(),
    );
  }
}
// import 'package:flutter_rehberim/main.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key}) : super(key: key);

  static const kRouteName = '/RoutesExample';

  @override
  Widget build(BuildContext context) {
    debugPrint('RouteName=${ModalRoute.of(context)!.settings.name}');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Page 1'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigator maintains a stack-like structure of pages. Jumping
            // between routes is by push/pop of Navigator.
            Navigator.push(context, _PageTwo());
          },
          child: const Text('Go to page two'),
        ),
      ),
    );
  }
}

// <void> means this route returns nothing.
class _PageTwo extends MaterialPageRoute<void> {
  _PageTwo()
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Page 2'),
              elevation: 1.0,
            ),
            // Note: use a Builder instead of directly giving the body, so
            // that Scaffold.of(context) won't throw exception, c.f.
            // https://stackoverflow.com/a/51304732.
            body: Builder(
              builder: (BuildContext context) => Center(
                child: RaisedButton(
                  onPressed: () {
                    // Navigator.push<T> returns a Future<T>, which is the
                    // return value of the pushed route when it's popped.
                    Navigator.push<String>(context, _PageThree())
                        .then((returnVal) {
                      if (returnVal != null) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You clicked: $returnVal'),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {},
                            ),
                          ),
                        );
                      }
                    });
                  },
                  child: const Text('Go to page 3'),
                ),
              ),
            ),
          );
        });
}

// MaterialPageRoute<String> returns a Future<String>.
class _PageThree extends MaterialPageRoute<String> {
  _PageThree()
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Last page'),
              elevation: 2.0,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const CircleAvatar(child: Text('1')),
                    title: const Text('user1@example.com'),
                    onTap: () => Navigator.pop(context, 'user1@example.com'),
                  ),
                  ListTile(
                    leading: const CircleAvatar(child: Text('2')),
                    title: const Text('user2@example.com'),
                    onTap: () => Navigator.pop(context, 'user2@example.com'),
                  ),
                  ListTile(
                    leading: const CircleAvatar(child: Text('3')),
                    title: const Text('user3@example.com'),
                    onTap: () => Navigator.pop(context, 'user3@example.com'),
                  ),
                  const Divider(),
                  MaterialButton(
                    onPressed: () {
                      // Pops until reaching a route with that route name.
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: const Text('Go home'),
                  ),
                ],
              ),
            ),
          );
        });
}
