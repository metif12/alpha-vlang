module main

import time

const dataset_path = 'dataset.csv'

const footprint_path = 'footprint.csv'

fn main() {
	sw := time.new_stopwatch()

	println('Reading dataset ...')
	mut eventlog := build_eventlog(dataset_path)?

	println('Build footprint matrix ...')
	mut footprint := build_footprint(mut eventlog)

	write_footprint(footprint_path, footprint)?

	println('Build petrynet ...')
	mut petrynet := build_petrynet(eventlog, footprint)

	println('finished in  ${sw.elapsed().seconds()}s')
}
