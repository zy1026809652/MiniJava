class PointTest {
    public static void main(String[] args) {
        System.out.println(new Point().init(10, 20).getX());
        System.out.println(new Point().init(10, 20).getY());
    }
}

class Point {
    int x;
    int y;

    public Point init(int _x, int _y) {
        x = _x;
        y = _y;
        return this;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }
}