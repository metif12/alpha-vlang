module main

import os
import time
import encoding.csv

[heap]
struct Eventlog {
mut:
	traces     map[string]Trace = map[string]Trace{}
	activities []string
}

fn (mut e Eventlog) get_case(id string) Trace {
	return e.traces[id] or {
		Trace{
			id: id
		}
	}
}

fn (mut e Eventlog) update_case(id string, t Trace) {
	e.traces[id] = t
}

fn build_eventlog(dataset_path string) ?Eventlog {
	mut e := Eventlog{}

	content := os.read_file(dataset_path)?

	mut csv_reader := csv.new_reader(content)

	csv_reader.delimiter = `;`

	_ := csv_reader.read()? //ignore header

	for {
		cols := csv_reader.read() or { break } //break when EOF reached

		cid := cols[0] //case id
		eid := cols[2] //event id
		ett := cols[3] //event name

		ets := time.Time{
			day: cols[1][0..2].int()
			month: cols[1][3..5].int()
			year: cols[1][6..10].int()
			hour: cols[1][11..13].int()
			minute: cols[1][14..16].int()
			second: cols[1][17..19].int()
		}

		mut trace := e.get_case(cid)
		mut event := Event{
			id: eid
			activity: ett
			time: ets
		}

		trace.add_event(event)

		if ett !in e.activities {
			e.activities << ett
		}

		e.update_case(cid, trace)
	}

	for _, mut t in e.traces {
		t.sort_events()
	}

	return e
}
