// lib/presentation/providers/kyc/kyc_document_provider.dart
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kyc_document_provider.g.dart'; // Corre el build_runner después

// 1. Definimos un estado inmutable para TODAS las imágenes del KYC
@immutable
class KycImagesState {
  final XFile? front;
  final XFile? back;
  final XFile? selfie;

  const KycImagesState({this.front, this.back, this.selfie});

  // El método copyWith para actualizar el estado de forma inmutable
  // (Usamos ValueGetter para poder setear null explícitamente)
  KycImagesState copyWith({
    ValueGetter<XFile?>? front,
    ValueGetter<XFile?>? back,
    ValueGetter<XFile?>? selfie,
  }) {
    return KycImagesState(
      front: front != null ? front() : this.front,
      back: back != null ? back() : this.back,
      selfie: selfie != null ? selfie() : this.selfie,
    );
  }
}

// 2. Refactorizamos el provider para que maneje este nuevo estado
@riverpod
class KycDocuments extends _$KycDocuments {

  @override
  KycImagesState build() {
    return const KycImagesState(); // Estado inicial vacío
  }

  // Métodos para actualizar cada imagen
  void setFront(XFile file) => state = state.copyWith(front: () => file);
  void setBack(XFile file) => state = state.copyWith(back: () => file);
  void setSelfie(XFile file) => state = state.copyWith(selfie: () => file);

  // Métodos para limpiar
  void clearFront() => state = state.copyWith(front: () => null);
  void clearBack() => state = state.copyWith(back: () => null);
  void clearSelfie() => state = state.copyWith(selfie: () => null);
}

// El provider de ImagePicker (sin cambios)
@riverpod
ImagePicker imagePicker(ImagePickerRef ref) {
  return ImagePicker();
}