-- Vita Backup Utility
--
-- by gnmmarechal

System.setCpuSpeed(444)

local version = "1.0.0"
local backupDir = "ux0:/data/vita-backup-utility"

local white = Color.new(255, 255, 255, 255)

-- Main Methods

function getBackupDir()
	h, m, s = System.getTime()
	dv, d, m, y = System.getDate()
	return backupDir.."/backup-"..y.."-"..m.."-".."d"
end

function copyFile(fileName, newFileName)
	if System.doesFileExist(fileName) then
		local fileStream = io.open(fileName, FCREATE)
		local content = io.read(fileStream, io.size(fileStream))
		local newFileStream = io.open(newFileName, FCREATE)
		io.write(newFileStream, content, io.size(fileStream))
		io.close(fileStream)
		io.close(newFileStream)
		return 0
	end
	return 1
end

function doScene(number)
	if number == 1 then
		Graphics.debugPrint(5, 5, "Vita Backup Utility v"..version, white)
		Graphics.debugPrint(5, 45, "X - Backup Files", white)
		if Controls.check(Controls.read(), SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
			scene = 2
			return
		end
		if Controls.check(Controls.read(), SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
			System.exit()
		end
	elseif number == 2 then
		Graphics.debugPrint(5, 5, "Backing up files...", white)
		scene = 3
		return
	elseif number == 3 then
		Graphics.debugPrint(5, 5, "Backing up files...", white)
		local backupPath = getBackupDir()
		-- Activation Files
		copyFile("tm0:/npdrm/act.dat", backupPath.."/tm0_npdrm_act.dat")
		copyFile("vd0:/registry/system.dreg", backupPath.."/vd0_registry_system.dreg")
		copyFile("vd0:/registry/system.ireg", backupPath.."/vd0_registry_system.ireg")
		-- Required for Remote Play
		copyFile("ur0:/user/00/np/myprofile.dat", backupPath.."/ur0_user_00_np_myprofile.dat")
		scene = 4
		return
	elseif number == 4 then
		Graphics.debugPrint(5, 5, "Finished Backup! Press X to return to the main menu")
		scene = 5		
		return
	elseif number == 5 then
		Graphics.debugPrint(5, 5, "Finished Backup! Press X to return to the main menu")
		Controls.check(Controls.read(), SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS) then
			scene = 1
			return		
		end
	end
end
-- Main Loop
local scene = 1
local running = true
local oldpad = Controls.read()
while running do
	Graphics.initBlend()
	Screen.clear()
	doScene(scene)
	Graphics.termBlend()	
	Screen.flip()
end
