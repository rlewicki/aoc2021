#import "Basic";
#import "File";
#import "String";

Position :: struct {
    x: int;
    y: int;
}

Fold_Data :: struct {
    axis: u8;
    line: int;
}

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }
    
    input := split(file, "\r\n");
    dots_locations: [..] Position;
    folds_data: [..] Fold_Data;
    defer {
        array_free(dots_locations);
        array_free(folds_data);
    }
    
    for input {
        if contains(it, #char ",") {
            coordinates := split(it, ",");
            x := to_integer(coordinates[0]);
            y := to_integer(coordinates[1]);
            new_dot := array_add(*dots_locations);
            new_dot.x = x;
            new_dot.y = y;
        } else if contains(it, #char "=") {
            fold_str := split(it, "=");
            axis := fold_str[0][fold_str[0].count - 1];
            line := to_integer(fold_str[1]);
            fold := array_add(*folds_data);
            fold.axis = axis;
            fold.line = line;
        }
    }

    for fold_data: folds_data {
        line_idx := fold_data.line;
        if fold_data.axis == #char "x" {
            for *dots_locations {
                if it.x > line_idx {
                    new_dot_x := line_idx * 2 - it.x;
                    it.x = new_dot_x;
                }
            }
        } else if fold_data.axis == #char "y" {
            for *dots_locations {
                if it.y > line_idx {
                    new_dot_y := line_idx * 2 - it.y;
                    it.y = new_dot_y;
                }
            }
        }

        idx := dots_locations.count - 1;
        while idx >= 0 {
            inner_idx := idx - 1;
            while inner_idx >= 0 {
                if dots_locations[idx].x == dots_locations[inner_idx].x && 
                dots_locations[idx].y == dots_locations[inner_idx].y {
                    array_unordered_remove_by_index(*dots_locations, idx);
                    break;
                }

                inner_idx -= 1;
            }
            idx -= 1;
        }
    }

    max_x := -1;
    max_y := -1;
    for dots_locations {
        if it.x > max_x {
            max_x = it.x;
        }

        if it.y > max_y {
            max_y = it.y;
        }
    }

    empty_row_data: [..] u8;
    defer array_free(empty_row_data);
    array_reserve(*empty_row_data, max_x);
    for x: 0..max_x {
        array_add(*empty_row_data, #char ".");
    }
    
    empty_row := to_string(empty_row_data);
    for y: 0..max_y {
        row := copy_string(empty_row);
        for dots_locations {
            if it.y == y {
                row[it.x] = #char "#";
            }
        }

        print("%\n", row);
    }
}