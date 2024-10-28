class LinkedListTest {
  public static void main(String[] args) {
    System.out.println(new NodeTest().test());
  }
}

class NodeTest {
  public int test() {
    Node list;

    list = new Node().init(
        12, new Node().init(13, new Node().init(14, new Node().empty())));

    while (list.hasValue()) {
      System.out.println(list.getValue());
      list = list.getNext();
    }

    return 0;
  }
}

class Node {
  int value;
  Node next;
  boolean valid;

  public Node init(int v, Node n) {
    value = v;
    next = n;
    valid = true;

    return this;
  }

  public Node empty() {
    value = 0;
    valid = false;

    return this;
  }

  public int getValue() { return value; }

  public Node getNext() { return next; }

  public boolean hasValue() { return valid; }
}
