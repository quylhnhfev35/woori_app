import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori_app/src/features/dashboard/data/dashboard_repository.dart';
import 'package:woori_app/src/features/dashboard/data/dto/phong_tap_summary.dart';
class DashboardState {
  const DashboardState({
    required this.summary,
    required this.buoiTaps,
  });

  final PhongTapSummary summary;
  final List<Map<String, dynamic>> buoiTaps;
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, AsyncValue<DashboardState>>(
  (ref) => DashboardController(DashboardRepository()),
);

class DashboardController extends StateNotifier<AsyncValue<DashboardState>> {
  DashboardController(this._repo) : super(const AsyncLoading());

  final DashboardRepository _repo;

  Future<void> loadHome() async {
    state = const AsyncLoading();
    try {
      final results = await Future.wait([
        _repo.fetchSummary(),
        _repo.fetchBuoiTaps(page: 1, limit: 10),
      ]);

      final summary = results[0] as PhongTapSummary;
      final buoiTaps = results[1] as List<Map<String, dynamic>>;

      state = AsyncData(DashboardState(summary: summary, buoiTaps: buoiTaps));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}