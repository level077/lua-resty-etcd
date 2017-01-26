local v = require "lua-resty-etcd.test"
v.init({
        etcd_host = "127.0.0.1",
        etcd_port = 2379,
        etcd_path = "/xxxxx",
})
