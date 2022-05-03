module main

import os
import time
import encoding.csv

[heap]
struct Eventlog {
mut:
	traces map[string]Trace = map[string]Trace{}
	activities []string
}

fn (mut e Eventlog) get_case(id string) Trace{
	return e.traces[id] or {
		Trace{
			id: id
		}
	}
}

fn (mut e Eventlog) update_case(id string, t Trace){
	e.traces[id] = t
}

// fn (mut e Eventlog) load_cache(eventlog_path string) ? {

// 	content := os.read_file(eventlog_path) ?

// 	mut csv_reader := csv.new_reader(content)

// 	csv_reader.delimiter= `;`

// 	_ := csv_reader.read() ?

// 	for {
// 		cols := csv_reader.read() or { break }

// 		cid := cols[0]
// 		eid := cols[1]
// 		ett := cols[2]
// 		ets := time.parse(cols[3])?

// 		mut trace := e.get_case(cid)

// 		trace.add_event(Event{
// 			id: eid
// 			activity: ett
// 			time: ets
// 		})

// 		e.update_case(cid, trace)
// 	}
// }

fn build_eventlog(dataset_path string) ?Eventlog{

	mut e := Eventlog{}

	content := os.read_file(dataset_path) ?

	mut csv_reader := csv.new_reader(content)

	csv_reader.delimiter= `;`

	_ := csv_reader.read() ?

	for {
		cols := csv_reader.read() or { break }
		
		cid := cols[0]
		eid := cols[2]
		ett := cols[3]

		ets := time.Time{
			day: cols[1][0..2].int()
			month: cols[1][3..5].int()
			year: cols[1][6..10].int()
			hour: cols[1][11..13].int()
			minute: cols[1][14..16].int()
			second: cols[1][17..19].int()
		}

		mut trace := e.get_case(cid)

		trace.add_event(Event{
			id: eid
			activity: ett
			time: ets
		})

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

// fn (e Eventlog) write_cache(eventlog_path string) ? {

// 	mut csv_writer := csv.new_writer()

// 	csv_writer.delimiter= `;`

// 	csv_writer.write(['case_id', 'event_id', 'event_title', 'event_timestamp'])?

// 	for _,t in e.traces {
// 		for event in t.events {
// 			// mut row := []string{}
// 			// row << t.id // type string = string
// 			// row << event.id // type EventId = string
// 			// row << event.activity // type Activity = string
// 			// row << event.time.format() // string
// 			csv_writer.write([t.id, event.id, event.activity, event.time.format()])?
// 		}
// 	}

// 	os.write_file(eventlog_path, csv_writer.str()) ?
	
// }