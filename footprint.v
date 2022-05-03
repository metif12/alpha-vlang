module main

import os
import encoding.csv

enum Relations {
	independency
	causality
	following
	follower
	cuncurrency
}

[heap]
struct Footprint {
mut:
	matrix map[string]map[string]Relations = map[string]map[string]Relations{}
	activities []string
}

fn (mut f Footprint) parse_eventlog(mut e Eventlog) {

	f.activities = e.activities

	for x in f.activities{
		for y in f.activities {
			f.matrix[x][y] = .independency
		}
	}

	for _, mut t in e.traces {
		t.sort_events()

		for i:=1; i<t.events.len; i++ {
			x := t.events[i-1].activity
			y := t.events[i].activity
			f.matrix[x][y] = .following
			f.matrix[y][x] = .follower
		}
	}

	for x in f.activities{
		for y in f.activities {
			if f.matrix[x][y] in [.follower, .following]{
				if f.matrix[y][x] in [.follower, .following]{
					f.matrix[x][y] = .cuncurrency
					f.matrix[y][x] = .cuncurrency
				}
			}
		}
	}

	// for x, m in f.matrix {
	// 	for y, n in m {
	// 		println('$x, $y = $n')
	// 	}
	// }
}

fn write_footprint(footprint_path string, f Footprint) ? {

	mut csv_writer := csv.new_writer()

	csv_writer.write(['x', 'y', 'relation'])?

	for x, m in f.matrix {
		for y, relation in m {
			csv_writer.write([x, y, relation.str()])?
		}
	}
	os.write_file(footprint_path, csv_writer.str()) ?
}

// fn load_footprint(footprint_path string) ?Footprint {

// 	content := os.read_file(footprint_path) ?
// 	return json.decode(Footprint, content)
// }