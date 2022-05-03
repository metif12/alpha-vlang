module main

enum Relations {
	independency
	causality
	direct_follow
	cuncurrency
}

[heap]
struct Footprint {
mut:
	matrix map[string]map[string]Relations = map[string]map[string]Relations{}
}

fn (mut f Footprint) parse_eventlog(mut e Eventlog) {
	for x in e.activities{
		for y in e.activities {
			f.matrix[x][y] = .independency
		}
	}

	for _, mut t in e.traces {
		t.sort_events()

		for i:=1; i<t.events.len; i++ {
			x := t.events[i-1].activity
			y := t.events[i].activity
			f.matrix[x][y] = .direct_follow
		}
	}

	println(f.matrix)
}