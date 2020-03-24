-- 54 mobs max!


--[] = {
--  mobName = "",
--  mobId = "",
--  matter = {
--    key = {
--      getItemStack = function() return {}, false, false end,
--      name = "",
--      id = "",
--      amount = 0.1
--    },
--    bulk = {
--      getItemStack = function() return {}, false, false end,
--      name = "",
--      id = "",
--      amount = 0.2
--    },
--    living = {
--      getItemStack = function() return {}, false, false end,
--      name = "Carrot",
--      id = "minecraft:carrot",
--      amount = 30
--    }
--  }
--},



local mobs = {
  [1] = {
    mobName = "Bat",
    mobId = "minecraft:bat",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:feather", label = "Feather"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 0.2
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 10
      }
    }
  },
  [2] = {
    mobName = "Basalz",
    mobId = "thermalfoundation:basalz",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "thermalfoundation:material", damage = 2052, label = "Basalz Rod"}, true, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:cobblestone", label = "Cobblestone"}, false, false
        end,
        amount = 0.5
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 30
      }
    }
  },
  [3] = {
    mobName = "Blaze",
    mobId = "minecraft:blaze",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:blaze_rod", label = "Blaze Rod"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:netherrack", label = "Natherrack"}, false, false
        end,
        amount = 0.5
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 30
      }
    }
  },
  [4] = {
    mobName = "Blitz",
    mobId = "thermalfoundation:blitz",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "thermalfoundation:material", damage = 2050, label = "Blitz Rod"}, true, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:sand", label = "Sand"}, false, false
        end,
        amount = 0.5
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 30
      }
    }
  },
  [5] = {
    mobName = "Blizz",
    mobId = "thermalfoundation:blizz",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "thermalfoundation:material", damage = 2048, label = "Blizz Rod"}, true, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 0.5
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 30
      }
    }
  },
  [6] = {
    mobName = "Cave Spider",
    mobId = "minecraft:cave_spider",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:string", label = "String"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 0.2
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 10
      }
    }
  },
  [7] = {
    mobName = "Chicken",
    mobId = "minecraft:chicken",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:feather", label = "Feather"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 0.2
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 15
      }
    }
  },
  [8] = {
    mobName = "Cow",
    mobId = "minecraft:cow",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:leather", label = "Leather"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 0.2
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 20
      }
    }
  },
  [9] = {
    mobName = "Enderman",
    mobId = "minecraft:enderman",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:ender_pearl", label = "Ender Pearl"}, false, false
        end,
        amount = 0.0001
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:end_stone", label = "End Stone"}, false, false
        end,
        amount = 0.001
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 0.01
      }
    }
  },
  [10] = {
    mobName = "Ghast",
    mobId = "minecraft:ghast",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:ghast_tear", label = "Ghast Tear"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:netherrack", label = "Natherrack"}, false, false
        end,
        amount = 1.0
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 50.0
      }
    }
  },
  [11] = {
    mobName = "Magma Cube",
    mobId = "minecraft:magma_cube",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:magma_cream", label = "Magma Cream"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:netherrack", label = "Natherrack"}, false, false
        end,
        amount = 0.2
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 10.0
      }
    }
  },
  [12] = {
    mobName = "Ocelot",
    mobId = "minecraft:ocelot",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:fish", label = "Raw Fish"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 1.0
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 20.0
      }
    }
  },
  [13] = {
    mobName = "Pig",
    mobId = "minecraft:pig",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:leather", name = "Leather"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 0.2
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 20
      }
    }
  },
  [14] = {
    mobName = "Sheep",
    mobId = "minecraft:sheep",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:wool", label = "Wool"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 0.2
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 20
      }
    }
  },
  [15] = {
    mobName = "Silverfish",
    mobId = "minecraft:silverfish",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:iron_ingot", label = "Iron Ingot"}, false, false
        end,
        amount = 0.05
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 0.2
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 10.0
      }
    }
  },
  [16] = {
    mobName = "Witch",
    mobId = "minecraft:witch",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:glass_bottle", label = "Glass Bottle"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:dirt", label = "Dirt"}, false, false
        end,
        amount = 1.0
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 30
      }
    }
  },
  [17] = {
    mobName = "Wither",
    mobId = "minecraft:wither",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:nether_star", label = "Nether Star"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:soul_sand", label = "Soul Sand"}, false, false
        end,
        amount = 0.5
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 100
      }
    }
  },
  [18] = {
    mobName = "Wither Skeleton",
    mobId = "minecraft:wither_skeleton",
    matter = {
      key = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:bone", label = "Bone"}, false, false
        end,
        amount = 0.1
      },
      bulk = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:netherrack", label = "Natherrack"}, false, false
        end,
        amount = 0.5
      },
      living = {
        getItemStack = function()
          -- stack object, match metadata, match nbt data
          return {name = "minecraft:carrot", label = "Carrot"}, false, false
        end,
        amount = 30
      }
    }
  }
}

return mobs
