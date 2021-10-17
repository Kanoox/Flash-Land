local Jobs = {}
local LastTime = nil

function RunAtDay(d, h, m, cb)
	table.insert(Jobs, {
		d = d,
		h = h,
		m = m,
		cb = cb
	})
end
function RunAt(h, m, cb)
	--print('ok')
	table.insert(Jobs, {
		d = nil,
		h = h,
		m = m,
		cb = cb
	})
end

function GetTime()
	local timestamp = os.time()
	local d = os.date('*t', timestamp).wday
	local h = tonumber(os.date('%H', timestamp))
	local m = tonumber(os.date('%M', timestamp))
	return {d = d, h = h, m = m}
end

function OnTime(d, h, m)
	for i=1, #Jobs, 1 do
		if Jobs[i].d ~= nil and Jobs[i].d == d and Jobs[i].h == h and Jobs[i].m == m then
			Jobs[i].cb(d, h, m)
		elseif Jobs[i].d == nil and Jobs[i].h == h and Jobs[i].m == m then
			print('Running Cron job')
			Jobs[i].cb(d, h, m)
		end
	end
end

function Tick()
	local time = GetTime()

	if time.h ~= LastTime.h or time.m ~= LastTime.m then
		OnTime(time.d, time.h, time.m)
		LastTime = time
	end

	SetTimeout(60000, Tick)
end

LastTime = GetTime()

Tick()

AddEventHandler('cron:runAtDay', function(d, h, m, cb)
	RunAtDay(d, h, m, cb)
end)

AddEventHandler('cron:runAt', function(h, m, cb)
	RunAt(h, m, cb)
end)
