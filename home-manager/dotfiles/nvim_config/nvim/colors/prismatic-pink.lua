-- Prismatic Pink Theme
vim.opt.background = "dark"
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "prismatic-pink"

local c = {
  -- syntax palette
  fg = "#C0C4D0",
  gray = "#828DA0",
  fadedGray = "#636D83",
  red = "#F24646",
  orange = "#FF8D5C",
  yellow = "#E3C24A",
  lime = "#89E736",
  lightGreen = "#D6FFD6",
  green = "#3FC56B",
  cyan = "#15C9C5",
  lightBlue = "#97BCCD",
  skyBlue = "#5CA2ED",
  blue = "#10B1FE",
  cornflower = "#8AA5FF",
  purple = "#A177F5",
  violet = "#DD99FF",
  lightPurple = "#D5C0E9",
  pink = "#F85EB4",
  lightPink = "#EEBBFF",
  strongPink = "#FF2884",
  boldGreen = "#2ECC4B",
  boldPink = "#F750AE",
  boldViolet = "#D88AFF",
  boldFg = "#B2B6C4",

  -- UI palette
  text_normal = "#CFD7E6",
  text_muted = "#8F9199",
  text_light = "#7C869B",
  text_inverse = "#FFFFFF",

  primaryBg = "#1E1E22",
  secondaryBg = "#1C1C20",
  tertiaryBg = "#121218",
  
  decoration_light = "#51576C",

  border = "#3D434F",
  selection = "#512535",
  selectedBg = "#2F2F37",
  matchBg = "#CCD00C",
  currentLineBg = "#252529",

  accent = "#FF1277",
  accentSecondary = "#09A1ED",

  -- Diagnostics
  diagHint = "#31A155",
  diagInfo = "#018ACC",
  diagWarn = "#E17615",
  diagError = "#FF1277",

  -- Git
  gitAdded = "#31A155",
  gitModified = "#018ACC",
  gitRemoved = "#FF1277",
  gitUntracked = "#C75AF3",
  
  -- Bracket pairs
  bracket1 = "#3FC56B",
  bracket2 = "#10B1FE",
  bracket3 = "#F9C859",
  bracket4 = "#FF6B66",
  bracket5 = "#D177F5",

  none = "NONE",
}

local function hi(group, opts)
  opts.default = false
  vim.api.nvim_set_hl(0, group, opts)
end

-- editor ui
hi("Normal", { fg = c.text_normal, bg = c.primaryBg })
hi("NormalNC", { fg = c.text_normal, bg = c.secondaryBg })
hi("NormalFloat", { fg = c.text_normal, bg = c.secondaryBg })
hi("FloatBorder", { fg = c.border, bg = c.secondaryBg })
hi("FloatTitle", { fg = c.pink, bg = c.secondaryBg, bold = true })
hi("Cursor", { fg = c.primaryBg, bg = c.accent })
hi("CursorLine", { bg = c.currentLineBg })
hi("CursorLineNr", { fg = c.accent, bold = true })
hi("LineNr", { fg = c.fadedGray })
hi("SignColumn", { fg = c.fadedGray, bg = c.primaryBg })
hi("ColorColumn", { bg = c.border })
hi("VertSplit", { fg = c.border })
hi("WinSeparator", { fg = c.border })
hi("EndOfBuffer", { fg = c.fadedGray })
hi("Folded", { fg = c.gray, bg = c.secondaryBg })
hi("FoldColumn", { fg = c.fadedGray, bg = c.primaryBg })

-- status/tab line
hi("StatusLine", { fg = c.text_normal, bg = c.secondaryBg })
hi("StatusLineNC", { fg = c.text_muted, bg = c.tertiaryBg })
hi("TabLine", { fg = c.text_muted, bg = c.secondaryBg })
hi("TabLineFill", { bg = c.secondaryBg })
hi("TabLineSel", { fg = c.text_normal, bg = c.secondaryBg, bold = true })
hi("WinBar", { fg = c.text_light, bg = c.primaryBg })
hi("WinBarNC", { fg = c.fadedGray, bg = c.secondaryBg })

-- popup/completion menu
hi("Pmenu", { fg = c.text_normal, bg = c.secondaryBg })
hi("PmenuSel", { fg = c.text_normal, bg = c.selectedBg, bold = true })
hi("PmenuSbar", { bg = c.tertiaryBg })
hi("PmenuThumb", { bg = c.gray })
hi("PmenuMatch", { fg = c.pink, bg = c.secondaryBg })
hi("PmenuMatchSel", { fg = c.pink, bg = c.selectedBg, bold = true })

-- search/selection
hi("Search", { fg = c.primaryBg, bg = c.matchBg })
hi("IncSearch", { fg = c.primaryBg, bg = c.accent })
hi("CurSearch", { fg = c.primaryBg, bg = c.accent })
hi("Visual", { bg = "#512535" })
hi("VisualNOS", { bg = "#3B2030" })
hi("MatchParen", { fg = c.accent, bold = true })

-- messages / prompts
hi("ModeMsg", { fg = c.green, bold = true})
hi("MsgArea", { fg = c.text_normal } )
hi("MoreMsg", { fg = c.accentSecondary } )
hi("Question", { fg = c.accentSecondary } )
hi("ErrorMsg", { fg = c.diagError } )
hi("WarningMsg", { fg = c.diagWarn } )

-- diff
hi("DiffAdd", { bg = "#273629" })
hi("DiffChange", { bg = "#1F2E35" })
hi("DiffDelete", { bg = "#3B1F2C" })
hi("DiffText", { bg = "#213B47" })
hi("Added", { fg = c.gitAdded })
hi("Removed", { fg = c.gitRemoved })

-- spell
hi("SpellBad", { undercurl = true, sp = c.diagError })
hi("SpellCap", { undercurl = true, sp = c.diagWarn })
hi("SpellRare", { undercurl = true, sp = c.diagHint })
hi("SpellLocal", { undercurl = true, sp = c.diagInfo })

-- diagnostics
hi("DiagnosticError", { fg = c.diagError })
hi("DiagnosticWarn", { fg = c.diagWarn })
hi("DiagnosticInfo", { fg = c.diagInfo })
hi("DiagnosticHint", { fg = c.diagHint })
hi("DiagnosticVirtualTextError", { fg = c.diagError, bg = "#35202A" })
hi("DiagnosticVirtualTextWarn", { fg = c.diagWarn, bg = "#3A2C20" })
hi("DiagnosticVirtualTextInfo", { fg = c.diagInfo, bg = "#1E2C36" })
hi("DiagnosticVirtualTextHint", { fg = c.diagHint, bg = "#232E27" })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.diagError })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.diagWarn })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.diagInfo })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.diagHint })
hi("DiagnosticSignError", { fg = c.diagError })
hi("DiagnosticSignWarn", { fg = c.diagWarn })
hi("DiagnosticSignInfo", { fg = c.diagInfo })
hi("DiagnosticSignHint", { fg = c.diagHint })

-- Git signs
hi("GitSignsAdd", { fg = c.gitAdded })
hi("GitSignsChange", { fg = c.gitModified })
hi("GitSignsDelete", { fg = c.gitRemoved })

-- Misc UI
hi("Directory", { fg = c.accentSecondary })
hi("Title", { fg = c.pink, bold =  true })
hi("NonText", { fg = c.fadedGray })
hi("Whitespace", { fg = c.decoration_light })
hi("SpecialKey", { fg = c.fadedGray })
hi("Conceal", { fg = c.gray })
hi("QuickFixLine", { bg = c.currentLineBg })
hi("qfLineNr", { fg = c.fadedGray })

-- Base syntax
hi("Comment", { fg = c.lightPink })
hi("Constant", { fg = c.orange })
hi("String", { fg = c.yellow })
hi("Character", { fg = c.orange })
hi("Number", { fg = c.orange })
hi("Boolean", { fg = c.orange })
hi("Float", { fg = c.orange })

hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.green })

hi("Statement", { fg = c.pink })
hi("Conditional", { fg = c.pink })
hi("Repeat", { fg = c.pink })
hi("Label", { fg = c.lime })
hi("Operator", { fg = c.lightGreen })
hi("Keyword", { fg = c.pink })
hi("Exception", { fg = c.pink })

hi("PreProc", { fg = c.strongPink })
hi("Include", { fg = c.pink })
hi("Define", { fg = c.pink })
hi("Macro", { fg = c.strongPink })
hi("PreCondit", { fg = c.pink })

hi("Type", { fg = c.pink })
hi("StorageClass", { fg = c.pink })
hi("Structure", { fg = c.blue })
hi("Typedef", { fg = c.blue })

hi("Special", { fg = c.orange })
hi("SpecialChar", { fg = c.orange })
hi("Tag", { fg = c.pink })
hi("Delimiter", { fg = c.lightGreen })
hi("SpecialComment", { fg = c.lightPink })
hi("Debug", { fg = c.red })

hi("Underlined", { underline = true })
hi("Ignore", { fg = c.fadedGray })
hi("Error", { fg = c.red })
hi("Todo", { fg = c.text_normal, bold = true })

---- Treesitter https://neovim.io/doc/user/treesitter/#_treesitter-syntax-highlighting
-- identifiers
hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.pink })
hi("@variable.parameter", { fg = c.violet })
hi("@variable.parameter.builtin", { fg = c.violet })
hi("@variable.member", { fg = c.lightPurple })
hi("@variable.member.key", { fg = c.lightPurple })
hi("@property", { fg = c.lightPurple })

hi("@constant", { fg = c.orange })
hi("@constant.builtin", { fg = c.orange })
hi("@constant.macro", { fg = c.orange })

-- strings
hi("@string", { fg = c.yellow })
hi("@string.escape", { fg = c.orange })
hi("@string.special", { fg = c.orange })
hi("@string.regexp", { fg = c.orange })
hi("@character", { fg = c.orange })
hi("@character.special", { fg = c.orange })
hi("@number", { fg = c.orange })
hi("@number.float", { fg = c.orange })
hi("@boolean", { fg = c.orange })

-- functions
hi("@function", { fg = c.green })
hi("@function.builtin", { link = "@function" })
hi("@function.call", { link = "@function" })
hi("@function.macro", { fg = c.strongPink })
hi("@function.method", { link = "@function" })
hi("@function.method.call", { link = "@function" })
hi("@constructor", { fg = c.blue })

-- keywords
hi("@keyword", { fg = c.pink })
hi("@keyword.function", { link = "@keyword" })
hi("@keyword.operator", { link = "@keyword" })
hi("@keyword.import", { link = "@keyword" })
hi("@keyword.return", { link = "@keyword" })
hi("@keyword.coroutine", { link = "@keyword" })
hi("@keyword.conditional", { link = "@keyword" })
hi("@keyword.repeat", { link = "@keyword" })
hi("@keyword.exception", { link = "@keyword" })
hi("@keyword.modifier", { link = "@keyword" })
hi("@keyword.type", { link = "@keyword" })
hi("@keyword.debug", { fg = c.red })

-- types
hi("@type", { fg = c.blue })
hi("@type.builtin", { fg = c.pink })
hi("@type.definition", { fg = c.blue })
hi("@attribute", { fg = c.orange })

-- punctuation
hi("@punctuation.delimiter", { fg = c.lightGreen })
hi("@punctuation.bracket", { fg = c.lightGreen })
hi("@punctuation.special", { fg = c.lightGreen })
hi("@operator", { fg = c.lightGreen })

-- namespaces/modules
hi("@module", { fg = c.fg })
hi("@module.builtin", { fg = c.pink })
hi("@label", { fg = c.lime })

-- markup/docs
hi("@comment", { fg = c.lightPink })
hi("@comment.documentation", { fg = c.lightPink })

hi("@markup.heading", { fg = c.pink, bold = true })
hi("@markup.strong", { fg = c.green, bold = true })
hi("@markup.italic", { fg = c.lightPink, italic = true })
hi("@markup.underline", { underline = true })
hi("@markup.strikethrough", { strikethrough = true })
hi("@markup.link", { fg = c.blue, underline = true })
hi("@markup.link.url", { fg = c.cornflower, underline = true })
hi("@markup.link.label", { fg = c.accentSecondary })
hi("@markup.raw", { fg = c.fg })
hi("@markup.raw.block", { fg = c.fg })
hi("@markup.list", { fg = c.cyan, bold = true })
hi("@markup.list.checked", { fg = c.cyan, bold = true })
hi("@markup.list.unchecked", { fg = c.cyan, bold = true })
hi("@markup.quote", { fg = c.yellow, italic = true })
hi("@markup.math", { fg = c.orange })

-- diff
hi("@diff.plus", { fg = c.gitAdded })
hi("@diff.minus", { fg = c.gitRemoved })
hi("@diff.delta", { fg = c.gitModified })

-- tags (HTML/JSX)
hi("@tag", { fg = c.pink })
hi("@tag.builtin", { fg = c.pink })
hi("@tag.attribute", { fg = c.cyan, italic = true })
hi("@tag.delimiter", { fg = c.lightGreen })

-- LSP semantic token fallbacks

--- Standard LSP token types
hi("@lsp.type.namespace", { fg = c.fg })

hi("@lsp.type.type", { fg = c.blue })
hi("@lsp.type.class", { fg = c.blue })
hi("@lsp.type.struct", { fg = c.blue })
hi("@lsp.type.enum", { fg = c.blue })
hi("@lsp.type.interface", { fg = c.cornflower })
hi("@lsp.type.typeParameter", { fg = c.skyBlue })

hi("@lsp.type.parameter", { fg = c.violet })
hi("@lsp.type.variable", { fg = c.fg })
hi("@lsp.type.property", { fg = c.lightPurple })
hi("@lsp.type.enumMember", { fg = c.cyan })

hi("@lsp.type.function", { fg = c.green })
hi("@lsp.type.method", { fg = c.green })
hi("@lsp.type.decorator", { fg = c.green })
hi("@lsp.type.macro", { fg = c.strongPink })

hi("@lsp.type.modifier", { fg = c.pink })

hi("@lsp.type.keyword", { fg = c.pink })
hi("@lsp.type.operator", { fg = c.lightGreen })

hi("@lsp.type.string", { fg = c.yellow })
hi("@lsp.type.number", { fg = c.orange })
hi("@lsp.type.regexp", { fg = c.orange })

hi("@lsp.type.comment", { fg = c.lightPink })
hi("@lsp.type.event", { fg = c.lime })

--- Standard LSP modifiers
hi("@lsp.mod.abstract", {})
hi("@lsp.mod.async", {})
hi("@lsp.mod.declaration", {})
hi("@lsp.mod.defaultLibrary", {})
hi("@lsp.mod.definition", {})
hi("@lsp.mod.deprecated", {})
hi("@lsp.mod.documentation", {})
hi("@lsp.mod.modification", {})
hi("@lsp.mod.readonly", {})
hi("@lsp.mod.static", {})

--- LSP extensions
hi("@lsp.type.builtinType", { fg = c.pink })
hi("@lsp.type.label", { fg = c.lime })
---- rust-analyzer
hi("@lsp.type.lifetime", { fg = c.purple })
hi("@lsp.type.selfKeyword", { fg = c.pink })
hi("@lsp.type.formatSpecifier", { fg = c.purple })

hi("@lsp.mod.mutable", { bold = true })
hi("@lsp.mod.reference", { italic = true })
hi("@lsp.mod.unsafe", { fg = c.red })

-- telescope

hi("TelescopeNormal", { fg = c.text_normal, bg = c.secondaryBg })
hi("TelescopeBorder", { fg = c.border, bg = c.secondaryBg })
hi("TelescopePromptNormal", { fg = c.text_normal, bg = c.selectedBg })
hi("TelescopePromptBorder", { fg = c.border, bg = c.selectedBg })
hi("TelescopePromptTitle", { fg = c.pink, bold = true })
hi("TelescopeResultsTitle", { fg = c.accentSecondary, bold = true })
hi("TelescopePreviewTitle", { fg = c.green, bold = true })
hi("TelescopeSelection", { bg = c.selectedBg })
hi("TelescopeSelectionCaret", { fg = c.accent })
hi("TelescopeMatching", { fg = c.pink, bold = true })

-- nvim-tree
hi("NvimTreeNormal", { fg = c.text_normal, bg = c.secondaryBg })
hi("NvimTreeGitDirty", { fg = c.gitModified })
hi("NvimTreeGitNew", { fg = c.gitAdded })
hi("NvimTreeGitDeleted", { fg = c.gitRemoved })
hi("NvimTreeOpenedFile", { fg = c.accent })
hi("NvimTreeRootFolder", { fg = c.pink, bold = true })
hi("NvimTreeFolderIcon", { fg = c.accentSecondary })
hi("NvimTreeFolderName", { fg = c.text_normal })
hi("NvimTreeIndentMarker", { fg = c.border })

hi("NeoTreeNormal", { fg = c.text_normal, bg = c.secondaryBg })
hi("NeoTreeNormalNC", { fg = c.text_normal, bg = c.secondaryBg })
hi("NeoTreeRootName", { fg = c.pink, bold = true })
hi("NeoTreeGitAdded", { fg = c.gitAdded })
hi("NeoTreeGitModified", { fg = c.gitModified })
hi("NeoTreeGitDeleted", { fg = c.gitRemoved })
hi("NeoTreeGitUntracked", { fg = c.gitUntracked })

-- which-key
hi("WhichKey", { fg = c.pink })
hi("WhichKeyGroup", { fg = c.accentSecondary })
hi("WhichKeyDesc", { fg = c.text_normal })
hi("WhichKeySeparator", { fg = c.fadedGray })
hi("WhichKeyFloat", { fg = c.text_normal, bg = c.secondaryBg })

-- ident guides (indent-blankline)
hi("IblIdent", { fg = c.decoration_light })
hi("IblScope", { fg = c.accent })
hi("IndentBlanklineChar", { fg = c.decoration_light })
hi("IndentBlanklineContextChar", { fg = c.accent })

-- noice/notify
hi("NotifyERRORBorder", { fg = c.diagError })
hi("NotifyWARNBorder", { fg = c.diagWarn })
hi("NotifyINFOBorder", { fg = c.diagInfo })
hi("NotifyDEBUGBorder", { fg = c.fadedGray })
hi("NotifyTRACEBorder", { fg = c.purple })

hi("NotifyERRORTitle", { fg = c.diagError })
hi("NotifyWARNTitle", { fg = c.diagWarn })
hi("NotifyINFOTitle", { fg = c.diagInfo })
hi("NotifyDEBUGTitle", { fg = c.fadedGray })
hi("NotifyTRACETitle", { fg = c.purple })

hi("NotifyERRORIcon", { fg = c.diagError })
hi("NotifyWARNIcon", { fg = c.diagWarn })
hi("NotifyINFOIcon", { fg = c.diagInfo })

-- mini statusline/lualine
hi("lualine_a_normal", { fg = c.primaryBg, bg = c.accent, bold = true })
hi("lualine_b_normal", { fg = c.text_normal, bg = c.secondaryBg })
hi("lualine_c_normal", { fg = c.text_muted, bg = c.primaryBg })

-- Rainbow Delimeters
hi("RainbowDelimiterRed", { fg = c.bracket4 })
hi("RainbowDelimiterYellow", { fg = c.bracket3 })
hi("RainbowDelimiterBlue", { fg = c.bracket2 })
hi("RainbowDelimiterOrange", { fg = c.orange })
hi("RainbowDelimiterGreen", { fg = c.bracket1 })
hi("RainbowDelimiterViolet", { fg = c.bracket5 })
hi("RainbowDelimiterCyan", { fg = c.cyan })
