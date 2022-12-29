library offset_stack;

import 'package:flutter/widgets.dart';
import 'package:offset_stack/offset_stack_render.dart';

typedef MoreWidget = Widget Function(int surplus);

class OffsetStack extends MultiChildRenderObjectWidget {
  final double coverage;
  final MoreWidget? moreWidget;

  OffsetStack({required this.coverage, required super.children, this.moreWidget, super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return OffsetStackRender(coverage);
  }

  @override
  void updateRenderObject(BuildContext context, OffsetStackRender renderObject) {
    renderObject.coverage = coverage;
  }
}
