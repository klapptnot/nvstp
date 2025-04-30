-- config loader

--- @alias NvstpConfig {mapping:NvimMappingConfig; options:NvimOptionsConfig; plugins:NvimPluginsConfig}

--- @type NvstpConfig
local main = {
  --- @return NvimMappingConfig
  mapping = require ("config.mapping"):new (),
  --- @return NvimOptionsConfig
  options = require ("config.options"):new (),
  --- @return NvimPluginsConfig
  plugins = require ("config.plugins"):new (),
} -- Return all configs classes

return main
