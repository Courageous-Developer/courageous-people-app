import 'package:flutter/material.dart';
import 'package:courageous_people/widget/menu_button.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({
    Key? key,
    required this.succeedLogIn,
    required this.onMainPressed,
    required this.onLogInPressed,
    required this.onLogOutPressed,
    required this.onAddingStorePressed,
    required this.onFavoriteListPressed,
    required this.onNearStoreListPressed,
  }) : super(key: key);

  final bool succeedLogIn;
  final void Function() onMainPressed;
  final void Function() onLogInPressed;
  final void Function() onLogOutPressed;
  final void Function() onAddingStorePressed;
  final void Function() onFavoriteListPressed;
  final void Function() onNearStoreListPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuButton(
          size: 40,
          borderRadiusValue: 8,
          iconData: Icons.menu,
          backgroundColor: Colors.black,
          onPressed: onMainPressed,
        ),
        const SizedBox(height: 12),
        succeedLogIn
            ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _addStoreMenuButton(onPressed: onAddingStorePressed),
            const SizedBox(height: 10),
            _favoriteMenuButton(onPressed: onFavoriteListPressed),
            const SizedBox(height: 10),
            _nearStoreMenuButton(onPressed: onNearStoreListPressed),
            const SizedBox(height: 10),
            _logOutButton(onPressed: onLogOutPressed),
          ],
        )
            : _logInButton(onPressed: onLogInPressed),
      ],
    );
  }

  Widget _logInButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.login,
      menuTitle: '로그인',
      backgroundColor: Colors.grey.shade500,
      heroTag: "registerStore",
      onPressed: onPressed,
    );
  }

  Widget _logOutButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.sensor_door,
      menuTitle: "로그아웃",
      backgroundColor: Colors.grey.shade500,
      heroTag: "logout",
      onPressed: onPressed,
    );
  }

  Widget _addStoreMenuButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.add,
      menuTitle: '가게 추가',
      backgroundColor: Colors.blue.shade300,
      heroTag: "registerStore",
      onPressed: onPressed,
    );
  }

  Widget _favoriteMenuButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.favorite,
      menuTitle: "찜한 가게",
      backgroundColor: Colors.pink.shade300,
      heroTag: "favorite",
      onPressed: onPressed,
    );
  }

  Widget _nearStoreMenuButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.store,
      menuTitle: "가까운 가게",
      backgroundColor: Colors.teal.shade300,
      heroTag: "near",
      onPressed: onPressed,
    );
  }
}











class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  ));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FlutterLogo(size: 150.0),
      ),
    );
  }
}