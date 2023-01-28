module eludris

import net.http

// new_rest_client creates a new rest client.

pub fn new_rest_client(username string, instance &Instance) &RestClient {
	return &RestClient{
		username: username
		instance: instance
	}
}

// RestClient is the main struct which is used to communicate with the REST API.
[noinit]
pub struct RestClient {
	pub:
	username string
	instance &Instance // The instance to send messages to.
}

// SendMessageParams is a struct that contains the parameters for the send_message function.
pub struct SendMessageParams {
	author ?string // Overridable author name, defaults to the client's name.
}

// send_message sends a message to the instance.
pub fn (c &RestClient) send_message(content string, p SendMessageParams) ! {
	message := Message{
		author: p.author or { c.name }
		content: content
	}
	http.post(c.instance.api_url, message)!
}
