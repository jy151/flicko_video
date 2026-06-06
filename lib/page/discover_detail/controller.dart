import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

class DiscoverDetailController extends StateNotifier<DiscoverDetailArgs?> {
  DiscoverDetailController() : super(null);

  void setArgs(DiscoverDetailArgs args) {
    state = args;
  }
}  

final discoverDetailProvider =
    StateNotifierProvider.autoDispose<
      DiscoverDetailController,
      DiscoverDetailArgs?
    >((ref) => DiscoverDetailController());
