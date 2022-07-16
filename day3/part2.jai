#import "Basic";
#import "File";
#import "String";
#import "Math";

remove_reports_by_predicate :: (reports: *[..] string, predicate: (zero_set: [] string, one_set: [] string) -> [] string) -> string {
    one_set: [..] string;
    zero_set: [..] string;
    current_set: [..] string;
    defer array_free(one_set);
    defer array_free(zero_set);
    defer array_free(current_set);
    array_copy(*current_set, <<reports);
    for bit: 0..11 {
        for current_set {
            if it[bit] == #char "1" {
                array_add(*one_set, it);
            } else {
                array_add(*zero_set, it);
            }
        }

        reports_to_keep := predicate(zero_set, one_set);
        if reports_to_keep.count == 1 {
            return reports_to_keep[0];
        }

        array_reset(*current_set);
        array_copy(*current_set, reports_to_keep);

        array_reset(*one_set);
        array_reset(*zero_set);
    }

    return "";
}

main :: () {
    file, success := read_entire_file("input.txt");
    if !success {
        print("failed to open file\n");
        return;
    }

    input := split(file, "\n");
    oxygen_generator: [..] string;
    scrubber: [..] string;
    defer array_free(oxygen_generator);
    defer array_free(scrubber);
    array_copy(*oxygen_generator, input);
    array_copy(*scrubber, input);

    oxygen_predicate :: (zero_set: [] string, one_set: [] string) -> [] string {
        if one_set.count >= zero_set.count {
            return one_set;
        } else {
            return zero_set;
        }
    }

    scrubber_predicate :: (zero_set: [] string, one_set: [] string) -> [] string {
        if zero_set.count <= one_set.count {
            return zero_set;
        } else {
            return one_set;
        }
    }

    oxygen_report := remove_reports_by_predicate(*oxygen_generator, oxygen_predicate);
    scrubber_report := remove_reports_by_predicate(*scrubber, scrubber_predicate);

    print("oxygen: %\n", oxygen_report);
    print("scrubber: %\n", scrubber_report);

    oxygen_decimal := 0;
    scrubber_decimal := 0;
    for bit: 0..11 {
        power := 11.0 - cast(float)bit;

        if oxygen_report[bit] == #char "1" {
            oxygen_decimal += cast(s64)pow(2.0, power);
        } 
        
        if scrubber_report[bit] == #char "1" {
            scrubber_decimal += cast(s64)pow(2.0, power);
        }
    }

    print("oxygen: %\n", oxygen_decimal);
    print("scrubber: %\n", scrubber_decimal);
    print("result: %\n", oxygen_decimal * scrubber_decimal);
}