class OptionTest {
    public static void main(String[] args) {
        System.out.println(new Option().test());
    }
}

class Option {
    public Option show() {
        return this;
    }

    public int test() {
        Option opt;
        Option t;
        opt = new Some().setValue(45);
        t = opt.show();
        opt = new None();
        t = opt.show();
        return 0;
    }
}

class None extends Option {
    public Option show() {
        System.out.println(0);
        return this;
    }
}

class Some extends Option {
    int value;

    public Some setValue(int v) {
        value = v;
        return this;
    }

    public Option show() {
        System.out.println(value);
        return this;
    }
}