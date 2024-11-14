import 'dart:math';
import 'package:demo/presentation/setting/setting_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/ui/color.dart';

class DashboardHeader extends SliverPersistentHeaderDelegate {
  final String email;
  const DashboardHeader({required this.email, this.vsync});

  @override
  final TickerProvider? vsync;

  double topSpace(double add) => kToolbarHeight + add;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scale = clampDouble(shrinkOffset / maxExtent, 0, 1);
    print(scale);
    final sW = MediaQuery.sizeOf(context).width;

    return Stack(fit: StackFit.expand, children: [
      Container(
        decoration: ShapeDecoration(
            color: AppColors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    // bottom: Radius.circular(35),
                    bottom: Radius.lerp(
                        const Radius.circular(35), Radius.zero, scale)!))),
      ),
      Positioned(
        top: max((1 - scale) * topSpace(25), kToolbarHeight),
        left: max((1 - scale) * (sW / 2 - max((1 - scale) * 50, 24)), 20),
        child: CircleAvatar(
          foregroundImage: const AssetImage(AssetsConstants.avatar_placeholder),
          radius: max((1 - scale) * 50, 24),
        ),
      ),
      Positioned(
        top: max((1 - scale) * topSpace(150), topSpace(10)),
        width: max(sW * (1 - scale), sW / 2),
        left: scale * 80,
        child: Text(
          email,
          textAlign: TextAlign.center,
          style: TextStyle.lerp(
              const TextStyle(
                color: AppColors.text,
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.92,
              ),
              const TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.92,
              ),
              scale),
        ),
      ),
      Positioned(
        top: kToolbarHeight,
        right: 15,
        child: Row(
          children: [
            IconButton.filled(
                onPressed: () {
                  context.pushNamed(SettingScreen.routeName);
                },
                style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                icon: const Icon(
                  Icons.settings,
                  color: AppColors.defaultButtonColor,
                )),
          ],
        ),
      )
    ]);
  }

  @override
  double get maxExtent => 260;

  @override
  double get minExtent => kToolbarHeight + 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration =>
      FloatingHeaderSnapConfiguration(
        curve: Curves.linear,
        duration: const Duration(milliseconds: 100),
      );
}
