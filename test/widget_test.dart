import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fight_club/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('module1', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final Iterable<Text> allTextsWithGrey = [
      ...tester.widgetList(find.text("DEFEND")),
      ...tester.widgetList(find.text("ATTACK")),
      ...tester.widgetList(find.text("HEAD")),
      ...tester.widgetList(find.text("TORSO")),
      ...tester.widgetList(find.text("LEGS")),
      ...tester.widgetList(find.text("You")),
      ...tester.widgetList(find.text("Enemy")),
    ].cast<Text>();
    final Iterable<Color?> colorsOfTextsWithGrey =
    allTextsWithGrey.map((e) => e.style?.color).toSet().toList();
    expect(colorsOfTextsWithGrey.length, 1);
    expect(colorsOfTextsWithGrey.first, isNotNull);

    expect(
      colorsOfTextsWithGrey.first,
      const Color(0xFF161616),
    );

    final Iterable<Text> allTextsWithWhite = [
      ...tester.widgetList(find.text("GO")),
    ].cast<Text>();
    final List<Color?> colorsOfTextsWithWhite =
    allTextsWithWhite.map((e) => e.style?.color).toSet().toList();
    expect(colorsOfTextsWithWhite.length, 1);
    expect(colorsOfTextsWithWhite.first, isNotNull);

    expect(
      colorsOfTextsWithWhite.first,
      isOneOrAnother(const Color(0xDDFFFFFF), const Color(0xDEFFFFFF)),
    );
  });
}

Matcher isOneOrAnother(dynamic one, dynamic another) => OneOrAnotherMatcher(one, another);

class OneOrAnotherMatcher extends Matcher {
  final dynamic _one;
  final dynamic _another;

  const OneOrAnotherMatcher(this._one, this._another);

  @override
  Description describe(Description description) {
    return description
        .add('either ${_one.runtimeType}:<$_one> or ${_another.runtimeType}:<$_another>');
  }

  @override
  bool matches(Object? item, Map matchState) => item == _one || item == _another;
}