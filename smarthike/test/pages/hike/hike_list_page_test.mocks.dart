// Mocks generated by Mockito 5.4.4 from annotations
// in smarthike/test/pages/hike/hike_list_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:ui' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:smarthike/models/hike.dart' as _i4;
import 'package:smarthike/providers/hike_provider.dart' as _i3;
import 'package:smarthike/services/hike_service.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeHikeService_0 extends _i1.SmartFake implements _i2.HikeService {
  _FakeHikeService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [HikeProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockHikeProvider extends _i1.Mock implements _i3.HikeProvider {
  MockHikeProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.HikeService get hikeService => (super.noSuchMethod(
        Invocation.getter(#hikeService),
        returnValue: _FakeHikeService_0(
          this,
          Invocation.getter(#hikeService),
        ),
      ) as _i2.HikeService);

  @override
  List<_i4.Hike> get hikes => (super.noSuchMethod(
        Invocation.getter(#hikes),
        returnValue: <_i4.Hike>[],
      ) as List<_i4.Hike>);

  @override
  int get currentPage => (super.noSuchMethod(
        Invocation.getter(#currentPage),
        returnValue: 0,
      ) as int);

  @override
  int get totalPages => (super.noSuchMethod(
        Invocation.getter(#totalPages),
        returnValue: 0,
      ) as int);

  @override
  bool get isLoading => (super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: false,
      ) as bool);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i5.Future<void> loadPaginatedHikesData(int? page) => (super.noSuchMethod(
        Invocation.method(
          #loadPaginatedHikesData,
          [page],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  void addListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
