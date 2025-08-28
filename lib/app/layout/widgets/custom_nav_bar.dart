import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
 static const double _labelFontSize = 10.0;
 static const double _iconSize = 30.0;

 final int currentIndex;
 final ValueChanged<int> onTap;
 final VoidCallback? onParisTabTap;
 final VoidCallback? onMesParisTabTap;

 const CustomNavBar({
   super.key,
   required this.currentIndex,
   required this.onTap,
   this.onParisTabTap,
   this.onMesParisTabTap,
 });

 @override
 Widget build(BuildContext context) {
   return BottomNavigationBar(
     backgroundColor: Colors.black,
     currentIndex: currentIndex,
     onTap: (index) {
       // Nếu nhấn vào tab Paris (index 2), gọi callback refresh
       if (index == 2 && onParisTabTap != null) {
         onParisTabTap!();
       }
       // Nếu nhấn vào tab Mes Paris (index 3), gọi callback kiểm tra đăng nhập
       if (index == 3 && onMesParisTabTap != null) {
         onMesParisTabTap!();
         // Không return ở đây, để onTap vẫn được gọi
       }
       onTap(index);
     },
     type: BottomNavigationBarType.fixed,
     selectedItemColor: Colors.white,
     unselectedItemColor: Colors.grey,
     selectedLabelStyle: const TextStyle(
       fontSize: _labelFontSize,
       fontWeight: FontWeight.bold,
       color: Colors.white,
     ),
     unselectedLabelStyle: const TextStyle(
       fontSize: _labelFontSize,
       fontWeight: FontWeight.bold,
       color: Colors.grey,
     ),
     iconSize: _iconSize,
     items: [
       BottomNavigationBarItem(
         icon: Icon(
           currentIndex == 0 ? Icons.sports_esports : Icons.sports_esports_outlined,
         ),
         label: 'E-Sports',
       ),
       BottomNavigationBarItem(
         icon: Icon(
           currentIndex == 1 ? Icons.emoji_events : Icons.emoji_events_outlined,
         ),
         label: 'Défis',
       ),
       BottomNavigationBarItem(
         icon: Icon(
           currentIndex == 2 ? Icons.rocket : Icons.rocket_outlined,
         ),
         label: 'Paris',
       ),
       BottomNavigationBarItem(
         icon: Icon(
           currentIndex == 3 ? Icons.bookmarks : Icons.bookmarks_outlined,
         ),
         label: 'Mes Paris',
       ),
       BottomNavigationBarItem(
         icon: Icon(
           currentIndex == 4 ? Icons.shopping_bag : Icons.shopping_bag_outlined,
         ),
         label: 'Boutique',
       ),
     ],
   );
 }
}