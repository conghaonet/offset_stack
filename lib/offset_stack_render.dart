import 'package:flutter/rendering.dart';

class OffsetStackRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, OffsetStackParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, OffsetStackParentData> {
  OffsetStackRender(double coverage) : _coverage = coverage;

  late double _coverage;

  double get coverage => _coverage;

  set coverage(double value) {
    if (_coverage != value) {
      _coverage = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! OffsetStackParentData) {
      child.parentData = OffsetStackParentData();
    }
  }

  @override
  bool get sizedByParent => false;

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    ///初始化区域
    var lastChildRect = Rect.zero;
    var rowRectList = [Rect.zero];
    var totalRect = Rect.zero;
    RenderBox? child = firstChild;
    int visibleCount = 0;
    int rowIndex = 0;
    while (child != null) {
      Size childDrySize = child.getDryLayout(constraints);
      Size rowSize =
          Size(rowRectList.last.size.width + childDrySize.width, rowRectList.last.size.height + childDrySize.height);
      if (rowSize.width > constraints.biggest.width) {
        if (constraints.biggest.height - rowRectList.last.height >= rowSize.height) {
          ++rowIndex;
          lastChildRect = Rect.zero;
          rowRectList.add(Rect.zero);
        } else {
          childDrySize = Size.zero;
        }
      }
      child.layout(BoxConstraints.tight(childDrySize), parentUsesSize: true);
      final OffsetStackParentData parentData = child.parentData! as OffsetStackParentData;
      parentData.width = child.size.width;
      parentData.height = child.size.height;
      double offsetX = rowRectList.last.width - lastChildRect.width * coverage;
      parentData.offset = Offset(offsetX, parentData.height * rowIndex);
      lastChildRect = parentData.rect;
      rowRectList.last = rowRectList.last.expandToInclude(parentData.rect);
      totalRect = totalRect.expandToInclude(rowRectList.last);
      ++visibleCount;
      child = parentData.nextSibling;
    }
    size = constraints
        .tighten(
          height: totalRect.height,
          width: totalRect.width,
        )
        .smallest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(HitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result as BoxHitTestResult, position: position);
  }
}

class OffsetStackParentData extends ContainerBoxParentData<RenderBox> {
  double width = 0;
  double height = 0;

  Rect get rect => Rect.fromLTWH(
        offset.dx,
        offset.dy,
        width,
        height,
      );
}
