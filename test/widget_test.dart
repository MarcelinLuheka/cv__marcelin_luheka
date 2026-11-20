
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_marcelin_luheka/main.dart';

void main() {
  testWidgets('Application CV démarre correctement',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CVMarcelinApp());

    expect(find.text('BIENVENUE'), findsOneWidget);
  });
}
