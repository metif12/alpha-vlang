module main

[heap]
struct Place {
	inputs  []string
	outputs []string
}

fn (p Place) is_maximal(allplaces []Place) bool {
	for d in allplaces {
		if set_is_subset(p.inputs, d.inputs) {
			if set_is_subset(p.outputs, d.outputs) {
				return false
			}
		}
	}

	return true
}

fn (p Place) is_valid(f Footprint) bool {
	if p.inputs.len == 0 || p.outputs.len == 0 {
		return false
	}

	for a in p.inputs {
		for b in p.inputs {
			if a != b && f.matrix[a][b] != .independency {
				return false
			}
		}
	}

	for a in p.outputs {
		for b in p.outputs {
			if a != b && f.matrix[a][b] != .independency {
				return false
			}
		}
	}

	for a in p.inputs {
		for b in p.outputs {
			if f.matrix[a][b] != .causality {
				return false
			}
		}
	}

	return true
}
