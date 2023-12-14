/*
Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:recaptcha_flutter_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('startup state', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      Text clientText =
          tester.firstWidget(find.byKey(const Key('clientState')));
      expect(clientText.data, 'NOT INITIALIZED');
      Text tokenText = tester.firstWidget(find.byKey(const Key('token')));
      expect(tokenText.data, 'NO TOKEN');
    });

    // TODO: This test has to be run before any tests that run init because of
    // hot reloading. Need to actually restart app to clear state.
    testWidgets('execute fails without init', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final Finder executeFinder = find.byKey(const Key('executeButton'));
      await tester.tap(executeFinder);
      await tester.pump(const Duration(milliseconds: 2000));
      Text tokenText = tester.firstWidget(find.byKey(const Key('token')));
      expect(tokenText.data != null, true);
      expect(tokenText.data?.isNotEmpty, true);
      expect(tokenText.data?.contains('FL_EXECUTE_FAILED'), true);
    });

    testWidgets('init and execute runs', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final Finder initFinder = find.byKey(const Key('initButton'));
      await tester.tap(initFinder);
      await tester.pump(const Duration(milliseconds: 2000));
      Text clientText =
          tester.firstWidget(find.byKey(const Key('clientState')));
      expect(clientText.data, 'ok');

      final Finder executeFinder = find.byKey(const Key('executeButton'));
      await tester.tap(executeFinder);
      await tester.pump(const Duration(milliseconds: 2000));
      Text tokenText = tester.firstWidget(find.byKey(const Key('token')));
      expect(tokenText.data != null, true);
      expect(tokenText.data?.isNotEmpty, true);
      expect(tokenText.data?.toLowerCase().contains('error'), false);
    });

    testWidgets('init and execute custom action runs', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final Finder initFinder = find.byKey(const Key('initButton'));
      await tester.tap(initFinder);
      await tester.pump(const Duration(milliseconds: 2000));
      Text clientText =
          tester.firstWidget(find.byKey(const Key('clientState')));
      expect(clientText.data, 'ok');

      final Finder executeFinder = find.byKey(const Key('executeButtonCustom'));
      await tester.tap(executeFinder);
      await tester.pump(const Duration(milliseconds: 2000));
      Text tokenText = tester.firstWidget(find.byKey(const Key('token')));
      expect(tokenText.data != null, true);
      expect(tokenText.data?.isNotEmpty, true);
      expect(tokenText.data?.toLowerCase().contains('error'), false);
    });
  });
}
