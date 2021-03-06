module main

enum Relations {
	// ##
	independency
	// ->
	causality
	// >>
	follow
	// ||
	cuncurrency
}

[heap]
struct Footprint {
mut:
	matrix map[string]map[string]Relations = map[string]map[string]Relations{}
}

fn build_footprint(mut e Eventlog) Footprint {
	mut f := Footprint{}

	for x in e.activities {
		for y in e.activities {
			f.matrix[x][y] = .independency // ##
		}
	}

	for _, mut t in e.traces {
		for i := 1; i < t.events.len; i++ {
			x := t.events[i - 1].activity
			y := t.events[i].activity
			f.matrix[x][y] = .follow // >>
		}
	}

	for x in e.activities {
		for y in e.activities {
			if f.matrix[x][y] == .follow {
				if f.matrix[y][x] == .follow {
					f.matrix[x][y] = .cuncurrency
				} else {
					f.matrix[x][y] = .causality
				}
			}
		}
	}

	return f
}
