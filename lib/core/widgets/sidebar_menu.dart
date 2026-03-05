import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SidebarMenu extends StatelessWidget {
  final List<SidebarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final String title;
  final VoidCallback onLogout;

  const SidebarMenu({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.title,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.sidebarText, thickness: 0.5),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isSelected ? AppColors.sidebarActive : AppColors.sidebarText,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? AppColors.sidebarActive : AppColors.sidebarText,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.white10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
          const Divider(color: AppColors.sidebarText, thickness: 0.5),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.sidebarText),
            title: const Text('Çıkış Yap', style: TextStyle(color: AppColors.sidebarText)),
            onTap: onLogout,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final String label;

  const SidebarItem({required this.icon, required this.label});
}
