#import "Basic";
#import "File";
#import "String";

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }

    input := split(file, "\r\n");
    height := input.count;
    width := input[0].count;
    print("width = %, height = %\n", width, height);

    char_to_int :: (c: u8) -> int {
        return c - #char "0";
    }

    risk_points: [..] int;
    for y: 0..height-1 {
        for x: 0..width-1 {
            current := char_to_int(input[y][x]);
            if     (x - 1 < 0 || current < char_to_int(input[y][x - 1]))
                && (x + 1 >= width || current < char_to_int(input[y][x + 1]))
                && (y - 1 < 0 || current < char_to_int(input[y - 1][x]))
                && (y + 1 >= height || current < char_to_int(input[y + 1][x]))
            {
                array_add(*risk_points, current);
            }
        }
    }

    print("risk points count = %\n", risk_points.count);
    risk_level := 0;
    for risk_points {
        risk_level += 1 + it;
    }

    print("risk level = %\n", risk_level);
}