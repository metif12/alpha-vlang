module main

import os
import time

const dataset_path = 'dataset.csv'

fn parse() ?map[string]Trace {
	dataset := os.read_file(dataset_path) ?

	mut log := map[string]Trace{}

	for li, line in dataset.split('\n')[1..] {
		row := line.trim_space().split(';')

		cid := row[0]
		ets := time.Time{
			day: row[1][0..2].int()
			month: row[1][3..5].int()
			year: row[1][6..10].int()
			hour: row[1][11..13].int()
			minute: row[1][14..16].int()
			second: row[1][17..19].int()
		}
		eid := row[2]
		ett := row[3]

		// for i,b in row[1]{
		// 	println('$i:${b.ascii_str()}')
		// }
		// println(row[1][10..13].int())
		println(row[1])
		println(ets)

		break

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
		if li > 100 {
			break
		}
	}

	return log
}
