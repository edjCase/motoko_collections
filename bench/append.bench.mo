import Bench "mo:bench";
import Nat "mo:core/Nat";
import Runtime "mo:core/Runtime";
import List "mo:core/List";
import DynamicArray "../src/DynamicArray";
import StableDynamicArray "../src/StableDynamicArray";

module {

  public func init() : Bench.Bench {

    let bench = Bench.Bench();

    bench.name("Append Benchmarks");
    bench.description("Benchmark append operations for various data structures");

    bench.rows([
      "DynamicArray",
      "DynamicArray-PreSized",
      "StableDynamicArray",
      "StableDynamicArray-PreSized",
      "Core-Library-List",
    ]);

    bench.cols(["1000", "100000", "1000000"]);

    bench.runner(
      func(row, col) {
        let ?n = Nat.fromText(col) else Runtime.trap("Cols must only contain numbers: " # col);

        let operation = switch (row) {
          case ("DynamicArray") {
            let dynamicArray = DynamicArray.DynamicArray<Nat>(0);
            func(i : Nat) {
              dynamicArray.add(i);
            };
          };
          case ("DynamicArray-PreSized") {
            let dynamicArray = DynamicArray.DynamicArray<Nat>(n);
            func(i : Nat) {
              dynamicArray.add(i);
            };
          };
          case ("StableDynamicArray") {
            let stableDynamicArray = StableDynamicArray.init<Nat>();
            func(i : Nat) {
              StableDynamicArray.add(stableDynamicArray, i);
            };
          };
          case ("StableDynamicArray-PreSized") {
            let stableDynamicArray = StableDynamicArray.initPresized<Nat>(n);
            func(i : Nat) {
              StableDynamicArray.add(stableDynamicArray, i);
            };
          };
          case ("Core-Library-List") {
            let list = List.empty<Nat>();
            func(i : Nat) {
              List.add(list, i);
            };
          };
          case (unknownRow) Runtime.trap("Unknown row: " # unknownRow);
        };

        for (i in Nat.range(1, n + 1)) {
          operation(i);
        };
      }
    );

    bench;
  };

};
