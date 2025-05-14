// import 'package:flutter/material.dart';

// class BottomNavigationProvider with ChangeNotifier {
//   int _tabIndex = 0;
//   late final PageController _pageController = PageController(initialPage: _tabIndex);
//   final ScrollController _scrollController = ScrollController();

//   int get tabIndex => _tabIndex;

//   PageController get pageController => _pageController;
//   ScrollController get scrollcontroller => _scrollController;
//   // void setTabIndex(int index) {
//   //   _tabIndex = index;
//   //   _pageController.jumpToPage(index);
//   //   notifyListeners();
//   // }

//   void setTabIndex(int index) {
//     _tabIndex = index;

//     // Ensure the PageController is attached to a PageView before jumping to a page
//     if (_pageController.hasClients) {
//       _pageController.jumpToPage(index);
//     } else {
//       Future.microtask(() {
//         if (_pageController.hasClients) {
//           _pageController.jumpToPage(index);
//         }
//       });
//     }

//     notifyListeners();
//   }
// //   /// Safely sets the tab index and navigates the PageController if attached
// // void setTabIndex(int index) {
// //   print("Setting tab index: $index");

// //   _tabIndex = index;

// //   // Ensure _pageController moves to correct index
// //   if (_pageController.hasClients) {
// //     _pageController.jumpToPage(index);
// //   } else {
// //     _pageController.addListener(() {
// //       _pageController.jumpToPage(index);
// //     });
// //   }

// //   notifyListeners();
// // }

//   /// Scrolls to the top of the current tab if the ScrollController is attached
//   void scrollToTop() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

import '../Utils/packages.dart';

class BottomNavigationState {
  final int tabIndex;
  final PageController pageController;
  final ScrollController scrollController;

  BottomNavigationState({
    required this.tabIndex,
    required this.pageController,
    required this.scrollController,
  });

  BottomNavigationState copyWith({
    int? tabIndex,
  }) {
    return BottomNavigationState(
      tabIndex: tabIndex ?? this.tabIndex,
      pageController: pageController,
      scrollController: scrollController,
    );
  }
}

class BottomNavigationNotifier
    extends AutoDisposeNotifier<BottomNavigationState> {
  @override
  BottomNavigationState build() {
    final pageController = PageController(initialPage: 4);
    final scrollController = ScrollController();

    ref.onDispose(() {
      pageController.dispose();
      scrollController.dispose();
    });

    return BottomNavigationState(
      tabIndex: 4,
      pageController: pageController,
      scrollController: scrollController,
    );
  }

  void setTabIndex(int index) {
    if (state.pageController.hasClients) {
      state.pageController.jumpToPage(index);
    } else {
      Future.microtask(() {
        if (state.pageController.hasClients) {
          state.pageController.jumpToPage(index);
        }
      });
    }

    state = state.copyWith(tabIndex: index);
  }

  void scrollToTop() {
    if (state.scrollController.hasClients) {
      state.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

final bottomNavigationProvider = AutoDisposeNotifierProvider<
    BottomNavigationNotifier, BottomNavigationState>(
  () => BottomNavigationNotifier(),
);
