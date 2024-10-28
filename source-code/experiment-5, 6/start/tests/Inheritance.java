class InheritanceTest {
    public static void main(String[] args) {
        System.out.println(new C1().init(1).val());
        System.out.println(new C2().init(1, 2).val());
        System.out.println(new C3().init(1, 2, 3).val());
    }
}

class C1 {
    int i1;
    public C1 init(int _i1) {
        i1 = _i1;
        return this;
    }
    public int val() {
        return i1;
    }
}

class C2 extends C1 {
    int i2;
    public C2 init(int _i1, int _i2) {
        i1 = _i1;
        i2 = _i2;
        return this;
    }
    public int val() {
        return i1 + i2;
    }
}

class C3 extends C2 {
    int i3;
    public C3 init(int _i1, int _i2, int _i3) {
        i1 = _i1;
        i2 = _i2;
        i3 = _i3;
        return this;
    }
    public int val() {
        return i1 + i2 + i3;
    }
}