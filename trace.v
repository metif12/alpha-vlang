module main

[heap]
struct Trace {
	id string
mut:
	events []Event
}

fn (mut t Trace) sort_events() {
	t.events.sort_with_compare(cmp_events_time)
}

fn (mut t Trace) add_event(e Event) {
	for event in t.events {
		if event.is_same(e) {
			return
		}
	}

	t.events << e
}
