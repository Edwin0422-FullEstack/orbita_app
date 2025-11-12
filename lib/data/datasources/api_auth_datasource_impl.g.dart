// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_datasource_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiAuthDatasource)
const apiAuthDatasourceProvider = ApiAuthDatasourceProvider._();

final class ApiAuthDatasourceProvider
    extends $FunctionalProvider<AuthDatasource, AuthDatasource, AuthDatasource>
    with $Provider<AuthDatasource> {
  const ApiAuthDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiAuthDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiAuthDatasourceHash();

  @$internal
  @override
  $ProviderElement<AuthDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthDatasource create(Ref ref) {
    return apiAuthDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthDatasource>(value),
    );
  }
}

String _$apiAuthDatasourceHash() => r'9a77d644cb206f33b77d9ed32ff7a7040ea104b9';
