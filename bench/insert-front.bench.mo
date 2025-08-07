import Bench "mo:bench";
import Nat "mo:core/Nat";
import Runtime "mo:core/Runtime";
import DynamicArray "../src/DynamicArray";
import StableDynamicArray "../src/StableDynamicArray";

module {

  public func init() : Bench.Bench {

    let bench = Bench.Bench();

    bench.name("Insert at Front Benchmarks");
    bench.description("Benchmark prepend/insert-at-0 operations for various data structures");

    bench.rows([
      "DynamicArray",
      "StableDynamicArray",
    ]);

    bench.cols(["100", "1000", "10000"]);

    bench.runner(
      func(row, col) {
        let ?n = Nat.fromText(col) else Runtime.trap("Cols must only contain numbers: " # col);

        let operation = switch (row) {
          case ("DynamicArray") {
            let dynamicArray = DynamicArray.DynamicArray<Nat>(0);
            func(i : Nat) {
              dynamicArray.insert(0, i);
            };
          };
          case ("StableDynamicArray") {
            let stableDynamicArray = StableDynamicArray.init<Nat>();
            func(i : Nat) {
              StableDynamicArray.insert(stableDynamicArray, 0, i);
            };
          };
          case (unknownRow) Runtime.trap("Unknown row: " # unknownRow);
        };

        for (i in Nat.range(1, n)) {
          operation(i);
        };
      }
    );

    bench;
  };

};
