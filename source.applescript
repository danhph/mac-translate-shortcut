-- AppleScript to translate selected text into Vietnamese using Google Translate (only Safari or Google Chrome)
-- Made by Danh Pham (danhph@outlook.com) at Jan 8, 2018
-- Updated at Jul 21, 2021: made it works with macOS 11.4

on run argv
    -- SETTINGS 
    set googleTranslate to "https://translate.google.com"
    set desLang to "vi"
    set defaultBrowser to null --  set null to get default browser 
    
    -- SCRIPT STARTS
    if defaultBrowser is equal to null then
		set defaultBrowser to do shell script "defaults read \\
	    	~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure \\
    		| awk -F'\"' '/http;/{print window[(NR)-1]}{window[NR]=$2}'"
		if defaultBrowser contains "chrome" then
			set defaultBrowser to "Google Chrome"
		else
    		set defaultBrowser to "Safari"
		end if
    end if
    
    set desURL to googleTranslate & "/#auto/" & desLang & "/" & item 1 of argv
    
    if defaultBrowser is equal to "Safari" then
        tell application "Safari"
            activate
            set windowCount to count of window
            
            -- Open new tab if Safari is not opened
            if windowCount is equal to 0 then
                make new document
            else
                -- Switch Google Translate tab if it is opened
                -- Repeat for Every Window
                repeat with x from 1 to windowCount
                    set tabCount to number of tabs in window x
                    
                    -- Repeat for Every Tab in Current Window
                    repeat with y from 1 to tabCount
                        -- Get Tab Name & URL
                        set tabURL to URL of tab y of window x
                        set theURL to tabURL as string
                        
                        -- Check if Google Translate is opened
                        if theURL contains "translate.google" then
                            set URL of tab y of window x to desURL
                            tell window x to set current tab to tab y
                            return
                        end if
                    end repeat
                end repeat
            end if
            tell front window
                set current tab to (make new tab with properties {URL:desURL})
                return
            end tell
        end tell
    end if
    
    if defaultBrowser is equal to "Google Chrome" then
        tell application "Google Chrome"
            activate
            set windowCount to count of window
            
            -- Open new tab if Chrome is not opened
            if windowCount is equal to 0 then
                make new window
            else
                -- Switch Google Translate tab if it is opened
                -- Repeat for Every Window
                repeat with x from 1 to windowCount
                    set tabCount to number of tabs in window x
                    
                    -- Repeat for Every Tab in Current Window
                    repeat with y from 1 to tabCount
                        -- Get Tab Name & URL
                        set tabURL to URL of tab y of window x
                        set theURL to tabURL as string
                        
                        -- Check if Google Translate is opened
                        if theURL contains "translate.google" then
                            set URL of tab y of window x to desURL
                            return
                        end if
                    end repeat
                end repeat
            end if
            tell front window
                make new tab with properties {URL:desURL}
                return
            end tell
        end tell
    end if
end run