import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('module2', (WidgetTester tester) async {
    expect(
      FightClubColors.background,
      const Color.fromRGBO(213, 222, 240, 1),
    );
    expect(
      FightClubColors.greyButton,
      isOneOrAnother(Colors.black38, Color(0x60000000)),
    );
    expect(
      FightClubColors.blueButton,
      Color(0xFF1C79CE),
    );
    expect(
      FightClubColors.blackButton,
      isOneOrAnother(Colors.black87, Color(0xDE000000)),
    );
    expect(
      FightClubColors.darkGreyText,
      Color(0xFF161616),
    );

    expect(
      FightClubColors.whiteText,
      isOneOrAnother(Color(0xDDFFFFFF), Color(0xDEFFFFFF)),
    );
  });


  testWidgets('module3',
          (WidgetTester tester) async {
        await tester.pumpWidget(MyApp());
        final List<Row> rowWidgets = tester
            .widgetList<Row>(
            find.descendant(of: find.byType(FightersInfo), matching: find.byType(Row)))
            .toList();
        final Row? rowWithTwoChildren = rowWidgets.firstWhereOrNull((e) => e.children.length == 2);
        expect(rowWithTwoChildren, isNotNull, reason: "Cannot find Row with needed colors");
        expect(rowWithTwoChildren!.crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(
          rowWithTwoChildren.children[0],
          isInstanceOf<Expanded>(),
        );
        expect(
          (rowWithTwoChildren.children[0] as Expanded).child,
          isInstanceOf<ColoredBox>(),
        );
        expect(
          ((rowWithTwoChildren.children[0] as Expanded).child as ColoredBox).color,
          Colors.white,
        );

        expect(
          rowWithTwoChildren.children[1],
          isInstanceOf<Expanded>(),
        );
        expect(
          (rowWithTwoChildren.children[1] as Expanded).child,
          isInstanceOf<ColoredBox>(),
        );
        expect(
          ((rowWithTwoChildren.children[1] as Expanded).child as ColoredBox).color,
          Color(0xFFC5D1EA),
        );
      });

  testWidgets('module4',
          (WidgetTester tester) async {
        void _testSizedBox(SizedBox sizedBox) {
          expect(sizedBox.width, double.infinity);
          expect(sizedBox.height, double.infinity);
        }

        void _testPadding(Padding padding) {
          expect((padding.padding as EdgeInsets).left, 16);
          expect((padding.padding as EdgeInsets).right, 16);
        }

        void _testColoredBox(ColoredBox coloredBox) {
          expect(coloredBox.color, const Color(0xFFC5D1EA));
        }

        await tester.pumpWidget(MyApp());
        final SafeArea safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
        expect(safeArea.child, isInstanceOf<Column>());

        final Column topLevelColumn = safeArea.child as Column;
        final Widget? possiblyExpanded =
        topLevelColumn.children.firstWhereOrNull((element) => element is Expanded);
        expect(possiblyExpanded, isNotNull);
        expect(possiblyExpanded, isInstanceOf<Expanded>());
        final Expanded expanded = possiblyExpanded as Expanded;

        if (expanded.child is SizedBox) {
          final SizedBox sizedBox = expanded.child as SizedBox;

          _testSizedBox(sizedBox);

          expect(sizedBox.child, isInstanceOf<Padding>());
          final Padding padding = sizedBox.child as Padding;
          _testPadding(padding);

          expect(padding.child, isInstanceOf<ColoredBox>());
          _testColoredBox(padding.child as ColoredBox);
        } else {
          expect(expanded.child, isInstanceOf<Padding>());
          final Padding padding = expanded.child as Padding;
          _testPadding(padding);

          if (padding.child is SizedBox) {
            final SizedBox sizedBox = padding.child as SizedBox;
            _testSizedBox(sizedBox);

            expect(sizedBox.child, isInstanceOf<ColoredBox>());
            _testColoredBox(sizedBox.child as ColoredBox);
          } else {
            expect(padding.child, isInstanceOf<ColoredBox>());
            final ColoredBox coloredBox = padding.child as ColoredBox;
            _testColoredBox(coloredBox);

            expect(coloredBox.child, isInstanceOf<SizedBox>());

            _testSizedBox(coloredBox.child as SizedBox);
          }
        }
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

extension MyIterable<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}