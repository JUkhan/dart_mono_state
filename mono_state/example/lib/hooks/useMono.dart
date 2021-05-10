import 'package:mono_state/mono_state.dart';
import 'package:get/instance_manager.dart';

MonoState useMono() {
  final MonoState mono = Get.find();
  return mono;
}
