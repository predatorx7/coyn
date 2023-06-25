import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_graphql/angel3_graphql.dart';
import 'package:graphql_schema2/graphql_schema2.dart';
import 'package:graphql_server2/graphql_server2.dart';

class TransactionsService {
  static void add(Angel app) {
    app.post(
      '/subscribe/transactions',
      graphQLWS(
        GraphQL(
          GraphQLSchema(
            subscriptionType: objectType(
              'Subscription',
              fields: [
                field(
                  'postAdded',
                  postType,
                  resolve: (_, __) => postAdded,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    app.post(
      '/subscribe/transactions',
      graphQLHttp(
        GraphQL(
          GraphQLSchema(
            queryType: objectType(
              'Subscription',
              fields: [
                field('postAdded', postType, resolve: (_, __) => postAdded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
