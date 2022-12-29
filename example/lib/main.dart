import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:offset_stack/offset_stack.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final List<String> data = [
    'https://dummyimage.com/80x80/1A237E/ffffff.png',
    'https://dummyimage.com/80x80/1B5E20/fffffe.png',
    'https://dummyimage.com/80x80/F57F17/fffffd.png',
    'https://dummyimage.com/80x80/BF360C/fffffc.png',
    'https://dummyimage.com/80x80/00B8D4/fffffb.png',
    'https://dummyimage.com/80x80/1A237E/fffffa.png',
    'https://dummyimage.com/80x80/1B5E20/fffff9.png',
    'https://dummyimage.com/80x80/F57F17/fffff8.png',
    'https://dummyimage.com/80x80/BF360C/fffff7.png',
    'https://dummyimage.com/80x80/00B8D4/fffff6.png',
    'https://dummyimage.com/80x80/1A237E/fffff5.png',
    'https://dummyimage.com/80x80/1B5E20/fffff4.png',
    'https://dummyimage.com/80x80/F57F17/fffff3.png',
    'https://dummyimage.com/80x80/BF360C/fffff2.png',
    'https://dummyimage.com/80x80/00B8D4/fffff1.png',
    'https://dummyimage.com/80x80/00B8D4/fffff0.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('offset_stack'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Text('====AvatarStack====')),
          AvatarStack(
            height: 50,
            settings: RestrictedPositions(
              maxCoverage: 0.5,
              minCoverage: 0.5,
              align: StackAlign.left,
            ),
            avatars: data.map((e) => NetworkImage(e)).toList(),
          ),
          const Center(child: Text('----WidgetStack----')),
          SizedBox(
            height: 50,
            child: _buildWidgetStack(context),
          ),
          const Center(child: Text('****OffsetStack****')),
/*
          Container(
            color: Colors.grey,
            child: OffsetStack(
              coverage: 0.8,
              children: data.map((e) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(e),
                    foregroundColor: Colors.transparent,
                    radius: 45,
                  ),
                );
              }).toList(),
            ),
          ),
*/
          const Placeholder(
            child: SizedBox(height: 365, width: double.infinity,),
          ),
          Container(
            color: Colors.grey,
            child: OffsetStack(
              coverage: 0.2,
              children: data.map((e) {
                var index = data.indexOf(e);
                String value = index == 3 ? '33333' : index.toString();
                return ElevatedButton(
                  onPressed: () {
                    debugPrint('index $index clicked, $e');
                  },
                  child: Text(value,),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetStack(BuildContext context) {
    return WidgetStack(
      positions: RestrictedPositions(
        maxCoverage: 0.2,
        minCoverage: 0.2,
        align: StackAlign.left,
      ),
      stackedWidgets: data.map((e) {
        return CircleAvatar(
          backgroundImage: NetworkImage(e),
          foregroundColor: Colors.transparent,
          radius: 80,
        );
      }).toList(),
      buildInfoWidget: (surplus) {
        return Center(
          child: Text(
            '+$surplus',
            style: Theme.of(context).textTheme.headline5,
          ),);
      },
    );
  }
}
