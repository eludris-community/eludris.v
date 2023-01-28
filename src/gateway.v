module eludris

import net.websocket
import json
import time

const (
	ping_payload = json.encode(Payload{'PING'}) // Const to avoid encoding on every ping.
)

// Payload is the default gateway payload.
struct Payload {
	op string
}

// MessagePayload is the payload for a message.
struct MessagePayload {
	d Message
}

// new_gateway_client creates a new gateway client with the given instance.

pub fn new_gateway_client(instance &Instance) &GatewayClient {
	return GatewayClient{instance}
}

// GatewayClient is a WebSocket client for the Eludris gateway.
[noinit]
pub struct GatewayClient {
mut:
	on_message_listener fn (message &Message) = fn (_ &Message) {} // The message listener.
pub:
	instance &Instance // The instance the client will connected to.
}

// on_message sets the message listener for the gateway client.
pub fn (mut c GatewayClient) on_message(listener fn (message &Message)) {
	c.on_message_listener = listener
}

// handle_message handles a message from the gateway.
fn (c &GatewayClient) handle_message(message &websocket.Message) {
	data := message.payload.bytestr()

	match json.decode(Payload, data)!.op {
		'PONG' {}
		'MESSAGE_CREATE' {
			event := json.decode(MessagePayload, data)!
			spawn c.on_message_listener(event.d)
		}
	}
}

// ping_gateway pings the gateway every 30 seconds.
fn ping_gateway(mut ws websocket.Client) {
	for {
		ws.write_string(eludris.ping_payload)!
		time.sleep(30 * time.second)
	}
}

// run starts the gateway client. This will block until the client is closed.
pub fn (c &GatewayClient) run() ! {
	mut ws := websocket.new_client(c.instance.gateway_url)!

	ws.on_open_ref(ping_gateway)
	ws.on_message_ref(c.handle_message)

	ws.connect()!
	ws.listen()!
}
