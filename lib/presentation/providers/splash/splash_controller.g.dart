// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splashController)
const splashControllerProvider = SplashControllerProvider._();

final class SplashControllerProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthStatus>,
          AuthStatus,
          FutureOr<AuthStatus>
        >
    with $FutureModifier<AuthStatus>, $FutureProvider<AuthStatus> {
  const SplashControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashControllerHash();

  @$internal
  @override
  $FutureProviderElement<AuthStatus> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthStatus> create(Ref ref) {
    return splashController(ref);
  }
}

String _$splashControllerHash() => r'ab6b7b3cdc722e7d0c06fa7e4776622987bf4be5';
