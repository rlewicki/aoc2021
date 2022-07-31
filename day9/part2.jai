#import "Basic";
#import "File";
#import "String";
#import "Sort";

Vec2i :: struct {
    x: int = -1;
    y: int = -1;
}

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }
    
    input := split(file, "\r\n");
    height := input.count;
    width := input[0].count;
    
    char_to_int :: (c: u8) -> int {
        return c - #char "0";
    }

    is_within_bounds :: (coordinates: Vec2i, width: int, height: int) -> bool {
        return coordinates.x >= 0 && 
               coordinates.y >= 0 && 
               coordinates.x < width && 
               coordinates.y < height;
    }

    contains_coordinates :: (container: [..] Vec2i, coordinates: Vec2i) -> bool {
        for container {
            if it.x == coordinates.x && it.y == coordinates.y {
                return true;
            }
        }

        return false;
    }
    
    directions: [4] Vec2i;
    directions[0] = Vec2i.{-1, 0};
    directions[1] = Vec2i.{1, 0};
    directions[2] = Vec2i.{0, -1};
    directions[3] = Vec2i.{0, 1};
    basins: [..] int;
    defer array_free(basins);

    // Could use sets instead arrays for faster lookup
    open_coordinates: [..] Vec2i;
    defer array_free(open_coordinates);
    closed_coordinates: [..] Vec2i;
    defer array_free(closed_coordinates);

    for y: 0..height-1 {
        for x: 0..width-1 {
            is_low_point := false;
            current := char_to_int(input[y][x]);
            if     (x - 1 < 0 || current < char_to_int(input[y][x - 1]))
                && (x + 1 >= width || current < char_to_int(input[y][x + 1]))
                && (y - 1 < 0 || current < char_to_int(input[y - 1][x]))
                && (y + 1 >= height || current < char_to_int(input[y + 1][x]))
            {
                is_low_point = true;
            }
            
            if !is_low_point {
                continue;
            }
            
            array_reset_keeping_memory(*open_coordinates);
            array_reset_keeping_memory(*closed_coordinates);

            start_coordinates: Vec2i;
            start_coordinates.x = x;
            start_coordinates.y = y;
            array_add(*open_coordinates, start_coordinates);
            while(open_coordinates.count > 0) {
                current_coordinates := open_coordinates[0];
                array_add(*closed_coordinates, current_coordinates);
                array_unordered_remove_by_index(*open_coordinates, 0);
                for directions {
                    new_coordinates: Vec2i;
                    new_coordinates.x = current_coordinates.x + it.x;
                    new_coordinates.y = current_coordinates.y + it.y;
                    if is_within_bounds(new_coordinates, width, height) && 
                       char_to_int(input[new_coordinates.y][new_coordinates.x]) < 9 && 
                       !contains_coordinates(closed_coordinates, new_coordinates) &&
                       !contains_coordinates(open_coordinates, new_coordinates) {
                        array_add(*open_coordinates, new_coordinates);
                    }
                }
            }

            array_add(*basins, closed_coordinates.count);
        }
    }

    quick_sort(basins, (a: int, b: int) -> s64 {
        return a - b;
    });

    result := basins[basins.count - 3] * 
              basins[basins.count - 2] * 
              basins[basins.count - 1];

    // print("found basins = %\n", basins);
    print("result = %\n", result);
}