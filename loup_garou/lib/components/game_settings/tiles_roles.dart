import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'package:loup_garou/visuals/colors.dart';

class TileRole extends StatelessWidget {
  final RoleAction role;
  final bool isSelected;
  final Function(RoleAction) onRoleSelected;

  const TileRole({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onRoleSelected(role),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? yellow: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? yellow: Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              role.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              role.description,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}