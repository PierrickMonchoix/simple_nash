import 'dart:developer';

import 'package:continuous_nash/utils.dart';
import 'package:matrices/matrices.dart';

class Fxy
{
  late List<double> xGrads;
  late List<double> yGrads;
  late Matrix values;

  Fxy();

  Fxy.custom({required this.xGrads, required this.yGrads, required this.values})
  {
    assert(xGrads.length == values.columnCount);
    assert(yGrads.length == values.rowCount);
  }

  Fxy.number({required this.xGrads, required this.yGrads, required double number})
  {
    values = Matrix.number(number, yGrads.length, xGrads.length);
  }

  Fxy.onlyX({required this.xGrads, required this.yGrads, required List<double> xValues})
  {
    values = Matrix.number(0, yGrads.length, xGrads.length);
    for (int i = 0; i < values.matrix.length; i++) {
      for (int j = 0; j < values.matrix[i].length; j++) 
      {
        values.matrix[i][j] = xValues[j];
      }
    }
  }

  Fxy.from(Fxy f) //TODO : la reference est coservée
  {
    xGrads = List.from(f.xGrads);
    yGrads = List.from(f.yGrads);
    values = Matrix.zero(f.yGrads.length, f.xGrads.length);
    for (int i = 0; i < values.matrix.length; i++) {
      for (int j = 0; j < values.matrix[i].length; j++) {
        values.matrix[i][j] = f.values[i][j];
      }
    }
  }

  double calc(double pX, double pY)
  {
    double lRet;
    int lIndexXGrad = 0;
    int lIndexYGrad = 0;
    for (int i = 0 ; i < xGrads.length ; i++) {
      if(pX >= xGrads[i])
      {
        lIndexXGrad = i;
      }
    }
    for (int i = 0 ; i < yGrads.length ; i++) {
      if(pY >= yGrads[i])
      {
        lIndexYGrad = i;
      }
    }
    lRet = values.matrix[lIndexYGrad][lIndexXGrad];
    return lRet;
  }

  Fxy.compositionX(Fxy f, Fxy g)
  {
    xGrads = List.from(g.xGrads);
    yGrads = List.from(f.yGrads);
    values = Matrix.zero(yGrads.length, xGrads.length);
    for (int deltaYRet = 0 ; deltaYRet < yGrads.length ; deltaYRet++) 
    {
      for (int deltaXRet = 0 ; deltaXRet < xGrads.length ; deltaXRet++) 
      {
        values[deltaYRet][deltaXRet] = f.calc(g.calc(g.xGrads[deltaXRet], f.yGrads[deltaYRet]), f.yGrads[deltaYRet]);
      }
    }
  }

  Fxy operator +(Fxy f) {
    assert(xGrads.length == f.xGrads.length);
    assert(yGrads.length == f.yGrads.length);
    for (int i = 0; i < xGrads.length; i++) {
      assert(doubleEqual(xGrads[i], f.xGrads[i]));       
    }
    for (int i = 0; i < yGrads.length; i++) {
      assert(doubleEqual(yGrads[i], f.yGrads[i]));       
    }
    Fxy lRet = Fxy.from(this);
    for (var i = 0; i < lRet.values.matrix.length; i++) {
      for (var j = 0; j < lRet.values.matrix[i].length; j++) {
        lRet.values.matrix[i][j] += f.values.matrix[i][j];
      }
    }
    return lRet;
  }

  Fxy operator *(Fxy f) {
    assert(xGrads.length == f.xGrads.length);
    assert(yGrads.length == f.yGrads.length);
    for (int i = 0; i < xGrads.length; i++) {
      assert(doubleEqual(xGrads[i], f.xGrads[i]));       
    }
    for (int i = 0; i < yGrads.length; i++) {
      assert(doubleEqual(yGrads[i], f.yGrads[i]));       
    }

    Fxy lRet = Fxy.from(this);
    for (var i = 0; i < lRet.values.matrix.length; i++) {
      for (var j = 0; j < lRet.values.matrix[i].length; j++) {
        lRet.values.matrix[i][j] *= f.values.matrix[i][j];
      }
    }
    return lRet;
  }

  double integrate() {
    double lRet = 0;
    for (int j = 0; j < xGrads.length; j++) {
      for (int i = 0; i < yGrads.length; i++) {
        double lDeltaX = ((j + 1 < xGrads.length) ? xGrads[j + 1] : 1) - xGrads[j];
        double lDeltaY = ((i + 1 < yGrads.length) ? yGrads[i + 1] : 1) - yGrads[i];
        double lOrdonate = values.matrix[i][j];
        lRet += lDeltaX * lDeltaY * lOrdonate;
      }
    }
    return lRet;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "xGrads: $xGrads\nyGrads: $yGrads\nvalues:\n$values";
  }

  //TODO : Fxy*Fxy -> Fxy , Fxy+double -> Fxy , integrale(Fxy)-> double , CompositionX(Fxy,Fxy) -> Fxy

}