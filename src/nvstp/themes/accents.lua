local color = require("src.warm.color")
local tbl = require("src.warm.table")

local colmt = {
  __tostring = function(t) return t[1] end,
  __call = function(t) return t[2] end,
  __index = function(t, k)
    if k == "name" then return t[1] end
    if k == "code" then return t[1]:lower():gsub(" ", "_") end
    if k == "hgrp" then return "AccHi" .. t[1]:gsub(" (.)", string.upper) end
    if k == "color" then return t[2] end
  end,
}

-- stylua: ignore
-- Do not add properties, let user add them
local main = {
  setmetatable({ "Fuchsia",        "#ff00ff" }, colmt),
  setmetatable({ "Pink",           "#fd65c5" }, colmt),
  setmetatable({ "Red",            "#ff6e6e" }, colmt),
  setmetatable({ "Orange",         "#ffb86c" }, colmt),
  setmetatable({ "Yellow",         "#ffe86c" }, colmt),
  setmetatable({ "Green",          "#6ff660" }, colmt),
  setmetatable({ "Mint green",     "#6cffb8" }, colmt),
  setmetatable({ "Cyan",           "#6ce8ff" }, colmt),
  setmetatable({ "Blue",           "#6c8cff" }, colmt),
  setmetatable({ "Violet",         "#8c6cff" }, colmt),
  setmetatable({ "Pastel Violet",  "#6b36ba" }, colmt),
  setmetatable({ "Indigo",         "#4b4592" }, colmt),
  setmetatable({ "Candy Violet",   "#7b00f7" }, colmt),
  setmetatable({ "Purple",         "#801de6" }, colmt),
  setmetatable({ "Candy Purple",   "#a020f0" }, colmt),
  setmetatable({ "Mauve",          "#bd93f9" }, colmt),
  setmetatable({ "Yogurt",         "#fdc5f5" }, colmt),
  setmetatable({ "Skin",           "#fdc5c5" }, colmt),
  setmetatable({ "Beige",          "#ffe8b8" }, colmt),
  setmetatable({ "Solar white",    "#fff5f5" }, colmt),
  setmetatable({ "Peach",          "#ffa98c" }, colmt),
  setmetatable({ "Dusty rose",     "#e188a4" }, colmt),
  setmetatable({ "Ocre",           "#b8966c" }, colmt),
  setmetatable({ "Brown",          "#8c5a2d" }, colmt),
  setmetatable({ "Dark brown",     "#674533" }, colmt),
  -- Neutral
  setmetatable({ "White",          "#f5f5ff" }, colmt),
  setmetatable({ "Light gray",     "#777777" }, colmt),
  setmetatable({ "Dark gray",      "#444444" }, colmt),
  setmetatable({ "Black",          "#202020" }, colmt),
}

function main.add(color, name)
  main[#main + 1] = setmetatable({ name, color }, colmt)
  return main
end

function main.hg_load()
  --& "Cupcake" colorscheme highlightings
  for _, v in ipairs(main) do
    local n, c = v.hgrp, v.color
    if color.brightness(c, 0.35) then
      vim.api.nvim_set_hl(0, n .. "Bs", { bg = c, fg = "#101010", bold = true })
      vim.api.nvim_set_hl(0, n .. "Fs", { fg = c, bg = "#101010", bold = true })
    else
      vim.api.nvim_set_hl(0, n .. "Bs", { bg = c, fg = "#fafaff", bold = true })
      vim.api.nvim_set_hl(0, n .. "Fs", { fg = c, bg = "#fafaff", bold = true })
    end
    vim.api.nvim_set_hl(0, n .. "B", { bg = c, bold = true })
    vim.api.nvim_set_hl(0, n .. "F", { fg = c, bold = true })
  end
end

return main
