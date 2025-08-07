import DynamicArray "../src/DynamicArray";
import Nat "mo:core/Nat";
import Nat32 "mo:core/Nat32";

import { test; suite } "mo:test";

// Helper function to compare arrays
func assertArrayEqual<T>(actual : [T], expected : [T], equal : (T, T) -> Bool) {
  assert actual.size() == expected.size();
  for (i in Nat.range(0, actual.size())) {
    assert equal(actual[i], expected[i]);
  };
};

// Helper function to compare dynamicArrays
func assertBufferEqual<T>(actual : DynamicArray.DynamicArray<T>, expected : DynamicArray.DynamicArray<T>, equal : (T, T) -> Bool) {
  assert actual.size() == expected.size();
  assert actual.capacity() == expected.capacity();
  let actualArray = DynamicArray.toArray(actual);
  let expectedArray = DynamicArray.toArray(expected);
  assertArrayEqual(actualArray, expectedArray, equal);
};

/* --------------------------------------- */
suite(
  "construct",
  func() {
    test(
      "initial size",
      func() {
        assert DynamicArray.DynamicArray<Nat>(10).size() == 0;
      },
    );

    test(
      "initial capacity",
      func() {
        assert DynamicArray.DynamicArray<Nat>(10).capacity() == 10;
      },
    );
  },
);

/* --------------------------------------- */

var dynamicArray = DynamicArray.DynamicArray<Nat>(10);
for (i in Nat.range(0, 4)) {
  dynamicArray.add(i);
};

suite(
  "add",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 4;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 10;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(2);
for (i in Nat.range(0, 4)) {
  dynamicArray.add(i);
};

suite(
  "add with capacity change",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 4;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 5;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(0);
for (i in Nat.range(0, 4)) {
  dynamicArray.add(i);
};

suite(
  "add with capacity change, initial capacity 0",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 4;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 5;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(2);

suite(
  "removeLast on empty dynamicArray",
  func() {
    test(
      "return value",
      func() {
        assert dynamicArray.removeLast() == null;
      },
    );

    test(
      "size",
      func() {
        assert dynamicArray.size() == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 2;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(2);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

suite(
  "removeLast",
  func() {
    test(
      "return value",
      func() {
        assert dynamicArray.removeLast() == ?5;
      },
    );

    test(
      "size",
      func() {
        assert dynamicArray.size() == 5;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

for (i in Nat.range(0, 6)) {
  ignore dynamicArray.removeLast();
};

suite(
  "removeLast until empty",
  func() {
    test(
      "return value",
      func() {
        assert dynamicArray.removeLast() == null;
      },
    );

    test(
      "size",
      func() {
        assert dynamicArray.size() == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 2;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(0);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

suite(
  "remove",
  func() {
    test(
      "return value",
      func() {
        assert dynamicArray.remove(2) == 2;
      },
    );

    test(
      "size",
      func() {
        assert dynamicArray.size() == 5;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 3, 4, 5], Nat.equal);
      },
    );

    test(
      "return value second",
      func() {
        assert dynamicArray.remove(0) == 0;
      },
    );

    test(
      "size second",
      func() {
        assert dynamicArray.size() == 4;
      },
    );

    test(
      "capacity second",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements second",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [1, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);
for (i in Nat.range(0, 3)) {
  dynamicArray.add(i);
};

suite(
  "remove last element at capacity",
  func() {
    test(
      "return value",
      func() {
        assert dynamicArray.remove(2) == 2;
      },
    );

    test(
      "size",
      func() {
        assert dynamicArray.size() == 2;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 3;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(0);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

for (i in Nat.range(0, 6)) {
  ignore dynamicArray.remove(5 - i);
};

suite(
  "remove until empty",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 2;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(1);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray.filterEntries(func(_, x) = x % 2 == 0);

suite(
  "filterEntries",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 3;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 2, 4], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(1);
dynamicArray.filterEntries(func(_, x) = x % 2 == 0);

suite(
  "filterEntries on empty",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 1;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(12);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};
dynamicArray.filterEntries(func(i, x) = i + x == 2);

suite(
  "filterEntries size down",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 1;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 6;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [1], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(5);
for (i in Nat.range(0, 5)) {
  dynamicArray.add(i);
};
dynamicArray.filterEntries(func(_, _) = false);

suite(
  "filterEntries size down to empty",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 2;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(10);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

suite(
  "get and getOpt",
  func() {
    test(
      "get",
      func() {
        assert dynamicArray.get(2) == 2;
      },
    );

    test(
      "getOpt success",
      func() {
        assert dynamicArray.getOpt(0) == ?0;
      },
    );

    test(
      "getOpt out of bounds",
      func() {
        assert dynamicArray.getOpt(10) == null;
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(10);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray.put(2, 20);

suite(
  "put",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 6;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 20, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(10);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray.reserve(6);

suite(
  "decrease capacity",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 6;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(10);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray.reserve(20);

suite(
  "increase capacity",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 20;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(10);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

var dynamicArray2 = DynamicArray.DynamicArray<Nat>(20);

for (i in Nat.range(10, 16)) {
  dynamicArray2.add(i);
};

dynamicArray.append(dynamicArray2);

suite(
  "append",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 18;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(10);
for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.DynamicArray<Nat>(0);

dynamicArray.append(dynamicArray2);

suite(
  "append empty dynamicArray",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 10;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(10);

dynamicArray2 := DynamicArray.DynamicArray<Nat>(10);

for (i in Nat.range(0, 6)) {
  dynamicArray2.add(i);
};

dynamicArray.append(dynamicArray2);

suite(
  "append to empty dynamicArray",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 10;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(8);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray.insert(3, 30);

suite(
  "insert",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 7;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 30, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(8);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray.insert(6, 60);

suite(
  "insert at back",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 7;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5, 60], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(8);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray.insert(0, 10);

suite(
  "insert at front",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 7;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [10, 0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(6);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray.insert(3, 30);

suite(
  "insert with capacity change",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 7;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 9;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 30, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(5);

dynamicArray.insert(0, 0);

suite(
  "insert into empty dynamicArray",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 1;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 5;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(0);

dynamicArray.insert(0, 0);

suite(
  "insert into empty dynamicArray with capacity change",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 1;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 1;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(15);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.DynamicArray<Nat>(10);

for (i in Nat.range(10, 16)) {
  dynamicArray2.add(i);
};

dynamicArray.insertDynamicArray(3, dynamicArray2);

suite(
  "insertDynamicArray",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 15;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 10, 11, 12, 13, 14, 15, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(15);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.DynamicArray<Nat>(10);

for (i in Nat.range(10, 16)) {
  dynamicArray2.add(i);
};

dynamicArray.insertDynamicArray(0, dynamicArray2);

suite(
  "insertDynamicArray at start",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 15;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(15);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.DynamicArray<Nat>(10);

for (i in Nat.range(10, 16)) {
  dynamicArray2.add(i);
};

dynamicArray.insertDynamicArray(6, dynamicArray2);

suite(
  "insertDynamicArray at end",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 15;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(8);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.DynamicArray<Nat>(10);

for (i in Nat.range(10, 16)) {
  dynamicArray2.add(i);
};

dynamicArray.insertDynamicArray(3, dynamicArray2);

suite(
  "insertDynamicArray with capacity change",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 12;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 18;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 10, 11, 12, 13, 14, 15, 3, 4, 5], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(7);

dynamicArray2 := DynamicArray.DynamicArray<Nat>(10);

for (i in Nat.range(10, 16)) {
  dynamicArray2.add(i);
};

dynamicArray.insertDynamicArray(0, dynamicArray2);

suite(
  "insertDynamicArray to empty dynamicArray",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 6;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 7;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [10, 11, 12, 13, 14, 15], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);
for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

dynamicArray.clear();

suite(
  "clear",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray.size() == 0;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.clone(dynamicArray);

suite(
  "clone",
  func() {
    test(
      "size",
      func() {
        assert dynamicArray2.size() == dynamicArray.size();
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == dynamicArray2.capacity();
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), DynamicArray.toArray(dynamicArray2), Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

var size = 0;

for (element in dynamicArray.vals()) {
  assert element == size;
  size += 1;
};

suite(
  "vals",
  func() {
    test(
      "size",
      func() {
        assert size == 7;
      },
    );
  },
);

/* --------------------------------------- */
suite(
  "array round trips",
  func() {
    test(
      "fromArray and toArray",
      func() {
        assertArrayEqual(DynamicArray.toArray<Nat>(DynamicArray.fromArray<Nat>([0, 1, 2, 3])), [0, 1, 2, 3], Nat.equal);
      },
    );

    test(
      "fromVarArray",
      func() {
        assertArrayEqual(DynamicArray.toArray<Nat>(DynamicArray.fromVarArray<Nat>([var 0, 1, 2, 3])), [0, 1, 2, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
suite(
  "empty array round trips",
  func() {
    test(
      "fromArray and toArray",
      func() {
        assertArrayEqual(DynamicArray.toArray<Nat>(DynamicArray.fromArray<Nat>([])), [], Nat.equal);
      },
    );

    test(
      "fromVarArray",
      func() {
        assertArrayEqual(DynamicArray.toArray<Nat>(DynamicArray.fromVarArray<Nat>([var])), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray.clear();

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

suite(
  "iter round trips",
  func() {
    test(
      "fromIter and vals",
      func() {
        assertArrayEqual(DynamicArray.toArray(DynamicArray.fromIter<Nat>(dynamicArray.vals())), [0, 1, 2, 3, 4, 5, 6], Nat.equal);
      },
    );

    test(
      "empty",
      func() {
        assertArrayEqual(DynamicArray.toArray(DynamicArray.fromIter<Nat>(DynamicArray.DynamicArray<Nat>(2).vals())), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
suite(
  "buffer",
  func() {
    test(
      "write to buffer interface",
      func() {
        let testArray = DynamicArray.DynamicArray<Nat>(2);
        let buffer = testArray.buffer();
        
        buffer.write(10);
        buffer.write(20);
        buffer.write(30);
        
        assertArrayEqual(DynamicArray.toArray(testArray), [10, 20, 30], Nat.equal);
        assert testArray.size() == 3;
      },
    );

    test(
      "empty buffer write",
      func() {
        let testArray = DynamicArray.DynamicArray<Nat>(1);
        let _buffer = testArray.buffer();
        
        assert testArray.size() == 0;
        assert DynamicArray.toArray(testArray).size() == 0;
      },
    );

    test(
      "buffer interface compatibility",
      func() {
        let testArray = DynamicArray.DynamicArray<Nat>(2);
        let buffer = testArray.buffer();
        
        // Simulate usage by a function that accepts Buffer.Buffer<X>
        func writeNumbers(buf : { write : Nat -> () }) {
          buf.write(1);
          buf.write(2);
          buf.write(3);
        };
        
        writeNumbers(buffer);
        assertArrayEqual(DynamicArray.toArray(testArray), [1, 2, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

DynamicArray.trimToSize(dynamicArray);

suite(
  "trimToSize",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 7;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5, 6], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

DynamicArray.trimToSize(dynamicArray);

suite(
  "trimToSize on empty",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 0;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.map<Nat, Nat>(dynamicArray, func x = x * 2);

suite(
  "map",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray2.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray2), [0, 2, 4, 6, 8, 10, 12], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(0);

dynamicArray2 := DynamicArray.map<Nat, Nat>(dynamicArray, func x = x * 2);

suite(
  "map empty",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray2.capacity() == 0;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray2), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

var sum = 0;

DynamicArray.iterate<Nat>(dynamicArray, func x = sum += x);

suite(
  "iterate",
  func() {
    test(
      "sum",
      func() {
        assert sum == 21;
      },
    );

    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 5, 6], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.chain<Nat, Nat>(dynamicArray, func x = DynamicArray.make<Nat> x);

suite(
  "chain",
  func() {
    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray2), DynamicArray.toArray(dynamicArray), Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.mapFilter<Nat, Nat>(dynamicArray, func x = if (x % 2 == 0) { ?x } else { null });

suite(
  "mapFilter",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray2.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray2), [0, 2, 4, 6], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.mapEntries<Nat, Nat>(dynamicArray, func(i, x) = i * x);

suite(
  "mapEntries",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray2.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray2), [0, 1, 4, 9, 16, 25, 36], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

var dynamicArrayResult = DynamicArray.mapResult<Nat, Nat, Text>(dynamicArray, func x = #ok x);

suite(
  "mapResult success",
  func() {
    test(
      "return value",
      func() {
        switch (dynamicArrayResult) {
          case (#ok(result)) {
            assertBufferEqual(result, dynamicArray, Nat.equal);
          };
          case (#err(_)) {
            assert false;
          };
        };
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

dynamicArrayResult := DynamicArray.mapResult<Nat, Nat, Text>(
  dynamicArray,
  func x = if (x == 4) { #err "error" } else { #ok x },
);

suite(
  "mapResult failure",
  func() {
    test(
      "return value",
      func() {
        switch (dynamicArrayResult) {
          case (#ok(_)) {
            assert false;
          };
          case (#err(msg)) {
            assert msg == "error";
          };
        };
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

suite(
  "foldLeft",
  func() {
    test(
      "return value",
      func() {
        assert DynamicArray.foldLeft<Text, Nat>(dynamicArray, "", func(acc, x) = acc # Nat.toText(x)) == "0123456";
      },
    );

    test(
      "return value empty",
      func() {
        assert DynamicArray.foldLeft<Text, Nat>(DynamicArray.DynamicArray<Nat>(4), "", func(acc, x) = acc # Nat.toText(x)) == "";
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

suite(
  "foldRight",
  func() {
    test(
      "return value",
      func() {
        assert DynamicArray.foldRight<Nat, Text>(dynamicArray, "", func(x, acc) = acc # Nat.toText(x)) == "6543210";
      },
    );

    test(
      "return value empty",
      func() {
        assert DynamicArray.foldRight<Nat, Text>(DynamicArray.DynamicArray<Nat>(4), "", func(x, acc) = acc # Nat.toText(x)) == "";
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 7)) {
  dynamicArray.add(i);
};

suite(
  "forAll",
  func() {
    test(
      "true",
      func() {
        assert DynamicArray.forAll<Nat>(dynamicArray, func x = x >= 0) == true;
      },
    );

    test(
      "false",
      func() {
        assert DynamicArray.forAll<Nat>(dynamicArray, func x = x % 2 == 0) == false;
      },
    );

    test(
      "default",
      func() {
        assert DynamicArray.forAll<Nat>(DynamicArray.DynamicArray<Nat>(2), func _ = false) == true;
      },
    );
  },
);

/* --------------------------------------- */
suite(
  "forSome",
  func() {
    test(
      "true",
      func() {
        assert DynamicArray.forSome<Nat>(dynamicArray, func x = x % 2 == 0) == true;
      },
    );

    test(
      "false",
      func() {
        assert DynamicArray.forSome<Nat>(dynamicArray, func x = x < 0) == false;
      },
    );

    test(
      "default",
      func() {
        assert DynamicArray.forSome<Nat>(DynamicArray.DynamicArray<Nat>(2), func _ = false) == false;
      },
    );
  },
);

/* --------------------------------------- */
suite(
  "forNone",
  func() {
    test(
      "true",
      func() {
        assert DynamicArray.forNone<Nat>(dynamicArray, func x = x < 0) == true;
      },
    );

    test(
      "false",
      func() {
        assert DynamicArray.forNone<Nat>(dynamicArray, func x = x % 2 != 0) == false;
      },
    );

    test(
      "default",
      func() {
        assert DynamicArray.forNone<Nat>(DynamicArray.DynamicArray<Nat>(2), func _ = true) == true;
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.make<Nat>(1);

suite(
  "make",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 1;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [1], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

suite(
  "contains",
  func() {
    test(
      "true",
      func() {
        assert DynamicArray.contains<Nat>(dynamicArray, 2, Nat.equal) == true;
      },
    );

    test(
      "false",
      func() {
        assert DynamicArray.contains<Nat>(dynamicArray, 9, Nat.equal) == false;
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.DynamicArray<Nat>(3);

suite(
  "contains empty",
  func() {
    test(
      "false 1",
      func() {
        assert DynamicArray.contains<Nat>(dynamicArray, 2, Nat.equal) == false;
      },
    );

    test(
      "false 2",
      func() {
        assert DynamicArray.contains<Nat>(dynamicArray, 9, Nat.equal) == false;
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.DynamicArray<Nat>(3);

dynamicArray.add(2);
dynamicArray.add(1);
dynamicArray.add(10);
dynamicArray.add(1);
dynamicArray.add(0);
dynamicArray.add(3);

suite(
  "max",
  func() {
    test(
      "return value",
      func() {
        assert DynamicArray.max<Nat>(dynamicArray, Nat.compare) == ?10;
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.DynamicArray<Nat>(3);

dynamicArray.add(2);
dynamicArray.add(1);
dynamicArray.add(10);
dynamicArray.add(1);
dynamicArray.add(0);
dynamicArray.add(3);
dynamicArray.add(0);

suite(
  "min",
  func() {
    test(
      "return value",
      func() {
        assert DynamicArray.min<Nat>(dynamicArray, Nat.compare) == ?0;
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.DynamicArray<Nat>(3);
dynamicArray.add(2);

suite(
  "isEmpty",
  func() {
    test(
      "true",
      func() {
        assert DynamicArray.isEmpty(DynamicArray.DynamicArray<Nat>(2)) == true;
      },
    );

    test(
      "false",
      func() {
        assert DynamicArray.isEmpty(dynamicArray) == false;
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.DynamicArray<Nat>(3);

dynamicArray.add(2);
dynamicArray.add(1);
dynamicArray.add(10);
dynamicArray.add(1);
dynamicArray.add(0);
dynamicArray.add(3);
dynamicArray.add(0);

DynamicArray.removeDuplicates<Nat>(dynamicArray, Nat.compare);

suite(
  "removeDuplicates",
  func() {
    test(
      "elements (stable ordering)",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [2, 1, 10, 0, 3], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.DynamicArray<Nat>(3);

DynamicArray.removeDuplicates<Nat>(dynamicArray, Nat.compare);

suite(
  "removeDuplicates empty",
  func() {
    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */

dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 5)) {
  dynamicArray.add(2);
};

DynamicArray.removeDuplicates<Nat>(dynamicArray, Nat.compare);

suite(
  "removeDuplicates repeat singleton",
  func() {
    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [2], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

func hashNat(n : Nat) : Nat32 {
  let j = Nat32.fromNat(n);
  hashNat8([
    j & (255 << 0),
    j & (255 << 8),
    j & (255 << 16),
    j & (255 << 24),
  ]);
};
func hashNat8(key : [Nat32]) : Nat32 {
  var hash : Nat32 = 0;
  for (natOfKey in key.vals()) {
    hash := hash +% natOfKey;
    hash := hash +% hash << 10;
    hash := hash ^ (hash >> 6);
  };
  hash := hash +% hash << 3;
  hash := hash ^ (hash >> 11);
  hash := hash +% hash << 15;
  return hash;
};

suite(
  "hash",
  func() {
    test(
      "empty dynamicArray",
      func() {
        assert Nat32.toNat(DynamicArray.hash<Nat>(DynamicArray.DynamicArray<Nat>(8), hashNat)) == 0;
      },
    );

    test(
      "non-empty dynamicArray",
      func() {
        let hashValue = DynamicArray.hash<Nat>(dynamicArray, hashNat);
        assert Nat32.toNat(hashValue) == 3365238326;
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

suite(
  "toText",
  func() {
    test(
      "empty dynamicArray",
      func() {
        assert DynamicArray.toText<Nat>(DynamicArray.DynamicArray<Nat>(3), Nat.toText) == "[]";
      },
    );

    test(
      "singleton dynamicArray",
      func() {
        assert DynamicArray.toText<Nat>(DynamicArray.make<Nat>(3), Nat.toText) == "[3]";
      },
    );

    test(
      "non-empty dynamicArray",
      func() {
        assert DynamicArray.toText<Nat>(dynamicArray, Nat.toText) == "[0, 1, 2, 3, 4, 5]";
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 3)) {
  dynamicArray.add(i);
};

suite(
  "equal",
  func() {
    test(
      "empty dynamicArrays",
      func() {
        assert DynamicArray.equal<Nat>(DynamicArray.DynamicArray<Nat>(3), DynamicArray.DynamicArray<Nat>(2), Nat.equal) == true;
      },
    );

    test(
      "non-empty dynamicArrays",
      func() {
        assert DynamicArray.equal<Nat>(dynamicArray, DynamicArray.clone(dynamicArray), Nat.equal) == true;
      },
    );

    test(
      "non-empty and empty dynamicArrays",
      func() {
        assert DynamicArray.equal<Nat>(dynamicArray, DynamicArray.DynamicArray<Nat>(3), Nat.equal) == false;
      },
    );

    test(
      "non-empty dynamicArrays mismatching lengths",
      func() {
        assert DynamicArray.equal<Nat>(dynamicArray, dynamicArray2, Nat.equal) == false;
      },
    );
  },
);

/* --------------------------------------- */
dynamicArray := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 6)) {
  dynamicArray.add(i);
};

dynamicArray2 := DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(0, 3)) {
  dynamicArray.add(i);
};

var dynamicArray3 = DynamicArray.DynamicArray<Nat>(3);

for (i in Nat.range(2, 6)) {
  dynamicArray3.add(i);
};

suite(
  "compare",
  func() {
    test(
      "empty dynamicArrays",
      func() {
        assert DynamicArray.compare<Nat>(DynamicArray.DynamicArray<Nat>(3), DynamicArray.DynamicArray<Nat>(2), Nat.compare) == #equal;
      },
    );

    test(
      "non-empty dynamicArrays equal",
      func() {
        assert DynamicArray.compare<Nat>(dynamicArray, DynamicArray.clone(dynamicArray), Nat.compare) == #equal;
      },
    );

    test(
      "non-empty and empty dynamicArrays",
      func() {
        assert DynamicArray.compare<Nat>(dynamicArray, DynamicArray.DynamicArray<Nat>(3), Nat.compare) == #greater;
      },
    );

    test(
      "non-empty dynamicArrays mismatching lengths",
      func() {
        assert DynamicArray.compare<Nat>(dynamicArray, dynamicArray2, Nat.compare) == #greater;
      },
    );

    test(
      "non-empty dynamicArrays lexicographic difference",
      func() {
        assert DynamicArray.compare<Nat>(dynamicArray, dynamicArray3, Nat.compare) == #less;
      },
    );
  },
);

/* --------------------------------------- */

var nestedBuffer = DynamicArray.DynamicArray<DynamicArray.DynamicArray<Nat>>(3);
for (i in Nat.range(0, 5)) {
  let innerBuffer = DynamicArray.DynamicArray<Nat>(2);
  for (j in if (i % 2 == 0) { Nat.range(0, 5) } else { Nat.range(0, 4) }) {
    innerBuffer.add(j);
  };
  nestedBuffer.add(innerBuffer);
};
nestedBuffer.add(DynamicArray.DynamicArray<Nat>(2));

dynamicArray := DynamicArray.flatten<Nat>(nestedBuffer);

suite(
  "flatten",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 45;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 3, 4], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */

nestedBuffer := DynamicArray.DynamicArray<DynamicArray.DynamicArray<Nat>>(3);
for (i in Nat.range(0, 5)) {
  nestedBuffer.add(DynamicArray.DynamicArray<Nat>(2));
};

dynamicArray := DynamicArray.flatten<Nat>(nestedBuffer);

suite(
  "flatten all empty inner dynamicArrays",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 8;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);

/* --------------------------------------- */

nestedBuffer := DynamicArray.DynamicArray<DynamicArray.DynamicArray<Nat>>(3);
dynamicArray := DynamicArray.flatten<Nat>(nestedBuffer);

suite(
  "flatten empty outer dynamicArray",
  func() {
    test(
      "capacity",
      func() {
        assert dynamicArray.capacity() == 0;
      },
    );

    test(
      "elements",
      func() {
        assertArrayEqual(DynamicArray.toArray(dynamicArray), [], Nat.equal);
      },
    );
  },
);
