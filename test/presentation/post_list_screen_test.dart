import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fudo_interview/src/api/post_api.dart';
import 'package:fudo_interview/src/api/user_api.dart';
import 'package:fudo_interview/src/models/post/post.dart';
import 'package:fudo_interview/src/models/user/user.dart';
import 'package:fudo_interview/src/presentation/post_detail_screen.dart';
import 'package:fudo_interview/src/presentation/post_list_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// Mocks for the APIs
import 'post_list_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PostApi>(), MockSpec<UserApi>()])
void main() {
  late MockPostApi mockPostApi;
  late MockUserApi mockUserApi;

  // Set up before each test
  setUp(() {
    mockPostApi = MockPostApi();
    mockUserApi = MockUserApi();
  });

  Future<void> buildWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostsListScreen(
            postApi: mockPostApi,
            userApi: mockUserApi,
          ),
        ),
      ),
    );
  }

  group('PostsListScreen Widget Tests', () {
    testWidgets('Renders List of posts after fetching data',
        (WidgetTester tester) async {
      // Arrange: Mock data for posts
      final mockPosts = [
        Post(id: 1, title: 'First Post', userId: 1, body: 'First post body'),
        Post(id: 2, title: 'Second Post', userId: 2, body: 'Second post body'),
      ];

      when(mockPostApi.getPosts()).thenAnswer((_) async => mockPosts);

      // Act
      await buildWidget(tester);
      await tester.pumpAndSettle(); // Wait for the async operations

      // Assert: Check that list of posts is rendered
      expect(find.text('First Post'), findsOneWidget);
      expect(find.text('Second Post'), findsOneWidget);
    });

    testWidgets('Search filters posts based on user name',
        (WidgetTester tester) async {
      // Arrange: Mock posts and users
      final mockPosts = [
        Post(id: 1, title: 'First Post', userId: 1, body: 'First post body'),
        Post(id: 2, title: 'Second Post', userId: 2, body: 'Second post body'),
      ];
      final mockUsers = [
        User(
            id: 1,
            name: 'John Doe',
            email: "john@doe.com",
            username: 'elpajarillo')
      ];

      when(mockPostApi.getPosts()).thenAnswer((_) async => mockPosts);
      when(mockUserApi.getUsersByName('John'))
          .thenAnswer((_) async => mockUsers);

      // Act
      await buildWidget(tester);
      await tester.pumpAndSettle();

      // Enter search query 'John'
      await tester.enterText(find.byType(TextField), 'John');
      await tester.pump(const Duration(milliseconds: 500)); // Wait for debounce

      // Assert: Only posts by 'John Doe' should be shown
      expect(find.text('First Post'), findsOneWidget);
      expect(find.text('Second Post'), findsNothing);
    });

    testWidgets('Tapping on post navigates to PostDetailScreen',
        (WidgetTester tester) async {
      // Arrange: Mock posts
      final mockPosts = [
        Post(id: 1, title: 'First Post', userId: 1, body: 'First post body'),
      ];

      when(mockPostApi.getPosts()).thenAnswer((_) async => mockPosts);

      // Act
      await buildWidget(tester);
      await tester.pumpAndSettle(); // Wait for the async operations

      // Tap on the first post
      await tester.tap(find.text('First Post'));
      await tester.pumpAndSettle(); // Wait for navigation

      // Assert: Check if PostDetailScreen is opened
      expect(find.byType(PostDetailScreen), findsOneWidget);
    });
  });
}
