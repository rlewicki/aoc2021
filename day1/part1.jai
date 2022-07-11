#import "Basic";
#import "File";
#import "String";

main :: () {
    input := read_entire_file("input.txt");
    numbers := split(input, "\n");
    previous_number := -1;
    increased := 0;
    for word, index: numbers {
        number := string_to_int(word);
        if previous_number != -1 && number > previous_number {
            increased += 1;
        }

        previous_number = number;
    }

    print("depth increased % times\n", increased);
}