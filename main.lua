require("graph")
require("train")
require("data")

local Hello = Graph(50)

train(Hello, data, 10, 0.1, 5)

local keys = {}
for k in pairs(Hello.map) do
    table.insert(keys, k)
end
local startingWord = keys[math.random(#keys)]
-- [1] = startingword 
-- [2] = token amount 
-- [3] = randomness (KEEP ON, OTHERWISE BULLSHIT IS OUTPUTTED)
print(#keys)
print(Hello:generate('i', 50, true))
print(math.sqrt(math.random())/10)