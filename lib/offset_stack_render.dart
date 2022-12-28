import 'package:flutter/rendering.dart';
import 'package:offset_stack/offset_stack.dart';

class OffsetStackRender extends RenderBox with
    ContainerRenderObjectMixin<RenderBox, OffsetStackParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, OffsetStackParentData> {

  OffsetStackRender(double coverage) : _coverage = coverage;

  late double _coverage;
  double get coverage => _coverage;
  set coverage(double value) {
    if(_coverage != value) {
      _coverage = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if(child.parentData is! OffsetStackParentData) {
      child.parentData = OffsetStackParentData();
    }
  }

  @override
  bool get sizedByParent => false;

  @override
  void performLayout() {
    if(childCount == 0) {
      size = constraints.smallest;
      return;
    }
    ///初始化区域
    var recordRect = Rect.zero;
    var recordRectList = [Rect.zero];
    RenderBox? child = firstChild;
    int count = 0;
    int line = 0;
    while (child != null) {
      // var childBoxConstraints = (child as RenderConstrainedBox).additionalConstraints;
      var computeSize = child.computeDryLayout(constraints);

      Size tempSize = Size(recordRectList.last.size.width + computeSize.width, recordRectList.last.size.height + computeSize.height);
      if(tempSize.width > constraints.biggest.width) {
        if(constraints.biggest.height - recordRectList.last.height >= tempSize.height) {
          ++line;
          count = 0;
          recordRectList.add(Rect.zero);
        } else {
          computeSize = Size.zero;
        }
      }

      child.layout(BoxConstraints.tight(computeSize), parentUsesSize: true);

      final OffsetStackParentData parentData = child.parentData! as OffsetStackParentData;
      parentData.width = child.size.width;
      parentData.height = child.size.height;
      double value = count * child.size.width * (1 - coverage);
      parentData.offset = Offset(value , parentData.height * line);

      recordRectList.last = recordRectList.last.expandToInclude(parentData.content);
      recordRect = recordRect.expandToInclude(recordRectList.last);
      ++count;
      child = parentData.nextSibling;
    }
    // size = Size(constraints.maxWidth, _layoutSize);
    size = constraints.tighten(height: recordRect.height, width: recordRect.width,).smallest;
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
  late double width;
  late double height;

  Rect get content => Rect.fromLTWH(
    offset.dx,
    offset.dy,
    width,
    height,
  );
}