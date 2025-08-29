import 'package:flutter/material.dart';

class IconCircle extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color backgroundColor;

  const IconCircle({
    super.key,
    required this.assetPath,
    required this.size,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: EdgeInsets.all(2),
        child: ClipOval(
          child: assetPath.isNotEmpty 
              ? (assetPath.startsWith('http')
                  ? Image.network(
                      assetPath,
                      fit: BoxFit.contain,
                      width: size - 4,
                      height: size - 4,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to a default icon if network image fails
                        return Icon(
                          Icons.sports_esports,
                          size: size * 0.6,
                          color: Colors.grey[600],
                        );
                      },
                    )
                  : Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      width: size - 4,
                      height: size - 4,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to a default icon if asset not found
                        return Icon(
                          Icons.sports_esports,
                          size: size * 0.6,
                          color: Colors.grey[600],
                        );
                      },
                    ))
              : Icon(
                  Icons.sports_esports,
                  size: size * 0.6,
                  color: Colors.grey[600],
                ),
        ),
      ),
    );
  }
}
