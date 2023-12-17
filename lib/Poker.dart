import 'dart:math';

import 'package:continuous_nash/Fxy.dart';
import 'dart:core';

import 'package:matrices/matrices.dart';

// Fxy IsYSupX({required List<double> xGrads, required List<double> yGrads})
// {
//   Fxy lRet = Fxy.number(xGrads: xGrads, yGrads: yGrads, number: 0);
  
// }

const double MISE_MAX = 10;

double surfaceUnderLine({required double x1, required double x2, required double y1, required double y2})
{
  double ret = 0;
  if(y1>x2)
  {
    ret = 0;
  }
  else if(y1>x1)
  {
    ret = (x2-y1)*(x2-y1)/2;
  }
  else if(y2>x2)
  {
    ret = (x2-x1)*(x1-y1) + (x2-x1)*(x2-x1)/2;
  }
  else if(y2>x1)
  {
    ret = (x2-x1)*(x1-y1) + (x2-x1)*(x2-x1)/2 - (x2-y2)*(x2-y2)/2;
  }
  else
  {
    ret = 0;
  }
  return ret;
}

Fxy winProportionX({required List<double> xGrads, required List<double> yGrads}) {
  Fxy ret = Fxy.number(xGrads: xGrads, yGrads: yGrads, number: 0);
  for (int j = 0; j < xGrads.length; j++) {
    for (int i = 0; i < yGrads.length; i++) {
      double x1 = xGrads[j];
      double x2 = ((j + 1 < xGrads.length) ? xGrads[j + 1] : 1);
      double y1 = yGrads[i];
      double y2 = ((i + 1 < yGrads.length) ? yGrads[i + 1] : 1);
      double surface = surfaceUnderLine(x1: x1, x2: x2, y1: y1, y2: y2);
      double proportion = surface/((x2-x1)*(y2-y1));
      ret.values.matrix[i][j] = proportion;
    }
  }
  return ret;
}

Fxy winProportionY({required List<double> xGrads, required List<double> yGrads}) {
  Fxy ret = Fxy.number(xGrads: xGrads, yGrads: yGrads, number: 0);
  for (int j = 0; j < xGrads.length; j++) {
    for (int i = 0; i < yGrads.length; i++) {
      double x1 = xGrads[j];
      double x2 = ((j + 1 < xGrads.length) ? xGrads[j + 1] : 1);
      double y1 = yGrads[i];
      double y2 = ((i + 1 < yGrads.length) ? yGrads[i + 1] : 1);
      double surface = surfaceUnderLine(x1: x1, x2: x2, y1: y1, y2: y2);
      double proportion = surface/((x2-x1)*(y2-y1));
      ret.values.matrix[i][j] = 1-proportion;
    }
  }
  return ret;
}

Fxy fxyEc({required Fxy c, required Fxy m})
{
         /*        C         */      /*                         M + 1                           */     /*           Prop(y>x)                          */  /*                    -M                                      */  /*           Prop(x>y)                          */
  return Fxy.compositionX(c, m) * ( (m + Fxy.number(xGrads: m.xGrads, yGrads: m.yGrads, number: 1) ) * winProportionY(xGrads: m.xGrads, yGrads: m.yGrads) + Fxy.number(xGrads: m.xGrads, yGrads: m.yGrads, number: -1) * m * winProportionX(xGrads: m.xGrads, yGrads: m.yGrads)) ;
}

double calcEc({required Fxy c, required Fxy m})
{
  return fxyEc(c: c, m: m).integrate();
}

Fxy randomM(List<double> yGrads)
{
  Fxy ret;
  Random rng = Random();

  List<double> xGrads = [0];
  List<double> xValues = [rng.nextDouble()*MISE_MAX];
  double x = 0;
  double delta = 0.01;
  double proba = 0.01;
  
  while(x<1)
  {
    if(rng.nextDouble()<proba)
    {
      xValues.add(rng.nextDouble()*MISE_MAX);
      xGrads.add(x);
    }
    x += delta;
  }
  
  ret = Fxy.onlyX(xGrads: xGrads, yGrads: yGrads, xValues: xValues);
  return ret;
}


Fxy randomC()
{
  Fxy ret;
  Random rng = Random();

  List<double> xGrads = [0];
  List<double> yGrads = [0];
  double x = 0;
  double deltaX = 0.01;
  double probaX = 0.01;
  double y = 0;
  double deltaY = 0.01;
  double probaY = 0.01;
  double probaValue1 = 0.5;
  
  while(x<MISE_MAX)
  {
    if(rng.nextDouble()<probaX)
    {
      xGrads.add(x);
    }
    x += deltaX;
  }
  while(y<1)
  {
    if(rng.nextDouble()<probaY)
    {
      yGrads.add(y);
    }
    y += deltaY;
  }

  Matrix values = Matrix.zero(yGrads.length, xGrads.length);
  for (int i = 0; i < values.matrix.length; i++) {
    for (int j = 0; j < values.matrix[i].length; j++) {
      if(rng.nextDouble()<probaValue1)
      {
        values.matrix[i][j] = 1;
      }
    }
  }

  ret = Fxy.custom(xGrads: xGrads, yGrads: yGrads, values: values);
  return ret;
}