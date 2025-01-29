static class BezierCurve {

  public static float[] calcBezier(PVector p2, PVector p3, int steps) {
    float[] vals = new float[steps+1];   //Since steps is the number of spaces between values of the desired Bezierfunction we'll need steps+1 values
    vals[0] = 0;                         //Set the first value
    float stepSize = 1.0/steps;          //Division of the Interval of the Bezier function through the number of steps is the size of each individual step

    //Controlpoints that dictate the shape of the Bezier Curve:
    PVector K1 = new PVector(0, 0);     //Startpoint of the Curve
    PVector K2 = p2;                    //Vector that dictates the Direction in which the Bezier Curve leaves controlpoint K1
    PVector K3 = p3;                    //Vector that dictates the Direction from which the Bezier Curve enters controlpoint K4
    PVector K4 = new PVector(1, 1);     //Endpoint of the Curve

    //Formulas to calculate necessary parametrics for the Forward Differencing method of Bezier Curve Calculation
    float ay = -K1.y +3*K2.y -3*K3.y +K4.y;
    float by = 3*K1.y -6*K2.y +3*K3.y;
    float cy = -3*K1.y +3*K2.y;
    float dy = K1.y;
    //The Bezier Curve is formatted as a Function, that starts at f(0) = 0 and reaches f(1) = 1 for better usability
    //It is saved in an array, where each index equals a particular x-value (stepSize*index = x-value)
    //And each saved value at a particular index, the according y-value
    //For instance:
    /*

  y-value
    |
    |                    ____X
    |               __---
    |            _-
    |          _
    |       __-
    |____---
    O------------------------ x-value
         (Array-indices)

    O(0, 0)
    X(Array.length, 1)
    */
    float t;
    float y;
    for(int i=1; i <= steps; i++){       //Iterate through the Array i.e. save a y-value for each index
       t = stepSize*i;
       y = ay*(t*t*t) + by*(t*t) + cy*t + dy;    //Calculate stuff and pray it works :D
       vals[i] = y;
    }
  return vals;
  }
}
