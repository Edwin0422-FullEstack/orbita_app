// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Ranking)
const rankingProvider = RankingProvider._();

final class RankingProvider extends $NotifierProvider<Ranking, RankingState> {
  const RankingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rankingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rankingHash();

  @$internal
  @override
  Ranking create() => Ranking();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RankingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RankingState>(value),
    );
  }
}

String _$rankingHash() => r'9f1deb09007bdfc481caadb1828a5bf53ead2faf';

abstract class _$Ranking extends $Notifier<RankingState> {
  RankingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RankingState, RankingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RankingState, RankingState>,
              RankingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
