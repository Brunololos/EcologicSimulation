static class MatrixMult {

  float[] M11 = {1, 2, 3};
  float[] M12 = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  float[] M13 = {7, 4, 3, 4, 1, 1, 7, 4, 9};
  float[] R = {};

  MatrixMult() {
    /*printMatrix(M12, 3, 3);
    println();
    //printMatrix(M13, 3, 3);
    //println();
    printMatrix(M11, 3, 1);
    println();
    R = Multiply(M12, M11, 3, 3, 1);
    //R = Multiply(M12, M11, 3, 3, 1);
    //R = Multiply(M12, M13, 3, 3, 3);
    for(int j=0; j<R.length; j++) {
      print(R[j] + " ");
    }
    print("\n");
    printMatrix(R, 3, 1);
    println();*/
  }

  float[] MatrixMultiply(float[] InList, float[] WeightList, int OutLen) {
    float[] OutList = new float[OutLen];

    for(int j=0; j<OutLen; j++) {
      float val = 0;
      for(int k=0; k<InList.length; k++) {
        val += InList[k]*WeightList[k+j*InList.length];
      }
      OutList[j] = float(int((val)*100))/100;
    }
    return OutList;
  }

  //Takes two flattened Matrices as arguments and additionally their dimensions
  static float[] Multiply(float[] M1, float[] M2, int dim1, int dim2, int dim3) {
    float[] M3 = new float[dim1*dim3];

    if(M1.length != dim1*dim2 || M2.length != dim2*dim3) {
      print("Wrong Matrix-dimensions\n");
      print("Passed: dim1=", dim1, ", dim2=", dim2, ", dim3=", dim3, "\n");
      print("With array-lengths: M1.length=", M1.length, ", M2.length=", M2.length,"\n");
      return M3;
    }

    for(int i=0; i<dim1; i++) {
      for(int j=0; j<dim3; j++) {
        M3[i*dim3 + j] = 0;
        for(int k=0; k<dim2; k++) {
          M3[i*dim3 + j] += M1[k+i*dim2] * M2[k*dim3+j];
        }
        M3[i*dim3 + j] = float(int((M3[i*dim3 + j])*100))/100;
      }
    }

    return M3;
  }

  // TODO: Add proper alignment for negative/positive values and different lengths behind da dot
  static void printMatrix(float[] M, int dim1, int dim2) {
    if(M.length != dim1*dim2) {
      print("Wrong Matrix-dimensions");
      return;
    }

    for(int i=0; i<dim1; i++) {
      for(int j=0; j<dim2; j++) {
        //print("["+M[j+i*dim2]+"]");
        print(M[j+i*dim2]+" ");
      }
      print("\n");
    }
  }






























}
