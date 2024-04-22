-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.warn_about_missing_glyphs = false
-- Color scheme
config.color_scheme = "Balam"
config.color_schemes = {
  ["Balam"] = {
    foreground = "#e3e3e3",
    background = "#161617",

    cursor_bg = "#e3e3e3",
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = "#161617",
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- of the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = "#e3e3e3",
    -- the foreground color of selected text
    selection_fg = "#161617",
    -- the background color of selected text
    selection_bg = "#e3e3e3",
    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = "#333333",
    -- The color of the split lines between panes
    split = "#333333",
    ansi = {
      "#161616",
      "#fc3030",
      "#7ee031",
      "#dbdb32",
      "#2691fc",
      "#c936d6",
      "#60d4d2",
      "#d8d8d8",
    },
    brights = {
      "#585858",
      "#ff5b5b",
      "#aaf873",
      "#faee78",
      "#529ff7",
      "#fa7ddd",
      "#80fff4",
      "#f8f8f8",
    }
  }
}

-- Keybinds
local act = wezterm.action
config.keys = {
    -- Create a new tab in the same domain as the current pane.
    {
        key = 't',
        mods = 'ALT',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'q',
        mods = 'ALT',
        action = wezterm.action.CloseCurrentTab { confirm = true },
    },
    { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
    { key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },     
  }
  
-- Misc
config.font = wezterm.font 'Hack Nerd Font Mono'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.hide_tab_bar_if_only_one_tab = true


return config