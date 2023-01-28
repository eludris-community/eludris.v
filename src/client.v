module eludris

// new_client creates a new client with the given username and instance parameters.

pub fn new_client(username string, p InstanceParams) !&Client {
	instance := new_instance(p)!
	return &Client{
		GatewayClient: new_gateway_client(instance)
		RestClient: new_rest_client(username, instance)
	}
}

// Client is the client that is a combination of the gateway client and rest client.
[noinit]
pub struct Client {
	GatewayClient
	RestClient
}
