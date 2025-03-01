-- stylua: ignore
local main = {
  codenames = {
    "twilight_weaver",
    "ember_echoes",
    "celestial_path",
    "emerald_isle",
    "loyal_sunrise",
    "ocean_majesty",
    "blues_cinderstorm",
    "golden_honey",
    "mesa_mycelium",
    "melodious_muse",
    "cloud_climber",
    "void_walker",
    "homestead_hearth",
    "glacier_glow",
    "molten_fortune",
    "coral_cove",
  },
  names = {
    "Wisteria Way",
    "Netherrack Nostalgia",
    "End Gateway",
    "Verdant Echoes",
    "Wolf Howl at Dawn",
    "Prismarine Palace",
    "Blaze and the Blues",
    "Honeycomb Haven",
    "Mushroom Mesa",
    "Allay Ambiance",
    "Sky Odyssey",
    "Enderman Encounter",
    "Village Dawn",
    "Crystal Clear",
    "Nether Gold",
    "Guardian Groove",
  }
}

---(For convenience) Returns codenames, names
---@return table codenames
---@return table names
function main:unpack() return self.codenames, self.names end

return main
