#import "Basic";
#import "File";
#import "String";
#import "Sort";

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }

    get_auto_complete_score :: (symbol: u8) -> int {
        if symbol == #char "(" return 1;
        if symbol == #char "[" return 2;
        if symbol == #char "{" return 3;
        if symbol == #char "<" return 4;
        return 0;
    }

    is_matching_symbol :: (stack_symbol: u8, current_symbol: u8) -> bool {
        if stack_symbol == #char "(" && current_symbol == #char ")" return true;
        if stack_symbol == #char "[" && current_symbol == #char "]" return true;
        if stack_symbol == #char "{" && current_symbol == #char "}" return true;
        if stack_symbol == #char "<" && current_symbol == #char ">" return true;
        return false;
    }
    
    stack: [512] u8;
    stack_pointer := 0;
    scores: [..] int;
    defer array_free(scores);
    input := split(file, "\r\n");
    for line: input {
        stack_pointer = 0;
        for i: 0..line.count - 1 {
            if line[i] == #char "(" || 
               line[i] == #char "[" || 
               line[i] == #char "{" || 
               line[i] == #char "<" {
                stack[stack_pointer] = line[i];
                stack_pointer += 1;
            } else {
                stack_pointer -= 1;
                if !is_matching_symbol(stack[stack_pointer], line[i]) {
                    break;
                }
            }

            score := 0;
            if i == line.count - 1 {
                while stack_pointer > 0 {
                    stack_pointer -= 1;
                    symbol_score := get_auto_complete_score(stack[stack_pointer]);
                    score *= 5;
                    score += symbol_score;
                }

                array_add(*scores, score);
            }
        }
    }

    quick_sort(scores, (a: int, b: int) -> s64 {
        return a - b;
    });

    middle_score := scores[scores.count / 2];
    print("middle score = %\n", middle_score);
}