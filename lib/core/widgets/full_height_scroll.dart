import 'package:flutter/material.dart';

/// Прокручуваний вміст, який займає щонайменше всю висоту екрана.
///
/// Дозволяє використовувати [Spacer] у [Column] (притиснути кнопку чи
/// посилання донизу, як у макеті), а на малих екранах — прокручувати.
class FullHeightScroll extends StatelessWidget {
  final EdgeInsets padding;
  final List<Widget> children;

  const FullHeightScroll({
    super.key,
    required this.padding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight - padding.vertical,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
