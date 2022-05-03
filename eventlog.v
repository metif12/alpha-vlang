module main

import os
import time
import encoding.csv

[heap]
struct Eventlog {
mut:
	traces map[string]Trace
}

fn (mut e Eventlog) get_case(case_id string) Trace{
	return e.traces[case_id] or {
		Trace{
			case_id: case_id
		}
	}
}

fn (mut e Eventlog) update_case(case_id string, t Trace){
	e.traces[case_id] = t
}

fn (mut e Eventlog) load_cache(eventlog_path string) ? {

	content := os.read_file(eventlog_path) ?

	mut csv_reader := csv.new_reader(content)

	csv_reader.delimiter= `;`

	_ := csv_reader.read() ?

	for {
		cols := csv_reader.read() or { break }
		
		cid := cols[0]
		eid := cols[1]
		ett := cols[2]
		ets := time.parse(cols[3])?
		
		mut trace := e.get_case(cid)

		trace.add_event(Event{
			id: eid
			title: ett
			time: ets
		})

		e.update_case(cid, trace)
	}
}

fn (e Eventlog) write_cache(eventlog_path string) ? {

	mut csv_writer := csv.new_writer()

	csv_writer.delimiter= `;`

	csv_writer.write(['case_id', 'event_id', 'event_title', 'event_timestamp'])?

	for _,t in e.traces {
		for event in t.events {
			csv_writer.write([t.case_id, event.id, event.title, event.time.format()])?
		}
	}

	os.write_file(eventlog_path, csv_writer.str()) ?
	
}