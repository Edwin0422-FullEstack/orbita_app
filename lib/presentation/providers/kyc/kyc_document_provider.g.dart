// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_document_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$imagePickerHash() => r'4ade97b98e4e2b1423bb08eb64f280b92f8ac945';

/// See also [imagePicker].
@ProviderFor(imagePicker)
final imagePickerProvider = AutoDisposeProvider<ImagePicker>.internal(
  imagePicker,
  name: r'imagePickerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$imagePickerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ImagePickerRef = AutoDisposeProviderRef<ImagePicker>;
String _$kycDocumentsHash() => r'4c31a31172e2396e15526ee844bb0da63c7a866a';

/// See also [KycDocuments].
@ProviderFor(KycDocuments)
final kycDocumentsProvider =
    AutoDisposeNotifierProvider<KycDocuments, KycImagesState>.internal(
      KycDocuments.new,
      name: r'kycDocumentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$kycDocumentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$KycDocuments = AutoDisposeNotifier<KycImagesState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
