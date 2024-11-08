import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:promise/const/const.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/util/response.ext.dart';

abstract class BaseRepository<T extends BaseAuditModel> {
  BaseRepository();

  @protected
  Future<T> createAsync(T t);

  @protected
  Future<T> modifyAsync(T t);

  @protected
  Future deleteAsync(String id);

  @protected
  Future<PageResult<T>> fetchAsync([int page = 1, int pageSize = PAGE_SIZE]);

  @protected
  Future teardown();
}