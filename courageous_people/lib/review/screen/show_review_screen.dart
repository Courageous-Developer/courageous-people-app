import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/log_in/log_In_screen.dart';
import 'package:courageous_people/model/menu_data.dart';
import 'package:courageous_people/model/review_data.dart';
import 'package:courageous_people/review/cubit/review_cubit.dart';
import 'package:courageous_people/review/cubit/review_state.dart';
import 'package:courageous_people/review/screen/add_review_screen.dart';
import 'package:courageous_people/review/screen/rewrite_review_screen.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../widget/review_tile.dart';

class ShowReviewScreen extends StatelessWidget {
  const ShowReviewScreen({
    Key? key,
    required this.storeId,
    required this.menuList,
  }) : super(key: key);

  final int storeId;
  final List<MenuData> menuList;

  @override
  Widget build(BuildContext context) {
    final reviewCubit = context.read<ReviewCubit>();
    final userId = UserHive().userId;

    reviewCubit.getReviews(storeId);

    return Scaffold(
      appBar: AppBar(title: Text('리뷰')),
      body: BlocConsumer<ReviewCubit, ReviewState>(
        bloc: reviewCubit,
        listener: (context, state) async {
          if(state is ReviewDeletedState) {
            await showAlertDialog(
              context: context,
              title: state.message,
            );

            reviewCubit.getReviews(storeId);
          }

          if(state is ReviewDeleteErrorState) {
            await showAlertDialog(context: context, title: state.message);
          }

          if(state is ReviewRewrittenState) reviewCubit.getReviews(storeId);

          if(state is ReviewRewriteErrorState) reviewCubit.getReviews(storeId);
        },
        builder: (context, state) {
          print('review reloading state: $state');

          return _reviewListSection(
            state: state,
            onCorrectionPressed: (review) async {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RewriteReviewScreen(
                    reviewId: review.reviewId,
                    storeId: storeId,
                    userId: userId,
                    menuList: menuList,
                    initialMenuText: review.tags[0].content,
                    initialVolume: review.tags[1].content,
                    initialComment: review.comment,
                    initialImageByte: null,
                  ),
                ),
              );
            },
            onDeletionPressed: (reviewId) async {
              await reviewCubit.deleteReview(reviewId);
            },
          );
        },
        buildWhen: (state, previousState) {
          if(state is DeleteReviewLoadingState)  return false;
          if(state is ReviewDeletedState)  return false;
          if(state is ReviewDeleteErrorState)  return false;

          return true;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () async {
          if(UserHive().userId == -1) {
            await showAlertDialog(
              context: context,
              title: '로그인이 필요합니다',
              onSubmit: () async {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogInScreen()),
                );
              },
            );
          }

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewScreen(
                storeId: storeId,
                userId: userId,
                menuList: menuList,
              ),
            ),
          );

          reviewCubit.getReviews(storeId);
        },
      ),
    );
  }

  Widget _reviewListSection({
    required ReviewState state,
    required void Function(ReviewData) onCorrectionPressed,
    required void Function(int) onDeletionPressed,
  }) {
    if (state is ReviewLoadingState) {
      return Center(child: CircularProgressIndicator());
    }

    if (state is ReviewLoadedState) {
      final reviews = state.reviewList;

      if (reviews.length == 0) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('등록된 리뷰가 없습니다!'),

              // Text('등록된 리뷰가 없습니다!'),
              // Text('아래의 아이콘을 눌러 리뷰를 등록해보세요!'),
              // SizedBox(height: 70),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.playlist_add, color: Colors.grey.shade700, size: 80),
              // ),
            ],
          ),
        );
      }

      final List<Widget> reviewTileList = reviews.map(
            (review) => ReviewTile(
          review: review,
          onCorrectionPressed: () => onCorrectionPressed(review),
          onDeletionPressed: () => onDeletionPressed(review.reviewId),
        ),
      ).toList();

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '리뷰  ',
                        style: TextStyle(
                          fontSize: 21.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${reviews.length}개',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Column(children: reviewTileList),
            ],
          ),
        ),
      );
    }

    return Container();
  }
}


