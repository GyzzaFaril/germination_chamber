import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:germination_chamber/main.dart';
import 'package:germination_chamber/features/device_control/widgets/device_control_card.dart';
import 'package:germination_chamber/features/device_control/widgets/water_level_control_card.dart';

void main() {
  testWidgets('Audit seluruh icon Dashboard sesuai desain Figma', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // 1. SIDEBAR ICONS AUDIT
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
    expect(find.byIcon(Icons.thermostat_outlined), findsNWidgets(4));
    expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // 2. DASHBOARD SENSOR ICONS AUDIT
    expect(find.byIcon(Icons.water_drop), findsNWidgets(3));

    // 3. STATUS PERANGKAT ICONS AUDIT
    expect(find.byIcon(Icons.air), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);

    // 4. LOGO
    expect(find.byIcon(Icons.energy_savings_leaf), findsOneWidget);
  });

  testWidgets('Verifikasi Lengkap Revisi UI & Alignment Kontrol Perangkat (TEST 1 - TEST 9)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Navigasi ke Kontrol Perangkat melalui sidebar
    final kontrolPerangkatMenu = find.widgetWithText(InkWell, 'Kontrol Perangkat');
    await tester.tap(kontrolPerangkatMenu);
    await tester.pumpAndSettle();

    final globalAutoButton = find.text('AUTO');
    final globalManualButton = find.text('MANUAL');

    // Finder Card & Control Keys
    final mistMakerCard = find.widgetWithText(DeviceControlCard, 'Mist Maker');
    final blowerCard = find.widgetWithText(DeviceControlCard, 'Blower');
    final intakeFanCard = find.widgetWithText(DeviceControlCard, 'Intake Fan');
    final exhaustFanCard = find.widgetWithText(DeviceControlCard, 'Exhaust Fan');
    final waterLevelCard = find.byType(WaterLevelControlCard);

    final mistToggle = find.byKey(const Key('toggle_Mist Maker'));
    final blowerToggle = find.byKey(const Key('toggle_Blower'));
    final intakeSlider = find.byKey(const Key('slider_Intake Fan'));
    final exhaustSlider = find.byKey(const Key('slider_Exhaust Fan'));
    final intakeInput = find.byKey(const Key('input_Intake Fan'));
    final exhaustInput = find.byKey(const Key('input_Exhaust Fan'));

    final mistManualPill = find.byKey(const Key('Mist Maker_pill_Manual'));
    final mistAutoPill = find.byKey(const Key('Mist Maker_pill_Auto'));
    final blowerManualPill = find.byKey(const Key('Blower_pill_Manual'));
    final blowerAutoPill = find.byKey(const Key('Blower_pill_Auto'));
    final intakeManualPill = find.byKey(const Key('Intake Fan_pill_Manual'));
    final intakeAutoPill = find.byKey(const Key('Intake Fan_pill_Auto'));
    final exhaustManualPill = find.byKey(const Key('Exhaust Fan_pill_Manual'));

    // =========================================================================
    // TEST 9: Alignment Posisi Value (ON, OFF, 41 %, 51 %, 80 %)
    // Harus berada pada kolom vertikal dengan koordinat dx horizontal yang sama!
    // =========================================================================
    final mistValDx = tester.getTopLeft(find.descendant(of: mistMakerCard, matching: find.text('ON'))).dx;
    final blowerValDx = tester.getTopLeft(find.descendant(of: blowerCard, matching: find.text('OFF'))).dx;
    final intakeValDx = tester.getTopLeft(find.descendant(of: intakeFanCard, matching: find.text('41 %'))).dx;
    final exhaustValDx = tester.getTopLeft(find.descendant(of: exhaustFanCard, matching: find.text('51 %'))).dx;
    final waterValDx = tester.getTopLeft(find.descendant(of: waterLevelCard, matching: find.text('80 %'))).dx;

    expect(mistValDx, equals(blowerValDx), reason: 'Mist Maker & Blower values must align');
    expect(blowerValDx, equals(intakeValDx), reason: 'Blower & Intake Fan values must align');
    expect(intakeValDx, equals(exhaustValDx), reason: 'Intake & Exhaust Fan values must align');
    expect(exhaustValDx, equals(waterValDx), reason: 'Fan & Water Level values must align');

    // =========================================================================
    // TEST 1: Semua AUTO
    // - Mist Maker toggle tidak terlihat
    // - Blower toggle tidak terlihat
    // - Intake slider tidak terlihat
    // - Exhaust slider tidak terlihat
    // - Value tetap terlihat
    // =========================================================================
    expect(mistToggle, findsNothing);
    expect(blowerToggle, findsNothing);
    expect(intakeSlider, findsNothing);
    expect(exhaustSlider, findsNothing);
    expect(intakeInput, findsNothing);
    expect(exhaustInput, findsNothing);

    expect(find.descendant(of: mistMakerCard, matching: find.text('ON')), findsOneWidget);
    expect(find.descendant(of: blowerCard, matching: find.text('OFF')), findsOneWidget);
    expect(find.descendant(of: intakeFanCard, matching: find.text('41 %')), findsOneWidget);
    expect(find.descendant(of: exhaustFanCard, matching: find.text('51 %')), findsOneWidget);

    // =========================================================================
    // TEST 2: Mist Maker MANUAL
    // - Toggle muncul
    // - Toggle dapat ON/OFF
    // =========================================================================
    await tester.tap(mistManualPill);
    await tester.pumpAndSettle();

    expect(mistToggle, findsOneWidget);
    await tester.tap(mistToggle); // ON -> OFF
    await tester.pumpAndSettle();
    expect(find.descendant(of: mistMakerCard, matching: find.text('OFF')), findsWidgets);

    await tester.tap(mistToggle); // OFF -> ON
    await tester.pumpAndSettle();
    expect(find.descendant(of: mistMakerCard, matching: find.text('ON')), findsWidgets);

    // Kembalikan ke AUTO -> toggle langsung hilang
    await tester.tap(mistAutoPill);
    await tester.pumpAndSettle();
    expect(mistToggle, findsNothing);

    // =========================================================================
    // TEST 3: Blower MANUAL
    // - Toggle muncul
    // - Toggle dapat ON/OFF
    // =========================================================================
    await tester.tap(blowerManualPill);
    await tester.pumpAndSettle();

    expect(blowerToggle, findsOneWidget);
    await tester.tap(blowerToggle); // OFF -> ON
    await tester.pumpAndSettle();
    expect(find.descendant(of: blowerCard, matching: find.text('ON')), findsWidgets);

    await tester.tap(blowerToggle); // ON -> OFF
    await tester.pumpAndSettle();
    expect(find.descendant(of: blowerCard, matching: find.text('OFF')), findsWidgets);

    await tester.tap(blowerAutoPill);
    await tester.pumpAndSettle();
    expect(blowerToggle, findsNothing);

    // =========================================================================
    // TEST 4: Intake Fan MANUAL
    // - Input angka muncul
    // - Slider muncul
    // - Input dan slider sinkron
    // - Value utama sinkron
    // =========================================================================
    await tester.tap(intakeManualPill);
    await tester.pumpAndSettle();

    expect(intakeInput, findsOneWidget);
    expect(intakeSlider, findsOneWidget);

    // Tes ubah via slider
    final Slider sliderWidget = tester.widget<Slider>(intakeSlider);
    sliderWidget.onChanged!(75.0);
    await tester.pumpAndSettle();
    expect(find.descendant(of: intakeFanCard, matching: find.text('75 %')), findsOneWidget);
    expect(find.descendant(of: intakeFanCard, matching: find.text('75')), findsOneWidget);

    // Tes ketik di TextField input angka
    await tester.enterText(intakeInput, '30');
    await tester.pumpAndSettle();
    expect(find.descendant(of: intakeFanCard, matching: find.text('30 %')), findsOneWidget);

    await tester.tap(intakeAutoPill);
    await tester.pumpAndSettle();
    expect(intakeInput, findsNothing);
    expect(intakeSlider, findsNothing);

    // =========================================================================
    // TEST 5: Exhaust Fan MANUAL
    // - Input angka muncul
    // - Slider muncul
    // - Input dan slider sinkron
    // - Value utama sinkron
    // =========================================================================
    await tester.tap(exhaustManualPill);
    await tester.pumpAndSettle();

    expect(exhaustInput, findsOneWidget);
    expect(exhaustSlider, findsOneWidget);

    final Slider exhaustSliderWidget = tester.widget<Slider>(exhaustSlider);
    exhaustSliderWidget.onChanged!(85.0);
    await tester.pumpAndSettle();
    expect(find.descendant(of: exhaustFanCard, matching: find.text('85 %')), findsOneWidget);

    await tester.enterText(exhaustInput, '55');
    await tester.pumpAndSettle();
    expect(find.descendant(of: exhaustFanCard, matching: find.text('55 %')), findsOneWidget);

    // =========================================================================
    // TEST 6: Global MANUAL
    // - Semua perangkat menjadi MANUAL
    // - Semua kontrol manual muncul
    // =========================================================================
    await tester.tap(globalManualButton);
    await tester.pumpAndSettle();

    expect(mistToggle, findsOneWidget);
    expect(blowerToggle, findsOneWidget);
    expect(intakeSlider, findsOneWidget);
    expect(exhaustSlider, findsOneWidget);
    expect(intakeInput, findsOneWidget);
    expect(exhaustInput, findsOneWidget);

    // =========================================================================
    // TEST 7: Global AUTO
    // - Semua perangkat menjadi AUTO
    // - Semua kontrol manual tersembunyi
    // =========================================================================
    await tester.tap(globalAutoButton);
    await tester.pumpAndSettle();

    expect(mistToggle, findsNothing);
    expect(blowerToggle, findsNothing);
    expect(intakeSlider, findsNothing);
    expect(exhaustSlider, findsNothing);
    expect(intakeInput, findsNothing);
    expect(exhaustInput, findsNothing);

    // =========================================================================
    // TEST 8: Water Level
    // - Menggunakan Icons.water_drop
    // - Tidak memiliki kontrol
    // - Value 80 % tetap tampil
    // =========================================================================
    expect(find.descendant(of: waterLevelCard, matching: find.byIcon(Icons.water_drop)), findsOneWidget);
    expect(find.descendant(of: waterLevelCard, matching: find.byType(Slider)), findsNothing);
    expect(find.descendant(of: waterLevelCard, matching: find.byType(TextField)), findsNothing);
    expect(find.descendant(of: waterLevelCard, matching: find.text('Auto')), findsNothing);
    expect(find.descendant(of: waterLevelCard, matching: find.text('Manual')), findsNothing);
    expect(find.descendant(of: waterLevelCard, matching: find.text('Normal')), findsOneWidget);
    expect(find.descendant(of: waterLevelCard, matching: find.text('80 %')), findsOneWidget);
  });
}
