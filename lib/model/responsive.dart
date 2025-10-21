import 'package:flutter/cupertino.dart';

class Responsive{
  BuildContext context;
  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;

  late double scale = width/411;

}