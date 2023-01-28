module main

import rgbcube.eludris

fn main() {
	mut client := eludris.new_client('Goof')!

	client.on_message(fn [client] (message eludris.Message) ! {
		if message.content.to_lower().starts_with('!ping') {
			client.send_message('Pong!')!
		}
	})

	client.run()!
}
