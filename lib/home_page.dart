import 'package:flutter/cupertino.dart';
import 'BocaInfoPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<_HomeButtonData> buttons = const [
    _HomeButtonData(
      pageData: BocaInfoPage(),
      icon: CupertinoIcons.person_2,
      label: 'Boca Info',
    ),
    _HomeButtonData(
      pageData: TemporaryPage(),
      icon: CupertinoIcons.person,
      label: 'Profile',
    ),
    _HomeButtonData(
      pageData: TemporaryPage(),
      icon: CupertinoIcons.settings,
      label: 'Settings',
    ),
    _HomeButtonData(
      pageData: TemporaryPage(),
      icon: CupertinoIcons.info,
      label: 'About',
    ),
    _HomeButtonData(
      pageData: TemporaryPage(),
      icon: CupertinoIcons.calendar,
      label: 'Schedule',
    ),
    _HomeButtonData(
      pageData: TemporaryPage(),
      icon: CupertinoIcons.bell,
      label: 'Alerts',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Home')),
      child: SafeArea(
        child: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children:
              buttons.map((button) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => button.pageData,
                          ),
                        );
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CupertinoColors.systemGrey4,
                        ),
                        child: Icon(button.icon, size: 30),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      button.label,
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}

class _HomeButtonData {
  final IconData icon;
  final String label;
  final StatelessWidget pageData;

  const _HomeButtonData({
    required this.pageData,
    required this.icon,
    required this.label,
  });
}

class TemporaryPage extends StatelessWidget {
  const TemporaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Temporary')),
      child: const Center(child: Text('This is a temporary page.')),
    );
  }
}
