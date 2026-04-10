import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_screen.dart';

import '../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  int _selectedNav = 0;

  late AnimationController _listAnim;

  @override
  void initState() {
    super.initState();
    _listAnim = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _listAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userName =
        user?.userMetadata?['display_name'] as String? ?? 'Utilisateur';

    return Scaffold(
      backgroundColor: NaloColors.background,
      body: Column(
        children: [
          _buildHeader(context, userName),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _buildStories(),
                _buildTabs(),
                const SizedBox(height: 8),
                _buildConversationList(),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: NaloColors.accentGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: NaloColors.accent.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
        ),
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- Header avec gradient ---
  Widget _buildHeader(BuildContext context, String userName) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 12,
        20,
        20,
      ),
      decoration: BoxDecoration(
        gradient: NaloColors.darkGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: NaloColors.primaryDark.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Statut centré
          Expanded(
            child: Column(
              children: [
                Text(
                  'Statut actuel',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: NaloColors.online.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: NaloColors.online, size: 7),
                      SizedBox(width: 5),
                      Text(
                        'En ligne',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Avatar logout
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: NaloColors.accentGradient,
              ),
              child: CircleAvatar(
                radius: 19,
                backgroundColor: NaloColors.primaryDark,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Déconnexion'),
        content: const Text('Tu veux vraiment te déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Supabase.instance.client.auth.signOut();
            },
            child: const Text(
              'Déconnexion',
              style: TextStyle(color: NaloColors.error),
            ),
          ),
        ],
      ),
    );
  }

  // --- Stories ---
  Widget _buildStories() {
    final stories = ['Ajouter', 'Alice', 'Bob', 'Clara', 'David', 'Emma'];

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Stories',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: NaloColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 92,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final isAdd = index == 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isAdd ? null : NaloColors.accentGradient,
                          border: isAdd
                              ? Border.all(
                                  color: NaloColors.textLight,
                                  width: 1.5,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                )
                              : null,
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: isAdd
                              ? NaloColors.surfaceVariant
                              : NaloColors.primary.withValues(alpha: 0.08),
                          child: isAdd
                              ? Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    gradient: NaloColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )
                              : Text(
                                  stories[index][0],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: NaloColors.primary,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        stories[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isAdd ? FontWeight.w600 : FontWeight.w500,
                          color: isAdd
                              ? NaloColors.primary
                              : NaloColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Onglets filtre ---
  Widget _buildTabs() {
    final tabs = [
      ('Tous', Icons.chat_bubble_rounded),
      ('Groupes', Icons.group_rounded),
      ('Channels', Icons.forum_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = i == _selectedTab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: selected ? NaloColors.accentGradient : null,
                  color: selected ? null : NaloColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: selected
                      ? null
                      : Border.all(
                          color: NaloColors.primary.withValues(alpha: 0.08),
                        ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: NaloColors.accent.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Icon(
                      tabs[i].$2,
                      size: 15,
                      color: selected ? Colors.white : NaloColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tabs[i].$1,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : NaloColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- Conversations ---
  Widget _buildConversationList() {
    final conversations = [
      _ConvData('Alice Martin', 'Salut ! Comment ça va ?', '12:02', true, 2),
      _ConvData('Bob Dupont', 'On se retrouve où ?', '12:00', false, 0),
      _ConvData(
        'Team Nalo',
        "Réunion à 14h, n'oubliez pas !",
        '11:45',
        true,
        5,
      ),
      _ConvData('Clara', 'Super idée ! 🎉', '09:24', false, 0),
      _ConvData('David', 'Je t\'envoie le fichier', '08:30', false, 1),
    ];

    return Column(
      children: List.generate(conversations.length, (index) {
        final interval = Interval(
          (index * 0.15).clamp(0.0, 1.0),
          ((index * 0.15) + 0.4).clamp(0.0, 1.0),
          curve: Curves.easeOut,
        );
        return FadeTransition(
          opacity: _listAnim.drive(
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: interval)),
          ),
          child: SlideTransition(
            position: _listAnim.drive(
              Tween(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).chain(CurveTween(curve: interval)),
            ),
            child: _buildConversationTile(conversations[index]),
          ),
        );
      }),
    );
  }

  Widget _buildConversationTile(_ConvData conv) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    ChatScreen(name: conv.name, isOnline: conv.isOnline),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: NaloColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: NaloColors.primary.withValues(alpha: 0.04),
              ),
            ),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            NaloColors.primary.withValues(alpha: 0.12),
                            NaloColors.accent.withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          conv.name[0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: NaloColors.primary,
                          ),
                        ),
                      ),
                    ),
                    if (conv.isOnline)
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: NaloColors.online,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: NaloColors.surface,
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Name + message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conv.name,
                        style: TextStyle(
                          fontWeight: conv.unread > 0
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: NaloColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conv.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: conv.unread > 0
                              ? NaloColors.textPrimary
                              : NaloColors.textSecondary,
                          fontSize: 13,
                          fontWeight: conv.unread > 0
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Time + badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      conv.time,
                      style: TextStyle(
                        color: conv.unread > 0
                            ? NaloColors.accent
                            : NaloColors.textLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (conv.unread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: NaloColors.accentGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${conv.unread}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Bottom Navigation ---
  Widget _buildBottomNav() {
    final items = [
      (Icons.chat_bubble_rounded, 'Chats'),
      (Icons.call_rounded, 'Appels'),
      (Icons.photo_library_rounded, 'Galerie'),
      (Icons.person_rounded, 'Profil'),
    ];

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 4,
        top: 8,
      ),
      decoration: BoxDecoration(
        color: NaloColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (i) {
          final selected = i == _selectedNav;
          return GestureDetector(
            onTap: () => setState(() => _selectedNav = i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? NaloColors.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].$1,
                    size: 22,
                    color: selected ? NaloColors.primary : NaloColors.textLight,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    items[i].$2,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? NaloColors.primary
                          : NaloColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ConvData {
  final String name;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final int unread;

  _ConvData(this.name, this.lastMessage, this.time, this.isOnline, this.unread);
}
