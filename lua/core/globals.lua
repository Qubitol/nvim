P = function(v)
	print(vim.inspect(v))
	return v
end

RELOAD = function(...)
	local status_plenary_reload, plenary_reload = pcall(require, "plenary.reload")
	local reloader = require
	if status_plenary_reload then
		reloader = plenary_reload.reload_module
	end

	return reloader(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end
