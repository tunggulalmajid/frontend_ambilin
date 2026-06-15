import 'package:flutter/material.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';

class ProfileHeaderFull extends StatelessWidget {
  final String backgroundUrl;
  final String inisial;
  final String nama;
  final String email;
  final String? fotoUrl;
  final VoidCallback? onBackPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onAvatarEditPressed;
  final bool showBackButton;

  const ProfileHeaderFull({
    super.key,
    required this.backgroundUrl,
    required this.inisial,
    required this.nama,
    required this.email,
    this.onBackPressed,
    this.onEditPressed,
    this.fotoUrl,
    this.onAvatarEditPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(backgroundUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.40),
                BlendMode.darken,
              ),
            ),
          ),
        ),

        if (showBackButton && onBackPressed != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: onBackPressed,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColor.putih100,
                  size: 24,
                ),
              ),
            ),
          ),

        if (onEditPressed != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            right: 20,
            child: GestureDetector(
              onTap: onEditPressed,
              child: Text(
                'Edit',
                style: AppFont.bold().copyWith(
                  fontSize: 16,
                  color: AppColor.putih100,
                ),
              ),
            ),
          ),

        Positioned(
          top: 90,
          child: Column(
            children: [
              GestureDetector(
                onTap: onAvatarEditPressed,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFFFCDD2),
                      backgroundImage: (fotoUrl != null && fotoUrl!.isNotEmpty)
                          ? NetworkImage(fotoUrl!)
                          : null,
                      child: (fotoUrl == null || fotoUrl!.isEmpty)
                          ? Text(
                              inisial,
                              style: AppFont.bold().copyWith(
                                fontSize: 36,
                                color: AppColor.redAllert,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColor.putih100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: AppColor.redAllert,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Text(
                nama,
                style: AppFont.bold().copyWith(
                  fontSize: 20,
                  color: AppColor.putih100,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                email,
                style: AppFont.regular().copyWith(
                  fontSize: 13,
                  color: AppColor.putih100,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileHeaderEdit extends StatelessWidget {
  final String backgroundUrl;
  final String inisial;
  final String? fotoUrl;
  final VoidCallback onBackPressed;
  final VoidCallback? onAvatarEditPressed;

  const ProfileHeaderEdit({
    super.key,
    required this.backgroundUrl,
    required this.inisial,
    required this.onBackPressed,
    this.fotoUrl,
    this.onAvatarEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(backgroundUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.45),
                BlendMode.darken,
              ),
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColor.putih100,
                size: 24,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -45,
          child: GestureDetector(
            onTap: onAvatarEditPressed,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFFFCDD2),
                  backgroundImage: (fotoUrl != null && fotoUrl!.isNotEmpty)
                      ? NetworkImage(fotoUrl!)
                      : null,
                  child: (fotoUrl == null || fotoUrl!.isEmpty)
                      ? Text(
                          inisial,
                          style: AppFont.bold().copyWith(
                            fontSize: 36,
                            color: AppColor.redAllert,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColor.putih100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 15,
                      color: AppColor.redAllert,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileHeaderSimple extends StatelessWidget {
  final String backgroundUrl;
  final VoidCallback onBackPressed;

  const ProfileHeaderSimple({
    super.key,
    required this.backgroundUrl,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(backgroundUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.45),
                BlendMode.darken,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColor.putih100,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFont.regular().copyWith(
              fontSize: 12,
              color: AppColor.font80,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppFont.bold().copyWith(
              fontSize: 16,
              color: AppColor.font100,
            ),
          ),
        ],
      ),
    );
  }
}
