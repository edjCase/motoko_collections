import Bench "mo:bench";
import Nat "mo:core/Nat";
import Runtime "mo:core/Runtime";
import List "mo:core/List";
import DynamicArray "../src/DynamicArray";
import StableDynamicArray "../src/StableDynamicArray";

module {

  public func init() : Bench.Bench {

    let bench = Bench.Bench();

    bench.name("IndexOf Benchmarks");
    bench.description("Benchmark indexOf/search operations for various data structures");

    bench.rows([
      "DynamicArray",
      "StableDynamicArray",
      "Core-Library-List",
    ]);

    bench.cols(["Found-Start", "Found-Middle", "Found-End", "Not-Found"]);

    let n = 10_000;
    let dynamicArray = DynamicArray.DynamicArray<Nat>(n);
    let stableDynamicArray = StableDynamicArray.initPresized<Nat>(n);
    let list = List.empty<Nat>();
    for (i in Nat.range(0, n)) {
      dynamicArray.add(i);
      StableDynamicArray.add(stableDynamicArray, i);
      List.add(list, i);
    };
    bench.runner(
      func(row, col) {

        // Determine search target and expected position
        let searchTarget : Nat = switch (col) {
          case ("Found-Start") 5;
          case ("Found-Middle") n / 2;
          case ("Found-End") n - 5 : Nat;
          case ("Not-Found") n + 999;
          case (unknownCol) Runtime.trap("Unknown col: " # unknownCol);
        };

        let operation = switch (row) {
          case ("DynamicArray") {
            func() {
              ignore DynamicArray.indexOf(searchTarget, dynamicArray, Nat.equal);
            };
          };
          case ("StableDynamicArray") {
            func() {
              ignore StableDynamicArray.indexOf(searchTarget, stableDynamicArray, Nat.equal);
            };
          };
          case ("Core-Library-List") {
            func() {
              ignore List.indexOf(list, Nat.equal, searchTarget);
            };
          };
          case (unknownRow) Runtime.trap("Unknown row: " # unknownRow);
        };

        // Perform 1000 search operations
        for (i in Nat.range(0, 999)) {
          operation();
        };
      }
    );

    bench;
  };

};
