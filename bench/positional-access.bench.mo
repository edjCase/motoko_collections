import Bench "mo:bench";
import Nat "mo:core/Nat";
import Runtime "mo:core/Runtime";
import List "mo:core/List";
import DynamicArray "../src/DynamicArray";
import StableDynamicArray "../src/StableDynamicArray";

module {

  public func init() : Bench.Bench {

    let bench = Bench.Bench();

    bench.name("Positional Access Benchmarks");
    bench.description("Benchmark get operations at different positions and collection sizes");

    bench.rows([
      "1K-DynamicArray",
      "1K-StableDynamicArray",
      "1K-Core-Library-List",
      "10K-DynamicArray",
      "10K-StableDynamicArray",
      "10K-Core-Library-List",
      "100K-DynamicArray",
      "100K-StableDynamicArray",
      "100K-Core-Library-List",
    ]);

    bench.cols(["Start", "Middle", "End"]);

    bench.runner(
      func(row, col) {

        let (dataStructure, n) = switch (row) {
          case ("1K-DynamicArray") ("DynamicArray", 1_000);
          case ("10K-DynamicArray") ("DynamicArray", 10_000);
          case ("100K-DynamicArray") ("DynamicArray", 100_000);
          case ("1K-StableDynamicArray") ("StableDynamicArray", 1_000);
          case ("10K-StableDynamicArray") ("StableDynamicArray", 10_000);
          case ("100K-StableDynamicArray") ("StableDynamicArray", 100_000);
          case ("1K-Core-Library-List") ("Core-Library-List", 1_000);
          case ("10K-Core-Library-List") ("Core-Library-List", 10_000);
          case ("100K-Core-Library-List") ("Core-Library-List", 100_000);
          case (unknownRow) Runtime.trap("Unknown row: " # unknownRow);
        };

        let accessIndex : Nat = switch (col) {
          case ("Start") 0;
          case ("Middle") n / 2;
          case ("End") n - 1;
          case (unknownCol) Runtime.trap("Unknown col: " # unknownCol);
        };

        let operation = switch (dataStructure) {
          case ("DynamicArray") {
            let dynamicArray = DynamicArray.DynamicArray<Nat>(n);
            // Pre-populate
            for (i in Nat.range(0, n)) {
              dynamicArray.add(i);
            };
            func() {
              ignore dynamicArray.get(accessIndex);
            };
          };
          case ("StableDynamicArray") {
            let stableDynamicArray = StableDynamicArray.initPresized<Nat>(n);
            // Pre-populate
            for (i in Nat.range(0, n)) {
              StableDynamicArray.add(stableDynamicArray, i);
            };
            func() {
              ignore StableDynamicArray.get(stableDynamicArray, accessIndex);
            };
          };
          case ("Core-Library-List") {
            var list = List.empty<Nat>();
            // Pre-populate
            for (i in Nat.range(0, n)) {
              List.add(list, i);
            };
            func() {
              ignore List.get(list, accessIndex);
            };
          };
          case (unknownDataStructure) Runtime.trap("Unknown data structure: " # unknownDataStructure);
        };

        // Perform 1000 accesses to the same position
        for (i in Nat.range(0, 999)) {
          operation();
        };
      }
    );

    bench;
  };

};
