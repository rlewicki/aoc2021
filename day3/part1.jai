#import "Basic";
#import "File";
#import "String";
#import "Math";

main :: () {
    file, success := read_entire_file("input.txt");
    if !success {
        print("failed to open file\n");
        return;
    }

    input := split(file, "\n");
    total_reports := input.count;
    bit_counter: [12] u32;
    for line, index: input {
        for bit: 0..11 {
            if line[bit] == #char "1" {
                bit_counter[bit] += 1;
            }
        }
    }

    gamma: [12] u8;
    epsilon: [12] u8;
    for bit: 0..11 {
        if bit_counter[bit] > 500 {
            gamma[bit] = 1;
            epsilon[bit] = 0;
        } else {
            gamma[bit] = 0;
            epsilon[bit] = 1;
        }
    }

    gamma_decimal := 0;
    epsilon_decimal := 0;
    for bit: 0..11 {
        power := 11.0 - cast(float)bit;

        if gamma[bit] == 1 {
            gamma_decimal += cast(s64)pow(2.0, power);
        } 
        
        if epsilon[bit] == 1 {
            epsilon_decimal += cast(s64)pow(2.0, power);
        }
    }

    result := gamma_decimal * epsilon_decimal;
    print("gamma: %, epsilon: %, result: %\n", gamma_decimal, epsilon_decimal, result);
}