{ config, pkgs, ... }:
let
  font = "${pkgs.meslo-lgs-nf}/share/fonts/truetype/MesloLGS NF Bold.ttf";
in
{
  config.home.packages = [
    pkgs.tofi
  ];
  config.home.file."${config.home.homeDirectory}/.config/tofi/config".text = ''
    	font = "${font}"
    	font-size = 24

    	# Perform font hinting. Only applies when a path to a font has been
    	# specified via `font`. Disabling font hinting speeds up text
    	# rendering appreciably, but will likely look poor at small font pixel
    	# sizes.
    	hint-font = true

    	# Window background
    	background-color = #1e1e2eAA

    	# Border outlines
    	outline-color = #080800

    	# Border
    	border-color = #F92672

    	# Default text
    	text-color = #cdd6f4

    	# Selection text
    	selection-color = #cba6f7

    	# Matching portion of selection text
    	selection-match-color = #b4befe

    	# Selection background
    	selection-background = #00000000

    	# Prompt to display.
    	prompt-text = ""

    	# Extra horizontal padding between prompt and input.
    	prompt-padding = 0

    	# Maximum number of results to display.
    	# If 0, tofi will draw as many results as it can fit in the window.
    	num-results = 0

    	# Spacing between results in pixels. Can be negative.
    	result-spacing = 25

    	# List results horizontally.
    	horizontal = false

    	# Minimum width of input in horizontal mode.
    	min-input-width = 0

    	# Extra horizontal padding of the selection background in pixels.
    	selection-padding = 0

    	# Width and height of the window. Can be pixels or a percentage.
    	width = 100%
    	height = 100%

    	# Width of the border outlines in pixels.
    	outline-width = 0

    	# Width of the border in pixels.
    	border-width = 0

    	# Radius of window corners in pixels.
    	corner-radius = 0

    	# Padding between borders and text. Can be pixels or a percentage.
    	padding-top = 35%
      padding-bottom = 35%
    	padding-left = 35%
      padding-right = 35%

    	# Whether to scale the window by the output's scale factor.
    	scale = true

    	# The name of the output to appear on. An empty string will use the
    	# default output chosen by the compositor.
    	output = ""

    	# Location on screen to anchor the window to.
    	#
    	# Supported values: top-left, top, top-right, right, bottom-right,
    	# bottom, bottom-left, left, center.
    	anchor = center

    	# Set the size of the exclusive zone.
    	#
    	# A value of -1 means ignore exclusive zones completely.
    	# A value of 0 will move tofi out of the way of other windows' zones.
    	# A value greater than 0 will set that much space as an exclusive zone.
    	#
    	# Values greater than 0 are only meaningful when tofi is anchored to a
    	# single edge.
    	exclusive-zone = -1

    	# Window offset from edge of screen. Only has an effect when anchored
    	# to the relevant edge. Can be pixels or a percentage.
    	margin-top = 0
    	margin-bottom = 0
    	margin-left = 0
    	margin-right = 0

    	# Hide the cursor.
    	hide-cursor = true

    	# Sort results by number of usages in run and drun modes.
    	history = true

    	# Use fuzzy matching for searches.
    	fuzzy-match = true

    	# If true, require a match to allow a selection to be made. If false,
    	# making a selection with no matches will print input to stdout.
    	# In drun mode, this is always true.
    	require-match = true

    	# If true, typed input will be hidden, and what is displayed (if
    	# anything) is determined by the hidden-character option.
    	hide-input = true

    	# Replace displayed input characters with a character. If the empty
    	# string is given, input will be completely hidden.
    	# This option only has an effect when hide-input is set to true.
    	hidden-character = ""

    	# If true, directly launch applications on selection when in drun mode.
    	# Otherwise, just print the command line to stdout.
    	drun-launch = false

    	# The terminal to run terminal programs in when in drun mode.
    	# This option has no effect if drun-launch is set to true.
    	# Defaults to the value of the TERMINAL environment variable.
    	# terminal = kitty

    	# Delay keyboard initialisation until after the first draw to screen.
    	# This option is experimental, and will cause tofi to miss keypresses
    	# for a short time after launch. The only reason to use this option is
    	# performance on slow systems.
    	late-keyboard-init = false

    	# If true, allow multiple simultaneous processes.
    	# If false, create a lock file on startup to prevent multiple instances
    	# from running simultaneously.
    	multi-instance = false
  '';
}
