// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'post.dart';

class PostMapper extends ClassMapperBase<Post> {
  PostMapper._();

  static PostMapper? _instance;
  static PostMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PostMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Post';

  static int _$userId(Post v) => v.userId;
  static const Field<Post, int> _f$userId = Field('userId', _$userId);
  static int _$id(Post v) => v.id;
  static const Field<Post, int> _f$id = Field('id', _$id);
  static String _$title(Post v) => v.title;
  static const Field<Post, String> _f$title = Field('title', _$title);
  static String _$body(Post v) => v.body;
  static const Field<Post, String> _f$body = Field('body', _$body);

  @override
  final MappableFields<Post> fields = const {
    #userId: _f$userId,
    #id: _f$id,
    #title: _f$title,
    #body: _f$body,
  };

  static Post _instantiate(DecodingData data) {
    return Post(
        userId: data.dec(_f$userId),
        id: data.dec(_f$id),
        title: data.dec(_f$title),
        body: data.dec(_f$body));
  }

  @override
  final Function instantiate = _instantiate;

  static Post fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Post>(map);
  }

  static Post fromJson(String json) {
    return ensureInitialized().decodeJson<Post>(json);
  }
}

mixin PostMappable {
  String toJson() {
    return PostMapper.ensureInitialized().encodeJson<Post>(this as Post);
  }

  Map<String, dynamic> toMap() {
    return PostMapper.ensureInitialized().encodeMap<Post>(this as Post);
  }

  PostCopyWith<Post, Post, Post> get copyWith =>
      _PostCopyWithImpl(this as Post, $identity, $identity);
  @override
  String toString() {
    return PostMapper.ensureInitialized().stringifyValue(this as Post);
  }

  @override
  bool operator ==(Object other) {
    return PostMapper.ensureInitialized().equalsValue(this as Post, other);
  }

  @override
  int get hashCode {
    return PostMapper.ensureInitialized().hashValue(this as Post);
  }
}

extension PostValueCopy<$R, $Out> on ObjectCopyWith<$R, Post, $Out> {
  PostCopyWith<$R, Post, $Out> get $asPost =>
      $base.as((v, t, t2) => _PostCopyWithImpl(v, t, t2));
}

abstract class PostCopyWith<$R, $In extends Post, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? userId, int? id, String? title, String? body});
  PostCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PostCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Post, $Out>
    implements PostCopyWith<$R, Post, $Out> {
  _PostCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Post> $mapper = PostMapper.ensureInitialized();
  @override
  $R call({int? userId, int? id, String? title, String? body}) =>
      $apply(FieldCopyWithData({
        if (userId != null) #userId: userId,
        if (id != null) #id: id,
        if (title != null) #title: title,
        if (body != null) #body: body
      }));
  @override
  Post $make(CopyWithData data) => Post(
      userId: data.get(#userId, or: $value.userId),
      id: data.get(#id, or: $value.id),
      title: data.get(#title, or: $value.title),
      body: data.get(#body, or: $value.body));

  @override
  PostCopyWith<$R2, Post, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PostCopyWithImpl($value, $cast, t);
}
