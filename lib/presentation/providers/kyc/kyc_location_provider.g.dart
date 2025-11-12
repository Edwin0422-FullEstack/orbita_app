// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KycLocation)
const kycLocationProvider = KycLocationProvider._();

final class KycLocationProvider
    extends $NotifierProvider<KycLocation, AsyncValue<Position?>> {
  const KycLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kycLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kycLocationHash();

  @$internal
  @override
  KycLocation create() => KycLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Position?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Position?>>(value),
    );
  }
}

String _$kycLocationHash() => r'9da8bee253351d7f7b99f9039b73b3edc731b60d';

abstract class _$KycLocation extends $Notifier<AsyncValue<Position?>> {
  AsyncValue<Position?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Position?>, AsyncValue<Position?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Position?>, AsyncValue<Position?>>,
              AsyncValue<Position?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
