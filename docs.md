#### *@RootFunction* `request(url: string, [options: table], callback: function)`
Initiates an asynchronous HTTPS request to `url` and when a response is received, the `callback` is called with the relevent `Response` object as it's sole argument.

If `options` is given then it can have the following fields:
```lua
{
	method = "get" | "post"
	headers = {},
	data = ""
}
```

##### *@Method* `request.update()`
Checks if any of the pending requests has finished. This function should be called in `love.update`.

##### *@Method* `request.getPendingCount()`
Returns the number of requests currently pending.


#### *@Class* `Response`
##### *@Field* `code`
The status code.
##### *@Field* `body`
The response body.
##### *@Field* `headers`
The response headers.
##### *@Field* `ok`
True if `code` is in the 200-299 range, false otherwise.
##### *@Method* `:assert()`
Raises an error if `ok` is false, returns self.
##### *@Method* `:table()`
If `content` is JSON then returns a table represention of it.