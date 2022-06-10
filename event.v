module main

import time

[heap]
struct Event {
	id       string
	activity string
	time     time.Time
}

fn (a Event) is_same(b Event) bool {
	return a.activity == b.activity
}

fn cmp_events_time(a &Event, b &Event) int {
	if a.time < b.time {
		return 1
	}
	if a.time > b.time {
		return -1
	}

	if a.id < b.id {
		return -1
	}
	if a.id > b.id {
		return 1
	}

	return 0
}
