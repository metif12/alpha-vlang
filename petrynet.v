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
// 		inputs := place.inputs.join(', ')
// 		outputs := place.outputs.join(', ')

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


	mut candidate_places := []Place

	for x in e.activities{
		for y in e.activities {
			if f.matrix[x][y] == .causality {

				candidate_places << Place{inputs:[x], outputs:[y]}
			}
		}
	}

	mut generated := false

	for {

			candidate_place := candidate_places.pop()

			for place in candidate_places {

				if place.inputs == candidate_place.inputs {

					mut outputs := place.outputs
					for o in candidate_place.outputs {
						if o !in outputs { outputs << o }
					}

					candidate_places << Place{place.inputs, outputs}

					generated = true

					continue
				}

				if place.outputs == candidate_place.outputs {

					mut inputs := place.inputs
					for o in candidate_place.inputs {
						if o !in inputs { inputs << o }
					}
					
					candidate_places << Place{inputs, place.outputs}

					generated = true

					continue
				}
			}

			break
		}






	// candidate_sets := all_subsets(e.activities)

	// mut independent_sets := [][]string{}

	// independency_check:for candidate_set in candidate_sets {
 
	// 	for a in candidate_set {
	// 		for b in candidate_set {
	// 			if a != b && f.matrix[a][b] != .independency {
	// 				continue independency_check
	// 			}
	// 		}
	// 	}

	// 	independent_sets << candidate_set
	// }

	// mut candidate_places := []Place

	// for inputs in independent_sets {
	// 	causality_check: for outputs in independent_sets {

	// 		for a in inputs {
	// 			for b in outputs {

	// 				if f.matrix[a][b] != .causality {
	// 					continue causality_check
	// 				}
	// 			}
	// 		}

	// 		candidate_places << Place{inputs:inputs, outputs:outputs}
	// 	}
	// }

	println('candidate places len: ${candidate_places.len}')

	for {

		if candidate_places.len == 0 { break }

		place := candidate_places.pop()

		if place.is_redundant(candidate_places) { 
			println('redundant place found')
			continue 
		}

		p.places << place
	}

	println('candidate places len: ${p.places.len}')
	return p
}