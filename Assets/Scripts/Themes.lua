--!Type(Module)

-- Define the themes
themes = {
    "defaultTheme"
}

-- We'll keep an index to know which theme to return next
currentIndex = 1

function ShuffleThemes()
    math.randomseed(os.time())
    local n = #themes
    for i = n, 2, -1 do
        local j = math.random(1, i)
        themes[i], themes[j] = themes[j], themes[i]
    end
end

function GetTheme()
    -- Set random seed (typically once per session, not every call)
    math.randomseed(os.time())

    -- Get the current theme
    local theme = themes[currentIndex]

    -- Move to the next index
    currentIndex = currentIndex + 1

    -- If we've reached the end of the table, shuffle and reset the index
    if currentIndex > #themes then
        ShuffleThemes()
        currentIndex = 1
    end

    print("Returning theme: " .. theme)
    return theme
end