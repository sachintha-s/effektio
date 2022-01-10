import 'package:flutter/material.dart';

void main() {
  runApp(Effektio());
}

class Effektio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Effektio',
      home: EffektioHome(),
    );
  }
}

class EffektioHome extends StatefulWidget {
  @override
  _EffektioHomeState createState() => _EffektioHomeState();
}

class _EffektioHomeState extends State<EffektioHome> {
  int _currentIndex = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        restorationScopeId: 'effektio',
        // title: GalleryLocalizations.of(context).starterAppTitle,
        title: "Effektio",
        debugShowCheckedModeBanner: false,
        //localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        //supportedLocales: GalleryLocalizations.supportedLocales,
        // locale: GalleryOptions.of(context).locale,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              primary: false,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.blue,
              elevation: 0.0,
              shadowColor: Colors.transparent,
              actions: [
                Icon(Icons.login_outlined),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.settings),
                ),
              ]),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const <Widget>[
                UserAccountsDrawerHeader(
                    accountName: Text("Ben"),
                    accountEmail: Text("ben:effektio.org"),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://matrix-client.matrix.org/_matrix/media/r0/download/matrix.org/ABFEXSDrESxovWwEnCYdNcHT"),
                    )),
                ListTile(
                  leading: Icon(Icons.task_alt_outlined),
                  title: Text('Tasks'),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today_outlined),
                  title: Text('Events'),
                ),
                ListTile(
                  leading: Icon(Icons.real_estate_agent_outlined),
                  title: Text('Resources'),
                ),
                Divider(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: Color(0xFF6200EE),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(.6),
            selectedFontSize: 0,
            unselectedFontSize: 0,
            onTap: (value) {
              // Respond to item press.
              setState(() => _currentIndex = value);
            },
            items: [
              BottomNavigationBarItem(
                label: 'News',
                icon: Icon(Icons.dashboard),
              ),
              BottomNavigationBarItem(
                label: 'FAQ',
                icon: Icon(Icons.help_outline),
              ),
              BottomNavigationBarItem(
                label: 'Community',
                icon: Icon(Icons.groups),
              ),
              BottomNavigationBarItem(
                label: 'Chat',
                icon: Icon(Icons.chat),
              ),
            ],
          ),
          body: const Center(
            child: Text('Hello World'),
          ),
        )

        // theme: ThemeData(
        //   primaryColor: _primaryColor,
        //   highlightColor: Colors.transparent,
        //   colorScheme: const ColorScheme(
        //     primary: _primaryColor,
        //     primaryContainer: Color(0xFF3700B3),
        //     secondary: Color(0xFF03DAC6),
        //     secondaryContainer: Color(0xFF018786),
        //     background: Colors.white,
        //     surface: Colors.white,
        //     onBackground: Colors.black,
        //     error: Color(0xFFB00020),
        //     onError: Colors.white,
        //     onPrimary: Colors.white,
        //     onSecondary: Colors.black,
        //     onSurface: Colors.black,
        //     brightness: Brightness.light,
        //   ),
        // dividerTheme: const DividerThemeData(
        //   thickness: 1,
        //   color: Color(0xFFE5E5E5),
        // ),
        // platform: GalleryOptions.of(context).platform,
        );
  }
}
