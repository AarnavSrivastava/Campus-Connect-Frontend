import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/graphql/mutations.dart';
import 'package:school_networking_project/graphql/queries.dart';
import 'package:school_networking_project/types/class_info.dart';
import 'package:school_networking_project/types/comments_info.dart';
import 'package:school_networking_project/types/post_info.dart';
import 'package:school_networking_project/types/school_info.dart';
import 'package:school_networking_project/types/user_info.dart';

class DataService {
  static UserInfo? user;

  Future<UserInfo> getOrCreateUser(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    QueryResult result = await client.value.query(
      QueryOptions(
        document: Queries().queryUser,
        variables: {
          "userID": values["id"],
        },
      ),
    );

    if (result.data!["users"].isEmpty) {
      result = await createUser(
        client,
        values,
      );

      UserInfo newUser = UserInfo.fromJson(
        result.data!["createUsers"]["users"][0],
      );

      newUser.exists = false;

      user = UserInfo(
        name: newUser.name,
        email: newUser.email,
        photoUrl: newUser.photoUrl,
        schoolInfo: newUser.schoolInfo,
      );

      user!.id = newUser.id;

      user!.exists = false;

      return newUser;
    } else {
      UserInfo existingUser = UserInfo.fromJson(result.data!["users"][0]);

      existingUser.exists = true;

      user = UserInfo(
        name: existingUser.name,
        email: existingUser.email,
        photoUrl: existingUser.photoUrl,
        schoolInfo: existingUser.schoolInfo,
      );

      user!.id = existingUser.id;

      user!.exists = true;

      return existingUser;
    }
  }

  Future<QueryResult> createUser(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.mutate(
      MutationOptions(
        document: mutateCreateUser,
        variables: values,
      ),
    );

    return result;
  }

  Future<SchoolInfo> createSchool(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.mutate(
      MutationOptions(
        document: mutateCreateSchool,
        variables: values,
      ),
    );

    SchoolInfo schoolInfo =
        SchoolInfo.fromJson(result.data!["createSchools"]["schools"][0]);

    return schoolInfo;
  }

  Future<ClassInfo> createClass(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.mutate(
      MutationOptions(
        document: mutateCreateClass,
        variables: values,
      ),
    );

    ClassInfo classInfo = ClassInfo.fromJson(
      result.data!["createClasses"]["classes"][0],
    );

    return classInfo;
  }

  Future<PostInfo> createPost(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.mutate(
      MutationOptions(
        document: mutateCreatePost,
        variables: values,
      ),
    );

    PostInfo postInfo = PostInfo.fromJson(
      result.data!["createPosts"]["posts"][0],
    );

    return postInfo;
  }

  Future<CommentInfo> createComment(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.mutate(
      MutationOptions(
        document: mutateCreateComment,
        variables: values,
      ),
    );

    CommentInfo commentInfo = CommentInfo.fromJson(
      result.data!["createComments"]["comments"][0],
    );

    return commentInfo;
  }

  Future<QueryResult> connectUserToClass(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.mutate(
      MutationOptions(
        document: updateUserClass,
        variables: values,
      ),
    );

    return result;
  }

  Future<QueryResult> connectUserToSchool(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.mutate(
      MutationOptions(
        document: updateUserSchool,
        variables: values,
      ),
    );

    return result;
  }

  Future<List<ClassInfo>> getClassesStudent(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.query(
      QueryOptions(
        document: Queries().queryUserClasses,
        variables: {
          "userID": values["id"],
        },
      ),
    );

    List<ClassInfo> classes = List.empty(growable: true);

    for (var object in result.data!["users"][0]["classes"]) {
      ClassInfo classInfo = ClassInfo.fromJson(object);

      classes.add(classInfo);
    }

    return classes;
  }

  Future<List<ClassInfo>> getClassesSchool(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.query(
      QueryOptions(
        document: Queries().querySchoolClasses,
        variables: values,
      ),
    );

    List<ClassInfo> classes = List.empty(growable: true);

    for (var object in result.data!["classes"]) {
      ClassInfo classInfo = ClassInfo.fromJson(object);

      classes.add(classInfo);
    }

    return classes;
  }

  Future<List<PostInfo>> getStudentPosts(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.query(
      QueryOptions(
        document: Queries().queryUserPosts,
        variables: values,
      ),
    );

    List<PostInfo> posts = List.empty(growable: true);

    for (var object in result.data!["posts"]) {
      PostInfo postInfo = PostInfo.fromJson(object);

      posts.add(postInfo);
    }

    return posts;
  }

  Future<List<PostInfo>> getClassPosts(
    ValueNotifier<GraphQLClient> client,
    Map<String, dynamic> values,
  ) async {
    final QueryResult result = await client.value.query(
      QueryOptions(
        document: Queries().queryClassPosts,
        variables: values,
      ),
    );

    List<PostInfo> posts = List.empty(growable: true);

    for (var object in result.data!["posts"]) {
      PostInfo postInfo = PostInfo.fromJson(object);

      posts.add(postInfo);
    }

    return posts;
  }

  Future<List<SchoolInfo>> getSchools(
    ValueNotifier<GraphQLClient> client,
  ) async {
    final QueryResult result = await client.value.query(
      QueryOptions(
        document: Queries().querySchools,
      ),
    );

    List<SchoolInfo> schools = List.empty(growable: true);

    for (var object in result.data!["schools"]) {
      SchoolInfo schoolInfo = SchoolInfo.fromJson(object);

      schools.add(schoolInfo);
    }

    return schools;
  }
}
