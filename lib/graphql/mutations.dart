import 'package:graphql_flutter/graphql_flutter.dart';

var mutateCreateTodo = gql(
  r"""
    mutation CreateTodos($className: String!) {
      createTodos(input: {
        category: {
          connect: {
            where: {
              node: {
                name: "Assignment"
              }
            }
          }
        },
        status: "NEW",
        title: $title
      }) {
        info {
          bookmark
          nodesCreated
          relationshipsCreated
        }
        todos {
          category {
            title
          }
          status
          title
        }
      }
    }
  """,
);

var mutateDeleteTodos = gql(
  r"""
    mutation DeleteTodos($title: String!) {
      deleteTodos(where: {
            title: $title
        }) {
            nodesDeleted
            relationshipsDeleted
        }
    }
  """,
);

var mutateDeleteClass = gql(
  r"""
    mutation DeleteClass($classID: ID!) {
      deleteClasses(where: {
            id: $classID
        }) {
            nodesDeleted
            relationshipsDeleted
        }
    }
  """,
);

var mutateCreateUser = gql(
  r"""
    mutation CreateUser($id: ID!, $email: String!, $name: String!, $photoUrl: String!) {
      createUsers(input: {
        id: $id
        email: $email
        name: $name
        photo_url: $photoUrl
      }) {
        info {
          bookmark
          nodesCreated
          relationshipsCreated
        }
        users {
          id
          email
          name
          photo_url
        }
      }
    }
  """,
);

var updateUserClass = gql(
  r"""
    mutation UpdateUsersInClass($classID: ID!, $userID: ID!) {
      updateClasses(
        update: {
          participants: {
            connect: {
              where: {
                node: {
                  id: $userID,
                }
              }
            }
          }
        },
        where: {
          id: $classID
        }) {
          classes {
            id
            name
            participants {
              name
            }
          }
      }
    }
  """,
);

var updateUserSchool = gql(
  r"""
    mutation UpdateUsersInSchool($schoolID: ID!, $userID: ID!) {
      updateSchools(
        update: {
          students: {
            connect: {
              where: {
                node: {
                  id: $userID,
                }
              }
            }
          }
        },
        where: {
          id: $schoolID
        }) {
          schools {
            id
            name
          }
      }
    }
  """,
);

var mutateCreateSchool = gql(
  r"""
    mutation CreateSchool($schoolName: String!) {
      createSchools(input: {
        name: $schoolName,
      }) {
        info {
          bookmark
          nodesCreated
          relationshipsCreated
        }
        schools {
          students {
            name
          }
          classes {
            id
            name
          }
          id
          name
        }
      }
    }
  """,
);

var mutateCreateClass = gql(
  r"""
    mutation CreateClasses($className: String!, $schoolID: ID!) {
      createClasses(input: {
        name: $className,
        school: {
          connect: {
            where: { node: { id: $schoolID } }
          }
        }
      }) {
        info {
          bookmark
          nodesCreated
          relationshipsCreated
        }
        classes {
          participants {
            name
          }
          id
          name
        }
      }
    }
  """,
);

var mutateCreatePost = gql(
  r"""
    mutation CreatePosts($title: String!, $userID: ID!, $classID: ID!, $files: [String!]!, $description: String!, $creationTime: String!) {
      createPosts(input: {
        title: $title,
        files: $files,
        description: $description,
        creation_time: $creationTime,
        class: {
          connect: {
            where: { node: { id: $classID } }
          }
        },
        poster: {
          connect: {
            where: { node: { id: $userID } }
          }
        },
      }) {
        info {
          bookmark
          nodesCreated
          relationshipsCreated
        }
        posts {
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
            name
            email
            photo_url
          }
          class {
            id
            name
          }
        }
      }
    }
  """,
);

var mutateCreateComment = gql(
  r"""
    mutation CreateComments($userID: ID!, $postID: ID!, $text: String!, $creationTime: String!) {
      createComments(input: {
        text: $text,
        creation_time: $creationTime,
        commenter: {
          connect: {
            where: { node: { id: $userID } }
          }
        }
        post: {
          connect: {
            where: { node: { id: $postID } }
          }
        }
      }) {
        info {
          bookmark
          nodesCreated
          relationshipsCreated
        }
        comments {
          commenter {
            name
            email
            photo_url
          }
          id
          text
          creation_time
          post {
            id
          }
        }
      }
    }
  """,
);
