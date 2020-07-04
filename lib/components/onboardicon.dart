import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class illustration extends StatelessWidget {
  illustration({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SvgPicture.string(
          _svg_ybcmbw,
          allowDrawingOutsideViewBox: true,
        ),
      ],
    );
  }
}

const String _svg_ybcmbw =
    '<svg viewBox="0.0 0.0 184.7 160.0" ><path transform="translate(-642.9, 0.0)" d="M 781.4000244140625 0 L 689.0999755859375 0 L 642.9000244140625 80 L 689.0999755859375 160 L 781.4000244140625 160 L 827.5999755859375 80 L 781.4000244140625 0 Z" fill="#c6bed2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-642.9, 0.0)" d="M 781.4000244140625 0 L 689.0999755859375 160 L 642.9000244140625 80 L 827.5999755859375 80 L 781.4000244140625 0 Z" fill="#582f8c" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
