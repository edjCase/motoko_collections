import Bench "mo:bench";
import Nat "mo:core/Nat";
import Runtime "mo:core/Runtime";
import DynamicArray "../src/DynamicArray";
import StableDynamicArray "../src/StableDynamicArray";

module {

  public func init() : Bench.Bench {

    let bench = Bench.Bench();

    bench.name("Remove Benchmarks");
    bench.description("Benchmark remove operations at different positions for various data structures");

    bench.rows([
      "DynamicArray",
      "StableDynamicArray",
    ]);

    bench.cols(["Remove-Front", "Remove-Middle", "Remove-End"]);

    let n = 10_000;

    // Build fresh collections for each test
    let dynamicArray = DynamicArray.DynamicArray<Nat>(n);
    let stableDynamicArray = StableDynamicArray.initPresized<Nat>(n);
    for (i in Nat.range(0, n)) {
      dynamicArray.add(i);
      StableDynamicArray.add(stableDynamicArray, i);
    };

    var dynamicArraySize = dynamicArray.size();
    var stableDynamicArraySize = StableDynamicArray.size(stableDynamicArray);

    bench.runner(
      func(row, col) {

        let operation = func(row : Text, col : Text) {

          let n : Nat = switch (row) {
            case ("DynamicArray") dynamicArraySize;
            case ("StableDynamicArray") stableDynamicArraySize;
            case (unknownRow) Runtime.trap("Unknown row: " # unknownRow);
          };

          // Determine removal index
          let removeIndex : Nat = switch (col) {
            case ("Remove-Front") 0;
            case ("Remove-Middle") n / 2;
            case ("Remove-End") n - 1 : Nat;
            case (unknownCol) Runtime.trap("Unknown col: " # unknownCol);
          };

          switch (row) {
            case ("DynamicArray") {
              ignore dynamicArray.remove(removeIndex);
              dynamicArraySize -= 1;
            };
            case ("StableDynamicArray") {
              ignore StableDynamicArray.remove(stableDynamicArray, removeIndex);
              stableDynamicArraySize -= 1;
            };
            case (unknownRow) Runtime.trap("Unknown row: " # unknownRow);
          };
        };

        // Perform 100 operations (each rebuilds the structure)
        for (i in Nat.range(0, 100)) {
          operation(row, col);
        };
      }
    );

    bench;
  };

};
