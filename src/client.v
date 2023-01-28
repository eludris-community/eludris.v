module eludris

// new_client creates a new client with the given username and instance.

pub fn new_client(username string, p InstanceParams) !&Client {
	instance := new_instance(p)!

	mut client := &Client{}

	client.GatewayClient.instance = instance
	client.RestClient.instance = instance
	client.RestClient.username = username

	return client
}

// Client is the client that is a combination of the gateway client and rest client.
[noinit]
pub struct Client {
	GatewayClient
	RestClient
}
