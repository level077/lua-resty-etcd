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
