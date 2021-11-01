import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/model/menu_data.dart';
import 'package:courageous_people/model/review_data.dart';
import 'package:courageous_people/review/cubit/review_cubit.dart';
import 'package:courageous_people/review/cubit/review_state.dart';
import 'package:courageous_people/review/screen/add_review_screen.dart';
import 'package:courageous_people/widget/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
    final _reviewCubit = context.read<ReviewCubit>();
    _reviewCubit.getReviews(storeId);

    return Scaffold(
      appBar: AppBar(title: Text('리뷰')),
      body: BlocConsumer<ReviewCubit, ReviewState>(
        bloc: _reviewCubit,
        listener: (context, state) async {},
        builder: (context, state) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: _reviewListSection(state),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // todo: user check
          final userId = UserHive().userId;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewScreen(
                storeId: storeId,
                userId: userId,
                menuList: menuList,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _reviewListSection(ReviewState state) {
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
              Text('아래의 아이콘을 눌러 리뷰를 등록해보세요!'),
              SizedBox(height: 70),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.playlist_add, color: Colors.grey.shade700, size: 80),
              ),
            ],
          ),
        );
      }

      final List<Widget> reviewTileList = reviews.map(
            (review) => _ReviewTile(review: review),
      ).toList();

      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
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

class _ReviewTile extends StatelessWidget {
  final ReviewData review;

  _ReviewTile({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 45),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userSection(),
          _imageSection(context),
          // review.imageUri.length == 0
          //     ? SizedBox(height: 0)
          //     : _imageSection(),
          _commentSection(),
          review.tags.length == 0
              ? SizedBox(height: 0)
              : _tagSection(),
        ],
      ),
    );
  }

  Widget _userSection() => Container(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          // backgroundImage: AssetImage('assets/images/user.jpg'),
          radius: 18,
        ),
        SizedBox(width: 9),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.userNickname,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              // todo: 날짜 수정
              review.createAt.split('T')[0],
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _imageSection(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(width: 2),
      // ),
      // width: MediaQuery.of(context).size.width*0.6,
      // height: MediaQuery
      //     .of(context)
      //     .size
      //     .width - 60,
      margin: EdgeInsets.only(top: 15),
      alignment: Alignment.topLeft,
      child: review.imageUri.length > 0
          ?
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(review.imageUri[0]),
      )
          : SizedBox(height: 0),
    );
  }

  Widget _commentSection() => Container(
    padding: EdgeInsets.only(top: 18.5),
    alignment: Alignment.centerLeft,
    child: Text(review.comment),
  );

  Widget _tagSection() => Container(
    padding: EdgeInsets.only(top: 25),
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: review.tags.map(
            (tag) => TagWidget(tag: tag),
      ).toList(),
    ),
  );
}
