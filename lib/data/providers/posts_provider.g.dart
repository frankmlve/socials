// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postsNotifierHash() => r'bf8e7088c9b2c6d0052422401d19950f33d957b1';

/// See also [PostsNotifier].
@ProviderFor(PostsNotifier)
final postsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PostsNotifier, List<Post>>.internal(
  PostsNotifier.new,
  name: r'postsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostsNotifier = AutoDisposeAsyncNotifier<List<Post>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
