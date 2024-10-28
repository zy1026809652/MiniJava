class FactorialTest {
    public static void main(String[] args) {
        System.out.println(new Factorial().compute(10));
    }
}

class Factorial {
    public int compute(int n) {
        int result;

        if (n < 1) {
            result = 1;
        } else {
            result = n * this.compute(n - 1);
        }

        return result;
    }
}