import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

var queryTodos = gql(
  """
    query Todos {
      todos {
        title
        status
        category {
          title
        }
      }
    }
  """,
);

Future<List> getTodos(ValueNotifier<GraphQLClient> client) async {
  final QueryResult result = await client.value.query(
    QueryOptions(
      document: queryTodos,
    ),
  );

  return result.data!["todos"];
}
