module eludris

import net.websocket
import json
import time

// MessageListenerFn is the type of a message listener.
pub type MessageListenerFn = fn (Message) !

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
	return &GatewayClient{
		instance2: instance
	}
}

// GatewayClient is a WebSocket client for the Eludris gateway.
[heap; noinit]
pub struct GatewayClient {
mut:
	on_message_listener MessageListenerFn = fn (_ Message) ! {}
pub mut:
	// Small hack: instance2 is used instead of instance because instance is used by Client.
	instance2 &Instance // The instance the client will connected to.
}

// on_message sets the message listener for the gateway client.
	pub fn (mut c GatewayClient) on_message(listener MessageListenerFn) {
	c.on_message_listener = listener
}

// handle_message handles a message from the gateway.
fn (c &GatewayClient) handle_message(mut _ websocket.Client, message &websocket.Message) ! {
	data := message.payload.bytestr()
	op := json.decode(Payload, data)!.op
	match op {
		'MESSAGE_CREATE' {
			spawn c.on_message_listener(json.decode(MessagePayload, data)!.d)
		}
		else {}
	}
}

// ping_gateway pings the gateway every 30 seconds.
fn ping_gateway(mut wsc websocket.Client) ! {
	spawn fn [mut wsc] () ! {
		for {
			wsc.write_string(eludris.ping_payload)!
			time.sleep(30 * time.second)
		}
	}()
}

// run starts the gateway client. This will block until the client is closed.
pub fn (c &GatewayClient) run() ! {
	mut ws := websocket.new_client(c.instance2.gateway_url)!

	ws.on_open(ping_gateway)
	ws.on_message(c.handle_message)

	ws.connect()!
	ws.listen()!
}
