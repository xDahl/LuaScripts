--[[
	Just tesing tables, because shelves are overrated.
	Dad jokes aside, second Lua script.

	In researching tables, I came across some
	interesting behaviors and features.
	And a potential bug;
	Not in Lua, but a trap I could get myself into.
]]

local sep = function()
	print("\n-------------------------------------\n")
end


local foo = function()
	print('Foo()')
end

local mytable = {
	-- Array elements.
	11,22,33,

	-- Keys.
	[45] = 54,
	["Name"] = false,
	[3.14] = "Short PI",

	-- Keys to array table.
	["Array-Table"] = {
		33, 22, 11
	},

	-- Keys to map table.
	["Map-Table"] = {
		[4] = 44,
		[5] = 55,
		[6] = 66
	},

	-- More array elements.
	44,55,66,

	foo = foo, -- Same as: ["fun"] = foo,
	-- This is what allows us to use characters.
	-- We can also do:
	["bar"] = function()
		print("Bar()")
	end
}

local is_array = function(t)
	-- Argument isn't a table.
	if type(t) ~= 'table' then
		return false
	end

	-- Has length, probably an array.
	-- Note, this won't work on empty tables.
	if #t > 0 then
		return true
	end

	-- Nothing else for now to indicate that this is an array.
	return false
end

local is_map = function(t)
	-- Not a table.
	if type(t) ~= 'table' then
		return false
	end

	-- If we can access keys and values, then it's a map.
	for k, v in pairs(t) do
		return true
	end

	return false
end


-- Only prints the array elements in our table,
-- not the key&value pairs, for that we
-- would need iterate and count.
-- I don't understand why this is.
print('myTable has ' .. tostring(#mytable) .. ' array elements:')

for k, v in pairs(mytable) do
	-- Keys and array indexes are the same,
	-- an array index is a key, hence why
	-- we can iterate over everything in a table.
	-- The array order will be in the same order
	-- the array elements were added to the table,
	-- regardless of what keys were put inbetween.
	-- The keys can be in any order tho.

	print(string.sub(type(k), 1, 4) .. ' ' .. k .. ' =',
		string.sub(type(v), 1, 4), v)

	-- Wrote this for testing,
	-- wouldn't do this in actual scripts.
	if is_array(v) then
		for i = 1, #v do
			print('', 'Array:', i, v[i])
		end
	elseif is_map(v) then
		for k, v in pairs(v) do
			print('', 'Pairs:', k, v)
		end
	end
end

print() -- Print single newline.

-- Yeah, it has an array length and keys and values.
print('is_array(mytable) = ' .. tostring(is_array(mytable)))
print('is_map(mytable)   = ' .. tostring(is_map(mytable)))

-- Basic access stuff.
print('mytable["name"] = ' .. tostring(mytable["Name"]))
print('mytable["Array-Table"][2] = ' .. tostring(mytable["Array-Table"][2]))

-- Same thing:
mytable.foo()
mytable["foo"]()
mytable.bar()
mytable["bar"]()

--[[
	What I take from this is that arrays
	and maps are the same thing, but #table
	only works on index based keys.
	And that string keys can be accessed
	without [""], which is nice.
	Functions can be placed in tables
	directly.
]]


sep()


--[[
	There is no switch statement in Lua,
	but we could just use tables and keys...
	Yeah, lua REALLY likes its tables,
	quite flexible :o
]]

local switch_table = {
	[0] = function() print('Switch: 0') end,
	[1] = function() print('Switch: 1') end,
	[2] = function() print('Switch: 2') end,
}

local var = 1
switch_table[var]()


sep()


--[[
	So, if we manually index an array
	but add an element with automatic
	indexing, it will overwrite the
	first element.
	I'm not sure what's going on here.
	But I can imagine this could cause
	issues if missed.
]]


mytable = {[1] = 11, [2] = 22, [3] = 33, --[[ No manual key! ]] "overwritten"}

for k, v in pairs(mytable) do
	print(k, v)
end


sep()


--[[
	This is some really cool syntactic sugar.
	Although I do find it a bit confusing,
	not sure how one would do OOP with Lua;
	I think I will look into that next.
]]

account = {
	money = 500,
	foo = function(self)
		print(self.money .. "$")
	end,
	deposit = function(self, amt)
		self.money = self.money + amt
	end
}

function account:withdraw (amt)
	if amt <= self.money then
		self.money = self.money - amt
	end
end

-- Notice the semicolon and period:
account:foo()
account:withdraw(150)
account.withdraw(account, 150)
account.foo(account)

account.deposit(account, 50)
account.foo(account)

account:deposit(50)
account:foo()


sep()


--[[
	Optional arguments using tables :)
]]

optional = function(options)
	local tab = {}
	tab.number = options.number or 5  -- Default to 5.
	tab.string = options.string or "X" -- Default string.
	tab.func   = options.func or function(self)
		print(self.string .. " = " .. tostring(self.number))
	end

	tab.func(tab)
	-- Or: tab:func()
end

-- Any order is fine.
optional({string = "Y", number = 15,})
-- Replacing function :D
optional({ func = function(self) print(self.string, self.number) end })
