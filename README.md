# request
[Löve](https://love2d.org) library to send asynchronous HTTPS requests to desired URLs.

## Installation
Download the repository and put it in a folder named `request`.
Then do,
```lua
local request = require "request"

function love.update(dt)
	request.update()
end
```

## Note
* This library currently requires a bleeding-edge version of löve that comes with [lua-https](https://github.com/love2d/lua-https).
You can grab such builds of löve from [here](https://github.com/love2d/love/actions/runs/1769672147) and [here for android](https://github.com/FlamingArr/love-android/actions/runs/1803015085).
* `love.thread` module must be enabled for asynchronous requests.

## Example: Fetch quotes
```lua
local request = require "request"
local quote = "Loading..."

request("https://api.quotable.io/random", function(response)
	quote = response:assert():table().content
end)

function love.draw()
	love.graphics.print(quote, 100, 100)
end

function love.update(dt)
	request.update()
end
```
## Example: Fetch cat images
```lua
local request = require "request"
local img

request("https://cataas.com/cat", function(response)
	local byteData = love.data.newByteData(response:assert().body)
	local imageData = love.image.newImageData(byteData)
	img = love.graphics.newImage(imageData)
end)

function love.draw()
	if img then 
		love.graphics.draw(img, 0, 0, 0, love.graphics.getWidth() / img:getWidth(), love.graphics.getHeight() / img:getHeight())
	else
		love.graphics.print("Loading...", 100, 100)
	end
end

function love.update(dt)
	request.update()
end
```

## Documentation
See [docs](docs.md)
