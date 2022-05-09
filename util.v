module main

fn all_subsets(initial_set []string) [][]string {

	mut subsets := [][]string{}

	for i:=0; i<initial_set.len; i++{

		mut subset := []string{}

		subset << initial_set[i]

		subsets << subset.clone()

		for j:= i+1; j<initial_set.len; j++ {

			subset << initial_set[j]

			subsets << subset.clone()
		}
	}

	return subsets
}

fn is_subset(a []string, b[] string) bool {

	for item in a {
		if item !in b {
			return false
		}
	}

	return true
}