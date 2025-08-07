import StableDynamicArray "../src/StableDynamicArray";
import Nat "mo:core/Nat";

import { test; suite } "mo:test";

// Helper function to compare arrays
func assertArrayEqual<T>(actual : [T], expected : [T], equal : (T, T) -> Bool) {
  assert actual.size() == expected.size();
  for (i in Nat.range(0, actual.size())) {
    assert equal(actual[i], expected[i]);
  };
};

/* --------------------------------------- */
suite(
  "construct",
  func() {
    test(
      "initial size",
      func() {
        assert StableDynamicArray.size(StableDynamicArray.initPresized<Nat>(10)) == 0;
      },
    );

    test(
      "initial capacity",
      func() {
        assert StableDynamicArray.capacity(StableDynamicArray.initPresized<Nat>(10)) == 10;
      },
    );
  },
);

/* --------------------------------------- */

var dynamicArray = StableDynamicArray.initPresized<Nat>(10);
for (i in Nat.range(0, 4)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "add",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 4;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 10;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(2);
for (i in Nat.range(0, 4)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "add with capacity change",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 4;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 5;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(0);
for (i in Nat.range(0, 4)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "add with capacity change, initial capacity 0",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 4;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 5;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(2);

suite(
  "removeLast on empty dynamicArray",
  func() {
    test(
      "return value",
      func() {
        assert StableDynamicArray.removeLast(dynamicArray) == (null : ?Nat);
      },
    );

    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 2;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(2);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "removeLast",
  func() {
    test(
      "return value",
      func() {
        assert StableDynamicArray.removeLast(dynamicArray) == ?5;
      },
    );

    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 5;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(3);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

for (i in Nat.range(0, 6)) {
  ignore StableDynamicArray.removeLast(dynamicArray);
};

suite(
  "removeLast until empty",
  func() {
    test(
      "return value",
      func() {
        assert StableDynamicArray.removeLast(dynamicArray) == (null : ?Nat);
      },
    );

    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 2;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(0);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "remove",
  func() {
    test(
      "return value",
      func() {
        assert StableDynamicArray.remove(dynamicArray, 2) == 2;
      },
    );

    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 5;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 3, 4, 5], Nat.equal);
      },
    );

    test(
      "return value",
      func() {
        assert StableDynamicArray.remove(dynamicArray, 0) == 0;
      },
    );

    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 4;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [1, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(3);
for (i in Nat.range(0, 3)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "remove last element at capacity",
  func() {
    test(
      "return value",
      func() {
        assert StableDynamicArray.remove(dynamicArray, 2) == 2;
      },
    );

    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 2;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 3;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(0);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

for (i in Nat.range(0, 6)) {
  ignore StableDynamicArray.remove(dynamicArray, 5 - i : Nat);
};

suite(
  "remove until empty",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 2;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(1);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

StableDynamicArray.filterEntries<Nat>(dynamicArray, func(_, x) = x % 2 == 0);

suite(
  "filterEntries",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 3;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 2, 4], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(1);
StableDynamicArray.filterEntries<Nat>(dynamicArray, func(_, x) = x % 2 == 0);

suite(
  "filterEntries on empty",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 1;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(12);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};
StableDynamicArray.filterEntries<Nat>(dynamicArray, func(i, x) = i + x == 2);

suite(
  "filterEntries size down",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 1;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 6;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [1], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(5);
for (i in Nat.range(0, 5)) {
  StableDynamicArray.add(dynamicArray, i);
};
StableDynamicArray.filterEntries<Nat>(dynamicArray, func(_, _) = false);

suite(
  "filterEntries size down to empty",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 2;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [] : [Nat], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(10);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "get and getOpt",
  func() {
    test(
      "get",
      func() {
        assert StableDynamicArray.get(dynamicArray, 2) == 2;
      },
    );

    test(
      "getOpt success",
      func() {
        assert StableDynamicArray.getOpt(dynamicArray, 0) == ?0;
      },
    );

    test(
      "getOpt out of bounds",
      func() {
        assert StableDynamicArray.getOpt(dynamicArray, 10) == (null : ?Nat);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(10);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

StableDynamicArray.put(dynamicArray, 2, 20);

suite(
  "put",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 6;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 20, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(10);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

StableDynamicArray.reserve(dynamicArray, 6);

suite(
  "decrease capacity",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 6;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(10);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

StableDynamicArray.reserve(dynamicArray, 20);

suite(
  "increase capacity",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 20;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(10);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

var dynamicArray2 = StableDynamicArray.initPresized<Nat>(20);

for (i in Nat.range(10, 16)) {
  StableDynamicArray.add(dynamicArray2, i);
};

StableDynamicArray.append(dynamicArray, dynamicArray2);

suite(
  "append",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 18;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(10);
for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

dynamicArray2 := StableDynamicArray.initPresized<Nat>(0);

StableDynamicArray.append(dynamicArray, dynamicArray2);

suite(
  "append empty dynamicArray",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 10;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(10);

dynamicArray2 := StableDynamicArray.initPresized<Nat>(10);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray2, i);
};

StableDynamicArray.append(dynamicArray, dynamicArray2);

suite(
  "append to empty dynamicArray",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 10;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(8);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

StableDynamicArray.insert(dynamicArray, 3, 30);

suite(
  "insert",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 7;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 30, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(8);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

StableDynamicArray.insert(dynamicArray, 6, 60);

suite(
  "insert at back",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 7;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5, 60], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(8);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

StableDynamicArray.insert(dynamicArray, 0, 10);

suite(
  "insert at front",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 7;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [10, 0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(6);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

StableDynamicArray.insert(dynamicArray, 3, 30);

suite(
  "insert with capacity change",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 7;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 9;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 30, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(5);

StableDynamicArray.insert(dynamicArray, 0, 0);

suite(
  "insert into empty dynamicArray",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 1;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 5;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(0);

StableDynamicArray.insert(dynamicArray, 0, 0);

suite(
  "insert into empty dynamicArray with capacity change",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 1;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 1;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(15);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

dynamicArray2 := StableDynamicArray.initPresized<Nat>(10);

for (i in Nat.range(10, 16)) {
  StableDynamicArray.add(dynamicArray2, i);
};

StableDynamicArray.insertDynamicArray(dynamicArray, 3, dynamicArray2);

suite(
  "insertDynamicArray",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 15;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 10, 11, 12, 13, 14, 15, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(15);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

dynamicArray2 := StableDynamicArray.initPresized<Nat>(10);

for (i in Nat.range(10, 16)) {
  StableDynamicArray.add(dynamicArray2, i);
};

StableDynamicArray.insertDynamicArray(dynamicArray, 0, dynamicArray2);

suite(
  "insertDynamicArray at start",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 15;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(15);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

dynamicArray2 := StableDynamicArray.initPresized<Nat>(10);

for (i in Nat.range(10, 16)) {
  StableDynamicArray.add(dynamicArray2, i);
};

StableDynamicArray.insertDynamicArray(dynamicArray, 6, dynamicArray2);

suite(
  "insertDynamicArray at end",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 15;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(8);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

dynamicArray2 := StableDynamicArray.initPresized<Nat>(10);

for (i in Nat.range(10, 16)) {
  StableDynamicArray.add(dynamicArray2, i);
};

StableDynamicArray.insertDynamicArray(dynamicArray, 3, dynamicArray2);

suite(
  "insertDynamicArray with capacity change",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 18;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 10, 11, 12, 13, 14, 15, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(0);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

dynamicArray2 := StableDynamicArray.initPresized<Nat>(10);

StableDynamicArray.insertDynamicArray(dynamicArray, 3, dynamicArray2);

suite(
  "insertDynamicArray empty",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(10);

for (i in Nat.range(0, 6)) {
  StableDynamicArray.add(dynamicArray, i);
};

let clonedDynamicArray = StableDynamicArray.clone(dynamicArray);

suite(
  "clone",
  func() {
    test(
      "size",
      func() {
        assert StableDynamicArray.size(clonedDynamicArray) == StableDynamicArray.size(dynamicArray);
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(clonedDynamicArray) == StableDynamicArray.capacity(dynamicArray);
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(clonedDynamicArray), StableDynamicArray.toArray(dynamicArray), Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(3);

for (i in Nat.range(0, 7)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "clear",
  func() {
    StableDynamicArray.clear(dynamicArray);

    test(
      "size",
      func() {
        assert StableDynamicArray.size(dynamicArray) == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert StableDynamicArray.capacity(dynamicArray) == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(StableDynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(5);

for (i in Nat.range(0, 5)) {
  StableDynamicArray.add(dynamicArray, i);
};

dynamicArray2 := StableDynamicArray.initPresized<Nat>(3);

for (i in Nat.range(8, 10)) {
  StableDynamicArray.add(dynamicArray2, i);
};

suite(
  "equal",
  func() {
    test(
      "equal",
      func() {
        assert StableDynamicArray.equal(dynamicArray, dynamicArray, Nat.equal) == true;
      },
    );

    test(
      "not equal due to contents",
      func() {
        assert StableDynamicArray.equal(dynamicArray, dynamicArray2, Nat.equal) == false;
      },
    );

    test(
      "not equal due to size",
      func() {
        assert StableDynamicArray.equal(dynamicArray, StableDynamicArray.initPresized<Nat>(1), Nat.equal) == false;
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(5);

for (i in Nat.range(0, 5)) {
  StableDynamicArray.add(dynamicArray, i);
};

dynamicArray2 := StableDynamicArray.initPresized<Nat>(3);

for (i in Nat.range(8, 10)) {
  StableDynamicArray.add(dynamicArray2, i);
};

suite(
  "compare",
  func() {
    test(
      "equal",
      func() {
        assert StableDynamicArray.compare(dynamicArray, dynamicArray, Nat.compare) == #equal;
      },
    );

    test(
      "less than",
      func() {
        assert StableDynamicArray.compare(dynamicArray2, dynamicArray, Nat.compare) == #greater;
      },
    );

    test(
      "greater than",
      func() {
        assert StableDynamicArray.compare(dynamicArray, dynamicArray2, Nat.compare) == #less;
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(5);

for (i in Nat.range(0, 5)) {
  StableDynamicArray.add(dynamicArray, i);
};

suite(
  "indexOf",
  func() {
    test(
      "find first",
      func() {
        assert StableDynamicArray.indexOf<Nat>(0, dynamicArray, Nat.equal) == ?0;
      },
    );

    test(
      "find middle",
      func() {
        assert StableDynamicArray.indexOf<Nat>(2, dynamicArray, Nat.equal) == ?2;
      },
    );

    test(
      "find last",
      func() {
        assert StableDynamicArray.indexOf<Nat>(4, dynamicArray, Nat.equal) == ?4;
      },
    );

    test(
      "not found",
      func() {
        assert StableDynamicArray.indexOf<Nat>(10, dynamicArray, Nat.equal) == (null : ?Nat);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(5);

StableDynamicArray.add(dynamicArray, 2);
StableDynamicArray.add(dynamicArray, 2);
StableDynamicArray.add(dynamicArray, 1);
StableDynamicArray.add(dynamicArray, 10);
StableDynamicArray.add(dynamicArray, 1);
StableDynamicArray.add(dynamicArray, 0);
StableDynamicArray.add(dynamicArray, 10);
StableDynamicArray.add(dynamicArray, 3);
StableDynamicArray.add(dynamicArray, 0);

suite(
  "lastIndexOf",
  func() {
    test(
      "find in middle",
      func() {
        assert StableDynamicArray.lastIndexOf<Nat>(10, dynamicArray, Nat.equal) == ?6;
      },
    );

    test(
      "find only",
      func() {
        assert StableDynamicArray.lastIndexOf<Nat>(3, dynamicArray, Nat.equal) == ?7;
      },
    );

    test(
      "find last",
      func() {
        assert StableDynamicArray.lastIndexOf<Nat>(0, dynamicArray, Nat.equal) == ?8;
      },
    );

    test(
      "not found",
      func() {
        assert StableDynamicArray.lastIndexOf<Nat>(100, dynamicArray, Nat.equal) == (null : ?Nat);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := StableDynamicArray.initPresized<Nat>(5);

StableDynamicArray.add(dynamicArray, 2);
StableDynamicArray.add(dynamicArray, 2);
StableDynamicArray.add(dynamicArray, 1);
StableDynamicArray.add(dynamicArray, 10);
StableDynamicArray.add(dynamicArray, 1);
StableDynamicArray.add(dynamicArray, 10);
StableDynamicArray.add(dynamicArray, 3);
StableDynamicArray.add(dynamicArray, 0);

suite(
  "indexOfDynamicArray",
  func() {
    test(
      "find in middle",
      func() {
        assert StableDynamicArray.indexOfDynamicArray<Nat>(StableDynamicArray.fromArray<Nat>([1, 10, 1]), dynamicArray, Nat.equal) == ?2;
      },
    );

    test(
      "find first",
      func() {
        assert StableDynamicArray.indexOfDynamicArray<Nat>(StableDynamicArray.fromArray<Nat>([2, 2, 1, 10]), dynamicArray, Nat.equal) == ?0;
      },
    );

    test(
      "find last",
      func() {
        assert StableDynamicArray.indexOfDynamicArray<Nat>(StableDynamicArray.fromArray<Nat>([0]), dynamicArray, Nat.equal) == ?7;
      },
    );

    test(
      "not found",
      func() {
        assert StableDynamicArray.indexOfDynamicArray<Nat>(StableDynamicArray.fromArray<Nat>([99, 100, 1]), dynamicArray, Nat.equal) == (null : ?Nat);
      },
    );

    test(
      "search for empty dynamicArray",
      func() {
        assert StableDynamicArray.indexOfDynamicArray<Nat>(StableDynamicArray.fromArray<Nat>([]), dynamicArray, Nat.equal) == (null : ?Nat);
      },
    );

    test(
      "search through empty dynamicArray",
      func() {
        assert StableDynamicArray.indexOfDynamicArray<Nat>(StableDynamicArray.fromArray<Nat>([1, 2, 3]), StableDynamicArray.initPresized<Nat>(2), Nat.equal) == (null : ?Nat);
      },
    );

    test(
      "search for empty in empty",
      func() {
        assert StableDynamicArray.indexOfDynamicArray<Nat>(StableDynamicArray.initPresized<Nat>(2), StableDynamicArray.initPresized<Nat>(3), Nat.equal) == (null : ?Nat);
      },
    );
  },
);
