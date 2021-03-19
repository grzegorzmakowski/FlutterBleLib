import 'package:mockito/annotations.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Peripheral>(returnNullOnMissingStub: true),
  MockSpec<ManagerForService>(returnNullOnMissingStub: true),
  MockSpec<ManagerForCharacteristic>(returnNullOnMissingStub: true),
  MockSpec<ManagerForDescriptor>(returnNullOnMissingStub: true),
  MockSpec<Service>(returnNullOnMissingStub: true),
  MockSpec<Characteristic>(returnNullOnMissingStub: true)
])
class Lorem {}