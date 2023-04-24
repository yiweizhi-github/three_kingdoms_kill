local _class={}
 
function class(super)
	local class_type={}
	class_type.ctor=false
	class_type.super=super
	class_type.new=function(...) 
			local obj={}
			do
				local create
				create = function(c,...)
					if c.super then
						create(c.super,...)
					end
					if c.ctor then
						c.ctor(obj,...)
					end
				end
 
				create(class_type,...)
			end
			setmetatable(obj,{ __index=_class[class_type] })
			return obj
		end
	local vtbl={}
	_class[class_type]=vtbl
 
	setmetatable(class_type,{
		__newindex= function(t,k,v) vtbl[k]=v end,
		__index= function(t,k) return vtbl[k] end
	})
 
	if super then
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret=_class[super][k]
				if type(ret) == "table" then
					vtbl[k]=deep_copy(ret)
					return vtbl[k]
				else
					vtbl[k]=ret
					return ret -- 这里不能写成return vtbl[k]，否则ret为空时会死循环
				end
			end
		})
	end

	return class_type
end

function deep_copy(t)
	local t1 = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			t[k] = deep_copy(v)
		else
			t1[k] = v
		end
	end
	return t1
end