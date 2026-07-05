EventD = require("src/events")
e = EventD.new()
e.register(e, "Frank", function(params) print("hello "..params.name) end)

e.fire(e, "Frank", {name="Frank"})
e:fire("Frank", {name="Bob", param="Robert"})
e:fire("Bob", {name="not Frank"})

print(e.getlog(e))
