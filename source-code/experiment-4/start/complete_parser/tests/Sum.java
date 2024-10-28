class SumTest {
  public static void main(String[] args) {
    System.out.println(new Sum().compute(new Sum().createArray()));
  }
}

class Sum {
  public int compute(int[] arr) {
    int i;
    int sum;

    i = 0;
    sum = 0;
    while (i < arr.length) {
      sum = sum + arr[i];
      i = i + 1;
    }

    return sum;
  }

  public int[] createArray() {
    int[] arr;

    arr = new int[7];
    arr[0] = 1;
    arr[1] = 1;
    arr[2] = 2;
    arr[3] = 3;
    arr[4] = 5;
    arr[5] = 8;
    arr[6] = 13;

    return arr;
  }
}
