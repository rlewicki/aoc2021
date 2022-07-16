#import "Basic";
#import "File";
#import "String";
#import "Bit_Array";

Board :: struct {
    cells: [25] int;
    crossed: Bit_Array;
}

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }

    input := split(file, "\n");
    bingo_sequence: [..] int;
    {
        bingo_numbers := split(input[0], ",");
        for number_to_parse: bingo_numbers {
            number, success := to_integer(number_to_parse);
            if !success {
                print("failed to parse bingo sequence number\n");
                return;
            }

            array_add(*bingo_sequence, number);
        }
    }


    boards: [..] Board;
    defer array_free(boards);
    current_board := array_add(*boards);
    rows_read := 0;
    for row_num: 2..input.count - 1 {
        if input[row_num] == "\r" {
            continue;
        }

        row_data := split(input[row_num], " ");
        current_column := 0;
        for number_char: row_data {
            number, success := to_integer(number_char);
            if !success {
                continue;
            }

            current_board.cells[rows_read * 5 + current_column] = number;
            current_column += 1;
        }
        rows_read += 1;
        if rows_read == 5 {
            rows_read = 0;
            init_bit_array(*current_board.crossed, 25);
            if row_num != input.count - 1 {
                current_board = array_add(*boards);
            }
        }
    }

    for bingo_number: bingo_sequence {
        for board: boards {
            for cell: 0..24 {
                if board.cells[cell] == bingo_number {
                    set_bit(*board.crossed, cell);

                    // Checking rows
                    for i: 0..4 {
                        winning := true;
                        for j: 0..4 {
                            if !board.crossed[i * 5 + j] {
                                winning = false;
                                break;
                            }
                        }

                        if winning {
                            sum := 0;
                            for board.crossed {
                                if !it {
                                    sum += board.cells[it_index];
                                }
                            }
                            result := sum * bingo_number;
                            print("winning result is %\n", result);
                            return;
                        }
                    }

                    // Checking columns
                    for i: 0..4 {
                        winning := true;
                        for j: 0..4 {
                            if !board.crossed[i + j * 5] {
                                winning = false;
                                break;
                            }
                        }

                        if winning {
                            sum := 0;
                            for board.crossed {
                                if !it {
                                    sum += board.cells[it_index];
                                }
                            }
                            result := sum * bingo_number;
                            print("winning result is %\n", result);
                            return;
                        }
                    }

                    break;
                }
            }
        }
    }
}