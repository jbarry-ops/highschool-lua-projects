--matrices.lua

local function pMat(m) --print matrix
	for _, row in pairs(m) do
		print(table.concat(row, " "))
	end
end
local function add(m1, m2)
	local m3 = {}
	for r = 1, #m1 do
		local row = {}
		for c = 1, #m1[1] do
			table.insert(row, m1[r][c]+m2[r][c])
		end
		table.insert(m3, row)
	end
	return m3
end
local function sub(m1, m2)
	local m3 = {}
	for r = 1, #m1 do
		local row = {}
		for c = 1, #m1[1] do
			table.insert(row, m1[r][c]-m2[r][c])
		end
		table.insert(m3, row)
	end
	return m3
end
local function mult(m1, m2)
	local x1, y1, x2 = #m1[1], #m1, #m2[1]
	--y2 = x1 (or else the matrices are not multiplicable)
	local m3 = {}
	for r = 1, y1 do
		local row = {}
		for c = 1, x2 do
			local sum = m1[r][1]*m2[1][c]
			for w = 2, x1 do
				sum = sum+m1[r][w]*m2[w][c]
			end
			table.insert(row, sum)
		end
		table.insert(m3, row)
	end
	return m3
end
local function m(m1, n)
	local m2 = {}
	for r = 1, #m1 do
		local row = {}
		for c = 1, #m1[1] do
			table.insert(row, m1[r][c]*n)
		end
		table.insert(m2, row)
	end
	return m2
end



t = {
	{1, 2, 3},
	{4, 5, 6},
	{7, 8, 9}
}
i3 = {
	{1, 0, 0},
	{0, 1, 0},
	{0, 0, 1}
}

pMat(mult(t, i3))