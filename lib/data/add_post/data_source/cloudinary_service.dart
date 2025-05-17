import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/config/cloudinary_config.dart';

abstract class CloudinaryService {
  Future<Either<String, List<String>>> uploadImages(List<File> imageFiles);
}

class CloudinaryServiceImpl implements CloudinaryService {
  final cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
  );


  
  @override
  Future<Either<String, List<String>>> uploadImages(
    List<File> imageFiles,
  ) async {
    try {
      final List<String> imageUrls = [];

      for (final imageFile in imageFiles) {
        final response = await cloudinary.uploadFile(
          CloudinaryFile .fromFile(imageFile.path, folder: 'car_ads'),
        );
        imageUrls.add(response.secureUrl);
      }

      return Right(imageUrls);
    } catch (e) {
      return Left('Failed to upload images: ${e.toString()}');
    }
  }
}
