module main

import time

[heap]
struct Event {
	id        string
	title     string
	timestamp time.Time
}

fn cmp_events(a &&Event, b &&Event) int {
	if a.timestamp < b.timestamp {
		return 1
	}
	if a.timestamp > b.timestamp {
		return -1
	}

	// println('equal timestamp!')

	if a.id < b.id {
		return -1
	}
	if a.id > b.id {
		return 1
	}

	return 0
}
