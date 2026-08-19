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

import '../../core/services/mood_detection_service.dart' as _i719;
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
import '../../features/chat/data/datasources/chat_remote_data_source.dart'
    as _i980;
import '../../features/chat/data/datasources/chat_remote_data_source_impl.dart'
    as _i867;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i504;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i420;
import '../../features/chat/domain/usecases/create_chat_usecase.dart' as _i599;
import '../../features/chat/domain/usecases/delete_message_usecase.dart'
    as _i481;
import '../../features/chat/domain/usecases/get_chats_usecase.dart' as _i692;
import '../../features/chat/domain/usecases/get_messages_usecase.dart' as _i325;
import '../../features/chat/domain/usecases/mark_messages_as_read_usecase.dart'
    as _i45;
import '../../features/chat/domain/usecases/send_message_usecase.dart' as _i795;
import '../../features/chat/presentation/bloc/chat_cubit.dart' as _i708;
import '../../features/chat/presentation/bloc/chats_list_cubit.dart' as _i696;
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
import '../../features/timeline/data/datasource/timeline_remote_datasource.dart'
    as _i112;
import '../../features/timeline/data/datasource/timeline_remote_datasource_impl.dart'
    as _i517;
import '../../features/timeline/data/datasource/timeline_repository_impl.dart'
    as _i816;
import '../../features/timeline/domain/repositories/timeline_repository.dart'
    as _i300;
import '../../features/timeline/domain/usecase/get_mood_frequency_usecase.dart'
    as _i429;
import '../../features/timeline/domain/usecase/get_timeline_conversation_usecase.dart'
    as _i206;
import '../../features/timeline/presentation/bloc/timeline_cubit.dart' as _i990;
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
    gh.lazySingleton<_i719.MoodDetectionService>(
        () => _i719.MoodDetectionService());
    gh.factory<_i182.AuthRemoteDataSource>(() => _i508.AuthRemoteDataSourceImpl(
          gh<_i59.FirebaseAuth>(),
          gh<_i974.FirebaseFirestore>(),
          gh<_i116.GoogleSignIn>(),
        ));
    gh.factory<_i112.TimelineRemoteDataSource>(() =>
        _i517.TimelineRemoteDatasourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.factory<_i815.FriendsRemoteDataSource>(
        () => _i862.FriendsRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.factory<_i980.ChatRemoteDataSource>(
        () => _i867.ChatRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.factory<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i182.AuthRemoteDataSource>()));
    gh.factory<_i810.FriendsRepository>(
        () => _i120.FriendsRepositoryImpl(gh<_i815.FriendsRemoteDataSource>()));
    gh.factory<_i710.GetFriendUsecase>(
        () => _i710.GetFriendUsecase(gh<_i810.FriendsRepository>()));
    gh.factory<_i300.TimelineRepository>(() =>
        _i816.TimelineRepositoryImpl(gh<_i112.TimelineRemoteDataSource>()));
    gh.factory<_i429.GetMoodFrequencyUseCase>(
        () => _i429.GetMoodFrequencyUseCase(gh<_i300.TimelineRepository>()));
    gh.factory<_i206.GetConversationTimelineUseCase>(() =>
        _i206.GetConversationTimelineUseCase(gh<_i300.TimelineRepository>()));
    gh.factory<_i420.ChatRepository>(
        () => _i504.ChatRepositoryImpl(gh<_i980.ChatRemoteDataSource>()));
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
    gh.factory<_i990.TimelineCubit>(
        () => _i990.TimelineCubit(gh<_i206.GetConversationTimelineUseCase>()));
    gh.factory<_i599.CreateChatUseCase>(
        () => _i599.CreateChatUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i481.DeleteMessageUseCase>(
        () => _i481.DeleteMessageUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i692.GetChatsUseCase>(
        () => _i692.GetChatsUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i325.GetMessagesUseCase>(
        () => _i325.GetMessagesUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i45.MarkMessagesAsReadUseCase>(
        () => _i45.MarkMessagesAsReadUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i795.SendMessageUseCase>(
        () => _i795.SendMessageUseCase(gh<_i420.ChatRepository>()));
    gh.factory<_i708.ChatCubit>(() => _i708.ChatCubit(
          gh<_i325.GetMessagesUseCase>(),
          gh<_i795.SendMessageUseCase>(),
          gh<_i481.DeleteMessageUseCase>(),
          gh<_i599.CreateChatUseCase>(),
          gh<_i45.MarkMessagesAsReadUseCase>(),
        ));
    gh.factory<_i877.FriendsCubit>(() => _i877.FriendsCubit(
          gh<_i710.GetFriendUsecase>(),
          gh<_i631.GetSuggestedUsersUseCase>(),
          gh<_i801.AddFriendUseCase>(),
          gh<_i56.RemoveFriendUseCase>(),
        ));
    gh.factory<_i936.SearchCubit>(
        () => _i936.SearchCubit(gh<_i252.SearchUsersUsecase>()));
    gh.factory<_i696.ChatsListCubit>(
        () => _i696.ChatsListCubit(gh<_i692.GetChatsUseCase>()));
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
