#Description
读取及监听etcd数据，同时将数据放入table中，etcd的key即table的key。如etcd中的key为/waf/blackip/1.1.1.1,则table中的key为t[/waf/black/1.1.1.1]。

#Usage
再次封装成一个module使用，如
```
local etcd = require "lua-resty-etcd.etcd"
local _M = {}
local handle
function _M.init(conf)
	handle = etcd:new(conf)
	local ok, err = handle:init()
	if not ok then
		return nil, err
	end
	return 1
end

function _M.status()
	return handle:status()
end

function _M.set_config(action,key,value)
	return handle:set_config(action,key,value)
end

return _M
```
编写init.lua, 用于启动nginx时启动nginx timer
```
local v = require "lua-resty-etcd.test"
v.init({
        etcd_host = "127.0.0.1",
        etcd_port = 2379,
        etcd_path = "/xxxx/",
})
```
然后配置nginx.conf
```
#nginx.conf
lua_package_path "/path/to/?.lua;;";
init_worker_by_lua_file "/path/to/init.lua";

server {
	server_name example.com;
	listen 80;
	location = /status {
		content_by_lua_block {
                	local test = require "lua-resty-etcd.test"
             		ngx.say(test:status())
                }
	}
	
	location = /config {
		content_by_lua_block {
                	local test = require "lua-resty-etcd.test"
                      	local args = ngx.req.get_uri_args()
                      	local res, err = test.set_config(args["action"],args["key"],args["value"])
                      	if not res then
                       		ngx.say(err)
                      	else
                            	ngx.say("ok")
                      	end
           	}
	}
}
```

#API
##new
```
v = etcd:new(conf)
```
conf是一个table，必须的参数为：
- etcd_host: etcd ip
- etcd_port: etcd port
- etcd_path: 不包含/v2/keys

##init
```
local ok, err = v:init()
if not ok then
	return nil, err
end
```
启动后台ngx.timer.at,读取数据及监听key

##status
```
local res, err = v:status()
if not res then
	return nil, err
end
return res
```
查看相关etcd数据

##set_config
```
local res, err = v:set_config(action,key,value)
if not res then
	return nil, err
end
```
参数为：
- action: PUT or DELETE
- key: etcd的key,不包含/v2/keys
- value: table类型

#Dependencies
- lua-resty-http: https://github.com/pintsized/lua-resty-http.git
