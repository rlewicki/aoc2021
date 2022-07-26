#import "Basic";
#import "File";
#import "String";

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }

    NUM_OF_DAYS :: 80;
    reproduction_per_day: [NUM_OF_DAYS] int;

    input := split(file, ",");
    for input {
        reproduction_day := to_integer(it);
        reproduction_per_day[reproduction_day] += 1;
    }

    total_lanternfish_count := 0;
    for reproduction_per_day {
        current := reproduction_per_day[it_index];
        reproduction_per_day[it_index] = 0;
        if it_index + 7 < NUM_OF_DAYS {
            reproduction_per_day[it_index + 7] += current;
        } else {
            total_lanternfish_count += current;
        }

        if it_index + 9 < NUM_OF_DAYS {
            reproduction_per_day[it_index + 9] += current;
        } else {
            total_lanternfish_count += current;
        }
    }

    print("total lanternfish count: %\n", total_lanternfish_count);
}