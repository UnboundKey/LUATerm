currentUser = nil
local json = require("libraries/dkjson")
userinfo = io.open("Users.json", "r+")
Users = json.decode(userinfo:read("*a"))
userinfo:close()

os.execute("clear")

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end


programinfo = {
	name = "TERMINAL7",
	version = "0.1.1 Alpha",
	creator = "Benjamin Nordin"
}

accounttypes = {
	normal = 0,
	admin = 1,
	root = 2,
}

function saveUserData()
	local wf = io.open("Users.json", "w+")
	wf:write(json.encode(Users))
	wf:close()
end

function checkPriv(privlevel)
	if currentUser == nil then
		return 0 >= privlevel
	else
	return Users[currentUser].acounttype >= privlevel
end
end

function printDivider()
	print("<" .. string.rep("=",tonumber(os.capture("tput cols", false) - 2)) .. ">")
end

commands = {

commands = function()
			print("\nCommands")
			printDivider()

			for k, v in pairs(commands) do
				print(k)
			end
		end,

users = function()
			print("\nUsers")
			printDivider()

			for k, v in pairs(Users) do
				print(k)
			end
		end,

	login = function(username)
		if currentUser == nil then
			 if username then
				 _username = username
			 else
				 print("enter name")
				 _username = io.read()
			 end
		if Users[_username] ~= nil then
			print("enter Password")
			local _password = io.read()
			if Users[_username].password == _password then
				user = _username
				printDivider()
				print("You logged in as " .. _username)
				printDivider()
				currentUser = _username
			else
				printDivider()
				print("Password Incorrect")
				printDivider()
			end
		else
			print("enter Password")
			io.read()
		end
		else print("You are already logged in.")
		end
	end,

	createuser = function()
		::CreateUserBegin::
		if checkPriv(1) then
		print("New Users Name")
		printDivider()

		local _username = io.read()
		if Users[_username] == nil then
			print("New Users Password")
			printDivider()

			local _password = io.read()
			::typeSelection::
			print("What type of account are you creating")
			printDivider()
			print("Normal" .. "\nAdmin")

			local _type = io.read()
			if accounttypes[string.lower(_type)] ~= nil then
				_type = accounttypes[_type]
			end

			Users[_username] = {
				password = _password,
				acounttype = _type
			}
			saveUserData()
			printDivider()
			print("User ".._username.." Sucessfully created.")
		else
				print("User already exists")
				goto CreateUserBegin
		end
	else
		print("You dont have permission to use this command")
	end
	end,

	deleteuser = function()
		if checkPriv(1) then
		printDivider()
		print("User to delete: ")
		local _username = io.read()
		if Users[_username] ~= nil then
			print("Are you sure? (Y/N)")
			local _input = io.read()
			if _input == "y" or _input == "Y" then
				print(_username .. "'s" .. " password")
				local _password = io.read()
				if _password == Users[_username].password then
					Users[_username] = nil
					saveUserData()
					print("User Succesfully deleted")
					else print("wrong password entered")
				end
			end
		else
			print("This user does not exist. It may have been deleted in the past or never existed in the first place.")
		end
	else
		print("YOU DO NOT HAVE ACCESS TO THIS COMMAND")
	end
	end,

	whoami = function()
		if currentUser ~= nil then
		print("You are: " .. currentUser .. " \n Acount Type:" .. Users[currentUser].acounttype)
	else
		print("You’re no one")
	end
end,

 logout = function()
	 if currentUser ~= nil then
	 currentUser = nil
	 printDivider()
	 print("Succesfully Logged Out")
	 printDivider()
	end
 end,


info = function()
print(programinfo.name .. "\nVersion: " .. programinfo.version .. "\nCreated By " .. programinfo.creator)
end,

changelog = function()
	local _file = io.open("README.md")
	_log = _file:read("*all")

	 printDivider()
	 print(_log)
	 printDivider()
end,

clear = function()
	os.execute("clear")
	print("Welcome to " .. programinfo.name .. " (Created By: ".. programinfo.creator .. ")")
end
}

print("Welcome to " .. programinfo.name .. " (Created By: ".. programinfo.creator .. ")")
::readCMD::
local jas = io.read()
cmd, input = string.match(string.lower(jas), "(%S+) (.*)")
cmd = cmd or jas
if commands[cmd] ~= nil then
	commands[cmd](input)
else
	print("Command does not exist")
end
goto readCMD
