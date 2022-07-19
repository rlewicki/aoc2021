#import "Basic";
#import "File";
#import "String";
#import "Hash_Table";
#import "Math";
#import "Hash";

Vec2i :: struct {
    x: int;
    y: int;
}

operator == :: (a: Vec2i, b: Vec2i) ->  bool {
    return a.x == b.x && a.y == b.y;
}

get_hash :: (a : Vec2i) -> u32 {
    hash := get_hash(a.x);
    hash = get_hash(a.y, hash);;
    return hash;
}

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }

    input := split(file, "\n");

    vents: Table(
        Vec2i, 
        int,
        given_hash_function=get_hash,
        given_compare_function=(a: Vec2i, b: Vec2i) -> bool { return a == b; });
    defer uninit(*vents);

    for line, index: input {
        coordinates := split(line, "->");
        segment_begin := split(coordinates[0], ",");
        segment_end := split(coordinates[1], ",");

        x0 := to_integer(segment_begin[0]);
        y0 := to_integer(segment_begin[1]);
        x1 := to_integer(segment_end[0]);
        y1 := to_integer(segment_end[1]);

        if x0 != x1 && y0 != y1 {
            continue;
        }

        if x0 > x1 {
            tmp := x0;
            x0 = x1;
            x1 = tmp;
        }

        if y0 > y1 {
            tmp := y0;
            y0 = y1;
            y1 = tmp;
        }

        modify_x :: (a: *Vec2i, new_value: int) {
            a.x = new_value;
        }

        modify_y :: (a: *Vec2i, new_value: int) {
            a.y = new_value;
        }

        coords: Vec2i;
        begin: int;
        end: int;
        modify_func: (a: *Vec2i, new_value: int);
        if x0 == x1 {
            coords.x = x0;
            begin = y0;
            end = y1;
            modify_func = modify_y;
        } else {
            coords.y = y0;
            begin = x0;
            end = x1;
            modify_func = modify_x;
        }

        for v: begin..end {
            modify_func(*coords, v);
            value := table_find_pointer(*vents, coords);
            if !value {
                table_set(*vents, coords, 1);
            } else {
                <<value += 1;
            }
        }
    }

    overlapping_points := 0;
    for vents {
        if it > 1 {
            overlapping_points += 1;
        }
    }

    print("overlapping points: %\n", overlapping_points);
}