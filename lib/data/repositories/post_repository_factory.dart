import 'package:connectme_app/data/repositories/post_repository.dart';

import '../datasources/post_remote_data_source.dart';
import 'post_repository_impl.dart';

enum PostDataSourceType { remote }

class PostRepositoryFactory {
  static PostRepository create({
    required PostDataSourceType type,
    required PostRemoteDataSource remoteDataSource,
  }) {
    switch (type) {
      case PostDataSourceType.remote:
        return PostRepositoryImpl(remoteDataSource);
    }
  }
}
