// Kyle Billones
// Number 7
// BSCS 4B-AI

// Note: This app is built to run in a vertical orientation. There might be UI problems when running in a horizontal orientation.

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SortingVisualizer(),
    );
  }
}

class SortingVisualizer extends StatefulWidget {
  @override
  _SortingVisualizerState createState() => _SortingVisualizerState();
}

class _SortingVisualizerState extends State<SortingVisualizer> {
  // Bars that will be displayed in UI
  List<int> quickSortBars = [];
  List<int> selectionSortBars = [];

  // number of bars (basically the length of the array)
  final int numBars = 100;

  // delay for the animation
  final int delay = 2;

  //to check if it array/bars are sorted
  bool isSorting = false;

  @override
  void initState() {
    super.initState();
    _initializeBars();
  }

  // Initialize both QuickSort and Selection Sort bar sets
  // This generates an array of random numbers in random order
  void _initializeBars() {
    quickSortBars =
        List.generate(numBars, (index) => Random().nextInt(300) + 10);
    selectionSortBars = List.from(quickSortBars);
    setState(() {});
  }

  // UI animation for bar swapping
  Future<void> _swap(List<int> bars, int i, int j) async {
    int temp = bars[i];
    bars[i] = bars[j];
    bars[j] = temp;

    setState(() {});
    await Future.delayed(Duration(milliseconds: delay));
  }

  // QuickSort algorithm
  Future<void> _quickSort(int low, int high) async {
    if (low < high) {
      int pi = await _partition(low, high);
      await Future.wait([
        _quickSort(low, pi - 1),
        _quickSort(pi + 1, high),
      ]);
    }
  }

  // Partition logic for QuickSort
  Future<int> _partition(int low, int high) async {
    int pivot = quickSortBars[high];
    int i = low - 1;
    for (int j = low; j < high; j++) {
      if (quickSortBars[j] < pivot) {
        i++;
        await _swap(quickSortBars, i, j);
      }
    }
    await _swap(quickSortBars, i + 1, high);
    return i + 1;
  }

  // Selection Sort algorithm
  Future<void> _selectionSort() async {
    for (int i = 0; i < selectionSortBars.length; i++) {
      int minIndex = i;
      for (int j = i + 1; j < selectionSortBars.length; j++) {
        if (selectionSortBars[j] < selectionSortBars[minIndex]) {
          minIndex = j;
        }
      }
      await _swap(selectionSortBars, i, minIndex);
    }
  }

  // Start sorting both algorithms parallelly
  Future<void> _startSorting() async {
    if (isSorting) return;
    setState(() => isSorting = true);

    // Start both QuickSort and Selection Sort asynchronously
    await Future.wait([
      _quickSort(0, quickSortBars.length - 1),
      _selectionSort(),
    ]);

    setState(() => isSorting = false);
  }

  // UI for the bar representing the number in an array
  Widget _buildBars(List<int> bars, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: bars
          .map((barHeight) => Container(
                width: 1.4,
                height: barHeight.toDouble() / 2,
                margin: EdgeInsets.symmetric(horizontal: 1),
                color: color,
              ))
          .toList(),
    );
  }

  // UI for the entire screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QuickSort vs Selection Sort')),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('QuickSort', style: TextStyle(fontSize: 18)),
                _buildBars(quickSortBars, Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Selection Sort', style: TextStyle(fontSize: 18)),
                _buildBars(selectionSortBars, Colors.red),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _startSorting,
            child: Text('Start Sorting'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
