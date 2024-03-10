################################################################################
#
# Base class for power. Contains the name, activation threshold, and icon
# Methods should be overridden if needed.
#
################################################################################

class_name Power
var name: String
var funk_threshold: int
var image: CompressedTexture2D

func _init(n: String, tex_path: String, f: int = -1) -> void:
	name = n
	funk_threshold = f
	image = load(tex_path) as CompressedTexture2D

func get_texture() -> CompressedTexture2D:
	return image

func is_satisfied() -> bool:
	#prints(PowerManager.funk_tracker.funk, ">=", funk_threshold, PowerManager.funk_tracker.funk >= funk_threshold)
	return PowerManager.funk_tracker.funk >= funk_threshold
