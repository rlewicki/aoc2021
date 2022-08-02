#import "Basic";
#import "File";
#import "String";

Vec2i :: struct {
    x: int;
    y: int;
}

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }

    char_to_int :: (c: u8) -> u8 {
        return c - #char "0";
    }

    input := split(file, "\r\n");

    octopuses: [10][10] u8;

    for line, y: input {
        for x: 0..line.count - 1 {
            octopuses[y][x] = char_to_int(line[x]);
        }
    }

    is_within_bounds :: (x: int, y: int, width: int, height: int) -> bool {
        return x >= 0 && y >= 0 && x < width && y < height;
    }

    directions: [8] Vec2i;
    directions[0] = Vec2i.{-1, -1};
    directions[1] = Vec2i.{0, -1};
    directions[2] = Vec2i.{1, -1};
    directions[3] = Vec2i.{-1, 0};
    directions[4] = Vec2i.{1, 0};
    directions[5] = Vec2i.{-1, 1};
    directions[6] = Vec2i.{0, 1};
    directions[7] = Vec2i.{1, 1};

    WIDTH :: 10;
    HEIGHT :: 10;

    flashes := 0;
    for i: 0..99 {
        if i <= 10 {
            print("\n\n\n");
            for y: 0..HEIGHT - 1 {
                for x: 0..WIDTH - 1 {
                    print("%", octopuses[y][x]);
                }
                print("\n");
            }
        }

        for y: 0..HEIGHT - 1 {
            for x: 0..WIDTH - 1 {
                octopuses[y][x] += 1;
            }
        }

        flashed_indicies: [..] int;
        defer array_free(flashed_indicies);
        for y: 0..HEIGHT - 1 {
            for x: 0..WIDTH - 1 {
                if octopuses[y][x] > 9 {
                    octopus_idx := y * WIDTH + x;
                    if array_find(flashed_indicies, octopus_idx) {
                        continue;
                    }

                    flashes += 1;
                    array_add(*flashed_indicies, octopus_idx);
                    octopuses_to_process: [..] int;
                    defer array_free(octopuses_to_process);
                    array_add(*octopuses_to_process, octopus_idx);
                    while octopuses_to_process.count > 0 {
                        next_octopus_idx := pop(*octopuses_to_process);
                        next_octopus_x := next_octopus_idx % WIDTH;
                        next_octopus_y := next_octopus_idx / HEIGHT;
                        for directions {
                            neighbour_x := next_octopus_x + it.x;
                            neighbour_y := next_octopus_y + it.y;
                            if !is_within_bounds(neighbour_x, neighbour_y, WIDTH, HEIGHT) {
                                continue;
                            }
                            
                            octopuses[neighbour_y][neighbour_x] += 1;
                            
                            if octopuses[neighbour_y][neighbour_x] <= 9 {
                                continue;
                            }
                            
                            neighbor_octopus_index := neighbour_y * WIDTH + neighbour_x;
                            found := array_find(flashed_indicies, neighbor_octopus_index);
                            if !found {
                                flashes += 1;
                                array_add(*flashed_indicies, neighbor_octopus_index);
                                array_add(*octopuses_to_process, neighbor_octopus_index);
                            }
                        }
                    }
                }
            }
        }

        for y: 0..HEIGHT - 1 {
            for x: 0..WIDTH - 1 {
                if octopuses[y][x] > 9 {
                    octopuses[y][x] = 0;
                }
            }
        }
    }

    print("total flashes = %\n", flashes);
}