import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:germination_chamber/main.dart';
import 'package:germination_chamber/features/device_control/widgets/device_control_card.dart';
import 'package:germination_chamber/features/device_control/widgets/water_level_control_card.dart';
import 'package:germination_chamber/features/setpoint/services/setpoint_protection.dart';
import 'package:germination_chamber/features/setpoint/models/setpoint_data.dart';
import 'package:germination_chamber/features/setpoint/widgets/discard_confirm_dialog.dart';
import 'package:germination_chamber/features/setpoint/widgets/unsaved_changes_dialog.dart';
import 'package:germination_chamber/features/settings/services/settings_controller.dart';
import 'package:germination_chamber/features/settings/models/app_settings_data.dart';

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

  testWidgets('Verifikasi Lengkap Halaman Setpoint, Editable Value Box & Validasi Clamping (14 Checklist)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // 1. Navigasi ke halaman Setpoint melalui menu sidebar
    final setpointMenu = find.widgetWithText(InkWell, 'Setpoint');
    expect(setpointMenu, findsOneWidget);
    await tester.tap(setpointMenu);
    await tester.pumpAndSettle();

    // Verifikasi Header Setpoint
    expect(find.text('Setpoint'), findsWidgets);
    expect(find.text('Configure target ranges for automatic control'), findsOneWidget);
    expect(find.text('14:32'), findsOneWidget);
    expect(find.text('26 Apr 2025'), findsOneWidget);

    // Verifikasi Keberadaan Seluruh Card
    expect(find.text('Temperature'), findsOneWidget);
    expect(find.text('Kelembapan'), findsOneWidget);
    expect(find.text('Cahaya'), findsOneWidget);
    expect(find.text('Ventilasi (Kipas)'), findsOneWidget);
    expect(find.text('Parameter Lainnya'), findsOneWidget);
    expect(find.text('Ventilation defaults'), findsOneWidget);
    expect(find.text('Used by AUTO mode'), findsOneWidget);
    expect(find.text('Automatic logic'), findsOneWidget);
    expect(find.text('Save changes'), findsNothing);

    // Verifikasi Nilai Awal Value Box
    final tempSetpointInput = find.byKey(const Key('temp_setpoint_input'));
    final tempUpperInput = find.byKey(const Key('temp_upper_input'));
    final tempLowerInput = find.byKey(const Key('temp_lower_input'));

    expect(find.widgetWithText(TextField, '28.0'), findsOneWidget);
    expect(find.widgetWithText(TextField, '30.0'), findsOneWidget);
    expect(find.widgetWithText(TextField, '26.0'), findsOneWidget);
    expect(find.text('°C'), findsNWidgets(3));

    expect(find.widgetWithText(TextField, '85'), findsOneWidget);
    expect(find.widgetWithText(TextField, '90'), findsOneWidget);
    expect(find.widgetWithText(TextField, '80'), findsOneWidget);
    expect(find.text('%RH'), findsNWidgets(3));

    expect(find.widgetWithText(TextField, '7000'), findsOneWidget);
    expect(find.widgetWithText(TextField, '8000'), findsOneWidget);
    expect(find.widgetWithText(TextField, '6000'), findsOneWidget);
    expect(find.text('lux'), findsNWidgets(3));

    // CHECKLIST 1 & 2 & 3: Klik value Temperature, ketik 29.5 dan Enter tersimpan
    await tester.tap(tempSetpointInput);
    await tester.pumpAndSettle();
    await tester.enterText(tempSetpointInput, '29.5');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '29.5'), findsOneWidget);

    // CHECKLIST 4: Klik + bertambah sesuai step (29.5 -> 29.6)
    await tester.tap(find.byKey(const Key('temp_setpoint_inc')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '29.6'), findsOneWidget);

    // CHECKLIST 5: Klik - berkurang sesuai step (29.6 -> 29.5)
    await tester.tap(find.byKey(const Key('temp_setpoint_dec')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '29.5'), findsOneWidget);

    // CHECKLIST 6: Input tidak valid (kosong atau karakter non-numerik) ditolak/dikembalikan
    await tester.enterText(tempSetpointInput, 'abc');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '29.5'), findsOneWidget);

    // CHECKLIST 7: Setpoint tidak dapat melewati Batas Atas (ketik 35.0, clamped ke 30.0)
    await tester.enterText(tempSetpointInput, '35.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '30.0'), findsNWidgets(2)); // Setpoint di-clamp ke upper 30.0

    // CHECKLIST 8: Setpoint tidak dapat turun melewati Batas Bawah (ketik 20.0, clamped ke 26.0)
    await tester.enterText(tempSetpointInput, '20.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '26.0'), findsNWidgets(2)); // Setpoint di-clamp ke lower 26.0

    // CHECKLIST 9: Batas Atas tidak dapat turun di bawah Setpoint (ketik 24.0 saat setpoint 26.0, clamped ke 26.0)
    await tester.enterText(tempUpperInput, '24.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '26.0'), findsNWidgets(3)); // Upper di-clamp ke setpoint 26.0

    // Kembalikan Upper ke 30.0
    await tester.enterText(tempUpperInput, '30.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // CHECKLIST 10: Batas Bawah tidak dapat naik di atas Setpoint (ketik 28.0 saat setpoint 26.0, clamped ke 26.0)
    await tester.enterText(tempLowerInput, '28.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '26.0'), findsNWidgets(2)); // Lower di-clamp ke setpoint 26.0

    // Uji Edit Manual Parameter Lain: Kelembapan, Cahaya, Intake Fan
    final humidityInput = find.byKey(const Key('humidity_setpoint_input'));
    await tester.enterText(humidityInput, '88');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '88'), findsOneWidget);

    final lightInput = find.byKey(const Key('light_setpoint_input'));
    await tester.enterText(lightInput, '7500');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '7500'), findsOneWidget);

    final intakeInput = find.byKey(const Key('intake_input'));
    await tester.enterText(intakeInput, '75');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '75'), findsOneWidget);

    // CHECKLIST 11: Tombol Apply changes di Sticky Action Bar adalah satu-satunya tombol simpan
    expect(find.byKey(const Key('save_changes_btn')), findsNothing);
    expect(find.byKey(const Key('discard_changes_btn')), findsNothing);
    expect(find.text('Automatic logic'), findsOneWidget);
    expect(find.text('Controller uses sensor values, setpoints and limits to manage actuators.'), findsOneWidget);

    final applyButton = find.byKey(const Key('action_bar_apply_btn'));
    expect(applyButton, findsOneWidget);
    await tester.tap(applyButton);
    await tester.pumpAndSettle();
    expect(find.text('Setpoint changes applied successfully'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // CHECKLIST 14: Navigasi kembali ke Dashboard dan Kontrol Perangkat tanpa merusak halaman lain
    final dashboardMenu = find.widgetWithText(InkWell, 'Beranda');
    await tester.tap(dashboardMenu);
    await tester.pumpAndSettle();
    expect(find.text('Overview kondisi chamber dan perangkat secara realtime'), findsOneWidget);

    final kontrolPerangkatMenu = find.widgetWithText(InkWell, 'Kontrol Perangkat');
    await tester.tap(kontrolPerangkatMenu);
    await tester.pumpAndSettle();
    expect(find.text('Kontrol Perangkat'), findsWidgets);
  });

  testWidgets('Verifikasi Final UX Polish Setpoint - Unsaved Changes, Cards, Sticky Action Bar & Guard (TEST 1 - TEST 11)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Reset saved state baseline
    SetpointProtection.savedData = SetpointData.initial();

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Navigasi ke Setpoint
    await tester.tap(find.widgetWithText(InkWell, 'Setpoint'));
    await tester.pumpAndSettle();

    final tempInput = find.byKey(const Key('temp_setpoint_input'));
    final berandaMenu = find.widgetWithText(InkWell, 'Beranda');

    // ==========================================
    // TEST 1: Initial state tidak memiliki Unsaved Changes
    // ==========================================
    expect(SetpointProtection.hasUnsavedChanges, isFalse);
    expect(find.byKey(const Key('unsaved_changes_header_indicator')), findsNothing);
    expect(find.byKey(const Key('setpoint_sticky_action_bar')), findsNothing);
    expect(find.byKey(const Key('card_modified_temperature')), findsNothing);

    // ==========================================
    // TEST 2: Mengubah satu parameter -> Unsaved Changes muncul
    // ==========================================
    await tester.tap(tempInput);
    await tester.pumpAndSettle();
    await tester.enterText(tempInput, '29.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(SetpointProtection.hasUnsavedChanges, isTrue);
    expect(find.byKey(const Key('unsaved_changes_header_indicator')), findsOneWidget);
    expect(find.text('Unsaved changes · 1'), findsOneWidget);
    expect(find.byKey(const Key('setpoint_sticky_action_bar')), findsOneWidget);
    expect(find.byKey(const Key('card_modified_temperature')), findsOneWidget);
    expect(find.byKey(const Key('action_bar_discard_btn')), findsOneWidget);
    expect(find.byKey(const Key('action_bar_apply_btn')), findsOneWidget);

    // ==========================================
    // TEST 3: Mengembalikan parameter ke nilai tersimpan -> Unsaved Changes hilang
    // ==========================================
    await tester.enterText(tempInput, '28.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(SetpointProtection.hasUnsavedChanges, isFalse);
    expect(find.byKey(const Key('unsaved_changes_header_indicator')), findsNothing);
    expect(find.byKey(const Key('setpoint_sticky_action_bar')), findsNothing);
    expect(find.byKey(const Key('card_modified_temperature')), findsNothing);

    // ==========================================
    // TEST 4: Apply Changes -> nilai menjadi saved state dan indikator hilang
    // ==========================================
    await tester.enterText(tempInput, '28.5');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(SetpointProtection.hasUnsavedChanges, isTrue);

    final applyBtn = find.byKey(const Key('action_bar_apply_btn'));
    expect(applyBtn, findsOneWidget);
    await tester.tap(applyBtn);
    await tester.pumpAndSettle();

    expect(SetpointProtection.hasUnsavedChanges, isFalse);
    expect(SetpointProtection.savedData.tempSetpoint, 28.5);
    expect(find.text('Setpoint changes applied successfully'), findsOneWidget);
    expect(find.byKey(const Key('unsaved_changes_header_indicator')), findsNothing);
    expect(find.byKey(const Key('setpoint_sticky_action_bar')), findsNothing);
    expect(find.byKey(const Key('card_modified_temperature')), findsNothing);

    // Biarkan SnackBar 2 detik selesai agar tidak menutupi layar untuk test berikutnya
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // ==========================================
    // TEST 5: Discard Changes -> nilai kembali ke saved state
    // ==========================================
    await tester.enterText(tempInput, '29.2');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(SetpointProtection.hasUnsavedChanges, isTrue);

    // Tekan Discard changes di sticky action bar
    await tester.tap(find.byKey(const Key('action_bar_discard_btn')));
    await tester.pumpAndSettle();

    // Dialog konfirmasi discard muncul
    expect(find.byType(DiscardConfirmDialog), findsOneWidget);
    expect(find.text('Discard changes?'), findsOneWidget);
    expect(find.text('Your unsaved changes will be lost.'), findsOneWidget);

    // Uji Cancel pada dialog discard -> draft tetap ada
    await tester.tap(find.byKey(const Key('discard_dialog_cancel_btn')));
    await tester.pumpAndSettle();
    expect(find.byType(DiscardConfirmDialog), findsNothing);
    expect(SetpointProtection.hasUnsavedChanges, isTrue);
    expect(find.widgetWithText(TextField, '29.2'), findsOneWidget);

    // Tekan Discard changes lagi -> kali ini pilih Discard
    await tester.tap(find.byKey(const Key('action_bar_discard_btn')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('discard_dialog_discard_btn')));
    await tester.pumpAndSettle();

    // Nilai kembali ke saved state (28.5), indikator hilang
    expect(SetpointProtection.hasUnsavedChanges, isFalse);
    expect(find.widgetWithText(TextField, '28.5'), findsOneWidget);
    expect(find.byKey(const Key('unsaved_changes_header_indicator')), findsNothing);
    expect(find.byKey(const Key('setpoint_sticky_action_bar')), findsNothing);

    // ==========================================
    // TEST 6: Navigation tanpa perubahan -> langsung berpindah
    // ==========================================
    await tester.tap(berandaMenu);
    await tester.pumpAndSettle();
    expect(find.byType(UnsavedChangesDialog), findsNothing);
    expect(find.text('Overview kondisi chamber dan perangkat secara realtime'), findsOneWidget);

    // Kembali ke Setpoint
    await tester.tap(find.widgetWithText(InkWell, 'Setpoint'));
    await tester.pumpAndSettle();

    // ==========================================
    // TEST 7: Navigation dengan Unsaved Changes -> dialog muncul
    // ==========================================
    await tester.enterText(tempInput, '29.8');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(SetpointProtection.hasUnsavedChanges, isTrue);

    await tester.tap(berandaMenu);
    await tester.pumpAndSettle();

    expect(find.byType(UnsavedChangesDialog), findsOneWidget);
    expect(find.text('You have unsaved changes. What would you like to do?'), findsOneWidget);

    // ==========================================
    // TEST 8: Stay -> tetap di Setpoint dan perubahan tetap ada
    // ==========================================
    await tester.tap(find.byKey(const Key('dialog_stay_here_btn')));
    await tester.pumpAndSettle();

    expect(find.byType(UnsavedChangesDialog), findsNothing);
    expect(find.text('Setpoint'), findsWidgets);
    expect(find.widgetWithText(TextField, '29.8'), findsOneWidget);
    expect(SetpointProtection.hasUnsavedChanges, isTrue);

    // ==========================================
    // TEST 9: Discard dari dialog -> perubahan dibuang dan navigation dilanjutkan
    // ==========================================
    await tester.tap(berandaMenu);
    await tester.pumpAndSettle();
    expect(find.byType(UnsavedChangesDialog), findsOneWidget);

    await tester.tap(find.byKey(const Key('dialog_discard_btn')));
    await tester.pumpAndSettle();

    expect(find.byType(UnsavedChangesDialog), findsNothing);
    expect(find.text('Overview kondisi chamber dan perangkat secara realtime'), findsOneWidget);

    // Kembali ke Setpoint -> nilai adalah saved state (28.5), bukan 29.8
    await tester.tap(find.widgetWithText(InkWell, 'Setpoint'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '28.5'), findsOneWidget);
    expect(SetpointProtection.hasUnsavedChanges, isFalse);

    // ==========================================
    // TEST 10: Apply dari dialog -> perubahan disimpan dan navigation dilanjutkan
    // ==========================================
    await tester.enterText(find.byKey(const Key('temp_setpoint_input')), '27.5');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(SetpointProtection.hasUnsavedChanges, isTrue);

    await tester.tap(berandaMenu);
    await tester.pumpAndSettle();
    expect(find.byType(UnsavedChangesDialog), findsOneWidget);

    await tester.tap(find.byKey(const Key('dialog_save_btn')));
    await tester.pumpAndSettle();

    expect(find.byType(UnsavedChangesDialog), findsNothing);
    expect(find.text('Overview kondisi chamber dan perangkat secara realtime'), findsOneWidget);
    expect(SetpointProtection.savedData.tempSetpoint, 27.5);

    // Kembali ke Setpoint -> tersimpan 27.5 dan hasUnsavedChanges false
    await tester.tap(find.widgetWithText(InkWell, 'Setpoint'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, '27.5'), findsOneWidget);
    expect(SetpointProtection.hasUnsavedChanges, isFalse);

    // ==========================================
    // TEST 11: Beberapa parameter berubah -> semuanya ikut disimpan/dibuang secara konsisten
    // ==========================================
    // Ubah 3 parameter: Temperature, Kelembapan, dan Cahaya
    await tester.enterText(find.byKey(const Key('temp_setpoint_input')), '28.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('humidity_setpoint_input')), '82');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('light_setpoint_input')), '7200');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Verifikasi header count: "Unsaved changes · 3"
    expect(find.text('Unsaved changes · 3'), findsOneWidget);
    expect(find.text('Unsaved changes (3)'), findsOneWidget);

    // Verifikasi ketiga card menampilkan badge Modified
    expect(find.byKey(const Key('card_modified_temperature')), findsOneWidget);
    expect(find.byKey(const Key('card_modified_kelembapan')), findsOneWidget);
    expect(find.byKey(const Key('card_modified_cahaya')), findsOneWidget);

    // Tekan Apply changes di sticky action bar
    await tester.tap(find.byKey(const Key('action_bar_apply_btn')));
    await tester.pumpAndSettle();

    expect(SetpointProtection.hasUnsavedChanges, isFalse);
    expect(SetpointProtection.savedData.tempSetpoint, 28.0);
    expect(SetpointProtection.savedData.humiditySetpoint, 82);
    expect(SetpointProtection.savedData.lightSetpoint, 7200);

    // Semua badge dan sticky action bar hilang
    expect(find.byKey(const Key('unsaved_changes_header_indicator')), findsNothing);
    expect(find.byKey(const Key('setpoint_sticky_action_bar')), findsNothing);
    expect(find.byKey(const Key('card_modified_temperature')), findsNothing);
    expect(find.byKey(const Key('card_modified_kelembapan')), findsNothing);
    expect(find.byKey(const Key('card_modified_cahaya')), findsNothing);
  });

  testWidgets('Verifikasi Lengkap Halaman Monitoring - Clean, Charts, Telemetry & Chamber Status', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Navigasi ke halaman Monitoring melalui sidebar
    final monitoringMenu = find.widgetWithText(InkWell, 'Monitoring');
    expect(monitoringMenu, findsOneWidget);
    await tester.tap(monitoringMenu);
    await tester.pumpAndSettle();

    // 1. HEADER
    expect(find.text('Monitoring'), findsWidgets);
    expect(find.text('Realtime environmental telemetry'), findsOneWidget);
    expect(find.text('14:32'), findsOneWidget);
    expect(find.text('26 Apr 2025'), findsOneWidget);

    // 2. 4 CURRENT SENSOR CARDS
    expect(find.text('Temperature'), findsOneWidget);
    expect(find.text('28.1'), findsWidgets);
    expect(find.text('°C'), findsWidgets);
    expect(find.text('Within range'), findsNWidgets(3)); // Temp, Humidity, Light

    expect(find.text('Kelembapan'), findsWidgets);
    expect(find.text('83'), findsWidgets);
    expect(find.text('%RH'), findsWidgets);

    expect(find.text('Cahaya'), findsWidgets);
    expect(find.text('7420'), findsWidgets);
    expect(find.text('lux'), findsWidgets);

    expect(find.text('Water Level'), findsWidgets);
    expect(find.text('80'), findsWidgets);
    expect(find.text('Normal'), findsOneWidget);

    // 3. CHARTS
    expect(find.text('Temperature & Kelembapan'), findsOneWidget);
    expect(find.text('Last 6 hours'), findsNWidgets(3)); // 3 charts default 6H
    expect(find.text('Temperature (°C)'), findsWidgets);
    expect(find.text('Kelembapan (%RH)'), findsWidgets);

    expect(find.text('Cahaya'), findsWidgets);
    expect(find.text('Light (lux)'), findsOneWidget);
    expect(find.text('Setpoint (7000 lux)'), findsOneWidget);

    expect(find.text('Water Level'), findsWidgets);
    expect(find.text('Water Level (%)'), findsWidgets);
    expect(find.text('Target (80 %)'), findsOneWidget);

    // Interaktivitas Filter Waktu (misal klik 1H pada chart Temperature & Kelembapan)
    final filter1H = find.byKey(const Key('period_filter_temperature_&_kelembapan_1H'));
    expect(filter1H, findsOneWidget);
    await tester.tap(filter1H);
    await tester.pumpAndSettle();
    expect(find.text('Last 1 hour'), findsOneWidget);

    // 4. CHAMBER STATUS
    expect(find.text('Chamber Status'), findsOneWidget);
    expect(find.text('Mode'), findsOneWidget);
    expect(find.text('AUTO'), findsOneWidget);
    expect(find.text('Mist Maker'), findsOneWidget);
    expect(find.text('OFF'), findsOneWidget);
    expect(find.text('Blower'), findsOneWidget);
    expect(find.text('ON'), findsOneWidget);
    expect(find.text('Intake Fan'), findsOneWidget);
    expect(find.text('60 %'), findsOneWidget);
    expect(find.text('Exhaust Fan'), findsOneWidget);
    expect(find.text('50 %'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);

    // 5. LATEST SENSOR READINGS TABLE
    expect(find.text('Latest Sensor Readings'), findsOneWidget);
    expect(find.text('Most recent data from all sensors'), findsOneWidget);
    expect(find.text('14:30'), findsWidgets);
    expect(find.text('14:20'), findsWidgets);
    expect(find.text('14:10'), findsWidgets);
    expect(find.text('14:00'), findsWidgets);
    expect(find.text('13:50'), findsWidgets);

    // 6. VERIFIKASI SIFAT READ-ONLY (Tidak ada stepper +/- atau switch kontrol)
    expect(find.byKey(const Key('temp_setpoint_dec')), findsNothing);
    expect(find.byKey(const Key('temp_setpoint_inc')), findsNothing);
    expect(find.byType(Switch), findsNothing);
  });

  testWidgets('Verifikasi Lengkap Halaman Alarm & Notifikasi - Header, Summary Bar, Event List & Filter', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Navigasi ke halaman Alarm & Notifikasi melalui sidebar
    final alarmMenu = find.widgetWithText(InkWell, 'Alarm & Notifikasi');
    expect(alarmMenu, findsOneWidget);
    await tester.tap(alarmMenu);
    await tester.pumpAndSettle();

    // 1. HEADER
    expect(find.text('Alarm & Notifikasi'), findsWidgets);
    expect(find.text('Events, warnings and system notifications'), findsOneWidget);
    expect(find.text('14:32'), findsOneWidget);
    expect(find.text('26 Apr 2025'), findsOneWidget);

    // 2. SUMMARY BAR (Default: All)
    expect(find.text('7 events'), findsOneWidget);
    expect(find.text('2 warnings • 1 critical • 4 info'), findsOneWidget);
    expect(find.text('Filter: All'), findsOneWidget);

    // 3. EVENT LIST (Default 7 Events)
    expect(find.text('CRITICAL'), findsOneWidget);
    expect(find.text('Suhu terlalu tinggi'), findsOneWidget);
    expect(find.text('Temperature exceeded upper limit'), findsOneWidget);
    expect(find.text('10:15'), findsOneWidget);

    expect(find.text('WARNING'), findsNWidgets(2));
    expect(find.text('Water level rendah'), findsOneWidget);
    expect(find.text('Water level is below safe threshold'), findsOneWidget);
    expect(find.text('11:23'), findsOneWidget);

    expect(find.text('Kelembapan terlalu rendah'), findsOneWidget);
    expect(find.text('RH is below configured setpoint'), findsOneWidget);
    expect(find.text('09:20'), findsOneWidget);

    expect(find.text('INFO'), findsNWidgets(4));
    expect(find.text('Selisih sensor normal'), findsOneWidget);
    expect(find.text('Sensor difference returned to normal'), findsOneWidget);
    expect(find.text('08:45'), findsOneWidget);

    expect(find.text('Mist Maker OFF'), findsOneWidget);
    expect(find.text('Humidity reached target'), findsOneWidget);
    expect(find.text('08:10'), findsOneWidget);

    // 4. BUKA DROPDOWN & VERIFIKASI VISIBILITAS SEMUA OPSI & INDIKATOR CHECKMARK
    await tester.tap(find.byKey(const Key('alarm_filter_dropdown')));
    await tester.pumpAndSettle();

    // Verifikasi semua opsi ditemukan dan dapat dibaca saat popup dibuka
    expect(find.byKey(const Key('filter_option_all')), findsOneWidget);
    expect(find.byKey(const Key('filter_option_critical')), findsOneWidget);
    expect(find.byKey(const Key('filter_option_warning')), findsOneWidget);
    expect(find.byKey(const Key('filter_option_info')), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget); // Checkmark aktif pada 'All'

    // Pilih Filter: Critical
    await tester.tap(find.byKey(const Key('filter_option_critical')));
    await tester.pumpAndSettle();

    expect(find.text('Filter: Critical'), findsOneWidget);
    expect(find.text('1 event'), findsOneWidget);
    expect(find.text('1 critical'), findsOneWidget);
    expect(find.text('Suhu terlalu tinggi'), findsOneWidget);
    expect(find.text('Water level rendah'), findsNothing);
    expect(find.text('Selisih sensor normal'), findsNothing);

    // 5. FILTER: Warning (dan verifikasi checkmark pada Critical sebelum ganti)
    await tester.tap(find.byKey(const Key('alarm_filter_dropdown')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsOneWidget); // Checkmark aktif pada 'Critical'
    await tester.tap(find.byKey(const Key('filter_option_warning')));
    await tester.pumpAndSettle();

    expect(find.text('Filter: Warning'), findsOneWidget);
    expect(find.text('2 events'), findsOneWidget);
    expect(find.text('2 warnings'), findsOneWidget);
    expect(find.text('Water level rendah'), findsOneWidget);
    expect(find.text('Kelembapan terlalu rendah'), findsOneWidget);
    expect(find.text('Suhu terlalu tinggi'), findsNothing);

    // 6. FILTER: Info
    await tester.tap(find.byKey(const Key('alarm_filter_dropdown')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsOneWidget); // Checkmark aktif pada 'Warning'
    await tester.tap(find.byKey(const Key('filter_option_info')));
    await tester.pumpAndSettle();

    expect(find.text('Filter: Info'), findsOneWidget);
    expect(find.text('4 events'), findsOneWidget);
    expect(find.text('4 info'), findsOneWidget);
    expect(find.text('Selisih sensor normal'), findsOneWidget);
    expect(find.text('Mist Maker OFF'), findsOneWidget);
    expect(find.text('Suhu terlalu tinggi'), findsNothing);

    // 7. KEMBALI KE FILTER: All
    await tester.tap(find.byKey(const Key('alarm_filter_dropdown')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsOneWidget); // Checkmark aktif pada 'Info'
    await tester.tap(find.byKey(const Key('filter_option_all')));
    await tester.pumpAndSettle();

    expect(find.text('Filter: All'), findsOneWidget);
    expect(find.text('7 events'), findsOneWidget);
    expect(find.text('2 warnings • 1 critical • 4 info'), findsOneWidget);
    expect(find.text('Suhu terlalu tinggi'), findsOneWidget);
    expect(find.text('Water level rendah'), findsOneWidget);

    // 8. VERIFIKASI SIFAT READ-ONLY (Tidak ada kontrol actuator atau stepper)
    expect(find.byType(Switch), findsNothing);
    expect(find.byType(Slider), findsNothing);
    expect(find.byKey(const Key('temp_setpoint_dec')), findsNothing);
  });

  testWidgets('Verifikasi Lengkap Modul Pengaturan (TEST 1 - TEST 12)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Reset settings controller ke kondisi default awal
    SettingsController.instance.resetToDefault();

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // ==========================================
    // TEST 1: Settings screen dapat dibuka via Sidebar
    // ==========================================
    final settingsSidebarMenu = find.widgetWithText(InkWell, 'Pengaturan');
    expect(settingsSidebarMenu, findsOneWidget);
    await tester.tap(settingsSidebarMenu);
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(
      find.text('Configure application and system preferences'),
      findsOneWidget,
    );

    // ==========================================
    // TEST 2: Semua 6 menu Settings terlihat
    // ==========================================
    expect(find.byKey(const Key('settings_menu_calibration')), findsOneWidget);
    expect(find.byKey(const Key('settings_menu_date_time')), findsOneWidget);
    expect(find.byKey(const Key('settings_menu_appearance')), findsOneWidget);
    expect(find.byKey(const Key('settings_menu_language')), findsOneWidget);
    expect(find.byKey(const Key('settings_menu_system_info')), findsOneWidget);
    expect(find.byKey(const Key('settings_menu_reset')), findsOneWidget);

    expect(find.text('Sensor Calibration'), findsOneWidget);
    expect(find.text('Date & Time'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('System Information'), findsOneWidget);
    expect(find.text('Reset Settings'), findsOneWidget);

    // ==========================================
    // TEST 3: Kalibrasi Sensor dapat dibuka & elemen terverifikasi
    // ==========================================
    await tester.tap(find.byKey(const Key('settings_menu_calibration')));
    await tester.pumpAndSettle();

    expect(find.text('Sensor Calibration'), findsWidgets);
    expect(find.text('Adjust sensor readings using calibration offsets'), findsOneWidget);
    expect(find.text('Back to Settings'), findsOneWidget);
    expect(find.text('Temperature (SHT31)'), findsOneWidget);
    expect(find.text('Humidity (SHT31)'), findsOneWidget);
    expect(find.text('Light (BH1750)'), findsOneWidget);
    expect(find.text('Water Level (Contactless)'), findsOneWidget);

    // ==========================================
    // TEST 11: Editable settings memiliki unsaved changes state
    // ==========================================
    expect(find.byKey(const Key('calibration_sticky_action_bar')), findsNothing);
    expect(find.byKey(const Key('settings_unsaved_indicator')), findsNothing);

    // Ubah offset temperatur dengan tombol '+'
    await tester.tap(find.byKey(const Key('temp_offset_inc')));
    await tester.pumpAndSettle();

    // Verifikasi indikator & sticky action bar muncul
    expect(find.byKey(const Key('calibration_sticky_action_bar')), findsOneWidget);
    expect(find.byKey(const Key('settings_unsaved_indicator')), findsOneWidget);
    expect(find.text('Unsaved changes (1)'), findsWidgets);

    // ==========================================
    // TEST 12: Navigation guard bekerja ketika terdapat perubahan yang belum disimpan
    // ==========================================
    // Coba klik tombol back di header ("← Back to Settings")
    await tester.tap(find.byKey(const Key('settings_back_btn')));
    await tester.pumpAndSettle();

    // Verifikasi dialog Unsaved Changes muncul
    expect(find.text('Unsaved changes'), findsWidgets);
    expect(
      find.text('You have unsaved changes. What would you like to do?'),
      findsOneWidget,
    );

    // Klik 'Stay' -> tetap di halaman kalibrasi
    await tester.tap(find.byKey(const Key('dialog_stay_here_btn')));
    await tester.pumpAndSettle();
    expect(find.text('Temperature (SHT31)'), findsOneWidget);
    expect(find.byKey(const Key('calibration_sticky_action_bar')), findsOneWidget);

    // Klik 'Discard changes' pada sticky action bar -> kembali ke state bersih
    await tester.tap(find.byKey(const Key('calibration_discard_btn')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('calibration_sticky_action_bar')), findsNothing);

    // Kembali ke menu utama Settings dengan "← Back to Settings"
    await tester.tap(find.byKey(const Key('settings_back_btn')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('settings_menu_calibration')), findsOneWidget);

    // ==========================================
    // TEST 4: Tanggal & Waktu dapat dibuka & dikonfigurasi
    // ==========================================
    await tester.tap(find.byKey(const Key('settings_menu_date_time')));
    await tester.pumpAndSettle();

    expect(find.text('Date & Time'), findsWidgets);
    expect(find.text('Configure date, time and timezone'), findsOneWidget);
    expect(find.text('Back to Settings'), findsOneWidget);
    expect(find.text('Use system time'), findsOneWidget);
    expect(find.text('Manual Adjustment'), findsOneWidget);
    expect(find.text('Timezone'), findsOneWidget);
    expect(find.text('24-Hour Format'), findsOneWidget);

    // Toggle 'Use system time'
    await tester.tap(find.byKey(const Key('switch_use_system_time')));
    await tester.pumpAndSettle();
    expect(SettingsController.instance.useSystemTime, false);

    // Toggle '24-Hour Format'
    await tester.tap(find.byKey(const Key('switch_24_hour_format')));
    await tester.pumpAndSettle();
    expect(SettingsController.instance.is24HourFormat, false);

    // Kembali ke menu Settings
    await tester.tap(find.byKey(const Key('settings_back_btn')));
    await tester.pumpAndSettle();

    // ==========================================
    // TEST 5: Tampilan dapat dibuka & dikonfigurasi
    // ==========================================
    await tester.tap(find.byKey(const Key('settings_menu_appearance')));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsWidgets);
    expect(find.text('Customize application appearance'), findsOneWidget);
    expect(find.text('Back to Settings'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Density'), findsOneWidget);
    expect(find.text('Animation'), findsOneWidget);

    // Pilih Dark mode
    await tester.tap(find.byKey(const Key('theme_option_dark')));
    await tester.pumpAndSettle();
    expect(SettingsController.instance.themeMode, ThemeMode.dark);

    // Pilih Compact density
    await tester.tap(find.byKey(const Key('density_option_compact')));
    await tester.pumpAndSettle();
    expect(SettingsController.instance.density, AppDensity.compact);

    // Kembali ke menu Settings
    await tester.tap(find.byKey(const Key('settings_back_btn')));
    await tester.pumpAndSettle();

    // ==========================================
    // TEST 6: Bahasa dapat dibuka & dikonfigurasi
    // ==========================================
    await tester.tap(find.byKey(const Key('settings_menu_language')));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsWidgets);
    expect(find.text('Choose application language'), findsOneWidget);
    expect(find.text('Back to Settings'), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsWidgets);
    expect(find.text('English'), findsOneWidget);

    // Ganti ke English
    await tester.tap(find.byKey(const Key('lang_option_en')));
    await tester.pumpAndSettle();
    expect(SettingsController.instance.languageCode, 'en');

    // Kembali ke menu Settings
    await tester.tap(find.byKey(const Key('settings_back_btn')));
    await tester.pumpAndSettle();

    // ==========================================
    // TEST 7: Informasi Sistem dapat dibuka (Read-only)
    // ==========================================
    await tester.tap(find.byKey(const Key('settings_menu_system_info')));
    await tester.pumpAndSettle();

    expect(find.text('System Information'), findsWidgets);
    expect(find.text('View controller and application information'), findsOneWidget);
    expect(find.text('Back to Settings'), findsOneWidget);
    expect(find.text('Application'), findsOneWidget);
    expect(find.text('Controller'), findsNWidgets(2));
    expect(find.text('Hardware'), findsOneWidget);
    expect(find.text('Germination Chamber Controller'), findsOneWidget);
    expect(find.text('Mini PC'), findsOneWidget);

    // Kembali ke menu Settings
    await tester.tap(find.byKey(const Key('settings_back_btn')));
    await tester.pumpAndSettle();

    // ==========================================
    // TEST 8: Reset Settings menampilkan confirmation dialog
    // ==========================================
    await tester.tap(find.byKey(const Key('settings_menu_reset')));
    await tester.pumpAndSettle();

    expect(find.text('Reset settings?'), findsOneWidget);
    expect(
      find.text('This will restore application preferences to their default values.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('reset_cancel_btn')), findsOneWidget);
    expect(find.byKey(const Key('reset_confirm_btn')), findsOneWidget);

    // ==========================================
    // TEST 9: Cancel pada reset tidak mengubah konfigurasi
    // ==========================================
    await tester.tap(find.byKey(const Key('reset_cancel_btn')));
    await tester.pumpAndSettle();

    // Dialog tertutup, konfigurasi tetap (language masih 'en', theme masih dark)
    expect(find.text('Reset settings?'), findsNothing);
    expect(SettingsController.instance.languageCode, 'en');
    expect(SettingsController.instance.themeMode, ThemeMode.dark);

    // ==========================================
    // TEST 10: Reset mengembalikan konfigurasi ke default
    // ==========================================
    await tester.tap(find.byKey(const Key('settings_menu_reset')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('reset_confirm_btn')));
    await tester.pumpAndSettle();

    // Dialog tertutup & feedback snackbar muncul
    expect(find.text('Reset settings?'), findsNothing);
    expect(find.text('Settings restored to default'), findsOneWidget);

    // Konfigurasi kembali ke default
    expect(SettingsController.instance.languageCode, 'id');
    expect(SettingsController.instance.themeMode, ThemeMode.system);
    expect(SettingsController.instance.density, AppDensity.standard);
    expect(SettingsController.instance.useSystemTime, true);
    expect(SettingsController.instance.is24HourFormat, true);
  });
}




