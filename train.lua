function randomVector(dim)
    local vec = {}
    for i = 1, dim do
        vec[i] = math.random() - 0.5
    end
    return vec
end


function train_unwrapped(graph, sentences, epoch, lr, window) 
    window = window or 5

    for _, sentence in ipairs(sentences) do
        for i, word in ipairs(sentence) do
            local w = word:lower()
            sentence[i] = w
            if not graph.map[w] then
                graph:set(w, randomVector(graph.dimensions))
            end
        end
    end

    -- training loop
    for e = 1, epoch do
        -- precompute keys
        local keys = {}
        for k in pairs(graph.map) do table.insert(keys, k) end

        for _, sentence in ipairs(sentences) do
            for i = 1, #sentence do
                local w1 = sentence[i]
                local v1 = graph:get(w1)

                for j = math.max(1, i - window), math.min(#sentence, i + window) do
                    if j ~= i then
                        local w2 = sentence[j]
                        local v2 = graph:get(w2)

                        local weight = 1 / math.abs(j - i)  -- closer words get stronger update
                        for d = 1, graph.dimensions do
                            local diff = v2[d] - v1[d]
                            v1[d] = v1[d] + lr * diff * weight
                            v2[d] = v2[d] - lr * diff * 0.5 * weight
                        end
                        graph:set(w2, v2)
                    end
                end

                graph:set(w1, v1)

                -- negative sampling (stop collapse)
                local neg = keys[ math.random(#keys) ]
                while neg == w1 do
                    neg = keys[ math.random(#keys) ]
                end
                local vneg = graph:get(neg)
                for d = 1, graph.dimensions do
                    local diff_neg = vneg[d] - v1[d]
                    v1[d]   = v1[d]   - lr * diff_neg * 0.1
                    vneg[d] = vneg[d] + lr * diff_neg * 0.1
                end
                graph:set(neg, vneg)
                graph:set(w1, v1)
            end
        end
    end
end
-- this is not stolen from stackoverflow i do not know what you are talking about at all 
function split(inputstr, sep) 
    if (sep == nil) then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end 
    return t
end

-- accepts sentences as a {"string", "somestring", "otherstring"... etc}
function train(graph, sentences, epoch, lr) 
    for i = 1, #sentences do
        sentences[i] = split(sentences[i], " ")
    end
    return train_unwrapped(graph, sentences, epoch, lr)
end

return train