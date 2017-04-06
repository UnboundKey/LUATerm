currentUser = nil
local json = require("libraries/dkjson")
userinfo = io.open("Users.json", "r+")
Users = json.decode(userinfo:read("*a"))
userinfo:close()

programinfo = {
  name = "INDIE TERMINAL",
  version = "0.05 alpha",
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

commands = {

commands = function()
      print("\nCommands")
      print("<============================================================================>")

      for k, v in pairs(commands) do
        print(k)
      end
    end,

users = function()
      print("\nUsers")
      print("<============================================================================>")

      for k, v in pairs(Users) do
        print(k)
      end
    end,

  login = function()
    if currentUser == nil then
      ::Logon::
    print("Enter Name")
    local _username = io.read()
    if Users[_username] ~= nil then
      print("enter Password")
      local _password = io.read()
      if Users[_username].password == _password then
        user = _username
        print("<---------------------------------------------------------------------------->")
        print("You logged in as " .. _username)
        print("<---------------------------------------------------------------------------->")
        currentUser = _username
      else
        print("<---------------------------------------------------------------------------->")
        print("Password Incorrect")
        print("<---------------------------------------------------------------------------->")
      end
    else
      print("Usename Incorrect")
      goto Logon
    end
    else print("You are already logged in.")
    end
  end,

  createuser = function()
    ::CreateUserBegin::
    if checkPriv(1) then
    print("New Users Name")
    print("<============================================================================>")

    local _username = io.read()
    if Users[_username] == nil then
      print("New Users Password")
      print("<============================================================================>")

      local _password = io.read()
      ::typeSelection::
      print("What type of account are you creating")
      print("<============================================================================>")
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
      print("<============================================================================>")
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
    print("<---------------------------------------------------------------------------->")
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
   print("<---------------------------------------------------------------------------->")
   print("Succesfully Logged Out")
   print("<---------------------------------------------------------------------------->")
  end
 end,


info = function()
print(programinfo.name .. "\nVersion: " .. programinfo.version .. "\nCreated By " .. programinfo.creator)
end,

changelog = function() 
  local _file = io.open("README.md")
  _log = _file:read("*all")

   print("<---------------------------------------------------------------------------->")
   print(_log)
   print("<---------------------------------------------------------------------------->")
end
}

print("Welcome to " .. programinfo.name .. " (Created By: ".. programinfo.creator .. ")")
::readCMD::
input = string.lower(io.read())
if commands[input] ~= nil then
  commands[input]()
else
  print("Command does not exist")
end
goto readCMD
