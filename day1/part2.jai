#import "Basic";
#import "File";
#import "String";

main :: () {
    input := read_entire_file("input.txt");
    numbers := split(input, "\n");
    increased: u32;
    for i: 0..numbers.count - 4 {
        first := string_to_int(numbers[i]);
        second := string_to_int(numbers[i + 1]);
        third := string_to_int(numbers[i + 2]);
        fourth := string_to_int(numbers[i + 3]);
        current_window := first + second + third;
        next_window := second + third + fourth;
        if next_window > current_window {
            increased += 1;
        }
    }

    print("depth increased % times\n", increased);
}