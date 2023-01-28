module eludris

import net.http
import json

// InstanceParams is a struct that contains the parameters for creating a new instance.
[params]
pub struct InstanceParams {
	api_url string = 'https://eludris.tooty.xyz'
}

// new_instance creates a new instance from the given parameters.

pub fn new_instance(p InstanceParams) !&Instance {
	response := http.get(p.api_url)!

	if response.status_code > 299 || response.status_code < 200 {
		return error('instance info request failed')
	}

	instance := json.decode(Instance, response.body)!
	return &instance
}

// Instance is a struct that contains information about an instance.
[heap; noinit]
pub struct Instance {
	api_url     string [json: 'oprish_url']
	gateway_url string [json: 'pandemonium_url']
	cdn_url     string [json: 'effis_url']
pub:
	name               string [json: 'instance_name']
	description        string
	version            string
	message_size_limit u64    [json: 'message_limit']
	file_size_limit    u64    [json: 'file_size']
}
