module main

import os
import time
import encoding.csv

[heap]
struct Dataset {
mut:
	traces map[string]Trace
}

fn (mut d Dataset) get_case(case_id string) Trace{
	return d.traces[case_id] or {
		Trace{
			case_id: case_id
		}
	}
}

fn (mut d Dataset) update_case(case_id string, t Trace){
	d.traces[case_id] = t
}

fn (mut d Dataset) parse(dataset_path string) ? {

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

		mut trace := d.get_case(cid)

		trace.add_event(Event{
			id: eid
			title: ett
			time: ets
		})

		d.update_case(cid, trace)
	}
}
