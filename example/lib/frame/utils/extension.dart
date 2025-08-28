import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void init(BuildContext context) {
  ScreenUtil.init(
    context,
    designSize: Size(375, 667),
  );
}

extension NumExtension on num {
  get dp {
    return ScreenUtil().scaleWidth < ScreenUtil().scaleHeight ? ScreenUtil().setWidth(this) : ScreenUtil().setHeight(this);
  }

  @Deprecated('Use dp instead')
  get width {
    return ScreenUtil().setWidth(this);
  }

  @Deprecated('Use dp instead')
  get height {
    return ScreenUtil().setHeight(this);
  }

  get sp {
    return ScreenUtil().setSp(this);
  }

  get spWithSystemScaling {
    return ScreenUtil().setSp(this);
  }
}

extension StringExtension on String {
  int get toInt {
    final regexp = RegExp(r'[^0-9]');
    return int.parse(this.replaceAll(regexp, ''));
  }

  double get toDouble {
    final regexp = RegExp(r'[^0-9.]');
    return double.parse(this.replaceAll(regexp, ''));
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
