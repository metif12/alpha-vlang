module main

fn set_all_subsets<T>(initial_set []T) [][]T {
	mut subsets := [][]T{}

	for i := 0; i < initial_set.len; i++ {
		mut subset := []T{}

		subset << initial_set[i]

		subsets << subset.clone()

		for j := i + 1; j < initial_set.len; j++ {
			subset << initial_set[j]

			subsets << subset.clone()
		}
	}

	return subsets
}

fn set_is_subset<T>(a []T, b []T) bool {
	for item in a {
		if item !in b {
			return false
		}
	}

	return true
}

fn set_is_equal<T>(a []T, b []T) bool {
	if a.len != b.len {
		return false
	}

	return set_is_subset(a, b)
}
