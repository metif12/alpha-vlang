module main

import os

struct InpArch {
	from  string
	place Place
}

struct OutArch {
	to    string
	place Place
}

type Arch = InpArch | OutArch

[heap]
struct Petrynet {
mut:
	start_activities []string
	end_activities   []string
	places           []Place
	archs            []Arch
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
		end_act := t.events[t.events.len - 1].activity

		if start_act !in p.start_activities {
			p.start_activities << start_act
		}

		if end_act !in p.end_activities {
			p.end_activities << end_act
		}
	}

	// mut candidate_places := []Place{}

	// for x in e.activities {
	// 	for y in e.activities {
	// 		if f.matrix[x][y] == .causality {
	// 			candidate_places << Place{
	// 				inputs: [x]
	// 				outputs: [y]
	// 			}
	// 		}
	// 	}
	// }

	// for {
	// 	mut exit_cnd := true

	// 	for p1 in candidate_places {
	// 		for p2 in candidate_places {
	// 			if set_is_equal(p1.inputs, p2.inputs) || set_is_equal(p1.outputs, p2.outputs) {
	// 				mut inps := p1.inputs
	// 				mut outs := p1.outputs

	// 				for i in p2.inputs {
	// 					if i !in inps {
	// 						inps << i
	// 					}
	// 				}

	// 				for o in p2.outputs {
	// 					if o !in outs {
	// 						inps << o
	// 					}
	// 				}

	// 				c := Place{inps, outs}

	// 				if c.is_valid(f) {
	// 					candidate_places << c
	// 					exit_cnd = false
	// 				}
	// 			}
	// 		}
	// 	}

	// 	if exit_cnd {
	// 		break
	// 	}
	// }

	candidate_sets := set_all_subsets(e.activities)

	mut independent_sets := [][]string{}

	independency_check: for candidate_set in candidate_sets {
		for a in candidate_set {
			for b in candidate_set {
				if a != b && f.matrix[a][b] != .independency {
					continue independency_check
				}
			}
		}

		independent_sets << candidate_set
	}

	mut candidate_places := []Place{}

	for inputs in independent_sets {
		causality_check: for outputs in independent_sets {
			for a in inputs {
				for b in outputs {
					if f.matrix[a][b] != .causality {
						continue causality_check
					}
				}
			}

			candidate_places << Place{inputs, outputs}
		}
	}

	// println('candidate places len: $candidate_places.len')

	for {
		if candidate_places.len == 0 {
			break
		}

		place := candidate_places.pop()

		if !place.is_maximal(candidate_places) {
			// println('redundant place found')
			continue
		}

		p.places << place
	}

	println('candidate places len: $p.places.len')

	p.places << Place{[], p.start_activities} // iL
	p.places << Place{p.start_activities, []} // oL

	for place in p.places {
		for inp in place.inputs {
			p.archs << InpArch{inp, place}
		}
		for oup in place.outputs {
			p.archs << OutArch{oup, place}
		}
	}
	return p
}

fn write_petrynet(petrynet_path string, p Petrynet) ? {
	os.write_file(petrynet_path, p.str())?
}
