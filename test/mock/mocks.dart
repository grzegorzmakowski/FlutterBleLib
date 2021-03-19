
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';


@GenerateMocks([
  // ManagerForService,
  // ManagerForCharacteristic,
  // ManagerForDescriptor,
  // Service,
  // Characteristic
], customMocks: [
  MockSpec<Peripheral>(returnNullOnMissingStub: true),
  MockSpec<ManagerForService>(returnNullOnMissingStub: true),
  MockSpec<ManagerForCharacteristic>(returnNullOnMissingStub: true),
  MockSpec<ManagerForDescriptor>(returnNullOnMissingStub: true),
  MockSpec<Service>(returnNullOnMissingStub: true),
  MockSpec<Characteristic>(returnNullOnMissingStub: true)
])
class Yolo {

}


// class ManagerForServiceMock extends Mock implements ManagerForService {}
//
// class ManagerForCharacteristicMock extends Mock
//     implements ManagerForCharacteristic {}
//
// class ManagerForDescriptorMock extends Mock implements ManagerForDescriptor {}
//
// class ServiceMock extends Mock implements Service {}
//
// class PeripheralMock extends Mock implements Peripheral {}
//
// class CharacteristicMock extends Mock implements Characteristic {}
