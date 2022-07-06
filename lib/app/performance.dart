import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef Native_Max = Int32 Function(Pointer<Int32> list, Int32 size);
typedef Dart_Max = int Function(Pointer<Int32> list, int size);

typedef Native_Dot = Float Function(
    Pointer<Float> listA, Pointer<Float> listB, Int32 size);
typedef Dart_Dot = double Function(
    Pointer<Float> listA, Pointer<Float> listB, int size);

class PerformanceView extends StatefulWidget {
  const PerformanceView({Key? key}) : super(key: key);

  @override
  State<PerformanceView> createState() => _PerformanceViewState();
}

class _PerformanceViewState extends State<PerformanceView> {
  int listSize = 10;
  int nIterations = 10;

  late Dart_Max maxFunc;
  late Dart_Dot dotFunc;

  // int? maxNative;
  // int? maxDart;

  double? resultNative;
  double? resultDart;

  int? nativeDuration;
  int? dartDuration;

  @override
  void initState() {
    _loadLibraries();
    super.initState();
  }

  Future<void> _loadLibraries() async {
    DynamicLibrary dylib = DynamicLibrary.open('libmathFunctions.so');
    maxFunc = dylib.lookupFunction<Native_Max, Dart_Max>('max');
    dotFunc = dylib.lookupFunction<Native_Dot, Dart_Dot>('dotProduct');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance comparison'),
        backgroundColor: const Color.fromRGBO(95, 79, 188, 1),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text(
                  'List size',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        listSize = int.tryParse(value) ?? listSize;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'default: 10',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Number of repetitions',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        nIterations = int.tryParse(value) ?? nIterations;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'default: 10',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            RaisedButton(
              child: Text('Max test'),
              onPressed: () {
                List<int> randList = getRandomList(listSize);

                Pointer<Int32> listP = intListToArray(randList);

                final watch = Stopwatch()..start();
                for (var i = 0; i < nIterations; i++) {
                  resultNative = maxFunc(listP, listSize).toDouble();
                }
                nativeDuration = watch.elapsed.inMicroseconds;

                watch.reset();
                watch.start();
                for (var i = 0; i < nIterations; i++) {
                  resultDart = randList.reduce(max).toDouble();
                }
                dartDuration = watch.elapsed.inMicroseconds;

                setState(() {});
              },
            ),
            RaisedButton(
              child: Text('Dot product test'),
              onPressed: () {
                List<double> randListD = getRandomListDouble(listSize);

                Pointer<Float> listFloatP = floatListToArray(randListD);

                final watch = Stopwatch()..start();
                for (var i = 0; i < nIterations; i++) {
                  resultNative = dotFunc(listFloatP, listFloatP, listSize);
                }
                nativeDuration = watch.elapsed.inMicroseconds;

                watch.reset();
                watch.start();
                for (var i = 0; i < nIterations; i++) {
                  resultDart = dotProduct(randListD, randListD);
                }
                dartDuration = watch.elapsed.inMicroseconds;

                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Native result: ${resultNative ?? 0}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Dart result:     ${resultDart ?? 0}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  'Native elapsed time: ${nativeDuration ?? 0} in us',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Dart elapsed time:     ${dartDuration ?? 0} in us',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Returns random list of integers
  List<int> getRandomList(int listSize) {
    final list = List<int>.generate(listSize, (index) => Random().nextInt(100));
    return list;
  }

  // Returns random list of doubles
  List<double> getRandomListDouble(int listSize) {
    final list =
        List<double>.generate(listSize, (index) => Random().nextDouble());
    return list;
  }
}

Pointer<Int32> intListToArray(List<int> list) {
  final ptr = malloc.allocate<Int32>(sizeOf<Int32>() * list.length);
  for (var i = 0; i < list.length; i++) {
    ptr.elementAt(i).value = list[i];
  }
  return ptr;
}

Pointer<Float> floatListToArray(List<double> list) {
  final ptr = malloc.allocate<Float>(sizeOf<Float>() * list.length);
  for (var i = 0; i < list.length; i++) {
    ptr.elementAt(i).value = list[i];
  }
  return ptr;
}

double dotProduct(List<double> listA, List<double> listB) {
  double result = 0.0;
  for (int i = 0; i < listA.length; i++) {
    result = result + listA[i] * listB[i];
  }
  return result;
}
