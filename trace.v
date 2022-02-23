module main

[heap]
struct Trace {
	case_id string
mut:
	events []&Event
}

fn (mut t Trace) sort_events() {
	t.events.sort_with_compare(cmp_events)
}

fn (mut t Trace) add_event(e &Event) {
	t.events << e
}
