// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/data_source/auth_remote_data_source.dart'
    as _i182;
import '../../features/auth/data/data_source/auth_remote_data_source_impl.dart'
    as _i508;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/sign_in_usecase.dart' as _i259;
import '../../features/auth/domain/usecases/sign_in_with_google_usecase.dart'
    as _i673;
import '../../features/auth/domain/usecases/sign_out_usecase.dart' as _i915;
import '../../features/auth/domain/usecases/sign_up_usecase.dart' as _i860;
import '../../features/auth/presentation/bloc/auth_cubit.dart' as _i52;
import '../../features/friends/data/datasources/friends_remote_data_source.dart'
    as _i815;
import '../../features/friends/data/datasources/friends_remote_data_source_impl.dart'
    as _i862;
import '../../features/friends/data/repositories/friends_repository_impl.dart'
    as _i120;
import '../../features/friends/domain/repository/friends_repository.dart'
    as _i810;
import '../../features/friends/domain/usecases/add_friend_usecase.dart'
    as _i801;
import '../../features/friends/domain/usecases/get_friend_usecase.dart'
    as _i710;
import '../../features/friends/domain/usecases/get_suggested_users_usecase.dart'
    as _i631;
import '../../features/friends/domain/usecases/remove_friend_usecase.dart'
    as _i56;
import '../../features/friends/domain/usecases/search_users_usecase.dart'
    as _i252;
import '../../features/friends/presentation/bloc/friends_cubit.dart' as _i877;
import '../../features/friends/presentation/bloc/search_cubit.dart' as _i936;
import 'firebase_injectable_module.dart' as _i574;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseInjectableModule = _$FirebaseInjectableModule();
    gh.lazySingleton<_i59.FirebaseAuth>(
        () => firebaseInjectableModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => firebaseInjectableModule.firestore);
    gh.lazySingleton<_i116.GoogleSignIn>(
        () => firebaseInjectableModule.googleSignIn);
    gh.factory<_i182.AuthRemoteDataSource>(() => _i508.AuthRemoteDataSourceImpl(
          gh<_i59.FirebaseAuth>(),
          gh<_i974.FirebaseFirestore>(),
          gh<_i116.GoogleSignIn>(),
        ));
    gh.factory<_i815.FriendsRemoteDataSource>(
        () => _i862.FriendsRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.factory<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i182.AuthRemoteDataSource>()));
    gh.factory<_i810.FriendsRepository>(
        () => _i120.FriendsRepositoryImpl(gh<_i815.FriendsRemoteDataSource>()));
    gh.factory<_i710.GetFriendUsecase>(
        () => _i710.GetFriendUsecase(gh<_i810.FriendsRepository>()));
    gh.factory<_i801.AddFriendUseCase>(
        () => _i801.AddFriendUseCase(gh<_i810.FriendsRepository>()));
    gh.factory<_i631.GetSuggestedUsersUseCase>(
        () => _i631.GetSuggestedUsersUseCase(gh<_i810.FriendsRepository>()));
    gh.factory<_i56.RemoveFriendUseCase>(
        () => _i56.RemoveFriendUseCase(gh<_i810.FriendsRepository>()));
    gh.factory<_i252.SearchUsersUsecase>(
        () => _i252.SearchUsersUsecase(gh<_i810.FriendsRepository>()));
    gh.factory<_i17.GetCurrentUserUsecase>(
        () => _i17.GetCurrentUserUsecase(gh<_i787.AuthRepository>()));
    gh.factory<_i259.SignInUseCase>(
        () => _i259.SignInUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i673.SignInWithGoogleUseCase>(
        () => _i673.SignInWithGoogleUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i915.SignOutUsecase>(
        () => _i915.SignOutUsecase(gh<_i787.AuthRepository>()));
    gh.factory<_i860.SignUpUseCase>(
        () => _i860.SignUpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i877.FriendsCubit>(() => _i877.FriendsCubit(
          gh<_i710.GetFriendUsecase>(),
          gh<_i631.GetSuggestedUsersUseCase>(),
          gh<_i801.AddFriendUseCase>(),
          gh<_i56.RemoveFriendUseCase>(),
        ));
    gh.factory<_i936.SearchCubit>(
        () => _i936.SearchCubit(gh<_i252.SearchUsersUsecase>()));
    gh.factory<_i52.AuthCubit>(() => _i52.AuthCubit(
          gh<_i259.SignInUseCase>(),
          gh<_i860.SignUpUseCase>(),
          gh<_i673.SignInWithGoogleUseCase>(),
          gh<_i915.SignOutUsecase>(),
          gh<_i17.GetCurrentUserUsecase>(),
        ));
    return this;
  }
}

class _$FirebaseInjectableModule extends _i574.FirebaseInjectableModule {}
