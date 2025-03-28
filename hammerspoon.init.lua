hs.hotkey.bind({ "ctrl" }, "8", function()
  hs.eventtap.keyStroke({}, "F5")
end)

--[[
Configuration lives in ~/Library/LaunchAgents/com.local.KeyRemapping.plist
That plist is the way to do it so that your settings survive a reboot.
Example plist is commented at the end of this file.

If you want to make adjustments manually:
If you want the capslock, return, and tab functionality, run this command to set them all at the same time in terminal.
This hidutil command will set:
  tab             --> left_option
  return_or_enter --> left_control
  caps_lock       --> right_control
  
Copy the command inside ``` below to terminal and run it.
```
hidutil property --set '{"UserKeyMapping":[
            {
              "HIDKeyboardModifierMappingSrc": 0x70000002B,
              "HIDKeyboardModifierMappingDst": 0x7000000E2
            },
            {
              "HIDKeyboardModifierMappingSrc": 0x700000028,
              "HIDKeyboardModifierMappingDst": 0x7000000E0
            },
            {
              "HIDKeyboardModifierMappingSrc": 0x700000039,
              "HIDKeyboardModifierMappingDst": 0x7000000E4
            }
        ]}'
```
--]]

-- Have a tenkey when holding down alt/option
numKeyMap = {
  [0] = "space",
  [1] = "m",
  [2] = ",",
  [3] = ".",
  [4] = "j",
  [5] = "k",
  [6] = "l",
  [7] = "u",
  [8] = "i",
  [9] = "o",
  ['.'] = "/",
  ['-'] = "p"
}

for num, key in pairs(numKeyMap) do
  hs.hotkey.bind({ "alt" }, key, function()
    hs.eventtap.keyStrokes(tostring(num))
  end)
end

--[[
Sends "escape" if "caps lock" is held for less than .1 seconds, and no other keys are pressed.
Must have caps lock as control (effectively right_control) either by using hidutil or System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys
Must have return_or_enter set as left_control, run this command in terminal:
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000028,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'
Look at :h keycode in vim for more info
--]]

send_escape = false
last_mods = {}
control_key_timer = hs.timer.delayed.new(0.1, function()
    send_escape = false
end)

controlWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(evt)
    -- "local" makes the variable only exist in this scope and available for garbage collection
    local new_mods = evt:getFlags()
    if last_mods["ctrl"] == new_mods["ctrl"] then
        return false
    end
    if not last_mods["ctrl"] then
        last_mods = new_mods
        send_escape = true
        control_key_timer:start()
    else
        if send_escape then
            -- check if we're in neovim or the git commit window in vim-fugitive
            title = hs.window.focusedWindow():title()
            if title == "nvim" or title == "sleep" then
              -- check for right_control
              if evt:getKeyCode() == 62 then
                -- vim understands ^[ as Escape
                hs.eventtap.keyStroke({ "ctrl" }, "[")
              -- check for left_control
              elseif evt:getKeyCode() == 59 then
                -- vim understands ^M as Return
                hs.eventtap.keyStroke({ "ctrl" }, "M")
              end
            else
              if evt:getKeyCode() == 62 then 
                hs.eventtap.keyStroke({}, "escape")
              elseif evt:getKeyCode() == 59 then
                -- pass through shift if it's there
                if new_mods["shift"] then
                  hs.eventtap.keyStroke({ "shift" }, "return")
                else
                  hs.eventtap.keyStroke({}, "return")
                end
              end
            end
        end
        last_mods = new_mods
        control_key_timer:stop()
    end
    return false
end):start()

--[[
Sends "tab" if tab is held for less than .1 seconds, and no other keys are pressed.
Otherwise sets the option/alt flag to true
Must have tab set to be left_option by running this command in terminal:
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x70000002B,"HIDKeyboardModifierMappingDst":0x7000000E2}]}'
--]]

send_tab = false
prev_mods = {}
tab_timer = hs.timer.delayed.new(0.1, function()
    send_tab = false
end)

tabWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(evt)
    local new_mods = evt:getFlags()
    if prev_mods["alt"] == new_mods["alt"] then
        return false
    end
    if not prev_mods["alt"] then
        prev_mods = new_mods
        send_tab = true
        tab_timer:start()
    else
        if send_tab then
            title = hs.window.focusedWindow():title()
            if title == "nvim" or title == "sleep" then
              -- vim understands ^I as tab
              hs.eventtap.keyStroke({ "ctrl" }, "I")
            else
              if new_mods["cmd"] then
                hs.eventtap.keyStroke({ "cmd" }, "tab")
              else
                hs.eventtap.keyStroke({}, "tab")
              end
            end
        end
        prev_mods = new_mods
        tab_timer:stop()
    end
    return false
end):start()

--[[ Example plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyRemapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[
            {
              "HIDKeyboardModifierMappingSrc": 0x70000002B,
              "HIDKeyboardModifierMappingDst": 0x7000000E2
            },
            {
              "HIDKeyboardModifierMappingSrc": 0x700000028,
              "HIDKeyboardModifierMappingDst": 0x7000000E0
            },
            {
              "HIDKeyboardModifierMappingSrc": 0x700000039,
              "HIDKeyboardModifierMappingDst": 0x7000000E4
            }
        ]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
--]]
