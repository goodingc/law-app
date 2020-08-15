import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class _NavigatorMenuItem {
  final key = GlobalKey();
  final String name;
  final IconData icon;

  _NavigatorMenuItem({this.name, this.icon});
}

class MainNavigator extends StatefulWidget {
  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator>
    with TickerProviderStateMixin {
  AnimationController _slideAnimationController;
  Animation<double> _slideAnimation;
  GlobalKey _menuAreaKey;

  List<_NavigatorMenuItem> _menuItems;
  _NavigatorMenuItem _selectedItem;

  static final menuRatio = 0.75;

  @override
  void initState() {
    super.initState();
    _slideAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _slideAnimation = CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.ease,
    );
    _menuItems = [
      _NavigatorMenuItem(
          name: 'News', icon: FaIcon(FontAwesomeIcons.newspaper).icon),
      _NavigatorMenuItem(
          name: 'The City', icon: FaIcon(FontAwesomeIcons.city).icon),
//      _NavigatorMenuItem(
//          name: 'Profile', icon: FaIcon(FontAwesomeIcons.userTie).icon),
      _NavigatorMenuItem(
          name: 'Applications', icon: FaIcon(FontAwesomeIcons.fileAlt).icon),
      _NavigatorMenuItem(name: 'Menu', icon: Icons.menu),
    ];
    _selectedItem = _menuItems[0];
    _menuAreaKey = GlobalKey();
  }

  TickerFuture closeMenu() => _slideAnimationController.reverse();
  TickerFuture openMenu() => _slideAnimationController.forward();

  RenderBox get selectedItemBox =>
      _selectedItem.key.currentContext?.findRenderObject();

  double get selectedItemY {
    var itemBox = selectedItemBox;
    if (itemBox == null) return 0;
    RenderBox areaBox = _menuAreaKey.currentContext.findRenderObject();
    return itemBox.localToGlobal(-areaBox.localToGlobal(Offset.zero)).dy;
  }

  double get selectedItemHeight {
    var itemBox = selectedItemBox;
    if (itemBox == null) return 0;
    return itemBox.size.height;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var menuWidth = screenWidth * menuRatio;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _slideAnimationController.value += details.primaryDelta / screenWidth;
      },
      onHorizontalDragEnd: (details) {
        var _kMinFlingVelocity = 365.0;

        if (_slideAnimationController.isDismissed ||
            _slideAnimationController.isCompleted) {
          return;
        }
        if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
          var visualVelocity =
              details.velocity.pixelsPerSecond.dx / screenWidth;
          _slideAnimationController.fling(velocity: visualVelocity);
        } else if (_slideAnimationController.value < 0.5) {
          closeMenu();
        } else {
          openMenu();
        }
      },
      onTapDown: (details) {
        if (details.globalPosition.dx > screenWidth * menuRatio) {
          closeMenu();
        }
      },
      child: AnimatedBuilder(
        animation: _slideAnimationController,
        builder: (context, _) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ])),
              ),
              if (!_slideAnimation.isDismissed)
                Transform(
                  transform: Matrix4.identity()
                    ..translate(-menuWidth * (1 - _slideAnimation.value)),
                  child: Container(
                      width: menuWidth,
                      child: SafeArea(
                          child: Stack(
                        key: _menuAreaKey,
                        children: [
                          AnimatedPositioned(
                            top: selectedItemY > 0 ? selectedItemY : null,
                            width: menuWidth,
                            height: selectedItemHeight > 0
                                ? selectedItemHeight
                                : null,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                            child: CustomPaint(
                              painter: SelectedOptionPainter(
                                  fillColor:
                                      Theme.of(context).colorScheme.surface),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              CircleAvatar(
                                radius: 75,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Name Surname',
                                  style: Theme.of(context).textTheme.headline4),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  children: [
                                    for (var item in _menuItems) ...[
                                      GestureDetector(
                                        key: item.key,
                                        onTap: () {
                                          setState(() {
                                            _selectedItem = item;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            children: [
                                              Icon(
                                                item.icon,
                                                size: 40,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    .color,
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  item.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))),
                ),
              Transform(
                transform: Matrix4.identity()
                  ..translate(_slideAnimation.value * menuWidth),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(40.0),
                    )),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Center(
                      child: MaterialButton(
                    onPressed: () {
                      _slideAnimationController.isDismissed
                          ? _slideAnimationController.forward()
                          : _slideAnimationController.reverse();
                    },
                    child: Text('go'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15.0),
                    )),
                    color: Colors.blueAccent,
                  )),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class SelectedOptionPainter extends CustomPainter {
  final Color fillColor;

  SelectedOptionPainter({this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    var boxLeft = 8.0;
    var rightCornerRadius = 20.0;
    var leftCornerRadius = 10.0;

    var path = Path()
      ..moveTo(size.width, -rightCornerRadius)
      ..arcToPoint(Offset(size.width - rightCornerRadius, 0),
          radius: Radius.circular(rightCornerRadius))
      ..lineTo(boxLeft + leftCornerRadius, 0)
      ..arcToPoint(Offset(boxLeft, leftCornerRadius),
          radius: Radius.circular(leftCornerRadius), clockwise: false)
      ..lineTo(boxLeft, size.height - leftCornerRadius)
      ..arcToPoint(Offset(boxLeft + leftCornerRadius, size.height),
          radius: Radius.circular(leftCornerRadius), clockwise: false)
      ..lineTo(size.width - rightCornerRadius, size.height)
      ..arcToPoint(Offset(size.width, size.height + rightCornerRadius),
          radius: Radius.circular(rightCornerRadius));

    canvas.drawPath(path, Paint()..color = fillColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
