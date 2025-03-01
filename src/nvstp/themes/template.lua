-- Name:         {:{head_name}:}
-- Description:  {:{head_desc}:}
-- Author:       {:{head_auth}:}
-- Maintainer:   {:{head_from}:}
-- Website:      {:{head_page}:}
-- License:      {:{head_lice}:}
-- Last Updated: {:{head_date}:}

-- {:{theme_desc}:}

local theme_mode = "{:{theme_mode}:}"

-- stylua: ignore
local ansi = {
  Black       = "{:{ansi_Black}:}",
  Red         = "{:{ansi_Red}:}",
  Green       = "{:{ansi_Green}:}",
  Yellow      = "{:{ansi_Yellow}:}",
  Blue        = "{:{ansi_Blue}:}",
  Purple      = "{:{ansi_Purple}:}",
  Cyan        = "{:{ansi_Cyan}:}",
  LightGray   = "{:{ansi_LightGray}:}",
  DarkGray    = "{:{ansi_DarkGray}:}",
  LightRed    = "{:{ansi_LightRed}:}",
  LightGreen  = "{:{ansi_LightGreen}:}",
  LightYellow = "{:{ansi_LightYellow}:}",
  LightBlue   = "{:{ansi_LightBlue}:}",
  LightPurple = "{:{ansi_LightPurple}:}",
  LightCyan   = "{:{ansi_LightCyan}:}",
  White       = "{:{ansi_White}:}",
}
-- stylua: ignore
local palette = {
  main = {
    [0] = "{:{main_0}:}",
    [1] = "{:{main_1}:}",
    [2] = "{:{main_2}:}",
    [3] = "{:{main_3}:}",
    [4] = "{:{main_4}:}",
    [5] = "{:{main_5}:}",
    [6] = "{:{main_6}:}",
    [7] = "{:{main_7}:}",
  },
  accent = {
    [0] = "{:{accent_0}:}",
    [1] = "{:{accent_1}:}",
    [2] = "{:{accent_2}:}",
    [3] = "{:{accent_3}:}",
    [4] = "{:{accent_4}:}",
    [5] = "{:{accent_5}:}",
    [6] = "{:{accent_6}:}",
    [7] = "{:{accent_7}:}",
  },
  state = {
    error   =  "{:{state_error}:}",
    warning =  "{:{state_warning}:}",
    hint    =  "{:{state_hint}:}",
    ok      =  "{:{state_ok}:}",
    info    =  "{:{state_info}:}",
  },
  syntax = {
    string  = "{:{syntax_string}:}",
    escape  = "{:{syntax_escape}:}",
    number  = "{:{syntax_number}:}",
    float   = "{:{syntax_float}:}",
    boolean = "{:{syntax_boolean}:}",
    keyword = "{:{syntax_keyword}:}",
    type    = "{:{syntax_type}:}",
    char    = "{:{syntax_char}:}",
    prop    = "{:{syntax_prop}:}",
    oper    = "{:{syntax_oper}:}",
    direc   = "{:{syntax_direc}:}",
    comment = "{:{syntax_comment}:}",
    punct   = "{:{syntax_punct}:}",
    attr    = "{:{syntax_attr}:}",
    func    = {
      self    = "{:{syntax_func_self}:}",
      builtin = "{:{syntax_func_builtin}:}",
      macro   = "{:{syntax_func_macro}:}",
      method  = "{:{syntax_func_method}:}",
    },
    var = {
      self    = "{:{syntax_var_self}:}",
      const   = "{:{syntax_var_const}:}",
      param   = "{:{syntax_var_param}:}",
      builtin = "{:{syntax_var_builtin}:}",
    }
  }
}

vim.cmd.highlight("clear")
vim.g.colors_name = "{:{theme_name}:}"

local function hi(name, opts)
  -- Force links
  -- opts.force = true

  -- Make sure that `cterm` attribute is not populated from `gui`
  opts.cterm = opts.cterm or {}

  -- Define global highlight
  vim.api.nvim_set_hl(0, name, opts)
end

--stylua: ignore start
-- General
hi('Normal', {})

hi('Conceal',      { fg = palette.main[1], bg = ansi.DarkGray, ctermfg = ansi.LightGray, ctermbg = ansi.DarkGray })
hi('Cursor',       {})
hi('lCursor',      {})
hi('DiffText',     { bg = palette.accent[0], bold = true,            ctermbg = ansi.Red,   cterm   = { bold = true } })
hi('ErrorMsg',     { fg = ansi.White, bg = palette.state.error,        ctermfg = ansi.White, ctermbg = ansi.DarkRed })
hi('IncSearch',    { reverse = true,                        cterm   = { reverse = true } })
hi('ModeMsg',      { bold    = true,                        cterm   = { bold    = true } })
hi('NonText',      { fg      = palette.main[5], bold = true,      ctermfg = ansi.Blue })
hi('PmenuSbar',    { bg      = palette.main[3],                   ctermbg = ansi.Gray })
hi('StatusLine',   { bg = palette.main[6], bold = true,           cterm   = { reverse = true, bold = true }})
hi('StatusLineNC', { bg = palette.main[6], cterm = { reverse = true } })
hi('TabLineFill',  { bg = palette.main[6],                        cterm   = { reverse = true } })
hi('TabLineSel',   { bold    = true,                        cterm   = { bold    = true } })
hi('TermCursor',   { bg = palette.main[0],                        cterm   = { reverse = true } })
hi('WinBar',       { bold    = true,                        cterm   = { bold    = true } })
hi('WildMenu',     { fg = palette.main[7], bg = palette.accent[2], ctermfg = ansi.Black, ctermbg = ansi.Yellow })

hi('VertSplit',      { fg = palette.main[0]})
hi('WinSeparator',   { link = 'VertSplit' })
hi('WinBarNC',       { link = 'WinBar' })
hi('EndOfBuffer',    { link = 'NonText' })
hi('LineNrAbove',    { fg = palette.main[0] })
hi('LineNrBelow',    { fg = palette.main[0] })
hi('QuickFixLine',   { link = 'Search' })
hi('CursorLineSign', { link = 'SignColumn' })
hi('CursorLineFold', { link = 'FoldColumn' })
hi('CurSearch',      { link = 'Search' })
hi('PmenuKind',      { link = 'Pmenu' })
hi('PmenuKindSel',   { link = 'PmenuSel' })
hi('PmenuExtra',     { link = 'Pmenu' })
hi('PmenuExtraSel',  { link = 'PmenuSel' })
hi('Substitute',     { link = 'Search' })
hi('Whitespace',     { link = 'NonText' })
hi('MsgSeparator',   { link = 'StatusLine' })
hi('NormalFloat',    { link = 'Pmenu' })
hi('FloatBorder',    { link = 'WinSeparator' })
hi('FloatTitle',     { link = 'Title' })
hi('FloatFooter',    { link = 'Title' })

hi('FloatShadow',          { bg      = palette.main[7], blend=80 })
hi('FloatShadowThrough',   { bg      = palette.main[7], blend=100 })
hi('RedrawDebugNormal',    { reverse = true,                         cterm   = { reverse = true } })
hi('RedrawDebugClear',     { bg      = palette.accent[2],            ctermbg = ansi.Yellow })
hi('RedrawDebugComposed',  { bg      = palette.accent[3],            ctermbg = ansi.Green })
hi('RedrawDebugRecompose', { bg      = palette.accent[0],            ctermbg = ansi.Red })
hi('Error',                { fg      = palette.state.error, bg = palette.state.error,    ctermfg = ansi.White, ctermbg = ansi.Red })
hi('Todo',                 { fg      = palette.state.info, bg  = palette.accent[7], ctermfg = ansi.Black, ctermbg = ansi.Yellow })

hi('String',         { link = 'Constant' })
hi('Character',      { link = 'Constant' })
hi('Number',         { link = 'Constant' })
hi('Boolean',        { link = 'Constant' })
hi('Float',          { link = 'Number' })
hi('Function',       { link = 'Identifier' })
hi('Conditional',    { link = 'Statement' })
hi('Repeat',         { link = 'Statement' })
hi('Label',          { link = 'Statement' })
hi('Operator',       { link = 'Statement' })
hi('Keyword',        { link = 'Statement' })
hi('Exception',      { link = 'Statement' })
hi('Include',        { link = 'PreProc' })
hi('Define',         { link = 'PreProc' })
hi('Macro',          { link = 'PreProc' })
hi('PreCondit',      { link = 'PreProc' })
hi('StorageClass',   { link = 'Type' })
hi('Structure',      { link = 'Type' })
hi('Typedef',        { link = 'Type' })
hi('Tag',            { link = 'Special' })
hi('SpecialChar',    { link = 'Special' })
hi('Delimiter',      { link = 'Special' })
hi('SpecialComment', { link = 'Special' })
hi('Debug',          { link = 'Special' })

hi('DiagnosticError',            { fg   = palette.state.error,                ctermfg = 1 })
hi('DiagnosticWarn',             { fg   = palette.state.warning,              ctermfg = 3 })
hi('DiagnosticInfo',             { fg   = palette.state.info,                 ctermfg = 4 })
hi('DiagnosticHint',             { fg   = palette.state.hint,                 ctermfg = 7 })
hi('DiagnosticOk',               { fg   = palette.state.ok,                   ctermfg = 10 })
hi('DiagnosticUnderlineError',   { sp   = palette.state.error,       underline = true, cterm   = { underline = true } })
hi('DiagnosticUnderlineWarn',    { sp   = palette.state.warning,     underline = true, cterm   = { underline = true } })
hi('DiagnosticUnderlineInfo',    { sp   = palette.state.info,        underline = true, cterm   = { underline = true } })
hi('DiagnosticUnderlineHint',    { sp   = palette.state.hint,        underline = true, cterm   = { underline = true } })
hi('DiagnosticUnderlineOk',      { sp   = palette.state.ok,          underline = true, cterm   = { underline = true } })
hi('DiagnosticVirtualTextError', { link = 'DiagnosticError' })
hi('DiagnosticVirtualTextWarn',  { link = 'DiagnosticWarn' })
hi('DiagnosticVirtualTextInfo',  { link = 'DiagnosticInfo' })
hi('DiagnosticVirtualTextHint',  { link = 'DiagnosticHint' })
hi('DiagnosticVirtualTextOk',    { link = 'DiagnosticOk' })
hi('DiagnosticFloatingError',    { link = 'DiagnosticError' })
hi('DiagnosticFloatingWarn',     { link = 'DiagnosticWarn' })
hi('DiagnosticFloatingInfo',     { link = 'DiagnosticInfo' })
hi('DiagnosticFloatingHint',     { link = 'DiagnosticHint' })
hi('DiagnosticFloatingOk',       { link = 'DiagnosticOk' })
hi('DiagnosticSignError',        { link = 'DiagnosticError' })
hi('DiagnosticSignWarn',         { link = 'DiagnosticWarn' })
hi('DiagnosticSignInfo',         { link = 'DiagnosticInfo' })
hi('DiagnosticSignHint',         { link = 'DiagnosticHint' })
hi('DiagnosticSignOk',           { link = 'DiagnosticOk' })
hi('DiagnosticDeprecated',       { sp   = palette.state.warning, strikethrough = true, cterm = { strikethrough = true } })

hi('DiagnosticUnnecessary', { link = 'Comment' })
hi('LspInlayHint',          { link = 'NonText' })
hi('SnippetTabstop',        { link = 'Visual' })

-- Text
hi('@markup.raw',       { link = 'Comment' })
hi('@markup.link',      { link = 'Identifier' })
hi('@markup.heading',   { link = 'Title' })
hi('@markup.link.url',  { link = 'Underlined' })
hi('@markup.underline', { link = 'Underlined' })
hi('@comment.todo',     { link = 'Todo' })

-- Miscs
hi('@comment',     { link = 'Comment' })
hi('@punctuation', { link = 'Delimiter' })

-- Constants
hi('@constant',          { fg = palette.syntax.var.const, underline = true })
hi('@constant.builtin',  { fg = palette.syntax.var.const, underline = true })
hi('@constant.macro',    { fg = palette.syntax.var.const, underline = true })
hi('@keyword.directive', { fg = palette.syntax.direc })
hi('@string',            { fg = palette.syntax.string })
hi('@string.escape',     { fg = palette.syntax.escape })
hi('@string.special',    { fg = palette.syntax.escape })
hi('@character',         { fg = palette.syntax.char })
hi('@character.special', { fg = palette.syntax.escape })
hi('@number',            { fg = palette.syntax.number })
hi('@boolean',           { fg = palette.syntax.boolean })
hi('@number.float',      { fg = palette.syntax.float })

-- Functions
hi('@function',                   { fg = palette.syntax.func.self })
hi('@function.builtin',           { fg = palette.syntax.func.builtin })
hi('@function.macro',             { fg = palette.syntax.func.macro })
hi('@function.method',            { fg = palette.syntax.func.method })
hi('@variable.parameter',         { fg = palette.syntax.var.param })
hi('@variable.parameter.builtin', { fg = palette.syntax.var.builtin })
hi('@variable.member',            { fg = palette.syntax.var.self })
hi('@property',                   { fg = palette.syntax.prop })
hi('@attribute',                  { fg = palette.syntax.func.macro })
hi('@attribute.builtin',          { fg = palette.syntax.func.builtin })
hi('@constructor',                { fg = palette.syntax.func.builtin })

-- Keywords
hi('@keyword.conditional', { fg = palette.syntax.keyword })
hi('@keyword.repeat',      { fg = palette.syntax.keyword })
hi('@keyword.type',        { fg = palette.syntax.type })
hi('@label',               { link = 'Label' })
hi('@operator',            { fg = palette.syntax.oper })
hi('@keyword',             { fg = palette.syntax.keyword })
hi('@keyword.exception',   { fg = palette.syntax.type })

hi('@variable',          { fg = palette.syntax.var.self })
hi('@type',              { fg = palette.syntax.type })
hi('@type.definition',   { fg = palette.syntax.type })
hi('@module',            { link = 'Identifier' })
hi('@keyword.import',    { fg = palette.syntax.keyword })
hi('@keyword.directive', { fg = palette.syntax.direc })
hi('@keyword.debug',     { link = 'Debug' })
hi('@tag',               { link = 'Tag' })
hi('@tag.builtin',       { link = 'Special' })

-- LSP semantic tokens
hi('@lsp.type.class',         { link = 'Structure' })
hi('@lsp.type.comment',       { link = 'Comment' })
hi('@lsp.type.decorator',     { link = 'Function' })
hi('@lsp.type.enum',          { link = 'Structure' })
hi('@lsp.type.enumMember',    { link = 'Constant' })
hi('@lsp.type.function',      { link = 'Function' })
hi('@lsp.type.interface',     { link = 'Structure' })
hi('@lsp.type.macro',         { link = 'Macro' })
hi('@lsp.type.method',        { link = 'Function' })
hi('@lsp.type.namespace',     { link = 'Structure' })
hi('@lsp.type.parameter',     { link = 'Identifier' })
hi('@lsp.type.property',      { link = 'Identifier' })
hi('@lsp.type.struct',        { link = 'Structure' })
hi('@lsp.type.type',          { link = 'Type' })
hi('@lsp.type.typeParameter', { link = 'TypeDef' })
hi('@lsp.type.variable',      { link = 'Identifier' })


hi('ColorColumn',  { bg = ansi.LightRed,                               ctermbg = ansi.LightRed })
hi('CursorColumn', { bg = palette.main[4],                             ctermbg = ansi.LightGray })
hi('CursorLine',   { bg = palette.main[5],                             cterm   = { underline = true } })
hi('CursorLineNr', { fg = palette.main[0], bold = true,                ctermfg = ansi.Brown, cterm = { underline = true } })
hi('DiffAdd',      { bg = ansi.LightBlue,                              ctermbg = ansi.LightBlue })
hi('DiffChange',   { bg = ansi.LightMagenta,                           ctermbg = ansi.LightMagenta })
hi('DiffDelete',   { fg = ansi.Blue, bg = ansi.LightCyan, bold = true, ctermfg = ansi.Blue, ctermbg = ansi.LightCyan })
hi('Directory',    { fg = ansi.Blue,                                   ctermfg = ansi.DarkBlue })
hi('FoldColumn',   { fg = ansi.DarkBlue, bg = ansi.Gray,               ctermfg = ansi.DarkBlue, ctermbg = ansi.Gray })
hi('Folded',       { fg = ansi.DarkBlue, bg = ansi.LightGray,          ctermfg = ansi.DarkBlue, ctermbg = ansi.Gray })
hi('LineNr',       { fg = palette.accent[7],                             ctermfg = ansi.Brown })
hi('MatchParen',   { fg = palette.accent[4],                           ctermbg = ansi.Cyan })
hi('MoreMsg',      { fg = ansi.SeaGreen, bold = true,                  ctermfg = ansi.DarkGreen })
hi('Pmenu',        { bg = ansi.LightMagenta,                           ctermfg = ansi.Black, ctermbg = ansi.LightMagenta })
hi('PmenuSel',     { bg = ansi.Gray,                                   ctermfg = ansi.Black, ctermbg = ansi.LightGray })
hi('PmenuThumb',   { bg = ansi.Black,                                  ctermbg = ansi.Black })
hi('Question',     { fg = ansi.SeaGreen, bold = true,                  ctermfg = ansi.DarkGreen })
hi('Search',       { bg = ansi.Yellow,                                 ctermbg = ansi.Yellow })
hi('SignColumn',   { fg = ansi.DarkBlue, bg = ansi.Gray,               ctermfg = ansi.DarkBlue, ctermbg = ansi.Gray })
hi('SpecialKey',   { fg = ansi.Blue,                                   ctermfg = ansi.DarkBlue })
hi('SpellBad',     { sp = ansi.Red, undercurl = true,                  ctermbg = ansi.LightRed })
hi('SpellCap',     { sp = ansi.Blue, undercurl = true,                 ctermbg = ansi.LightBlue })
hi('SpellLocal',   { sp = ansi.DarkCyan, undercurl = true,             ctermbg = ansi.Cyan })
hi('SpellRare',    { sp = ansi.Magenta, undercurl = true,              ctermbg = ansi.LightMagenta })
hi('TabLine',      { bg = palette.main[6], underline = true,           ctermfg = ansi.Black, ctermbg = ansi.LightGray, cterm = { underline = true } })
hi('Title',        { fg = palette.main[3], bold = true,                ctermfg = ansi.DarkMagenta })
hi('Visual',       { fg = ansi.Black, bg = ansi.LightGray,             ctermfg = ansi.Black, ctermbg = ansi.Gray })
hi('WarningMsg',   { fg = ansi.Red,                                    ctermfg = ansi.DarkRed })
hi('Comment',      { fg = ansi.Blue,                                   ctermfg = ansi.DarkBlue })
hi('Constant',     { fg = ansi.Magenta,                                ctermfg = ansi.DarkRed })
hi('Special',      { fg = '#6a5acd',                                   ctermfg = ansi.DarkMagenta })
hi('Identifier',   { fg = ansi.DarkCyan,                               ctermfg = ansi.DarkCyan })
hi('Statement',    { fg = ansi.Brown, bold = true,                     ctermfg = ansi.Brown })
hi('PreProc',      { fg = '#6a0dad',                                   ctermfg = ansi.DarkMagenta })
hi('Type',         { fg = ansi.SeaGreen, bold = true,                  ctermfg = ansi.DarkGreen })
hi('Underlined',   { fg = ansi.SlateBlue, underline = true,            ctermfg = ansi.DarkMagenta, cterm = { underline = true } })
hi('Ignore',       { fg = palette.main[0],                             ctermfg = ansi.White })
--stylua: ignore end
