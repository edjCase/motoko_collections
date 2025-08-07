import Prim "mo:⛔";
import B "../src/StableDynamicArray";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Order "mo:base/Order";

import Suite "mo:matchers/Suite";
import T "mo:matchers/Testable";
import M "mo:matchers/Matchers";

let { run; test; suite } = Suite;

let NatDynamicArrayTestable : T.Testable<B.StableDynamicArray<Nat>> = object {
  public func display(dynamicArray : B.StableDynamicArray<Nat>) : Text {
    B.toText(dynamicArray, Nat.toText);
  };
  public func equals(dynamicArray1 : B.StableDynamicArray<Nat>, dynamicArray2 : B.StableDynamicArray<Nat>) : Bool {
    B.equal(dynamicArray1, dynamicArray2, Nat.equal);
  };
};

class OrderTestable(initItem : Order.Order) : T.TestableItem<Order.Order> {
  public let item = initItem;
  public func display(order : Order.Order) : Text {
    switch (order) {
      case (#less) {
        "#less";
      };
      case (#greater) {
        "#greater";
      };
      case (#equal) {
        "#equal";
      };
    };
  };
  public let equals = Order.equal;
};

/* --------------------------------------- */
run(
  suite(
    "construct",
    [
      test(
        "initial size",
        B.size(B.initPresized<Nat>(10)),
        M.equals(T.nat(0)),
      ),
      test(
        "initial capacity",
        B.capacity(B.initPresized<Nat>(10)),
        M.equals(T.nat(10)),
      ),
    ],
  )
);

/* --------------------------------------- */

var dynamicArray = B.initPresized<Nat>(10);
for (i in Iter.range(0, 3)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "add",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(4)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(10)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(2);
for (i in Iter.range(0, 3)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "add with capacity change",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(4)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(5)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(0);
for (i in Iter.range(0, 3)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "add with capacity change, initial capacity 0",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(4)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(5)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(2);

run(
  suite(
    "removeLast on empty dynamicArray",
    [
      test(
        "return value",
        B.removeLast(dynamicArray),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(0)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(2)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(2);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "removeLast",
    [
      test(
        "return value",
        B.removeLast(dynamicArray),
        M.equals(T.optional<Nat>(T.natTestable, ?5)),
      ),
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(5)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

for (i in Iter.range(0, 5)) {
  ignore B.removeLast(dynamicArray);
};

run(
  suite(
    "removeLast until empty",
    [
      test(
        "return value",
        B.removeLast(dynamicArray),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(0)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(2)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(0);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "remove",
    [
      test(
        "return value",
        B.remove(dynamicArray, 2),
        M.equals(T.nat(2)),
      ),
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(5)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 3, 4, 5])),
      ),
      test(
        "return value",
        B.remove(dynamicArray, 0),
        M.equals(T.nat(0)),
      ),
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(4)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [1, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);
for (i in Iter.range(0, 2)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "remove last element at capacity",
    [
      test(
        "return value",
        B.remove(dynamicArray, 2),
        M.equals(T.nat(2)),
      ),
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(2)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(3)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(0);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

for (i in Iter.range(0, 5)) {
  ignore B.remove(dynamicArray, 5 - i : Nat);
};

run(
  suite(
    "remove until empty",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(0)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(2)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(1);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

B.filterEntries<Nat>(dynamicArray, func(_, x) = x % 2 == 0);

run(
  suite(
    "filterEntries",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(3)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 2, 4])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(1);
B.filterEntries<Nat>(dynamicArray, func(_, x) = x % 2 == 0);

run(
  suite(
    "filterEntries on empty",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(0)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(1)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(12);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};
B.filterEntries<Nat>(dynamicArray, func(i, x) = i + x == 2);

run(
  suite(
    "filterEntries size down",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(1)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [1])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(5);
for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};
B.filterEntries<Nat>(dynamicArray, func(_, _) = false);

run(
  suite(
    "filterEntries size down to empty",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(0)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(2)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(10);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "get and getOpt",
    [
      test(
        "get",
        B.get(dynamicArray, 2),
        M.equals(T.nat(2)),
      ),
      test(
        "getOpt success",
        B.getOpt(dynamicArray, 0),
        M.equals(T.optional(T.natTestable, ?0)),
      ),
      test(
        "getOpt out of bounds",
        B.getOpt(dynamicArray, 10),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(10);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

B.put(dynamicArray, 2, 20);

run(
  suite(
    "put",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 20, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(10);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

B.reserve(dynamicArray, 6);

run(
  suite(
    "decrease capacity",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(10);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

B.reserve(dynamicArray, 20);

run(
  suite(
    "increase capacity",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(20)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(10);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

var dynamicArray2 = B.initPresized<Nat>(20);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.append(dynamicArray, dynamicArray2);

run(
  suite(
    "append",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(12)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(18)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(10);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(0);

B.append(dynamicArray, dynamicArray2);

run(
  suite(
    "append empty dynamicArray",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(10)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(10);

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray2, i);
};

B.append(dynamicArray, dynamicArray2);

run(
  suite(
    "append to empty dynamicArray",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(10)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(8);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

B.insert(dynamicArray, 3, 30);

run(
  suite(
    "insert",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(7)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 30, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(8);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

B.insert(dynamicArray, 6, 60);

run(
  suite(
    "insert at back",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(7)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5, 60])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(8);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

B.insert(dynamicArray, 0, 10);

run(
  suite(
    "insert at front",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(7)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [10, 0, 1, 2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(6);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

B.insert(dynamicArray, 3, 30);

run(
  suite(
    "insert with capacity change",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(7)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(9)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 30, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(5);

B.insert(dynamicArray, 0, 0);

run(
  suite(
    "insert into empty dynamicArray",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(1)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(5)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(0);

B.insert(dynamicArray, 0, 0);

run(
  suite(
    "insert into empty dynamicArray with capacity change",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(1)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(1)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(15);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.insertDynamicArray(dynamicArray, 3, dynamicArray2);

run(
  suite(
    "insertDynamicArray",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(12)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(15)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 10, 11, 12, 13, 14, 15, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(15);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.insertDynamicArray(dynamicArray, 0, dynamicArray2);

run(
  suite(
    "insertDynamicArray at start",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(12)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(15)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(15);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.insertDynamicArray(dynamicArray, 6, dynamicArray2);

run(
  suite(
    "insertDynamicArray at end",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(12)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(15)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(8);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.insertDynamicArray(dynamicArray, 3, dynamicArray2);

run(
  suite(
    "insertDynamicArray with capacity change",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(12)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(18)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 10, 11, 12, 13, 14, 15, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(8);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.insertDynamicArray(dynamicArray, 0, dynamicArray2);

run(
  suite(
    "insertDynamicArray at start with capacity change",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(12)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(18)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(8);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.insertDynamicArray(dynamicArray, 6, dynamicArray2);

run(
  suite(
    "insertDynamicArray at end with capacity change",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(12)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(18)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(7);

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.insertDynamicArray(dynamicArray, 0, dynamicArray2);

run(
  suite(
    "insertDynamicArray to empty dynamicArray",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(7)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [10, 11, 12, 13, 14, 15])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

dynamicArray2 := B.initPresized<Nat>(10);

for (i in Iter.range(10, 15)) {
  B.add(dynamicArray2, i);
};

B.insertDynamicArray(dynamicArray, 0, dynamicArray2);

run(
  suite(
    "insertDynamicArray to empty dynamicArray with capacity change",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(9)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [10, 11, 12, 13, 14, 15])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray);

run(
  suite(
    "clear",
    [
      test(
        "size",
        B.size(dynamicArray),
        M.equals(T.nat(0)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.clone(dynamicArray);

run(
  suite(
    "clone",
    [
      test(
        "size",
        B.size(dynamicArray2),
        M.equals(T.nat(B.size(dynamicArray))),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(B.capacity(dynamicArray2))),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, B.toArray(dynamicArray2))),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

var size = 0;

for (element in B.vals(dynamicArray)) {
  M.assertThat(element, M.equals(T.nat(size)));
  size += 1;
};

run(
  suite(
    "vals",
    [
      test(
        "size",
        size,
        M.equals(T.nat(7)),
      )
    ],
  )
);

/* --------------------------------------- */
run(
  suite(
    "array round trips",
    [
      test(
        "fromArray and toArray",
        B.toArray<Nat>(B.fromArray<Nat>([0, 1, 2, 3])),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3])),
      ),
      test(
        "fromVarArray",
        B.toArray<Nat>(B.fromVarArray<Nat>([var 0, 1, 2, 3])),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3])),
      ),
    ],
  )
);

/* --------------------------------------- */
run(
  suite(
    "empty array round trips",
    [
      test(
        "fromArray and toArray",
        B.toArray<Nat>(B.fromArray<Nat>([])),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
      test(
        "fromVarArray",
        B.toArray<Nat>(B.fromVarArray<Nat>([var])),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "iter round trips",
    [
      test(
        "fromIter and vals",
        B.toArray(B.fromIter<Nat>(B.vals(dynamicArray))),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5, 6])),
      ),
      test(
        "empty",
        B.toArray(B.fromIter<Nat>(B.vals(B.initPresized<Nat>(2)))),
        M.equals(T.array<Nat>(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

B.trimToSize(dynamicArray);

run(
  suite(
    "trimToSize",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(7)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5, 6])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

B.trimToSize(dynamicArray);

run(
  suite(
    "trimToSize on empty",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(0)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.map<Nat, Nat>(dynamicArray, func x = x * 2);

run(
  suite(
    "map",
    [
      test(
        "capacity",
        B.capacity(dynamicArray2),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray2),
        M.equals(T.array<Nat>(T.natTestable, [0, 2, 4, 6, 8, 10, 12])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(0);

dynamicArray2 := B.map<Nat, Nat>(dynamicArray, func x = x * 2);

run(
  suite(
    "map empty",
    [
      test(
        "capacity",
        B.capacity(dynamicArray2),
        M.equals(T.nat(0)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray2),
        M.equals(T.array<Nat>(T.natTestable, [])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

var sum = 0;

B.iterate<Nat>(dynamicArray, func x = sum += x);

run(
  suite(
    "iterate",
    [
      test(
        "sum",
        sum,
        M.equals(T.nat(21)),
      ),
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 2, 3, 4, 5, 6])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.chain<Nat, Nat>(dynamicArray, func x = B.make<Nat> x);

run(
  suite(
    "chain",
    [
      test(
        "elements",
        B.toArray(dynamicArray2),
        M.equals(T.array<Nat>(T.natTestable, B.toArray(dynamicArray))),
      )
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.mapFilter<Nat, Nat>(dynamicArray, func x = if (x % 2 == 0) { ?x } else { null });

run(
  suite(
    "mapFilter",
    [
      test(
        "capacity",
        B.capacity(dynamicArray2),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray2),
        M.equals(T.array<Nat>(T.natTestable, [0, 2, 4, 6])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.mapEntries<Nat, Nat>(dynamicArray, func(i, x) = i * x);

run(
  suite(
    "mapEntries",
    [
      test(
        "capacity",
        B.capacity(dynamicArray2),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray2),
        M.equals(T.array<Nat>(T.natTestable, [0, 1, 4, 9, 16, 25, 36])),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

var dynamicArrayResult = B.mapResult<Nat, Nat, Text>(dynamicArray, func x = #ok x);

run(
  suite(
    "mapResult success",
    [
      test(
        "return value",
        #ok dynamicArray,
        M.equals(T.result<B.StableDynamicArray<Nat>, Text>(NatDynamicArrayTestable, T.textTestable, dynamicArrayResult)),
      )
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

dynamicArrayResult := B.mapResult<Nat, Nat, Text>(
  dynamicArray,
  func x = if (x == 4) { #err "error" } else { #ok x },
);

run(
  suite(
    "mapResult failure",
    [
      test(
        "return value",
        #err "error",
        M.equals(T.result<B.StableDynamicArray<Nat>, Text>(NatDynamicArrayTestable, T.textTestable, dynamicArrayResult)),
      )
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "foldLeft",
    [
      test(
        "return value",
        B.foldLeft<Text, Nat>(dynamicArray, "", func(acc, x) = acc # Nat.toText(x)),
        M.equals(T.text("0123456")),
      ),
      test(
        "return value empty",
        B.foldLeft<Text, Nat>(B.initPresized<Nat>(4), "", func(acc, x) = acc # Nat.toText(x)),
        M.equals(T.text("")),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "foldRight",
    [
      test(
        "return value",
        B.foldRight<Nat, Text>(dynamicArray, "", func(x, acc) = acc # Nat.toText(x)),
        M.equals(T.text("6543210")),
      ),
      test(
        "return value empty",
        B.foldRight<Nat, Text>(B.initPresized<Nat>(4), "", func(x, acc) = acc # Nat.toText(x)),
        M.equals(T.text("")),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "forAll",
    [
      test(
        "true",
        B.forAll<Nat>(dynamicArray, func x = x >= 0),
        M.equals(T.bool(true)),
      ),
      test(
        "false",
        B.forAll<Nat>(dynamicArray, func x = x % 2 == 0),
        M.equals(T.bool(false)),
      ),
      test(
        "default",
        B.forAll<Nat>(B.initPresized<Nat>(2), func _ = false),
        M.equals(T.bool(true)),
      ),
    ],
  )
);

/* --------------------------------------- */
run(
  suite(
    "forSome",
    [
      test(
        "true",
        B.forSome<Nat>(dynamicArray, func x = x % 2 == 0),
        M.equals(T.bool(true)),
      ),
      test(
        "false",
        B.forSome<Nat>(dynamicArray, func x = x < 0),
        M.equals(T.bool(false)),
      ),
      test(
        "default",
        B.forSome<Nat>(B.initPresized<Nat>(2), func _ = false),
        M.equals(T.bool(false)),
      ),
    ],
  )
);

/* --------------------------------------- */
run(
  suite(
    "forNone",
    [
      test(
        "true",
        B.forNone<Nat>(dynamicArray, func x = x < 0),
        M.equals(T.bool(true)),
      ),
      test(
        "false",
        B.forNone<Nat>(dynamicArray, func x = x % 2 != 0),
        M.equals(T.bool(false)),
      ),
      test(
        "default",
        B.forNone<Nat>(B.initPresized<Nat>(2), func _ = true),
        M.equals(T.bool(true)),
      ),
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.make<Nat>(1);

run(
  suite(
    "make",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(1)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [1])),
      ),
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "contains",
    [
      test(
        "true",
        B.contains<Nat>(dynamicArray, 2, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "true",
        B.contains<Nat>(dynamicArray, 9, Nat.equal),
        M.equals(T.bool(false)),
      ),
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.initPresized<Nat>(3);

run(
  suite(
    "contains empty",
    [
      test(
        "true",
        B.contains<Nat>(dynamicArray, 2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "true",
        B.contains<Nat>(dynamicArray, 9, Nat.equal),
        M.equals(T.bool(false)),
      ),
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.initPresized<Nat>(3);

B.add(dynamicArray, 2);
B.add(dynamicArray, 1);
B.add(dynamicArray, 10);
B.add(dynamicArray, 1);
B.add(dynamicArray, 0);
B.add(dynamicArray, 3);

run(
  suite(
    "max",
    [
      test(
        "return value",
        B.max<Nat>(dynamicArray, Nat.compare),
        M.equals(T.optional(T.natTestable, ?10)),
      )
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.initPresized<Nat>(3);

B.add(dynamicArray, 2);
B.add(dynamicArray, 1);
B.add(dynamicArray, 10);
B.add(dynamicArray, 1);
B.add(dynamicArray, 0);
B.add(dynamicArray, 3);
B.add(dynamicArray, 0);

run(
  suite(
    "min",
    [
      test(
        "return value",
        B.min<Nat>(dynamicArray, Nat.compare),
        M.equals(T.optional(T.natTestable, ?0)),
      )
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.initPresized<Nat>(3);
B.add(dynamicArray, 2);

run(
  suite(
    "isEmpty",
    [
      test(
        "true",
        B.isEmpty(B.initPresized<Nat>(2)),
        M.equals(T.bool(true)),
      ),
      test(
        "false",
        B.isEmpty(dynamicArray),
        M.equals(T.bool(false)),
      ),
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.initPresized<Nat>(3);

B.add(dynamicArray, 2);
B.add(dynamicArray, 1);
B.add(dynamicArray, 10);
B.add(dynamicArray, 1);
B.add(dynamicArray, 0);
B.add(dynamicArray, 3);
B.add(dynamicArray, 0);

B.removeDuplicates<Nat>(dynamicArray, Nat.compare);

run(
  suite(
    "removeDuplicates",
    [
      test(
        "elements (stable ordering)",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [2, 1, 10, 0, 3])),
      )
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.initPresized<Nat>(3);

B.removeDuplicates<Nat>(dynamicArray, Nat.compare);

run(
  suite(
    "removeDuplicates empty",
    [
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      )
    ],
  )
);

/* --------------------------------------- */

dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, 2);
};

B.removeDuplicates<Nat>(dynamicArray, Nat.compare);

run(
  suite(
    "removeDuplicates repeat singleton",
    [
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [2])),
      )
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "hash",
    [
      test(
        "empty dynamicArray",
        Nat32.toNat(B.hash<Nat>(B.initPresized<Nat>(8), Hash.hash)),
        M.equals(T.nat(0)),
      ),
      test(
        "non-empty dynamicArray",
        Nat32.toNat(B.hash<Nat>(dynamicArray, Hash.hash)),
        M.equals(T.nat(3365238326)),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "toText",
    [
      test(
        "empty dynamicArray",
        B.toText<Nat>(B.initPresized<Nat>(3), Nat.toText),
        M.equals(T.text("[]")),
      ),
      test(
        "singleton dynamicArray",
        B.toText<Nat>(B.make<Nat>(3), Nat.toText),
        M.equals(T.text("[3]")),
      ),
      test(
        "non-empty dynamicArray",
        B.toText<Nat>(dynamicArray, Nat.toText),
        M.equals(T.text("[0, 1, 2, 3, 4, 5]")),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(3);

for (i in Iter.range(0, 2)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "equal",
    [
      test(
        "empty dynamicArrays",
        B.equal<Nat>(B.initPresized<Nat>(3), B.initPresized<Nat>(2), Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "non-empty dynamicArrays",
        B.equal<Nat>(dynamicArray, B.clone(dynamicArray), Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "non-empty and empty dynamicArrays",
        B.equal<Nat>(dynamicArray, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "non-empty dynamicArrays mismatching lengths",
        B.equal<Nat>(dynamicArray, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
    ],
  )
);

/* --------------------------------------- */
dynamicArray := B.initPresized<Nat>(3);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray2 := B.initPresized<Nat>(3);

for (i in Iter.range(0, 2)) {
  B.add(dynamicArray, i);
};

var dynamicArray3 = B.initPresized<Nat>(3);

for (i in Iter.range(2, 5)) {
  B.add(dynamicArray3, i);
};

run(
  suite(
    "compare",
    [
      test(
        "empty dynamicArrays",
        B.compare<Nat>(B.initPresized<Nat>(3), B.initPresized<Nat>(2), Nat.compare),
        M.equals(OrderTestable(#equal)),
      ),
      test(
        "non-empty dynamicArrays equal",
        B.compare<Nat>(dynamicArray, B.clone(dynamicArray), Nat.compare),
        M.equals(OrderTestable(#equal)),
      ),
      test(
        "non-empty and empty dynamicArrays",
        B.compare<Nat>(dynamicArray, B.initPresized<Nat>(3), Nat.compare),
        M.equals(OrderTestable(#greater)),
      ),
      test(
        "non-empty dynamicArrays mismatching lengths",
        B.compare<Nat>(dynamicArray, dynamicArray2, Nat.compare),
        M.equals(OrderTestable(#greater)),
      ),
      test(
        "non-empty dynamicArrays lexicographic difference",
        B.compare<Nat>(dynamicArray, dynamicArray3, Nat.compare),
        M.equals(OrderTestable(#less)),
      ),
    ],
  )
);

/* --------------------------------------- */

var nestedDynamicArray = B.initPresized<B.StableDynamicArray<Nat>>(3);
for (i in Iter.range(0, 4)) {
  let innerDynamicArray = B.initPresized<Nat>(2);
  for (j in if (i % 2 == 0) { Iter.range(0, 4) } else { Iter.range(0, 3) }) {
    B.add(innerDynamicArray, j);
  };
  B.add(nestedDynamicArray, innerDynamicArray);
};
B.add(nestedDynamicArray, B.initPresized<Nat>(2));

dynamicArray := B.flatten<Nat>(nestedDynamicArray);

run(
  suite(
    "flatten",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(45)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 3, 4])),
      ),
    ],
  )
);

/* --------------------------------------- */

nestedDynamicArray := B.initPresized<B.StableDynamicArray<Nat>>(3);
for (i in Iter.range(0, 4)) {
  B.add(nestedDynamicArray, B.initPresized<Nat>(2));
};

dynamicArray := B.flatten<Nat>(nestedDynamicArray);

run(
  suite(
    "flatten all empty inner dynamicArrays",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */

nestedDynamicArray := B.initPresized<B.StableDynamicArray<Nat>>(3);
dynamicArray := B.flatten<Nat>(nestedDynamicArray);

run(
  suite(
    "flatten empty outer dynamicArray",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(0)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 7)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray2, i);
};

B.clear(dynamicArray3);

var dynamicArray4 = B.make<Nat>(3);

B.reverse<Nat>(dynamicArray);
B.reverse<Nat>(dynamicArray2);
B.reverse<Nat>(dynamicArray3);
B.reverse<Nat>(dynamicArray4);

run(
  suite(
    "reverse",
    [
      test(
        "even elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [7, 6, 5, 4, 3, 2, 1, 0])),
      ),
      test(
        "odd elements",
        B.toArray(dynamicArray2),
        M.equals(T.array(T.natTestable, [6, 5, 4, 3, 2, 1, 0])),
      ),
      test(
        "empty",
        B.toArray(dynamicArray3),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
      test(
        "singleton",
        B.toArray(dynamicArray4),
        M.equals(T.array(T.natTestable, [3])),
      ),
    ],
  )
);

/* --------------------------------------- */

B.clear(dynamicArray);
for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

var partition = B.partition<Nat>(dynamicArray, func x = x % 2 == 0);
dynamicArray2 := partition.0;
dynamicArray3 := partition.1;

run(
  suite(
    "partition",
    [
      test(
        "capacity of true dynamicArray",
        B.capacity(dynamicArray2),
        M.equals(T.nat(6)),
      ),
      test(
        "elements of true dynamicArray",
        B.toArray(dynamicArray2),
        M.equals(T.array(T.natTestable, [0, 2, 4])),
      ),
      test(
        "capacity of false dynamicArray",
        B.capacity(dynamicArray3),
        M.equals(T.nat(6)),
      ),
      test(
        "elements of false dynamicArray",
        B.toArray(dynamicArray3),
        M.equals(T.array(T.natTestable, [1, 3, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */

B.clear(dynamicArray);
for (i in Iter.range(0, 3)) {
  B.add(dynamicArray, i);
};

for (i in Iter.range(10, 13)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);
for (i in Iter.range(2, 5)) {
  B.add(dynamicArray2, i);
};
for (i in Iter.range(13, 15)) {
  B.add(dynamicArray2, i);
};

dynamicArray := B.merge<Nat>(dynamicArray, dynamicArray2, Nat.compare);

run(
  suite(
    "merge",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(23)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [0, 1, 2, 2, 3, 3, 4, 5, 10, 11, 12, 13, 13, 14, 15])),
      ),
    ],
  )
);

/* --------------------------------------- */

B.clear(dynamicArray);
for (i in Iter.range(0, 3)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);

dynamicArray := B.merge<Nat>(dynamicArray, dynamicArray2, Nat.compare);

run(
  suite(
    "merge with empty",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(6)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [0, 1, 2, 3])),
      ),
    ],
  )
);

/* --------------------------------------- */

B.clear(dynamicArray);
B.clear(dynamicArray2);

dynamicArray := B.merge<Nat>(dynamicArray, dynamicArray2, Nat.compare);

run(
  suite(
    "merge two empty",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(1)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

B.add(dynamicArray, 0);
B.add(dynamicArray, 2);
B.add(dynamicArray, 1);
B.add(dynamicArray, 1);
B.add(dynamicArray, 5);
B.add(dynamicArray, 4);

B.sort(dynamicArray, Nat.compare);

run(
  suite(
    "sort even",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [0, 1, 1, 2, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

B.add(dynamicArray, 0);
B.add(dynamicArray, 2);
B.add(dynamicArray, 1);
B.add(dynamicArray, 1);
B.add(dynamicArray, 5);

B.sort(dynamicArray, Nat.compare);

run(
  suite(
    "sort odd",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [0, 1, 1, 2, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

B.sort(dynamicArray, Nat.compare);

run(
  suite(
    "sort empty",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);
B.add(dynamicArray, 2);

B.sort(dynamicArray, Nat.compare);

run(
  suite(
    "sort singleton",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [2] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

partition := B.split<Nat>(dynamicArray, 2);
dynamicArray2 := partition.0;
dynamicArray3 := partition.1;

run(
  suite(
    "split",
    [
      test(
        "capacity prefix",
        B.capacity(dynamicArray2),
        M.equals(T.nat(3)),
      ),
      test(
        "elements prefix",
        B.toArray(dynamicArray2),
        M.equals(T.array(T.natTestable, [0, 1])),
      ),
      test(
        "capacity suffix",
        B.capacity(dynamicArray3),
        M.equals(T.nat(6)),
      ),
      test(
        "elements suffix",
        B.toArray(dynamicArray3),
        M.equals(T.array(T.natTestable, [2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

partition := B.split<Nat>(dynamicArray, 0);
dynamicArray2 := partition.0;
dynamicArray3 := partition.1;

run(
  suite(
    "split at index 0",
    [
      test(
        "capacity prefix",
        B.capacity(dynamicArray2),
        M.equals(T.nat(1)),
      ),
      test(
        "elements prefix",
        B.toArray(dynamicArray2),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
      test(
        "capacity suffix",
        B.capacity(dynamicArray3),
        M.equals(T.nat(9)),
      ),
      test(
        "elements suffix",
        B.toArray(dynamicArray3),
        M.equals(T.array(T.natTestable, [0, 1, 2, 3, 4, 5])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

partition := B.split<Nat>(dynamicArray, 6);
dynamicArray2 := partition.0;
dynamicArray3 := partition.1;

run(
  suite(
    "split at last index",
    [
      test(
        "capacity prefix",
        B.capacity(dynamicArray2),
        M.equals(T.nat(9)),
      ),
      test(
        "elements prefix",
        B.toArray(dynamicArray2),
        M.equals(T.array(T.natTestable, [0, 1, 2, 3, 4, 5])),
      ),
      test(
        "capacity suffix",
        B.capacity(dynamicArray3),
        M.equals(T.nat(1)),
      ),
      test(
        "elements suffix",
        B.toArray(dynamicArray3),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);
B.clear(dynamicArray2);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};
for (i in Iter.range(0, 3)) {
  B.add(dynamicArray2, i);
};

var dynamicArrayPairs = B.zip<Nat, Nat>(dynamicArray, dynamicArray2);

run(
  suite(
    "zip",
    [
      test(
        "capacity",
        B.capacity(dynamicArrayPairs),
        M.equals(T.nat(6)),
      ),
      test(
        "elements",
        B.toArray(dynamicArrayPairs),
        M.equals(T.array(T.tuple2Testable(T.natTestable, T.natTestable), [(0, 0), (1, 1), (2, 2), (3, 3)])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);
B.clear(dynamicArray2);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArrayPairs := B.zip<Nat, Nat>(dynamicArray, dynamicArray2);

run(
  suite(
    "zip empty",
    [
      test(
        "capacity",
        B.capacity(dynamicArrayPairs),
        M.equals(T.nat(1)),
      ),
      test(
        "elements",
        B.toArray(dynamicArrayPairs),
        M.equals(T.array(T.tuple2Testable(T.natTestable, T.natTestable), [] : [(Nat, Nat)])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);
B.clear(dynamicArray2);

dynamicArrayPairs := B.zip<Nat, Nat>(dynamicArray, dynamicArray2);

run(
  suite(
    "zip both empty",
    [
      test(
        "capacity",
        B.capacity(dynamicArrayPairs),
        M.equals(T.nat(1)),
      ),
      test(
        "elements",
        B.toArray(dynamicArrayPairs),
        M.equals(T.array(T.tuple2Testable(T.natTestable, T.natTestable), [] : [(Nat, Nat)])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);
B.clear(dynamicArray2);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};
for (i in Iter.range(0, 3)) {
  B.add(dynamicArray2, i);
};

dynamicArray3 := B.zipWith<Nat, Nat, Nat>(dynamicArray, dynamicArray2, Nat.add);

run(
  suite(
    "zipWith",
    [
      test(
        "capacity",
        B.capacity(dynamicArray3),
        M.equals(T.nat(6)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray3),
        M.equals(T.array(T.natTestable, [0, 2, 4, 6])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);
B.clear(dynamicArray2);

for (i in Iter.range(0, 5)) {
  B.add(dynamicArray, i);
};

dynamicArray3 := B.zipWith<Nat, Nat, Nat>(dynamicArray, dynamicArray2, Nat.add);

run(
  suite(
    "zipWithEmpty",
    [
      test(
        "capacity",
        B.capacity(dynamicArray3),
        M.equals(T.nat(1)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray3),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 8)) {
  B.add(dynamicArray, i);
};

var chunks = B.chunk<Nat>(dynamicArray, 2);

run(
  suite(
    "chunk",
    [
      test(
        "num chunks",
        B.size(chunks),
        M.equals(T.nat(5)),
      ),
      test(
        "chunk 0 capacity",
        B.capacity(B.get(chunks, 0)),
        M.equals(T.nat(3)),
      ),
      test(
        "chunk 0 elements",
        B.toArray(B.get(chunks, 0)),
        M.equals(T.array(T.natTestable, [0, 1])),
      ),
      test(
        "chunk 2 capacity",
        B.capacity(B.get(chunks, 2)),
        M.equals(T.nat(3)),
      ),
      test(
        "chunk 2 elements",
        B.toArray(B.get(chunks, 2)),
        M.equals(T.array(T.natTestable, [4, 5])),
      ),
      test(
        "chunk 4 capacity",
        B.capacity(B.get(chunks, 4)),
        M.equals(T.nat(3)),
      ),
      test(
        "chunk 4 elements",
        B.toArray(B.get(chunks, 4)),
        M.equals(T.array(T.natTestable, [8])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

chunks := B.chunk<Nat>(dynamicArray, 3);

run(
  suite(
    "chunk empty",
    [
      test(
        "num chunks",
        B.size(chunks),
        M.equals(T.nat(0)),
      )
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

chunks := B.chunk<Nat>(dynamicArray, 10);

run(
  suite(
    "chunk larger than dynamicArray",
    [
      test(
        "num chunks",
        B.size(chunks),
        M.equals(T.nat(1)),
      ),
      test(
        "chunk 0 elements",
        B.toArray(B.get(chunks, 0)),
        M.equals(T.array(T.natTestable, [0, 1, 2, 3, 4])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

B.add(dynamicArray, 2);
B.add(dynamicArray, 2);
B.add(dynamicArray, 2);
B.add(dynamicArray, 1);
B.add(dynamicArray, 0);
B.add(dynamicArray, 0);
B.add(dynamicArray, 2);
B.add(dynamicArray, 1);
B.add(dynamicArray, 1);

var groups = B.groupBy<Nat>(dynamicArray, Nat.equal);

run(
  suite(
    "groupBy",
    [
      test(
        "num groups",
        B.size(groups),
        M.equals(T.nat(5)),
      ),
      test(
        "group 0 capacity",
        B.capacity(B.get(groups, 0)),
        M.equals(T.nat(9)),
      ),
      test(
        "group 0 elements",
        B.toArray(B.get(groups, 0)),
        M.equals(T.array(T.natTestable, [2, 2, 2])),
      ),
      test(
        "group 1 capacity",
        B.capacity(B.get(groups, 1)),
        M.equals(T.nat(6)),
      ),
      test(
        "group 1 elements",
        B.toArray(B.get(groups, 1)),
        M.equals(T.array(T.natTestable, [1])),
      ),
      test(
        "group 4 capacity",
        B.capacity(B.get(groups, 4)),
        M.equals(T.nat(2)),
      ),
      test(
        "group 4 elements",
        B.toArray(B.get(groups, 4)),
        M.equals(T.array(T.natTestable, [1, 1])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

groups := B.groupBy<Nat>(dynamicArray, Nat.equal);

run(
  suite(
    "groupBy clear",
    [
      test(
        "num groups",
        B.size(groups),
        M.equals(T.nat(0)),
      )
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, 0);
};

groups := B.groupBy<Nat>(dynamicArray, Nat.equal);

run(
  suite(
    "groupBy clear",
    [
      test(
        "num groups",
        B.size(groups),
        M.equals(T.nat(1)),
      ),
      test(
        "group 0 elements",
        B.toArray(B.get(groups, 0)),
        M.equals(T.array(T.natTestable, [0, 0, 0, 0, 0])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

dynamicArray := B.prefix<Nat>(dynamicArray, 3);

run(
  suite(
    "prefix",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(5)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [0, 1, 2])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

dynamicArray := B.prefix<Nat>(dynamicArray, 0);

run(
  suite(
    "prefix of empty",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(1)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

dynamicArray := B.prefix<Nat>(dynamicArray, 5);

run(
  suite(
    "trivial prefix",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(8)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [0, 1, 2, 3, 4])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);

for (i in Iter.range(0, 2)) {
  B.add(dynamicArray2, i);
};

B.clear(dynamicArray3);

B.add(dynamicArray3, 2);
B.add(dynamicArray3, 1);
B.add(dynamicArray3, 0);

run(
  suite(
    "isPrefixOf",
    [
      test(
        "normal prefix",
        B.isPrefixOf<Nat>(dynamicArray2, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "identical dynamicArrays",
        B.isPrefixOf<Nat>(dynamicArray, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "one empty dynamicArray",
        B.isPrefixOf<Nat>(B.initPresized<Nat>(3), dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "not prefix",
        B.isPrefixOf<Nat>(dynamicArray3, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not prefix from length",
        B.isPrefixOf<Nat>(dynamicArray, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not prefix of empty",
        B.isPrefixOf<Nat>(dynamicArray, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "empty prefix of empty",
        B.isPrefixOf<Nat>(B.initPresized<Nat>(4), B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(true)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);

for (i in Iter.range(0, 2)) {
  B.add(dynamicArray2, i);
};

B.clear(dynamicArray3);

B.add(dynamicArray3, 2);
B.add(dynamicArray3, 1);
B.add(dynamicArray3, 0);

run(
  suite(
    "isStrictPrefixOf",
    [
      test(
        "normal prefix",
        B.isStrictPrefixOf<Nat>(dynamicArray2, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "identical dynamicArrays",
        B.isStrictPrefixOf<Nat>(dynamicArray, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "one empty dynamicArray",
        B.isStrictPrefixOf<Nat>(B.initPresized<Nat>(3), dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "not prefix",
        B.isStrictPrefixOf<Nat>(dynamicArray3, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not prefix from length",
        B.isStrictPrefixOf<Nat>(dynamicArray, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not prefix of empty",
        B.isStrictPrefixOf<Nat>(dynamicArray, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "empty prefix of empty",
        B.isStrictPrefixOf<Nat>(B.initPresized<Nat>(4), B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

dynamicArray := B.subDynamicArray<Nat>(dynamicArray, 1, 3);

run(
  suite(
    "subDynamicArray",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(5)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [1, 2, 3])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "subDynamicArray edge cases",
    [
      test(
        "prefix",
        B.prefix(dynamicArray, 3),
        M.equals({
          { item = B.subDynamicArray(dynamicArray, 0, 3) } and NatDynamicArrayTestable
        }),
      ),
      test(
        "suffix",
        B.suffix(dynamicArray, 3),
        M.equals({
          { item = B.subDynamicArray(dynamicArray, 2, 3) } and NatDynamicArrayTestable
        }),
      ),
      test(
        "empty",
        B.toArray(B.subDynamicArray(dynamicArray, 2, 0)),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
      test(
        "trivial",
        B.subDynamicArray(dynamicArray, 0, B.size(dynamicArray)),
        M.equals({ { item = dynamicArray } and NatDynamicArrayTestable }),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);

for (i in Iter.range(0, 2)) {
  B.add(dynamicArray2, i);
};

B.clear(dynamicArray3);

for (i in Iter.range(1, 3)) {
  B.add(dynamicArray3, i);
};

run(
  suite(
    "isSubDynamicArrayOf",
    [
      test(
        "normal subDynamicArray",
        B.isSubDynamicArrayOf<Nat>(dynamicArray3, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "prefix",
        B.isSubDynamicArrayOf<Nat>(dynamicArray2, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "identical dynamicArrays",
        B.isSubDynamicArrayOf<Nat>(dynamicArray, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "one empty dynamicArray",
        B.isSubDynamicArrayOf<Nat>(B.initPresized<Nat>(3), dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "not subDynamicArray",
        B.isSubDynamicArrayOf<Nat>(dynamicArray3, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not subDynamicArray from length",
        B.isSubDynamicArrayOf<Nat>(dynamicArray, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not subDynamicArray of empty",
        B.isSubDynamicArrayOf<Nat>(dynamicArray, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "empty subDynamicArray of empty",
        B.isSubDynamicArrayOf<Nat>(B.initPresized<Nat>(4), B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(true)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);

for (i in Iter.range(0, 2)) {
  B.add(dynamicArray2, i);
};

B.clear(dynamicArray3);

for (i in Iter.range(1, 3)) {
  B.add(dynamicArray3, i);
};

dynamicArray4 := B.initPresized<Nat>(4);

for (i in Iter.range(3, 4)) {
  B.add(dynamicArray4, i);
};

run(
  suite(
    "isStrictSubDynamicArrayOf",
    [
      test(
        "normal strict subDynamicArray",
        B.isStrictSubDynamicArrayOf<Nat>(dynamicArray3, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "prefix",
        B.isStrictSubDynamicArrayOf<Nat>(dynamicArray2, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "suffix",
        B.isStrictSubDynamicArrayOf<Nat>(dynamicArray4, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "identical dynamicArrays",
        B.isStrictSubDynamicArrayOf<Nat>(dynamicArray, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "one empty dynamicArray",
        B.isStrictSubDynamicArrayOf<Nat>(B.initPresized<Nat>(3), dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "not subDynamicArray",
        B.isStrictSubDynamicArrayOf<Nat>(dynamicArray3, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not subDynamicArray from length",
        B.isStrictSubDynamicArrayOf<Nat>(dynamicArray, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not subDynamicArray of empty",
        B.isStrictSubDynamicArrayOf<Nat>(dynamicArray, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "empty not strict subDynamicArray of empty",
        B.isStrictSubDynamicArrayOf<Nat>(B.initPresized<Nat>(4), B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

dynamicArray := B.suffix<Nat>(dynamicArray, 3);

run(
  suite(
    "suffix",
    [
      test(
        "capacity",
        B.capacity(dynamicArray),
        M.equals(T.nat(5)),
      ),
      test(
        "elements",
        B.toArray(dynamicArray),
        M.equals(T.array(T.natTestable, [2, 3, 4])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "suffix edge cases",
    [
      test(
        "empty",
        B.toArray(B.prefix(dynamicArray, 0)),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
      test(
        "trivial",
        B.prefix(dynamicArray, B.size(dynamicArray)),
        M.equals({ { item = dynamicArray } and NatDynamicArrayTestable }),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);
for (i in Iter.range(3, 4)) {
  B.add(dynamicArray2, i);
};

B.clear(dynamicArray3);

B.add(dynamicArray3, 2);
B.add(dynamicArray3, 1);
B.add(dynamicArray3, 0);

run(
  suite(
    "isSuffixOf",
    [
      test(
        "normal suffix",
        B.isSuffixOf<Nat>(dynamicArray2, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "identical dynamicArrays",
        B.isSuffixOf<Nat>(dynamicArray, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "one empty dynamicArray",
        B.isSuffixOf<Nat>(B.initPresized<Nat>(3), dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "not suffix",
        B.isSuffixOf<Nat>(dynamicArray3, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not suffix from length",
        B.isSuffixOf<Nat>(dynamicArray, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not suffix of empty",
        B.isSuffixOf<Nat>(dynamicArray, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "empty suffix of empty",
        B.isSuffixOf<Nat>(B.initPresized<Nat>(4), B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(true)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

B.clear(dynamicArray2);
for (i in Iter.range(3, 4)) {
  B.add(dynamicArray2, i);
};

B.clear(dynamicArray3);

B.add(dynamicArray3, 2);
B.add(dynamicArray3, 1);
B.add(dynamicArray3, 0);

run(
  suite(
    "isStrictSuffixOf",
    [
      test(
        "normal suffix",
        B.isStrictSuffixOf<Nat>(dynamicArray2, dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "identical dynamicArrays",
        B.isStrictSuffixOf<Nat>(dynamicArray, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "one empty dynamicArray",
        B.isStrictSuffixOf<Nat>(B.initPresized<Nat>(3), dynamicArray, Nat.equal),
        M.equals(T.bool(true)),
      ),
      test(
        "not suffix",
        B.isStrictSuffixOf<Nat>(dynamicArray3, dynamicArray, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not suffix from length",
        B.isStrictSuffixOf<Nat>(dynamicArray, dynamicArray2, Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "not suffix of empty",
        B.isStrictSuffixOf<Nat>(dynamicArray, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
      test(
        "empty suffix of empty",
        B.isStrictSuffixOf<Nat>(B.initPresized<Nat>(4), B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.bool(false)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "takeWhile",
    [
      test(
        "normal case",
        B.toArray(B.takeWhile<Nat>(dynamicArray, func x = x < 3)),
        M.equals(T.array(T.natTestable, [0, 1, 2])),
      ),
      test(
        "empty",
        B.toArray(B.takeWhile<Nat>(B.initPresized<Nat>(3), func x = x < 3)),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 4)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "dropWhile",
    [
      test(
        "normal case",
        B.toArray(B.dropWhile<Nat>(dynamicArray, func x = x < 3)),
        M.equals(T.array(T.natTestable, [3, 4])),
      ),
      test(
        "empty",
        B.toArray(B.dropWhile<Nat>(B.initPresized<Nat>(3), func x = x < 3)),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
      test(
        "drop all",
        B.toArray(B.dropWhile<Nat>(dynamicArray, func _ = true)),
        M.equals(T.array(T.natTestable, [] : [Nat])),
      ),
      test(
        "drop none",
        B.toArray(B.dropWhile<Nat>(dynamicArray, func _ = false)),
        M.equals(T.array(T.natTestable, [0, 1, 2, 3, 4])),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(1, 6)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "binarySearch",
    [
      test(
        "find in middle",
        B.binarySearch<Nat>(2, dynamicArray, Nat.compare),
        M.equals(T.optional(T.natTestable, ?1)),
      ),
      test(
        "find first",
        B.binarySearch<Nat>(1, dynamicArray, Nat.compare),
        M.equals(T.optional(T.natTestable, ?0)),
      ),
      test(
        "find last",
        B.binarySearch<Nat>(6, dynamicArray, Nat.compare),
        M.equals(T.optional(T.natTestable, ?5)),
      ),
      test(
        "not found to the right",
        B.binarySearch<Nat>(10, dynamicArray, Nat.compare),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
      test(
        "not found to the left",
        B.binarySearch<Nat>(0, dynamicArray, Nat.compare),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

for (i in Iter.range(0, 6)) {
  B.add(dynamicArray, i);
};

run(
  suite(
    "indexOf",
    [
      test(
        "find in middle",
        B.indexOf<Nat>(2, dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?2)),
      ),
      test(
        "find first",
        B.indexOf<Nat>(0, dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?0)),
      ),
      test(
        "find last",
        B.indexOf<Nat>(6, dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?6)),
      ),
      test(
        "not found",
        B.indexOf<Nat>(10, dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
      test(
        "empty",
        B.indexOf<Nat>(100, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

B.add(dynamicArray, 2); // 0
B.add(dynamicArray, 2); // 1
B.add(dynamicArray, 1); // 2
B.add(dynamicArray, 10); // 3
B.add(dynamicArray, 1); // 4
B.add(dynamicArray, 0); // 5
B.add(dynamicArray, 10); // 6
B.add(dynamicArray, 3); // 7
B.add(dynamicArray, 0); // 8

run(
  suite(
    "lastIndexOf",
    [
      test(
        "find in middle",
        B.lastIndexOf<Nat>(10, dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?6)),
      ),
      test(
        "find only",
        B.lastIndexOf<Nat>(3, dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?7)),
      ),
      test(
        "find last",
        B.lastIndexOf<Nat>(0, dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?8)),
      ),
      test(
        "not found",
        B.lastIndexOf<Nat>(100, dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
      test(
        "empty",
        B.lastIndexOf<Nat>(100, B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
    ],
  )
);

/* --------------------------------------- */
B.clear(dynamicArray);

B.add(dynamicArray, 2); // 0
B.add(dynamicArray, 2); // 1
B.add(dynamicArray, 1); // 2
B.add(dynamicArray, 10); // 3
B.add(dynamicArray, 1); // 4
B.add(dynamicArray, 10); // 5
B.add(dynamicArray, 3); // 6
B.add(dynamicArray, 0); // 7

run(
  suite(
    "indexOfDynamicArray",
    [
      test(
        "find in middle",
        B.indexOfDynamicArray<Nat>(B.fromArray<Nat>([1, 10, 1]), dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?2)),
      ),
      test(
        "find first",
        B.indexOfDynamicArray<Nat>(B.fromArray<Nat>([2, 2, 1, 10]), dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?0)),
      ),
      test(
        "find last",
        B.indexOfDynamicArray<Nat>(B.fromArray<Nat>([0]), dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, ?7)),
      ),
      test(
        "not found",
        B.indexOfDynamicArray<Nat>(B.fromArray<Nat>([99, 100, 1]), dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
      test(
        "search for empty dynamicArray",
        B.indexOfDynamicArray<Nat>(B.fromArray<Nat>([]), dynamicArray, Nat.equal),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
      test(
        "search through empty dynamicArray",
        B.indexOfDynamicArray<Nat>(B.fromArray<Nat>([1, 2, 3]), B.initPresized<Nat>(2), Nat.equal),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
      test(
        "search for empty in empty",
        B.indexOfDynamicArray<Nat>(B.initPresized<Nat>(2), B.initPresized<Nat>(3), Nat.equal),
        M.equals(T.optional(T.natTestable, null : ?Nat)),
      ),
    ],
  )
);
