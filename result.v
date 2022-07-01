module main

import os

[heap]
struct Result {
	len_traces     int
	len_activities int
	len_places     int
	len_archs      int
	eventlog       &Eventlog
	footprint      &Footprint
	petrynet       &Petrynet
}

fn build_result(e &Eventlog, f &Footprint, p &Petrynet) Result {
	return Result{e.traces.len, e.activities.len, p.places.len, p.archs.len, e, f, p}
}

fn write_result(result_path string, r Result) ? {
	os.write_file(result_path, r.str())?
}
