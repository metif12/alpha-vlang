module main

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

	for {
		if candidate_places.len == 0 {
			break
		}

		place := candidate_places.pop()

		if !place.is_maximal(candidate_places) {
			continue
		}

		p.places << place
	}

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
