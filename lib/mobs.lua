-- 54 mobs max!
local mobs = {
  [1] = {
    mobName = "Cow",
    mobId = "minecraft:cow",
    mobsPerKeyMatter = 10,
    matter = {
      key = {
        name = "Leather",
        id = "minecraft:leather",
        amount = 0.1
      },
      bulk = {
        name = "Dirt",
        id = "minecraft:dirt",
        amount = 0.2
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 20
      }
    }
  },
  [2] = {
    mobName = "Witch",
    mobId = "minecraft:witch",
    mobsPerKeyMatter = 10,
    matter = {
      key = {
        name = "Glass Bottle",
        id = "minecraft:glass_bottle",
        amount = 0.1
      },
      bulk = {
        name = "Dirt",
        id = "minecraft:dirt",
        amount = 1.0
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 30
      }
    }
  },
  [3] = {
    mobName = "Wither Skeleton",
    mobId = "minecraft:wither_skeleton",
    mobsPerKeyMatter = 10,
    matter = {
      key = {
        name = "Bone",
        id = "minecraft:bone",
        amount = 0.1
      },
      bulk = {
        name = "Netherrack",
        id = "minecraft:netherrack",
        amount = 0.5
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 30
      }
    }
  }
}

return mobs
