module main

import time

const dataset_path = 'dataset.csv'
const eventlog_path = 'eventlog.csv'

fn main() {

	println('Reading dataset ...')

	sw := time.new_stopwatch()

	mut dataset := Dataset{}

	dataset.parse(dataset_path) ?

	mut eventlog := Eventlog{traces: dataset.traces}

	println('Writing eventlog cache ...')
	eventlog.write_cache(eventlog_path)?
	// eventlog.load_cache(eventlog_path)?
	
	println('finished in  ${sw.elapsed().seconds()}s')
}
