import 'package:graphql_flutter/graphql_flutter.dart';

var mutateAddTodo = gql(
  """
    mutation CreateTodos(\$title: String!) {
      createTodos(input: {
        category: {
          connect: {
            where: {
              node: {
                title: "Assignment"
              }
            }
          }
        },
        status: "NEW",
        title: \$title
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
  """
    mutation DeleteTodos(\$title: String!) {
      deleteTodos(where: {
            title: \$title
        }) {
            nodesDeleted
            relationshipsDeleted
        }
    }
  """,
);
