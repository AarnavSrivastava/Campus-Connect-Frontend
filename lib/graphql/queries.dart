import 'package:graphql_flutter/graphql_flutter.dart';

class Queries {
  var querySchools = gql(
    r"""
      query Schools {
        schools {
          id
          name
          classes {
            id
            name
          }
        }
      }
    """,
  );

  var queryUser = gql(
    r"""
      query GetUserByID($userID: ID!) {
        users(where: {
          id: $userID
        }) {
          id
          name
          email
          photo_url
          school {
            id
            name
          }
        }
      }
    """,
  );

  var queryUserClasses = gql(
    r"""
      query GetClassesOfStudent($userID: ID!) {
        users(where: {
          id: $userID
        }) {
          classes {
            id
            name
            participants {
              name
              email
              photo_url
            }
            posts {
              id
              title
              files
              creation_time
              description
              poster {
                name
                email
                photo_url
              }
              comments {
                id
                text
                creation_time
                commenter {
                  name
                  photo_url
                  email
                }
              }
            }
          }
        }
      }
    """,
  );

  var queryUserPosts = gql(
    r"""
      query UserPosts($userID: ID!) {
        posts(where: {
          poster: {
            id: $userID
          }
        }) {
          id
          title
          files
          creation_time
          description
          poster {
            name
            email
            photo_url
          }
          comments {
            id
            text
            creation_time
            commenter {
              name
              photo_url
              email
            }
          }
        }
      }
    """,
  );

  var queryPostComments = gql(
    r"""
      query PostComments($postID: ID!) {
        comments(where: {
          post: {
            id: $postID
          }
        }) {
          post {
            id
            title
            creation_time
          }
          commenter {
            id
            name
            photo_url
          }
          id
          text
          creation_time
        }
      }
    """,
  );

  var queryClassPosts = gql(
    r"""
      query ClassPosts($classID: ID!) {
        posts(where: {
          class: {
            id: $classID
          }
        }) {
          comments {
            id
            creation_time
            text
          }
          id
          title
          files
          description
          creation_time
          poster {
            email
            name
            photo_url
          }
        }
      }
    """,
  );

  var querySchoolClasses = gql(
    r"""
      query GetSchoolClasses($schoolID: ID!, $userID: ID!) {
        classes(where: {
          AND: [{
            school: {
              id: $schoolID
            },
            NOT: {
              participants_SINGLE: {
                id: $userID
              }
            }
          },]
        }) {
          id
          name
          participants {
            email
            name
            photo_url
          }
          posts {
            comments {
              id
              creation_time
              commenter {
                email
                name
                photo_url
              }
              text
            }
            id
            poster {
              name
              email
              photo_url
            }
            creation_time
            description
            title
          }
        }
      }
    """,
  );
}
