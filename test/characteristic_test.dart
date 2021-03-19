import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock/mocks.mocks.dart';
import 'test_util/characteristic_generator.dart';
import 'test_util/descriptor_generator.dart';

class ServiceMock extends Mock implements Service {}

void main() {
  Peripheral peripheral = MockPeripheral();
  ManagerForCharacteristic managerForCharacteristic =
      MockManagerForCharacteristic();
  CharacteristicGenerator characteristicGenerator =
      CharacteristicGenerator(managerForCharacteristic);
  DescriptorGenerator descriptorGenerator =
      DescriptorGenerator(MockManagerForDescriptor());

  Characteristic characteristic =
      characteristicGenerator.create(123, ServiceMock());

  DescriptorWithValue createDescriptor(int seed) =>
      descriptorGenerator.create(seed, characteristic);

  tearDown(() {
    [
      peripheral,
      managerForCharacteristic,
    ].forEach(clearInteractions);
  });

  test("descriptors returns a list of descriptors provided by manager", () async {
    //given
    when(managerForCharacteristic.descriptorsForCharacteristic(characteristic))
        .thenAnswer((_) => Future.value([
              createDescriptor(0),
              createDescriptor(1),
              createDescriptor(2),
            ]));

    //when
    var descriptors = await characteristic.descriptors();

    //then
    expect(
        descriptors,
        equals([
          createDescriptor(0),
          createDescriptor(1),
          createDescriptor(2),
        ]));
  });

  test("read returns expected value", () async {
    //given
    when(managerForCharacteristic.readCharacteristicForIdentifier(
            any, characteristic, "a123"))
        .thenAnswer((_) => Future.value(Uint8List.fromList([1, 2, 3, 4])));

    //when
    var value = await characteristic.read(transactionId: "a123");

    //then
    expect(value, equals(Uint8List.fromList([1, 2, 3, 4])));
  });

  test(
      "read invokes manager with expected params when transactionId is specified",
      () {
    //when
    characteristic.read(transactionId: "a123");

    //then
    verify(
      managerForCharacteristic.readCharacteristicForIdentifier(
          any, characteristic, "a123"),
    );
  });

  test(
      "write invokes manager with expected params when transactionId is specified",
      () {
    //when
    characteristic.write(
      Uint8List.fromList([1, 2, 3, 4]),
      false,
      transactionId: "a456",
    );

    //then
    verify(
      managerForCharacteristic.writeCharacteristicForIdentifier(
          any, characteristic, Uint8List.fromList([1, 2, 3, 4]), false, "a456"),
    );
  });

  test("monitor emits expected values", () {
    //given
    var streamController = StreamController<Uint8List>();
    when(managerForCharacteristic.monitorCharacteristicForIdentifier(
            any, characteristic, "a123"))
        .thenAnswer((_) => streamController.stream);

    //when
    var valuesNotifications = characteristic.monitor(transactionId: "a123");
    streamController.sink.add(Uint8List.fromList([1, 2, 3]));
    streamController.sink.add(Uint8List.fromList([4, 5, 6]));
    streamController.sink.add(Uint8List.fromList([7, 8, 9]));
    streamController.close();

    //then
    expect(
        valuesNotifications,
        emitsInOrder([
          emits(equals(Uint8List.fromList([1, 2, 3]))),
          emits(equals(Uint8List.fromList([4, 5, 6]))),
          emits(equals(Uint8List.fromList([7, 8, 9]))),
          emitsDone
        ]));
  });

  test(
      "monitor invokes manager with expected params when transactionId is specified",
      () {
    //when
    characteristic.monitor(transactionId: "a123");

    //then
    verify(
      managerForCharacteristic.monitorCharacteristicForIdentifier(
          any, characteristic, "a123"),
    );
  });

  test("readDescriptor returns expected descriptor", () async {
    //given
    when(managerForCharacteristic.readDescriptorForCharacteristic(
            characteristic, "123", "a456"))
        .thenAnswer((_) => Future.value(createDescriptor(0)));

    //when
    var descriptor =
        await characteristic.readDescriptor("123", transactionId: "a456");

    //then
    expect(descriptor, equals(createDescriptor(0)));
  });

  test(
      "readDescriptor invokes manager with expected params when transactionId is specified",
      () {
    //when
    characteristic.readDescriptor("123", transactionId: "a456");

    //then
    verify(
      managerForCharacteristic.readDescriptorForCharacteristic(
          characteristic, "123", "a456"),
    );
  });

  test("writeDescriptor returns expected descriptor", () async {
    //given
    when(managerForCharacteristic.writeDescriptorForCharacteristic(
            characteristic, "123", Uint8List.fromList([1, 2, 3, 4]), "a456"))
        .thenAnswer((_) => Future.value(createDescriptor(0)));

    //when
    var descriptor = await characteristic.writeDescriptor(
      "123",
      Uint8List.fromList([1, 2, 3, 4]),
      transactionId: "a456",
    );

    //then
    expect(descriptor, equals(createDescriptor(0)));
  });

  test(
      "writeDescriptor invokes manager with expected params when transactionId is specified",
      () {
    //when
    characteristic.writeDescriptor(
      "123",
      Uint8List.fromList([1, 2, 3, 4]),
      transactionId: "a456",
    );

    //then
    verify(
      managerForCharacteristic.writeDescriptorForCharacteristic(
          characteristic, "123", Uint8List.fromList([1, 2, 3, 4]), "a456"),
    );
  });
}
