import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:flutter_fight_club/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('module5',
          (WidgetTester tester) async {
        final String youAvatarPath = "assets/images/you-avatar.png";
        final String enemyAvatarPath = "assets/images/enemy-avatar.png";

        final yourData = await rootBundle.load(youAvatarPath);
        final yourEncoded = utf8.encode(yourData.buffer.asUint8List().join());
        final yourHash = md5.convert(yourEncoded);
        expect(yourHash.toString(), "f1c9df7ba406c0a4749c7580cb71884d");

        final enemyData = await rootBundle.load(enemyAvatarPath);
        final enemyEncoded = utf8.encode(enemyData.buffer.asUint8List().join());
        final enemyHash = md5.convert(enemyEncoded);
        expect(enemyHash.toString(), "4812da1169f703562e653a1465b12fcf");

        expect(FightClubImages.youAvatar, youAvatarPath);
        expect(FightClubImages.enemyAvatar, enemyAvatarPath);

        await tester.pumpWidget(MyApp());
        final youImageFinder = find.descendant(
          of: find.descendant(
            of: find.byType(FightersInfo),
            matching: find.ancestor(
              of: find.text("You"),
              matching: find.byType(Column),
            ),
          ),
          matching: find.byType(Image),
        );
        expect(youImageFinder, findsOneWidget);
        final Image youImage = tester.widget(youImageFinder);
        expect(youImage.image, isInstanceOf<AssetImage>());
        expect((youImage.image as AssetImage).assetName, youAvatarPath);

        final enemyImageFinder = find.descendant(
          of: find.descendant(
            of: find.byType(FightersInfo),
            matching: find.ancestor(
              of: find.text("Enemy"),
              matching: find.byType(Column),
            ),
          ),
          matching: find.byType(Image),
        );
        expect(enemyImageFinder, findsOneWidget);
        final Image enemyImage = tester.widget(enemyImageFinder);
        expect(enemyImage.image, isInstanceOf<AssetImage>());
        expect((enemyImage.image as AssetImage).assetName, enemyAvatarPath);
      });

  testWidgets('module6', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    final LivesWidget livesWidget = tester.widget<LivesWidget>(find.byType(LivesWidget).first);
    final heartsCount = livesWidget.overallLivesCount;
    final Size size = tester.getSize(find.byType(LivesWidget).first);
    final heightOfGap = (size.height - heartsCount * 18) / (heartsCount - 1);
    expect(heightOfGap, 4.0);
  });

  testWidgets('module7', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final textFinder = find.descendant(
      of: find.byWidgetPredicate(
              (widget) => widget is ColoredBox && widget.color == Color(0xFFC5D1EA)),
      matching: find.byType(Text),
    );
    expect(tester.widget<Text>(textFinder).data, "");

    MyHomePageState state = tester.state(find.byType(MyHomePage));

    await tester.tap(
      find.widgetWithText(GestureDetector, state.whatEnemyDefends.name.toUpperCase()).last,
    );
    await tester.pump();

    await tester.tap(
      find.widgetWithText(GestureDetector, state.whatEnemyAttacks.name.toUpperCase()).first,
    );
    await tester.pump();

    await tester.tap(find.text("GO").last);
    await tester.pump();

    expect(
      tester.widget<Text>(textFinder).data,
      "Your attack was blocked.\nEnemy's attack was blocked.",
    );

    state = tester.state(find.byType(MyHomePage));

    BodyPart otherBodyPart(final BodyPart currentBodyPart) {
      if (currentBodyPart == BodyPart.legs) {
        return BodyPart.head;
      } else if (currentBodyPart == BodyPart.head) {
        return BodyPart.torso;
      } else {
        return BodyPart.legs;
      }
    }

    final attack = otherBodyPart(state.whatEnemyDefends);
    final enemyAttacks = state.whatEnemyAttacks;
    final defend = otherBodyPart(enemyAttacks);
    await tester.tap(
      find.widgetWithText(GestureDetector, attack.name.toUpperCase()).last,
    );
    await tester.pump();

    await tester.tap(
      find.widgetWithText(GestureDetector, defend.name.toUpperCase()).first,
    );
    await tester.pump();

    await tester.tap(find.text("GO").last);
    await tester.pump();

    expect(
      tester.widget<Text>(textFinder).data,
      "You hit enemy's ${attack.name.toLowerCase()}.\nEnemy hit your ${enemyAttacks.name.toLowerCase()}.",
    );

    state = tester.state(find.byType(MyHomePage));
    while (state.enemysLives > 0) {
      final attack = otherBodyPart(state.whatEnemyDefends);
      final defend = otherBodyPart(state.whatEnemyAttacks);
      await tester.tap(
        find.widgetWithText(GestureDetector, attack.name.toUpperCase()).last,
      );
      await tester.pump();

      await tester.tap(
        find.widgetWithText(GestureDetector, defend.name.toUpperCase()).first,
      );
      await tester.pump();

      await tester.tap(find.text("GO").last);
      await tester.pump();
    }

    expect(
      tester.widget<Text>(textFinder).data,
      "Draw",
    );

    await tester.tap(find.text("START NEW GAME").last);
    await tester.pump();

    state = tester.state(find.byType(MyHomePage));
    while (state.enemysLives > 0) {
      final attack = otherBodyPart(state.whatEnemyDefends);
      final defend = state.whatEnemyAttacks;
      await tester.tap(
        find.widgetWithText(GestureDetector, attack.name.toUpperCase()).last,
      );
      await tester.pump();

      await tester.tap(
        find.widgetWithText(GestureDetector, defend.name.toUpperCase()).first,
      );
      await tester.pump();

      await tester.tap(find.text("GO").last);
      await tester.pump();
    }

    expect(
      tester.widget<Text>(textFinder).data,
      "You won",
    );

    await tester.tap(find.text("START NEW GAME").last);
    await tester.pump();

    state = tester.state(find.byType(MyHomePage));
    while (state.yourLives > 0) {
      final attack = state.whatEnemyDefends;
      final defend = otherBodyPart(state.whatEnemyAttacks);
      await tester.tap(
        find.widgetWithText(GestureDetector, attack.name.toUpperCase()).last,
      );
      await tester.pump();

      await tester.tap(
        find.widgetWithText(GestureDetector, defend.name.toUpperCase()).first,
      );
      await tester.pump();

      await tester.tap(find.text("GO").last);
      await tester.pump();
    }

    expect(
      tester.widget<Text>(textFinder).data,
      "You lost",
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

extension MyIterable<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}