part of 'post_ad_bloc.dart';

abstract class PostAdEvent extends Equatable {
  const PostAdEvent();

  @override
  List<Object> get props => [];
}

class SubmitAdEvent extends PostAdEvent {
  final String userId;
  final String brand;
  final String model;
  final String fuelType;
  final String transmissionType;
  final int year;
  final int kmDriven;
  final int noOfOwners;
  final String description;
  final LocationModel location;
  final List<String> imageFiles;
  final double price;

  const SubmitAdEvent({
    required this.userId,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmissionType,
    required this.year,
    required this.kmDriven,
    required this.noOfOwners,
    required this.description,
    required this.location,
    required this.imageFiles,
    required this.price,
  });

  @override
  List<Object> get props => [
        userId,
        brand,
        model,
        fuelType,
        transmissionType,
        year,
        kmDriven,
        noOfOwners,
        description,
        location,
        imageFiles,
        price,
      ];
}