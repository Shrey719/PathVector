require("graph")
require("train")
require("data")

local Hello = Graph(1024)

train(Hello, data, 10, 0.1)

local keys = {}
for k in pairs(Hello.map) do
    table.insert(keys, k)
end
local startingWord = keys[math.random(#keys)]
-- [1] = startingword 
-- [2] = token amount 
-- [3] = randomness (KEEP ON, OTHERWISE BULLSHIT IS OUTPUTTED)
-- [4] = context window
print(#keys)
print(Hello:generate(startingWord, 50, true, 10))
