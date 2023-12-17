import 'package:continuous_nash/Fxy.dart';
import 'package:continuous_nash/Poker.dart';
import 'package:continuous_nash/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrices/matrices.dart';
import 'dart:core';
import 'dart:math';

void main() {
  Fxy c = Fxy.number(xGrads: [0], yGrads: [0], number: 0);
  Fxy m = Fxy.number(xGrads: [0], yGrads: c.yGrads, number: 0);
  double ec = calcEc(c: c, m: m);

    print("M:\n");
    print(m);
    print("C:\n");
    print(c);


 
  for (int i = 0; i < 10000; i++) 
  {
    Fxy tM = randomM(c.yGrads);
    double tEc = calcEc(c: c, m: tM);
    if(tEc<ec)
    {
      ec = tEc;
      m = tM;
      print("M change");
    }
    print("M:\n");
    print(m);

    Fxy tC = randomC();
    m = Fxy.onlyX(xGrads: m.xGrads, yGrads: tC.yGrads, xValues: m.values[0]);
    tEc = calcEc(c: tC, m: m);
    if(tEc>ec)
    {
      ec = tEc;
      c = tC;
      print("C change");
    }
    print("C:\n");
    print(c);
  }

  // test('all tests', () {
  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0, 0.3, 0.85],
  //         yGrads: [0, 0.2],
  //         values: Matrix.fromList([
  //           [1, 2, 3],
  //           [4, 5, 6],
  //         ]));
  //     expect(f.calc(0.25, 0.1), 1);
  //     expect(f.calc(0.35, 0.1), 2);
  //     expect(f.calc(0.9, 0.1), 3);
  //     expect(f.calc(0.25, 0.3), 4);
  //     expect(f.calc(0.35, 0.3), 5);
  //     expect(f.calc(0.9, 0.3), 6);
  //   }
  //   {
  //     Fxy m = Fxy.custom(
  //         xGrads: [0, 0.2, 0.7, 0.9],
  //         yGrads: [0],
  //         values: Matrix.fromList([
  //           [1, 2, 3, 4]
  //         ]));
  //     expect(m.calc(0.1, 0.25), 1);
  //     expect(m.calc(0.3, 114), 2);
  //     expect(m.calc(0.8, 0.9), 3);
  //     expect(m.calc(0.95, 0), 4);
  //   } 
  //   {
  //     Fxy m = Fxy.custom(
  //         xGrads: [0, 0.6],
  //         yGrads: [0],
  //         values: Matrix.fromList([
  //           [0, 12]
  //         ]));
  //     Fxy cm = Fxy.custom(
  //         xGrads: [0, 5, 10],
  //         yGrads: [0],
  //         values: Matrix.fromList([
  //           [1, 1, 0]
  //         ]));
  //     Fxy cx = Fxy.compositionX(cm, m);
  //     expect(cx.calc(0.65, 114), 0);
  //     expect(cx.calc(0.55, 114), 1);
  //   }

  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0, 0.3, 0.85],
  //         yGrads: [0, 0.2],
  //         values: Matrix.fromList([
  //           [1, 12, 3],
  //           [4, 5, 6],
  //         ]));
  //     Fxy g = f + Fxy.number(xGrads: f.xGrads, yGrads: f.yGrads, number: 2);
  //     expect(g.calc(0.25, 0.1), 3);
  //     expect(g.calc(0.35, 0.1), 14);
  //     expect(g.calc(0.9, 0.1), 5);
  //     expect(g.calc(0.25, 0.3), 6);
  //     expect(g.calc(0.35, 0.3), 7);
  //     expect(g.calc(0.9, 0.3), 8);
  //   }

  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0, 0.3, 0.85],
  //         yGrads: [0, 0.2],
  //         values: Matrix.fromList([
  //           [1, 12, 3],
  //           [4, 5, 6],
  //         ]));
  //     Fxy g = Fxy.custom(
  //         xGrads: [0, 0.3, 0.85],
  //         yGrads: [0, 0.2],
  //         values: Matrix.fromList([
  //           [7, 3, 6],
  //           [1, 5, 11],
  //         ]));
  //     Fxy fg = f + g;
  //     expect(fg.calc(0.25, 0.1), 8);
  //     expect(fg.calc(0.35, 0.1), 15);
  //     expect(fg.calc(0.9, 0.1), 9);
  //     expect(fg.calc(0.25, 0.3), 5);
  //     expect(fg.calc(0.35, 0.3), 10);
  //     expect(fg.calc(0.9, 0.3), 17);
  //   }

  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0, 0.3, 0.85],
  //         yGrads: [0, 0.2],
  //         values: Matrix.fromList([
  //           [1, 12, 3],
  //           [4, 5, 6],
  //         ]));
  //     Fxy g = f * Fxy.number(xGrads: f.xGrads, yGrads: f.yGrads, number: 2);
  //     expect(g.calc(0.25, 0.1), 2);
  //     expect(g.calc(0.35, 0.1), 24);
  //     expect(g.calc(0.9, 0.1), 6);
  //     expect(g.calc(0.25, 0.3), 8);
  //     expect(g.calc(0.35, 0.3), 10);
  //     expect(g.calc(0.9, 0.3), 12);
  //   }

  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0, 0.3, 0.85],
  //         yGrads: [0, 0.2],
  //         values: Matrix.fromList([
  //           [1, 12, 3],
  //           [4, 5, 6],
  //         ]));
  //     Fxy g = Fxy.custom(
  //         xGrads: [0, 0.3, 0.85],
  //         yGrads: [0, 0.2],
  //         values: Matrix.fromList([
  //           [7, 3, 6],
  //           [1, 5, 11],
  //         ]));
  //     Fxy fg = f * g;
  //     expect(fg.calc(0.25, 0.1), 7);
  //     expect(fg.calc(0.35, 0.1), 36);
  //     expect(fg.calc(0.9, 0.1), 18);
  //     expect(fg.calc(0.25, 0.3), 4);
  //     expect(fg.calc(0.35, 0.3), 25);
  //     expect(fg.calc(0.9, 0.3), 66);
  //   }

  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0],
  //         yGrads: [0],
  //         values: Matrix.fromList([
  //           [42],
  //         ]));
  //     expect(f.integrate(), 42);
  //   }
  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0, 0.5],
  //         yGrads: [0],
  //         values: Matrix.fromList([
  //           [10,30],
  //         ]));
  //     expect(f.integrate(), 20);
  //   }
  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0, 0.5],
  //         yGrads: [0, 0.5],
  //         values: Matrix.fromList([
  //           [10,30],
  //           [30,10]
  //         ]));
  //     expect(f.integrate(), 20);
  //   }
  //   {
  //     Fxy f = Fxy.custom(
  //         xGrads: [0, 0.8],
  //         yGrads: [0, 0.5],
  //         values: Matrix.fromList([
  //           [10,30],
  //           [7,13]
  //         ]));
  //     expect(doubleEqual(f.integrate(), 11.1), true);
  //   }
  //   {
  //     expect(doubleEqual(surfaceUnderLine(x1: 5, x2: 7, y1: 1, y2: 4), 0), true);
  //     expect(doubleEqual(surfaceUnderLine(x1: 1, x2: 4, y1: 3, y2: 5), 0.5),true);
  //     expect(doubleEqual(surfaceUnderLine(x1: 2, x2: 4, y1: 1, y2: 7), 4),true);
  //     expect(doubleEqual(surfaceUnderLine(x1: 2, x2: 7, y1: 5, y2: 8), 2),true);
  //     expect(doubleEqual(surfaceUnderLine(x1: 2, x2: 7, y1: 8, y2: 15), 0), true);
  //   }
  //   {
  //     Fxy f = winProportionX(xGrads: [0, 0.4], yGrads: [0, 0.8]);
  //     expect(doubleEqual(f.values.matrix[0][0], 2/8), true);
  //     expect(doubleEqual(f.values.matrix[0][1], 10/12), true);
  //     expect(doubleEqual(f.values.matrix[1][0], 0), true);
  //     expect(doubleEqual(f.values.matrix[1][1], 1/6), true);
  //   }
  //   {
  //     Fxy f = winProportionY(xGrads: [0, 0.4], yGrads: [0, 0.8]);
  //     expect(doubleEqual(f.values.matrix[0][0], 6/8), true);
  //     expect(doubleEqual(f.values.matrix[0][1], 2/12), true);
  //     expect(doubleEqual(f.values.matrix[1][0], 1), true);
  //     expect(doubleEqual(f.values.matrix[1][1], 5/6), true);
  //   }
  //   {
  //     Fxy f = winProportionY(xGrads: [0, 0.4], yGrads: [0, 0.8]);
  //     double integ = f.integrate();
  //     expect(doubleEqual(integ, 0.5), true);
  //   }
  //   {
  //     Fxy f = Fxy.onlyX(xGrads: [0, 0.4], yGrads: [0, 0.7], xValues: [12, 4]);
  //     expect(doubleEqual(f.values.matrix[0][0], 12), true);
  //     expect(doubleEqual(f.values.matrix[0][1], 4), true);
  //     expect(doubleEqual(f.values.matrix[1][0], 12), true);
  //     expect(doubleEqual(f.values.matrix[1][1], 4), true);
  //   }
  //   {
  //     Fxy c = Fxy.number(xGrads: [0, 0.4], yGrads: [0, 0.8], number: 0);
  //     Fxy m = Fxy.onlyX( xGrads: [0, 0.4], yGrads: c.yGrads, xValues: [0, 0]);
  //     Fxy f = fxyEc(m: m, c: c);
  //     expect(doubleEqual(f.values.matrix[0][0], 0), true);
  //     expect(doubleEqual(f.values.matrix[0][1], 0), true);
  //     expect(doubleEqual(f.values.matrix[1][0], 0), true);
  //     expect(doubleEqual(f.values.matrix[1][1], 0), true);
  //   }
  //   {
  //     Fxy c = Fxy.number(xGrads: [0, 0.4], yGrads: [0, 0.8], number: 0);
  //     Fxy m = Fxy.onlyX( xGrads: [0, 0.4], yGrads: c.yGrads, xValues: [7, 10041]);
  //     Fxy f = fxyEc(m: m, c: c);
  //     expect(doubleEqual(f.values.matrix[0][0], 0), true);
  //     expect(doubleEqual(f.values.matrix[0][1], 0), true);
  //     expect(doubleEqual(f.values.matrix[1][0], 0), true);
  //     expect(doubleEqual(f.values.matrix[1][1], 0), true);
  //   }
  //   {
  //     List<double> mXGrads = [0];
  //     List<double> cXGrads = [0];
  //     List<double> cYGrads = [0];

  //     Fxy m = Fxy.onlyX( xGrads: mXGrads, yGrads: cYGrads, xValues: [13]);
  //     Fxy c = Fxy.number(xGrads: cXGrads, yGrads: cYGrads, number: 0);
  //     Fxy f = fxyEc(m: m, c: c);

  //     expect(doubleEqual(f.integrate(), 0), true);
  //   }
  //   {
  //     List<double> mXGrads = [0];
  //     List<double> cXGrads = [0];
  //     List<double> cYGrads = [0];

  //     Fxy m = Fxy.onlyX( xGrads: mXGrads, yGrads: cYGrads, xValues: [13]);
  //     Fxy c = Fxy.number(xGrads: cXGrads, yGrads: cYGrads, number: 1);
  //     Fxy f = fxyEc(m: m, c: c);

  //     double ec = f.integrate();
  //     expect(doubleEqual(ec, 0.5), true);
  //   }
  //   {
  //     List<double> mXGrads = [0];
  //     List<double> cXGrads = [0];
  //     List<double> cYGrads = [0, 0.5];

  //     Fxy m = Fxy.onlyX(xGrads: mXGrads, yGrads: cYGrads, xValues: [13]);
  //     Fxy c = Fxy.custom(xGrads: cXGrads, yGrads: cYGrads, values: Matrix.fromList([
  //           [0],
  //           [1],
  //         ]));
  //     Fxy f = fxyEc(m: m, c: c);

  //     double ec = f.integrate();
  //     expect(doubleEqual(ec, 14.5 / 4), true);
  //   }
  //   {
  //     List<double> mXGrads = [0, 0.5];
  //     List<double> cXGrads = [0, 13];
  //     List<double> cYGrads = [0, 0.5];

  //     Fxy m = Fxy.onlyX(xGrads: mXGrads, yGrads: cYGrads, xValues: [0, 13]);
  //     Fxy c = Fxy.custom(
  //         xGrads: cXGrads,
  //         yGrads: cYGrads,
  //         values: Matrix.fromList([
  //           [1, 0],
  //           [1, 1],
  //         ]));
  //     Fxy f = fxyEc(m: m, c: c);

  //     double ec = f.integrate();
  //     expect(doubleEqual(ec,0.5), true);
  //   }
  //   {
  //     List<double> mXGrads = [0, 0.5];
  //     List<double> cXGrads = [0, 12];
  //     List<double> cYGrads = [0, 2/3];

  //     Fxy m = Fxy.onlyX(xGrads: mXGrads, yGrads: cYGrads, xValues: [0, 13]);
  //     Fxy c = Fxy.custom(
  //         xGrads: cXGrads,
  //         yGrads: cYGrads,
  //         values: Matrix.fromList([
  //           [1, 0],
  //           [1, 1],
  //         ]));
  //     Fxy f = fxyEc(m: m, c: c);

  //     double ec = f.integrate();
  //     expect(doubleEqual(ec, (7.5 + 6 + 4 * 14 - 2 * 13) / 36), true);
  //   }
  // });

}
