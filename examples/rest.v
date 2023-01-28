module main

import os
import rgbcube.eludris

fn main() {
	rest := eludris.new_rest_client('Goof', eludris.new_instance()!)

	for s in os.args[1..] {
		rest.send_message(s)!
	}
}
