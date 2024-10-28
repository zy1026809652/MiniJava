class AddTest {
    public static void main(String[] args) {
        System.out.println(new Add().compute(10, 35));
    }
}

class Add {
   public int compute(int x, int y) {
       return x + y;
   } 
}
