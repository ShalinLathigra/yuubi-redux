################################################################################
#
# Data class containing all of the info relating to the frequency with which
# beats will come. In theory, changing this will cause effects to be felt across
# all other listeners.
#
# May need signal here to be emitted whenever options here change to inform
# rest of the game to retrieve the correct values. Maybe... Or they take directly
# from here?
#
################################################################################

class_name GameBeatInfo extends Resource

# Functional Params
# 60000 / bpm = ms / beat Do this conversion for determining the edges
@export_range(0, 240, 1) var beats_per_minute: int :
	set (value):
		beats_per_minute = value
	get:
		return beats_per_minute

@export_range(0, 500, 2) var beat_width: int

# Display Only Parameters
@export_range(-250, 250, 2) var display_offset: float = 0
@export_range(0, 16.0) var display_radius: float
@export_range(0, 5.0, .1) var time_to_sweet_spot: float
@export_range(0, 16.0) var skin_width: float
@export_range(0, 16.0) var sweet_spot_width: float
@export var gradient: GradientTexture1D
