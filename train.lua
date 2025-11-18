function randomVector(dim)
    local vec = {}
    for i = 1, dim do
        vec[i] = math.random() - 0.5
    end
    return vec
end

function train_unwrapped(graph, sentences, epoch, lr) 
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
        for _, sentence in ipairs(sentences) do
            for i = 1, #sentence - 1 do
                local w1, w2 = sentence[i], sentence[i + 1]
                local v1, v2 = graph:get(w1), graph:get(w2)

                for d = 1, graph.dimensions do
                    local diff = v2[d] - v1[d]
                    v1[d] = v1[d] + lr * diff
                    v2[d] = v2[d] - lr * diff * 0.5
                end

                graph:set(w1, v1)
                graph:set(w2, v2)
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
        sentences[i] = split(sentences[i], "/")
    end
    return train_unwrapped(graph, sentences, epoch, lr)
end

return train