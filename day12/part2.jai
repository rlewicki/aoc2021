#import "Basic";
#import "File";
#import "String";

Node :: struct {
    id: int;
    name: string;
    nodes: [..] int;
}

main :: () {
    file, file_success := read_entire_file("input.txt");
    if !file_success {
        print("failed to open file\n");
        return;
    }

    input := split(file, "\r\n");

    nodes: [..] Node;
    defer {
        for nodes {
            array_free(it.nodes);
        }
        array_free(nodes);
    }

    try_add_new_node :: (node_name: string, nodes: *[..] Node) -> int {
        for i: 0..nodes.count-1 {
            if nodes.data[i].name == node_name {
                return i;
            }
        }

        new_node := array_add(nodes);
        new_node.name = node_name;
        new_node.id = nodes.count - 1;
        return new_node.id;
    }

    node_count := 0;
    for entry: input {
        points := split(entry, "-");
        point_a := points[0];
        point_b := points[1];
        node_a_idx := try_add_new_node(point_a, *nodes);
        node_b_idx := try_add_new_node(point_b, *nodes);
        array_add(*nodes[node_a_idx].nodes, node_b_idx);
        array_add(*nodes[node_b_idx].nodes, node_a_idx);
    }

    start_node_idx := -1;
    for nodes {
        if it.name == "start" {
            start_node_idx = it_index;
            break;
        }
    }
    
    is_lower :: (name: string) -> bool {
        for i: 0..name.count - 1 {
            if name[i] < #char "a" || name[i] > #char "z" {
                return false;
            }
        }

        return true;
    }

    progress_path :: (  nodes: [] Node, 
                        current_node: *Node, 
                        visited_nodes: [..] int, 
                        visited_small_cave_twice: bool, 
                        path_count: *int) {
        if current_node.name == "end" {
            <<path_count += 1;
            return;
        }
        new_visited_nodes: [..] int;
        defer array_free(new_visited_nodes);
        array_copy(*new_visited_nodes, visited_nodes);
        array_add(*new_visited_nodes, current_node.id);
        for connected_node_idx: current_node.nodes {
            copy_visited_small_cave_twice := visited_small_cave_twice;
            already_visited_node := array_find(new_visited_nodes, connected_node_idx);
            is_small_cave := is_lower(nodes[connected_node_idx].name);
            can_visit_node := nodes[connected_node_idx].name != "start" && 
                              (!is_small_cave || (!already_visited_node || !visited_small_cave_twice));
            if can_visit_node {
                if already_visited_node && is_small_cave {
                    copy_visited_small_cave_twice = true;
                }
                progress_path(
                    nodes, 
                    *nodes[connected_node_idx], 
                    new_visited_nodes, 
                    copy_visited_small_cave_twice, 
                    path_count);
            }
        }
    }

    visited_nodes: [..] int;
    defer array_free(visited_nodes);
    path_count := 0;
    progress_path(nodes, *nodes[start_node_idx], visited_nodes, false, *path_count);
    print("total paths found: %\n", path_count);
}