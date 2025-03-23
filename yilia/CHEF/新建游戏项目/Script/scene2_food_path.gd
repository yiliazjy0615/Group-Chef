extends Node2D


@export var path2d: Path2D

func _process(delta: float) -> void:
	for path_follow: PathFollow2D in path2d.get_children():
		path_follow.progress_ratio += delta * 0.1
		if path_follow.progress_ratio == 1:
			path_follow.progress_ratio = 0.45
