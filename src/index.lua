-- Vita Backup Utility
--
-- by gnmmarechal

System.setCpuSpeed(444)

local version = "1.0.0"

local white = Color.new(255, 255, 255, 255)
local oldpad = Controls.read()
-- Main Methods
local scene = 1
System.createDirectory("ux0:/data")
System.createDirectory("ux0:/data/vita-backup-utility")

function copyFile(input, output)
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
	if Controls.check(Controls.read(), SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS) then
		scene = 2
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
		if Controls.check(Controls.read(), SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
			loop = nil
			backupPath = nil
			backedUp = false
			scene = 1
		end
	end
end

function restore()
	Graphics.debugPrint(5, 5, "Available Backups:", white)
	
end

-- Main Loop

local running = true
local backedUp = false
while running do
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
end
System.exit()
