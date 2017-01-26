local etcd = require "lua-resty-etcd.etcd"
local _M = {}
function _M.init(conf)
	_M.handle = etcd:new(conf)
	local ok, err = _M["handle"]:init()
	if not ok then
		return nil, err
	end
	return 1
end

function _M.status()
	return _M["handle"]:status()
end

function _M.set_config(action,key,value)
	return _M["handle"]:set_config(action,key,value)
end

return _M
