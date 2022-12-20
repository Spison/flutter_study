import 'package:flutter_study/domain/models/attach_meta.dart';
import 'package:flutter_study/domain/models/post_content.dart';
import 'package:flutter_study/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String id;
  String? description;
  User author;
  List<PostContent> contents;

  PostModel({
    required this.id,
    this.description,
    required this.author,
    required this.contents,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

@JsonSerializable()
class PostModelCreate {
  String? description;
  bool visibleToSubscribersOnly;
  List<AttachMeta> contents;
  PostModelCreate(
      {this.description,
      required this.visibleToSubscribersOnly,
      required this.contents});
  factory PostModelCreate.fromJson(Map<String, dynamic> json) =>
      _$PostModelCreateFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelCreateToJson(this);
}
