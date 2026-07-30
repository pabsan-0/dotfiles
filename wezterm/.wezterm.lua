local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- TODO
-- config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- config.quick_select_patterns = {}


-- Perf and rendering
config.front_end = "Software"
config.animation_fps = 1
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.max_fps = 60
config.enable_wayland = false
config.use_ime = false
config.freetype_render_target = 'HorizontalLcd'
config.freetype_load_target = 'Light'


-- Looks (colors at the bottom)
config.font = wezterm.font('monospace')
config.font_size = 13.0
config.window_background_opacity = 0.9
config.enable_scroll_bar = true
config.window_padding = {
  left = 2,
  right = 4,
  top = 0.01,
  bottom = 0.01,
}


-- Muxing
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

wezterm.on('conditional-leader', function(window, pane)
    local process_name = pane:get_foreground_process_name() or ""
    local pane_title = pane:get_title() or ""

    if process_name:find('tmux') or pane_title:find('tmux') then
        window:perform_action(wezterm.action.SendKey { key = 's', mods = 'CTRL' }, pane)
    else
        window:perform_action(wezterm.action.ActivateKeyTable {
            name = 'wezterm_tmux_like',
            one_shot = true,
            timeout_milliseconds = 1000,
        }, pane)
    end
end)

config.key_tables = {
  wezterm_tmux_like = {
    { key = 't', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', action = wezterm.action.CloseCurrentTab { confirm = true } },
    { key = '%', mods = 'SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '"', mods = 'SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = "c", action = wezterm.action.SpawnTab("CurrentPaneDomain"), },
    { key = "p", action = wezterm.action.ActivateTabRelative(-1), },
    { key = "n", action = wezterm.action.ActivateTabRelative(1), },
    { key = '1', action = wezterm.action.ActivateTab(0) },
    { key = '2', action = wezterm.action.ActivateTab(1) },
    { key = '3', action = wezterm.action.ActivateTab(2) },
    { key = '4', action = wezterm.action.ActivateTab(3) },
    { key = '5', action = wezterm.action.ActivateTab(4) },
    { key = '6', action = wezterm.action.ActivateTab(5) },
    { key = '7', action = wezterm.action.ActivateTab(6) },
    { key = '8', action = wezterm.action.ActivateTab(7) },
    { key = '9', action = wezterm.action.ActivateTab(8) },
    { key = 'x', action = wezterm.action.CloseCurrentTab { confirm = true }, },
    { key = 'h', action = wezterm.action.ActivatePaneDirection 'Left', },
    { key = 'j', action = wezterm.action.ActivatePaneDirection 'Down', },
    { key = 'k', action = wezterm.action.ActivatePaneDirection 'Up', },
    { key = 'l', action = wezterm.action.ActivatePaneDirection 'Right', },
  }
}

config.keys = {
    -- Leader: Ctrl+s by default, unless in tmux. Ctrl+Shift+s always reaches wezterm
    {
        key = 's',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent 'conditional-leader',
    },
    {
        key = 'S',
        mods = 'CTRL',
        action = wezterm.action.ActivateKeyTable {
            name = 'wezterm_tmux_like',
            one_shot = true,
            timeout_milliseconds = 1000,
        },
    },
    -- Open a new Terminal at the current directory
    {
        key = 'Enter',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SpawnWindow,
    },
    -- Shift space is space (sanity)
    {
        key = ' ',
        mods = 'SHIFT',
        action = wezterm.action.SendString ' '
    },
    -- Scans terminal for filenames and opens selection in $EDITOR
    {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.QuickSelectArgs {
        label = 'open in editor',
        action = wezterm.action_callback(function(window, pane)
          local selection = window:get_selection_text_for_pane(pane)
          local file_path = selection:gsub('^%s*(.-)%s*$', '%1')
          local editor = os.getenv('EDITOR') or 'vim'
          window:perform_action(
            wezterm.action.SpawnCommandInNewTab {
              args = { editor, file_path },
            },
            pane
          )
        end),
      },
    },
    -- Dump all scrollback into $EDITOR
    {
        key = 'h',
        mods = 'CTRL|SHIFT',
        action = wezterm.action_callback(function(window, pane)

            local dimensions = pane:get_dimensions()
            local total_lines = dimensions.scrollback_rows + dimensions.viewport_rows
            local text = pane:get_lines_as_text(total_lines)

            local tmp_dir = os.getenv("TMPDIR") or "/tmp"
            local timestamp = os.date("%Y%m%d_%H%M%S")
            local random_suffix = math.random(1000, 9999)
            local name = string.format("%s/wezterm_scrollback_%s_%s.txt", tmp_dir, timestamp, random_suffix)

            local f = io.open(name, 'w+')
            f:write(text)
            f:flush()
            f:close()
            window:perform_action(
                wezterm.action.SpawnCommandInNewTab {
                    args = {
                        'vim', name,
                        '-c', 'set buftype=nofile readonly nolist',
                        '-c', 'xnoremap y "+y',
                        '-c', 'nnoremap y "+y',
                        '-c', 'nnoremap yy "+yy',
                        '-c', 'nnoremap Y "+Y',
                        '-c', 'normal G'
                    },
                },
                pane
            )

            -- Cleanup is optional: files go to /tmp
            -- wezterm.sleep_ms(1000)
            -- os.remove(name)
      end),
    },
}


config.colors = {
    foreground = '#FFFFFF',
    background = '#000000',

    ansi = {
        '#000000', -- Black (Color0)
        '#B21818', -- Red (Color1)
        '#18B218', -- Green (Color2)
        '#B26818', -- Yellow (Color3)
        '#1818B2', -- Blue (Color4)
        '#B218B2', -- Magenta (Color5)
        '#18B2B2', -- Cyan (Color6)
        '#B2B2B2', -- White (Color7)
    },

    brights = {
        '#686868', -- Bright Black (Color0Intense)
        '#FF5454', -- Bright Red (Color1Intense)
        '#54FF54', -- Bright Green (Color2Intense)
        '#FFFF54', -- Bright Yellow (Color3Intense)
        '#5454FF', -- Bright Blue (Color4Intense)
        '#FF54FF', -- Bright Magenta (Color5Intense)
        '#54FFFF', -- Bright Cyan (Color6Intense)
        '#FFFFFF', -- Bright White (Color7Intense)
    },
}

config.window_background_gradient = {
    orientation = { Linear = { angle = -45.0 } },
    colors = {
        '#121b2d', -- Top-Left: Deep midnight blue (firmly blue, not black)
        '#16162a', -- Deep indigo
        '#0b0e14', -- Top: Very deep, near-black void blue
    },
    blend = 'Oklab',
}


-- Tab titles
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
	local tab_title = ''
	local pane = tab.active_pane
	local process_name = pane.foreground_process_name
	local process_aliases = {
		['vim.gtk3'] = 'vim',
	}

	if process_name and #process_name > 0 then
		tab_title = process_name:match('([^/\\]+)$')
		if process_aliases[tab_title] then
			tab_title = process_aliases[tab_title]
		end
	end
	if tab_title == '' then
		tab_title = pane.title
	end
	local index = tab.tab_index + 1
	local final_title = string.format(' %d: %s ', index, tab_title)
	return { { Text = final_title }, }
end)

return config
