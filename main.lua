require("graph")
require("train")
require("data")

local Hello = Graph(512)

train(Hello, data, 100, 1.05)

local keys = {}
for k in pairs(Hello.map) do
    table.insert(keys, k)
end
local startingWord = keys[math.random(#keys)]
function makeRoute() 
    return "/"..startingWord.."/"..Hello:closest(startingWord, true)[1].."/"
end

print(makeRoute())
return makeRoute