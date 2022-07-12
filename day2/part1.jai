#import "Basic";
#import "File";
#import "String";

main :: () {
    file, success := read_entire_file("input.txt");
    if !success {
        print("failed to open file\n");
        return;
    }

    depth := 0;
    forward := 0;
    input := split(file, "\n");
    for line, index: input {
        instructions := split(line, " ");
        direction := instructions[0];
        value := string_to_int(instructions[1]);
        if direction == "forward" {
            forward += value;
        } else {
            if direction == "up" {
                depth -= value;
            } else {
                depth += value;
            }
        }
    }

    print("forward: %, depth: %, final result: %\n", forward, depth, forward * depth);
}