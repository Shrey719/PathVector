math.randomseed(os.time())

-- graph 'class' 
function Graph(dimensions) 
    local obj = {}

    -- stores 'string':'table'
    -- for example a key of 'hello' to a value of {0.5, 0.1, 0.3, 0.5}
    obj.map = {}
    obj.dimensions = dimensions

    -- see comments for obj.map
    function obj:set(key, value)
        if #value ~= dimensions then
            print("[ERROR]: Attempted to set a point where value did not match dimensions (Graph:set). Exiting function")
            return;
        end
        self.map[key] = value
    end

    function obj:get(key) 
        return self.map[key]
    end

    function obj:linearDistance(key1str, key2str) 
        local key1 = self:get(key1str)
        local key2 = self:get(key2str) 
        if #key1 ~= #key2 then
            print("[ERROR]: Attempted to find the linear distance between two points with different dimensions. Exiting function, please stop.")
            return
        end
        
        local sum = 0
        for i = 1, #key1 do
            local diff = key2[i] - key1[i] 
            sum = sum + diff * diff
        end 
        return math.sqrt(sum)
    end

    function obj:serialize()
        local parts = {}
        for k,v in pairs(self.map) do
            local vs = table.concat(v, ";")  
            table.insert(parts, k .. ":" .. vs)
        end
        return table.concat(parts, ",")
    end
    function obj:deserialize(s)
        self.map = {}
        for pair in s:gmatch("[^,]+") do
            local k, vs = pair:match("([^:]+):(.+)")
            if k and vs then
                local vec = {}
                for n in vs:gmatch("[^;]+") do
                    table.insert(vec, tonumber(n))
                end
                self.map[k] = vec
            end
        end
    end
    -- query: a string (no spaces, single word)
    -- random: boolean, if true, will add a random number to every vector distance
    function obj:closest(query, random)
        local bestWord, bestDist = nil, math.huge
        local qVec = self:get(query)
        if not qVec then return nil end

        for word, vec in pairs(self.map) do
            -- goto's usually make spaghetti, so just note that ::skip:: is located at the end of this for loop
            if word == query then goto skip end
            local dist = 0
            for i = 1, #vec do
                local diff = vec[i] - qVec[i]
                if random == true then
                    dist = dist + diff * diff + math.sqrt(math.random())/10
                else dist = dist + diff * diff

                end 
            end
            if dist < bestDist then
                bestDist = dist
                bestWord = word
            end
            ::skip::
        end
        return {bestWord, math.sqrt(bestDist)}
    end

    -- start: starting word
    -- n: amount of tokens
    -- random: flag to see if random gen is allowed
    function obj:generate(start, n, random) 
        local sentence = {start}
        local current = start

        for i = 1, n do
            local nearest = self:closest(current, random)
            if not nearest or not nearest[1] then break end  -- no more words
            local next_word = nearest[1]

            table.insert(sentence, next_word)
            current = next_word
        end

        return table.concat(sentence, " ")
    end

    return obj
end

return Graph