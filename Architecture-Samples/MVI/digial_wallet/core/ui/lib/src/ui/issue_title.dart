import 'package:ComposableWidget/composable_widget.dart';
import 'package:flutter/material.dart';

//@formatter:off
class IssueTitle extends StatelessWidget {
  final String title,issueNo;

  const IssueTitle({super.key, required this.title, required this.issueNo});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleSmall;

   return  (FlowRowBuilder(horizontalSpace: 8)
        +Text(title, style: style)
        +Text("#$issueNo", style: style?.copyWith(color: style.color?.withAlpha(150))))//80%
        .build();
  }
}
