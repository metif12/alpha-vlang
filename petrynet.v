module main

import arrays

[heap]
struct Petrynet {
mut:
	start_activities []string
	end_activities []string
	places []Place
}

// fn write_places(places_path string, p Petrynet) ? {

// 	mut csv_writer := csv.new_writer()

// 	csv_writer.delimiter= `;`

// 	csv_writer.write(['inputs', 'outputs'])?

// 	for place in p.places {
// 		inputs := 

// 		csv_writer.write([inputs, outputs])?

// 	}

// 	os.write_file(places_path, csv_writer.str()) ?
// }

fn build_petrynet(e Eventlog, f Footprint) Petrynet {

	mut p := Petrynet{}

	for _, t in e.traces {

		start_act := t.events[0].activity
		end_act := t.events[t.events.len-1].activity

		if start_act !in p.start_activities {
			p.start_activities << start_act
		}

		if end_act !in p.end_activities {
			p.end_activities << end_act
		}
	}







	candidate_sets := all_subsets(e.activities)

	mut independent_sets := [][]string{}

	independency_check:for candidate_set in candidate_sets {
 
		for a in candidate_set {
			for b in candidate_set {
				if a != b && f.matrix[a][b] != .independency {
					continue independency_check
				}
			}
		}

		independent_sets << candidate_set
	}

	for inputs in independent_sets {
		causality_check: for outputs in independent_sets {

			for a in inputs {
				for b in outputs {

					if f.matrix[a][b] != .causality {
						continue causality_check
					}
				}
			}

			p.places << Place{inputs:inputs, outputs:outputs}
		}
	}

	return p
}