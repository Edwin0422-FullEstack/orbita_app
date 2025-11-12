// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_document_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KycDocuments)
const kycDocumentsProvider = KycDocumentsProvider._();

final class KycDocumentsProvider
    extends $NotifierProvider<KycDocuments, KycImagesState> {
  const KycDocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kycDocumentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kycDocumentsHash();

  @$internal
  @override
  KycDocuments create() => KycDocuments();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KycImagesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KycImagesState>(value),
    );
  }
}

String _$kycDocumentsHash() => r'4c31a31172e2396e15526ee844bb0da63c7a866a';

abstract class _$KycDocuments extends $Notifier<KycImagesState> {
  KycImagesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<KycImagesState, KycImagesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KycImagesState, KycImagesState>,
              KycImagesState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(imagePicker)
const imagePickerProvider = ImagePickerProvider._();

final class ImagePickerProvider
    extends $FunctionalProvider<ImagePicker, ImagePicker, ImagePicker>
    with $Provider<ImagePicker> {
  const ImagePickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imagePickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imagePickerHash();

  @$internal
  @override
  $ProviderElement<ImagePicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImagePicker create(Ref ref) {
    return imagePicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImagePicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImagePicker>(value),
    );
  }
}

String _$imagePickerHash() => r'4ade97b98e4e2b1423bb08eb64f280b92f8ac945';
