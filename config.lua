local component = require("component")
local sides = require("sides")

local config = {
  ui = {
    messageDisplayDuration = 4,
    colors = {
      black = 0x000000,
      white = 0xFFFFFF,
      gray = 0xA9A9A9,
      red = 0xFF0000,
      darkgray = 0x222324,
      blue = 0x0000FF,
      yellow = 0xFFFF00
    },
    messageTypes = {
      info = 1,
      warn = 2,
      error = 3
    }
  },
  logger = {
    maxBufferSize = 43
  },
  components = {
    syringe = {
      interface = component.proxy(component.get("46a55702-789c-4e0c-a078-a15515e44d02")),
      transposer = component.proxy(component.get("27ef4202-4e6d-409e-9f8b-8e43873db51d")),
      io = {
        interface = {
          input = nil,
          output = sides.bottom
        },
        transposer = {
          input = sides.top,
          output = sides.bottom
        }
      }
    },
    matter = {
      key = {
        label = "key",
        infusion = 0,
        interface = component.proxy(component.get("84b2cd3e-49df-4ab1-ae0e-82f0a308b825")),
        transposer = component.proxy(component.get("53708a22-c036-4d5d-9006-75ee34063ae5")),
        redstone = component.proxy(component.get("7f2a31b6-f024-4d95-894d-a38939f38686")),
        io = {
          interface = {
            input = nil,
            output = sides.south
          },
          transposer = {
            input = sides.top,
            output = sides.west
          },
          redstone = {
            input = nil,
            output = sides.top
          }
        }
      },
      bulk = {
        label = "bulk",
        infusion = 0,
        interface = component.proxy(component.get("84b2cd3e-49df-4ab1-ae0e-82f0a308b825")),
        transposer = component.proxy(component.get("53708a22-c036-4d5d-9006-75ee34063ae5")),
        redstone = component.proxy(component.get("f844ecc7-f41b-4a89-b455-f190aabbcea4")),
        io = {
          interface = {
            input = nil,
            output = sides.south
          },
          transposer = {
            input = sides.top,
            output = sides.east
          },
          redstone = {
            input = nil,
            output = sides.top
          }
        }
      },
      living = {
        label = "living",
        infusion = 100,
        interface = component.proxy(component.get("84b2cd3e-49df-4ab1-ae0e-82f0a308b825")),
        transposer = component.proxy(component.get("53708a22-c036-4d5d-9006-75ee34063ae5")),
        redstone = component.proxy(component.get("47407deb-5fce-4854-a32e-f9137679daf9")),
        io = {
          interface = {
            input = nil,
            output = sides.south
          },
          transposer = {
            input = sides.top,
            output = sides.bottom
          },
          redstone = {
            input = nil,
            output = sides.top
          }
        }
      }
    },
    gpu = {
      device = component.proxy(component.get(component.gpu.address))
    }
  }
}

return config
