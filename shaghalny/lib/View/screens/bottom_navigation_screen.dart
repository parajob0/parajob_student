
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
import 'package:shaghalny/ViewModel/cubits/notifications_cubit/notifications_cubit.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '/View/screens/home_screen.dart';
import '/View/screens/profile_screen.dart';
import 'package:simple_shadow/simple_shadow.dart';
import '../../color_const.dart';
import 'jobs_screen.dart';
import 'notification_screen.dart';

class BottomNavigation extends StatefulWidget {
  int index;
  BottomNavigation({required this.index, Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const JobsScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      // _selectedIndex = index;
      widget.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    PreferenceCubit prefCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    NotificationsCubit notiCubit = BlocProvider.of<NotificationsCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: _widgetOptions.elementAt(widget.index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: widget.index == 0 ? SimpleShadow(
              color: secondary,
              offset: const Offset(2, 2), // Default: Offset(2, 2)
              sigma: 9,
              child: Container(
                  width: 40.w,
                  height: 40.h,
                  child: SvgPicture.asset('assets/homeFilled.svg',)),
            )
                : Container(
                width: 40.w,
                height: 40.h,
                child: SvgPicture.asset('assets/homeFilled.svg', color: Colors.white)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: widget.index == 1 ? SimpleShadow(
                color: secondary,
                offset: const Offset(2, 2), // Default: Offset(2, 2)
                sigma: 9,
                child: Container(
                    width: 35.w,
                    height: 40.h,
                    child: SvgPicture.asset('assets/jobsFilled.svg',))
            )
                : Container(
                width: 35.w,
                height: 40.h,
                child: SvgPicture.asset('assets/jobsFilled.svg', color: Colors.white)),
            label: 'Jobs',
          ),

          BottomNavigationBarItem(
            icon: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                widget.index == 2 ?
                SimpleShadow(
                    color: secondary,
                    offset: const Offset(2, 2), // Default: Offset(2, 2)
                    sigma: 9,
                    child: Container(
                        width: 30.w,
                        height: 30.h,
                        child: SvgPicture.asset('assets/notiFilled.svg',))
                )
                : Container(
                    width: 30.w,
                    height: 30.h,
                    child: SvgPicture.asset('assets/notiFilled.svg', color: Colors.white,)),

                if(notiCubit.unseenNotifications > 0)
                  Positioned(
                    top: 2,
                    right: 3,
                    child: Container(
                      width: 13.w,
                      height: 13.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFF4D4D),
                      ),
                      child: Center(child: CustomText(text: "${notiCubit.unseenNotifications}", weight: FontWeight.w300, size: 10.sp, color: Colors.white)),
                    ),
                  )
              ],
            ),
            label: 'Notifications',
          ),

          BottomNavigationBarItem(
            icon: Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(prefCubit.userModel!.profilePic.toString())
                )
              ),
            ),
            // icon: CircleAvatar(
            //   minRadius: 13.sp,
            //   maxRadius: 13.sp,
            //   backgroundImage: NetworkImage(prefCubit.userModel!.profilePic.toString()),
            // ),
    // SvgPicture.network(prefCubit.userModel!.profilePic.toString(), color: secondary,),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: secondary,
        showUnselectedLabels: true,
        currentIndex: widget.index,
        selectedFontSize: 9.sp,
        unselectedFontSize: 9.sp,
        enableFeedback: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
