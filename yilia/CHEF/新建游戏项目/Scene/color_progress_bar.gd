class_name ColorProgressBar
extends ProgressBar

@export var fill_color: Color
@export var empty_color: Color

var fill_style_box: StyleBoxFlat

func _ready() -> void:
	fill_style_box = get_theme_stylebox("fill")

func _process(_delta: float) -> void:
	var weight: float = remap(value, min_value, max_value, 0, 1)
	var finish_color: Color = empty_color.lerp(fill_color, weight)
	fill_style_box.bg_color = finish_color
