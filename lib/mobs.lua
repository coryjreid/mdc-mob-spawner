-- 54 mobs max!


--[] = {
--  mobName = "",
--  mobId = "",
--  matter = {
--    key = {
--      name = "",
--      id = "",
--      amount = 0.1
--    },
--    bulk = {
--      name = "",
--      id = "",
--      amount = 0.2
--    },
--    living = {
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
        name = "Feather",
        id = "minecraft:feather",
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
        amount = 10
      }
    }
  },
  [2] = {
    mobName = "Basalz",
    mobId = "thermalfoundation:basalz",
    matter = {
      key = {
        name = "Basalz Rod",
        id = "thermalfoundation:material:2052",
        amount = 0.1
      },
      bulk = {
        name = "Cobblestone",
        id = "minecraft:cobblestone",
        amount = 0.5
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 30
      }
    }
  },
  [3] = {
    mobName = "Blaze",
    mobId = "minecraft:blaze",
    matter = {
      key = {
        name = "Blaze Rod",
        id = "minecraft:blaze_rod",
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
  },
  [4] = {
    mobName = "Blitz",
    mobId = "thermalfoundation:blitz",
    matter = {
      key = {
        name = "Blitz Rod",
        id = "thermalfoundation:material:2050",
        amount = 0.1
      },
      bulk = {
        name = "Sand",
        id = "minecraft:sand",
        amount = 0.5
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 30
      }
    }
  },
  [5] = {
    mobName = "Blizz",
    mobId = "thermalfoundation:blizz",
    matter = {
      key = {
        name = "Blizz Rod",
        id = "thermalfoundation:material:2048",
        amount = 0.1
      },
      bulk = {
        name = "Dirt",
        id = "minecraft:dirt",
        amount = 0.5
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 30
      }
    }
  },
  [6] = {
    mobName = "Cave Spider",
    mobId = "minecraft:cave_spider",
    matter = {
      key = {
        name = "String",
        id = "minecraft:string",
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
        amount = 10
      }
    }
  },
  [7] = {
    mobName = "Chicken",
    mobId = "minecraft:chicken",
    matter = {
      key = {
        name = "Feather",
        id = "minecraft:feather",
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
        amount = 15
      }
    }
  },
  [8] = {
    mobName = "Cow",
    mobId = "minecraft:cow",
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
  [9] = {
    mobName = "Enderman",
    mobId = "minecraft:enderman",
    matter = {
      key = {
        name = "Ender Pearl",
        id = "minecraft:ender_pearl",
        amount = 0.0001
      },
      bulk = {
        name = "End Stone",
        id = "minecraft:end_stone",
        amount = 0.001
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 0.01
      }
    }
  },
  [10] = {
    mobName = "Ghast",
    mobId = "minecraft:ghast",
    matter = {
      key = {
        name = "Ghast Tear",
        id = "minecraft:ghast_tear",
        amount = 0.1
      },
      bulk = {
        name = "Netherrack",
        id = "minecraft:netherrack",
        amount = 1.0
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 50.0
      }
    }
  },
  [11] = {
    mobName = "Magma Cube",
    mobId = "minecraft:magma_cube",
    matter = {
      key = {
        name = "Magma Cream",
        id = "minecraft:magma_cream",
        amount = 0.1
      },
      bulk = {
        name = "Netherrack",
        id = "minecraft:netherrack",
        amount = 0.2
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 10.0
      }
    }
  },
  [12] = {
    mobName = "Ocelot",
    mobId = "minecraft:ocelot",
    matter = {
      key = {
        name = "Raw Fish",
        id = "minecraft:fish",
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
        amount = 20.0
      }
    }
  },
  [13] = {
    mobName = "Pig",
    mobId = "minecraft:pig",
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
  [14] = {
    mobName = "Sheep",
    mobId = "minecraft:sheep",
    matter = {
      key = {
        name = "Wool",
        id = "minecraft:wool",
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
  [15] = {
    mobName = "Silverfish",
    mobId = "minecraft:silverfish",
    matter = {
      key = {
        name = "Iron Ingot",
        id = "minecraft:iron_ingot",
        amount = 0.05
      },
      bulk = {
        name = "Dirt",
        id = "minecraft:dirt",
        amount = 0.2
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 10.0
      }
    }
  },
  [16] = {
    mobName = "Witch",
    mobId = "minecraft:witch",
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
  [17] = {
    mobName = "Wither",
    mobId = "minecraft:wither",
    matter = {
      key = {
        name = "Nether Star",
        id = "minecraft:nether_star",
        amount = 0.1
      },
      bulk = {
        name = "Soul Sand",
        id = "minecraft:soul_sand",
        amount = 0.5
      },
      living = {
        name = "Carrot",
        id = "minecraft:carrot",
        amount = 100
      }
    }
  },
  [18] = {
    mobName = "Wither Skeleton",
    mobId = "minecraft:wither_skeleton",
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
