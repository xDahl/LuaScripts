--[[
	This is my first Lua script
	(besides testing out the language).

	This Lua script tells me what's inside '_G' :)

	I noticed that there are tables inside of
	some of these members, but they reference
	each other in an infinite loop;
	so there is no point in recursively listing.
	...
	But, maybe not all of them do? :o

	After some further testing, I found out
	that you can write:
	if type(member) == 'table' then ... end
	but I don't know if that is more efficient,
	still learning after all.
]]

print_string = function(str)
	local fmt = ""

	-- Not the best or optimal way to do it.
	for i = 1, string.len(str) do
		local c = string.byte(str, i)

		if c < 0x20 or c > 127 then
			fmt = string.format("\\x%.2X", c)
		else
			fmt = string.format("%c", c)
		end

		io.write(fmt)
	end
end

-- Only pass false to this function.
foo = function(tab, ind) -- I prefer this style.
--function foo(tab, ind)
	-- name   is the name of member "utf8/os" etc.
	-- member is the member itself (can be string, function, etc).
	for name, member in pairs(tab) do
		-- Get the type of member.
		local _type = type(member)
		if string.match(_type, "function") then
			_type = string.sub(_type, 1, 4)
		end

		-- Indent if ind is true.
		if ind then
			io.write('\t')
		end

		io.write(_type .. '\t' .. name)

		-- List members of table.
		if string.match(_type, "table") -- Table found.
		-- _G contains itself, which is not worth listing.
		   and not string.match(name, "_G")
		-- Already indented, stop.
		-- (_G.package contains tables that references itself)
		   and ind == false then
			io.write('\n')
			foo(member, true)
		elseif string.match(_type, "string") then
			io.write(" = \"")
			print_string(member)
			io.write("\"\n")
		else
			-- Some other type, end line here.
			io.write('\n')
		end
	end
end

print("Listing Globals (_G):")
foo(_G, false)
