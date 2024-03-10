################################################################################
#
# Current iteration of the Beat UI. Known desync issues that need to be addressed.
# This object will receive a few parameters on game start, then will calculate
# the Dots and lines to be drawn accordingly.
#
# May want to move to a more "tangible" method in the future to simplify the Beat
# Manager's work determining beat validity.
#
################################################################################

extends Node2D

var num_beats: int
var converted_rate: float
@export var offset: Vector2
@export var bounds: RectangleShape2D
@export var stats: GameBeatInfo
var time_trackers: Array[float]
var dbg: bool

func _ready() -> void:
	converted_rate = bounds.size.x / (stats.time_to_sweet_spot * 1000.0)

func inject_data(num_beats_in: int, \
				time_trackers_in: Array[float], \
				dbg_in: bool) -> void:
	num_beats = num_beats_in
	time_trackers = time_trackers_in
	dbg = dbg_in

func _draw() -> void:
	draw_circle(offset, stats.display_radius + (stats.skin_width + stats.sweet_spot_width) * 2.0, Color.BLACK)
	draw_rect(Rect2(Vector2(offset.x-6,offset.y-35), Vector2(12,70)), Color.BLACK)
	if dbg:
		draw_rect(Rect2(Vector2(offset.x-2,offset.y-20), Vector2(4,40)), Color.YELLOW)
	for i in range(num_beats):
		var t = time_trackers[i]
		var x = offset.x + bounds.size.x * .5 - bounds.size.x * clamp(t, 0.0, 1.0)
		var y = offset.y
		var origin = Vector2(x,y)

		# Draw the background
		var rad: float = stats.display_radius + stats.skin_width * 2.0
		rad *= float((i % 2)) * 0.25 + 0.75
		var colour: Color = Color.DARK_GRAY if t < 0.5 else Color.BLACK
		draw_circle(origin, rad, colour)
		#draw_rect(Rect2(Vector2(x-4.5,y-27.5), Vector2(9,55)), Color.WHITE)

		# Draw the leading edges
		var leading_edge = Vector2.RIGHT * converted_rate * (stats.beat_width / 2.0 + stats.display_offset)
		var trailing_edge = Vector2.RIGHT * converted_rate * stats.beat_width
		if dbg:
			draw_line(origin - leading_edge, origin - leading_edge + trailing_edge, Color.YELLOW, 5)
			#for j in range(i + 1):
				#draw_circle(origin + Vector2.DOWN * 20 * j, 5, Color.YELLOW)

