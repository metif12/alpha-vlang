module main

import time

const dataset_path = 'dataset.csv'
const footprint_path = 'footprint.csv'

fn main() {

	sw := time.new_stopwatch()

	mut eventlog := Eventlog{}

	println('Reading dataset ...')
	eventlog.parse_dataset(dataset_path)?

	mut footprint := Footprint{}

	println('Make footprint matrix ...')
	footprint.parse_eventlog(mut eventlog)

	write_footprint(footprint_path, footprint)?
	
	println('finished in  ${sw.elapsed().seconds()}s')
}
