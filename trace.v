module main

[heap]
struct Trace {
	case_id string
mut:
	events []&Event
}

fn (mut t Trace) add_event(e &Event) {
	t.events << e
	t.events.sort_with_compare(fn (a &&Event, b &&Event) int {
		if a.timestamp < b.timestamp {
			return 1
		}
		if a.timestamp > b.timestamp {
			return -1
		}

		if a.id < b.id {
			return -1
		}
		if a.id > b.id {
			return 1
		}

		return 0
	})
}
