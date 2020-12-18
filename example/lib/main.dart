import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fortune Wheel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.orangeAccent,
        visualDensity: VisualDensity.comfortable,
      ),
      home: ExamplePage(),
    );
  }
}

class WheelPage extends StatefulWidget {
  @override
  _WheelPageState createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage> {
  int _value = 0;
  bool _isAnimating = false;
  Alignment _alignment = Alignment.topCenter;

  @override
  Widget build(BuildContext context) {
    final wheelFields = <String>['1', '2', '3', '4', '5', '6', '7', '8'];

    final alignmentSelector = AlignmentSelector(
      selected: _alignment,
      onChanged: (v) {
        setState(() {
          _alignment = v;
        });
      },
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          RollButtonWithPreview(
            selected: _value,
            items: wheelFields,
            onPressed: _isAnimating
                ? null
                : (value) {
                    setState(() {
                      _value = value;
                    });
                  },
          ),
          alignmentSelector,
          Expanded(
            child: FortuneWheel(
              selected: _value,
              animation: FortuneAnimation.Roll,
              onAnimationStart: () {
                setState(() {
                  _isAnimating = true;
                });
              },
              onAnimationEnd: () {
                setState(() {
                  _isAnimating = false;
                });
              },
              indicators: [
                FortuneWheelIndicator(
                  alignment: _alignment,
                  child: TriangleIndicator(),
                ),
              ],
              slices: [
                for (var it in wheelFields) CircleSlice(child: Text(it))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BandPage extends StatefulWidget {
  @override
  _BandPageState createState() => _BandPageState();
}

class _BandPageState extends State<BandPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FortuneBand(),
      ],
    );
  }
}

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Fortune Wheel'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Wheel'),
              Tab(text: 'Band'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Layout(child: WheelPage()),
            Layout(child: BandPage()),
          ],
        ),
      ),
    );
  }
}

typedef Callback<T> = void Function(T);

class Layout extends StatelessWidget {
  final Widget child;

  const Layout({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: child);
  }
}

class AlignmentSelector extends StatelessWidget {
  final Alignment selected;
  final Callback<Alignment> onChanged;

  const AlignmentSelector({
    Key key,
    @required this.selected,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<Alignment, String> alignments = {
      Alignment.topCenter: 'top center',
      Alignment.topRight: 'top right',
      Alignment.centerRight: 'center right',
      Alignment.bottomRight: 'bottom right',
      Alignment.bottomCenter: 'bottom center',
      Alignment.bottomLeft: 'bottom left',
      Alignment.centerLeft: 'center left',
      Alignment.topLeft: 'top left',
      Alignment.center: 'center',
    };

    return DropdownButtonFormField<Alignment>(
      decoration: InputDecoration(
        labelText: 'Indicator Alignment',
      ),
      value: selected,
      items: [
        for (final entry in alignments.entries)
          DropdownMenuItem(
            child: Text(entry.value),
            value: entry.key,
          )
      ],
      onChanged: onChanged,
    );
  }
}

class RollButton extends StatelessWidget {
  final int lastValue;
  final Callback<int> onPressed;
  final int itemCount;

  const RollButton({
    Key key,
    this.onPressed,
    this.itemCount,
    this.lastValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int roll() {
      if (lastValue == null) {
        return Random().nextInt(itemCount);
      } else {
        int val = lastValue;
        while (val == lastValue) {
          val = Random().nextInt(itemCount);
        }
        return val;
      }
    }

    return ElevatedButton(
      child: Text('Roll'),
      onPressed: onPressed == null ? null : () => onPressed(roll()),
    );
  }
}

class RollButtonWithPreview extends StatelessWidget {
  final int selected;
  final List<String> items;
  final Callback<int> onPressed;

  const RollButtonWithPreview({
    Key key,
    this.selected,
    this.items,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RollButton(
          itemCount: items.length,
          onPressed: onPressed,
          lastValue: selected,
        ),
        Text('Rolled Value: ${items[selected]}'),
      ],
    );
  }
}
