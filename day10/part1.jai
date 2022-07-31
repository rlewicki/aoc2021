#import "Basic";
#import "File";
#import "String";

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }

    get_syntax_error_score :: (invalid_char: u8) -> int {
        if invalid_char == #char ")" return 3;
        if invalid_char == #char "]" return 57;
        if invalid_char == #char "}" return 1197;
        if invalid_char == #char ">" return 25137;
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
    score := 0;
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
                    score += get_syntax_error_score(line[i]);
                    break;
                }
            }
        }
    }

    print("total syntax error score = %\n", score);
}