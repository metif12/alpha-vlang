module main

[heap]
struct Place {
	inputs []string
	outputs []string
}

fn (p Place) is_redundant(allplaces []Place) bool {

	for d in allplaces {
		if is_subset(p.inputs, d.inputs) {
			if is_subset(p.outputs, d.outputs) {

				return true
			}
		}
	}

	return false
}