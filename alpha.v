module main

import time

const (
	dataset_path = 'dataset.csv'
	result_path  = 'result.txt'
)

fn main() {
	sw := time.new_stopwatch()

	mut eventlog := build_eventlog(dataset_path)?
	mut footprint := build_footprint(mut eventlog)
	mut petrynet := build_petrynet(eventlog, footprint)
	mut result := build_result(eventlog, footprint, petrynet)

	write_result(result_path, result)?

	println('finished in  ${sw.elapsed().seconds()}s')
}
