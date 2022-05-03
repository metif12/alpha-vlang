module main

[heap]
struct Petrynet {
mut:
	matrix map[string]map[string]Relations = map[string]map[string]Relations{}
	activities []string
	start_activities []string
	end_activities []string
	places []Place
}

fn build_petrynet(e Eventlog, f Footprint) Petrynet {

	mut p := Petrynet{activities: e.activities}

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







	candidate_sets := all_subsets(p.activities)

	mut independent_sets := [][]string{}

	l1:for candidate_set in candidate_sets {

		for a in candidate_set.clone() {
			for b in candidate_set.clone(){
				if a != b && f.matrix[a][b] != .independency {
					continue l1
				}
			}
		}

		independent_sets << candidate_set
	}

	for inputs in independent_sets.clone() {
		l2: for outputs in independent_sets.clone() {

			for a in inputs {
				for b in outputs {

					if f.matrix[a][b] !in [.left, .right] {
						continue l2
					}
				}
			}

			p.places << Place{inputs:inputs, outputs:outputs}
		}
	}

	println(p.places)

	return p
}