module main

import os
import time

const dataset_path = 'dataset.csv'

fn parse() ?map[string]Trace {
	dataset := os.read_file(dataset_path) ?

	mut log := map[string]Trace{}

	lines := dataset.split('\n')

	cols_count := lines[1].trim_space().split(';').len

	for line in lines[1..] {
		cols := line.trim_space().split(';')

		if cols.len < cols_count {
			continue
		}

		cid := cols[0]
		ets := time.Time{
			day: cols[1][0..2].int()
			month: cols[1][3..5].int()
			year: cols[1][6..10].int()
			hour: cols[1][11..13].int()
			minute: cols[1][14..16].int()
			second: cols[1][17..19].int()
		}
		eid := cols[2]
		ett := cols[3]

		// for i,b in cols[1]{
		// 	println('$i:${b.ascii_str()}')
		// }
		// println(cols[1][10..13].int())
		// println(cols[1])
		// println(ets)

		// break

		mut tc := log[cid] or {
			Trace{
				case_id: cid
			}
		}

		ne := &Event{
			id: eid
			title: ett
			timestamp: ets
		}

		tc.add_event(ne)

		log[cid] = tc

		// todo: remove
		// if li > 100 {
		// 	break
		// }
	}

	return log
}
