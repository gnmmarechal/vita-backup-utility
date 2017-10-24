-- Vita Backup Utility
--
-- by gnmmarechal

System.setCpuSpeed(444)

local version = "1.0.0"

local white = Color.new(255, 255, 255, 255)
local yellow = Color.new(255, 255, 0)
local red = Color.new(255, 0, 0)
local oldpad = Controls.read()
local pad = Controls.read()
-- Main Methods
local scene = 1
System.createDirectory("ux0:/data")
System.createDirectory("ux0:/data/vita-backup-utility")
local backups = System.listDirectory("ux0:/data/vita-backup-utility")
local i = 1
function copyFile(input, output)
	if input == output then
		error("Input file is the same as output")
	end
	inp = io.open(input, FREAD)
	if System.doesFileExist(output) then
		System.deleteFile(output)
	end
	out = io.open(output,FCREATE)
	size = io.size(inp)
	io.write(out, io.read(inp, size), size)
	io.close(inp)
	io.close(out)
end

function menu()
	Graphics.debugPrint(5, 5, "Vita Backup Utility v"..version, white)
	Graphics.debugPrint(5, 45, "X - Backup Files", white)
	if Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS) then
		scene = 2
	end
	if Controls.check(pad, SCE_CTRL_CIRCLE) and not Controls.check(oldpad, SCE_CTRL_CIRCLE) then
		scene = 3
	end
end

function backup()
	if loop == nil then
		loop = 0
	end
	loop = loop + 1
	Graphics.debugPrint(5, 5, "Backing up files...", white)
	if (not backedUp) and (loop > 1) then
		if backupPath == nil then
			local h, m, s = System.getTime()
			local dv, d, m, y = System.getDate()		
			backupPath = "ux0:/data/vita-backup-utility/backup-"..y.."-"..m.."-"..d.."-"..h.."."..m.."."..s
			System.createDirectory(backupPath)
		end

		copyFile("tm0:/npdrm/act.dat", backupPath.."/tm0_npdrm_act.dat")
		copyFile("vd0:/registry/system.dreg", backupPath.."/vd0_registry_system.dreg")
		copyFile("vd0:/registry/system.ireg", backupPath.."/vd0_registry_system.ireg")
		-- Required for Remote Play
		copyFile("ur0:/user/00/np/myprofile.dat", backupPath.."/ur0_user_00_np_myprofile.dat")
		backedUp = true
	else
		Graphics.debugPrint(5, 20, "Finished backing up. Press START to go back.", white)
		if Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
			loop = nil
			backupPath = nil
			backedUp = false
			backups = System.listDirectory("ux0:/data/vita-backup-utility")
			scene = 1
		end
	end
end

function doRestore(name)
	
end

function restore()
	Graphics.debugPrint(5, 5, "Available Backups:", white)
	local y = 25
	for j, file in pairs(backups) do
		x = 5
		if j >= i and y < 960 then
			if i == j then
				color = red
				x = 10
			else
				color = white
			end
		end

		Graphics.debugPrint(x, y, file.name, color)
		y = y + 20
	end
	
	if Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS) then
		if backups[i].directory then
			doRestore(backups[i].name)
		end
	elseif Controls.check(pad, SCE_CTRL_UP) and not Controls.check(oldpad, SCE_CTRL_UP) then
		i = i - 1
	elseif Controls.check(pad, SCE_CTRL_DOWN) and not Controls.check(oldpad, SCE_CTRL_DOWN) then
		i = i + 1
	end
	if i > #backups then
		i = 1
	elseif i < 1 then
		i = #backups
	end
end

-- Main Loop

local running = true
local backedUp = false
while running do
	pad = Controls.read()
	Graphics.initBlend()
	Screen.clear()
	if scene == 3 then
		restore()
	elseif scene == 2 then
		backup()
	elseif scene == 1 then
		menu()
	end
	Graphics.termBlend()	
	Screen.flip()
	oldpad = pad
end
System.exit()
