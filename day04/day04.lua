required_keys = {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"}
optional_keys = {"cid",}

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function contains_required_fields(pp)
    local valid = 1
    for _, key in pairs(required_keys) do
        if has_value(pp, key) == false then
            print("Missing Key: " .. key)
            valid = 0
            break
        end
    end
    for _, key in pairs(pp) do
        if ((has_value(required_keys, key) == false) and (has_value(optional_keys, key) == false)) then
            print("Surplus key: " .. key)
            valid = 0
        end
    end
    if valid == 1 then
        print("Found Valid Entry!")
        return 1
    end
end

--byr (Birth Year) - four digits; at least 1920 and at most 2002.
function validate_byr(entry)
    if #entry ~= 4 then return false end
    local num = tonumber(entry)
    if num == nil then return false end
    if ((num < 1920) or (num > 2002)) then return false end
    return true
end

--iyr (Issue Year) - four digits; at least 2010 and at most 2020.
function validate_iyr(entry)
    if #entry ~= 4 then return false end
    local num = tonumber(entry)
    if num == nil then return false end
    if ((num < 2010) or (num > 2020)) then return false end
    return true
end

--eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
function validate_eyr(entry)
    if #entry ~= 4 then return false end
    local num = tonumber(entry)
    if num == nil then return false end
    if ((num < 2020) or (num > 2030)) then return false end
    return true
end

--hgt (Height) - a number followed by either cm or in:
--    If cm, the number must be at least 150 and at most 193.
--    If in, the number must be at least 59 and at most 76.
function validate_hgt(entry)
    if #entry < 2 then return false end
    local num = tonumber(string.sub(entry, 1, #entry - 2))
    if num == nil then return false end
    local unit = string.sub(entry, -2)
    if unit == "cm" then
        if ((num < 150) or (num > 193)) then return false end
    elseif unit == "in" then
        if ((num < 59) or (num > 76)) then return false end
    else
        return false
    end
    return true
end

--hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
function validate_hcl(entry)
    if #entry ~= 7 then return false end
    if string.match(entry, "^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]$") == false then
        return false
    end
    return true
end

--ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
function validate_ecl(entry)
    local valid_ecls = {"amb", "blu", "brn", "gry", "grn", "hzl", "oth"}
    if has_value(valid_ecls, entry) == false then
        return false
    end
    return true
end

--pid (Passport ID) - a nine-digit number, including leading zeroes.
function validate_pid(entry)
    if #entry ~= 9 then return false end
    if string.match(entry, "^%d%d%d%d%d%d%d%d%d$") == false then
        return false
    end
    return true
end

--cid (Country ID) - ignored, missing or not.
function validate_cid(entry)
    return true
end


--byr (Birth Year) - four digits; at least 1920 and at most 2002.
--iyr (Issue Year) - four digits; at least 2010 and at most 2020.
--eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
--hgt (Height) - a number followed by either cm or in:
--    If cm, the number must be at least 150 and at most 193.
--    If in, the number must be at least 59 and at most 76.
--hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
--ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
--pid (Passport ID) - a nine-digit number, including leading zeroes.
--cid (Country ID) - ignored, missing or not.

function validate_entry(key, entry)
    if key == "byr" then
        return validate_byr(entry)
    elseif key == "iyr" then
        return validate_iyr(entry)
    elseif key == "eyr" then
        return validate_eyr(entry)
    elseif key == "hgt" then
        return validate_hgt(entry)
    elseif key == "hcl" then
        return validate_hcl(entry)
    elseif key == "ecl" then
        return validate_ecl(entry)
    elseif key == "pid" then
        return validate_pid(entry)
    elseif key == "cid" then
        return true
    else
        return false
    end
end

function check_valid_entries(input_file)
    local valid_entries = 0
    local current_keys = {}
    for line in io.lines(input_file) do
        -- print(line)
        if #line == 0 then
            print("--- chunk end ---")
            if contains_required_fields(current_keys) then
                valid_entries = valid_entries + 1
            end
            for k,v in pairs(current_keys) do current_keys[k]=nil end
        end
        local parts = mysplit(line, nil)
        for _, part in pairs(parts) do
            k_v = mysplit(part, ":")
            local key = k_v[1]
            local value = k_v[2]
            if validate_entry(key, value) == true then
                table.insert(current_keys, k_v[1])
            else
                print("Invalid Entry: " .. key .. ":" .. value)
                table.insert(current_keys, "<invalid>")
            end
        end
    end
    if contains_required_fields(current_keys) then
        valid_entries = valid_entries + 1
    end
    return valid_entries
end

valid_demo_entries = check_valid_entries('demo.txt')
print("Valid Demo Entries: " .. valid_demo_entries)

valid_real_entries = check_valid_entries('input.txt')
print("Valid Real Entries: " .. valid_real_entries)