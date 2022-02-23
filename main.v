module main

import time

fn main() {
	println('Starting...')

	sw := time.new_stopwatch()

	_ := parse() ?
	// log := parse() ?

	// println(log)

	println('total time: ${sw.elapsed().seconds()}s')
}
