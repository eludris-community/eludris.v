module main

import rgbcube.eludris

fn main() {
	mut gateway := eludris.new_gateway_client(eludris.new_instance()!)

	gateway.on_message(fn [gateway] (message eludris.Message) ! {
		println("Received message from '${message.author}': ${message.content}")
		println('Selling message to the CCP...')
	})

	gateway.run()!
}
