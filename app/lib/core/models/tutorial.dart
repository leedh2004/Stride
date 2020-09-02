import 'package:flutter/material.dart';

class RangeWrapper {
  RangeValues value;
  RangeWrapper(this.value);
}

class FlagWrapper {
  bool value;
  FlagWrapper(this.value);
}

Map<String, Map<String, List<double>>> sizeRange = {
  'xs': {
    'shoulder': [36, 38],
    'bust': [78, 83],
    'waist': [23, 25],
    'hip': [84, 88],
    'thigh': [20, 24]
  },
  's': {
    'shoulder': [38, 40],
    'bust': [83, 88],
    'waist': [25, 27],
    'hip': [88, 92],
    'thigh': [24, 28]
  },
  'm': {
    'shoulder': [40, 42],
    'bust': [88, 93],
    'waist': [27, 29],
    'hip': [92, 96],
    'thigh': [28, 32]
  },
  'l': {
    'shoulder': [42, 44],
    'bust': [93, 98],
    'waist': [29, 31],
    'hip': [96, 100],
    'thigh': [32, 36]
  },
  'xl': {
    'shoulder': [44, 46],
    'bust': [98, 102],
    'waist': [31, 33],
    'hip': [100, 104],
    'thigh': [36, 40]
  },
};
