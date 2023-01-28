<div align="center">

<h1>eludris.v</h1>

[Docs](https://rgbcube.github.io/docs/eludris) | [Examples](https://github.com/eludris-community/eludris.v/tree/master/examples)

The V wrapper for Eludris.

</div>

## Installation

After doing these, you can use the module in your V programs by importing `rgbcube.eludris`.

### Via VPM

```bash
v install RGBCube.eludris
```

### Via Git

```bash
git clone https://github.com/eludris-community/eludris.v ~/.vmodules/rgbcube/eludris
```

## Examples

Here are some examples to get you started:

### Ping Pong Bot

```v
import rgbcube.eludris

mut client := eludris.new_client("Goof")

client.on_message(fn [client] (message eludris.Message) ! {
    if message.content.to_lower().starts_with("!ping") {
        client.send_message("Pong!")!
    }
})

client.run()!
```

### Gateway Client

```v
import rgbcube.eludris

mut gateway := eludris.new_gateway_client(eludris.new_instance()!)

gateway.on_message(fn [gateway] (message eludris.Message) ! {
    println("Received message from '${message.author}': ${message.content}")
    println("Selling message to the CCP...")
})

gateway.run()!
```

### REST Client

```v
import rgbcube.eludris

rest := eludris.new_rest_client('Goof', eludris.new_instance()!)

rest.send_message("Sent from my toaster which runs an executable every time i toast!")!
```

## License

```
MIT License

Copyright (c) 2023-present Eludris Community

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
