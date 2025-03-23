class_name CharacterEntity
extends Node2D

@export var animated_sprite: AnimatedSprite2D

@export var food_output_resource: FoodOutputResource

@export var dialogue_animated_sprite: AnimatedSprite2D

@export var emoji_animated_sprite: AnimatedSprite2D

@export var food_sprite: Sprite2D

var active: bool = false

func random_look() -> void:
	var anim_names: PackedStringArray = animated_sprite.sprite_frames.get_animation_names()
	var index: int = randi() % anim_names.size()
	var anim: String = anim_names[index]
	animated_sprite.play(anim)

func set_food_output_resource(fr: FoodOutputResource) -> void:
	food_output_resource = fr
	food_sprite.texture = food_output_resource.texture

func show_food() -> void:
	emoji_animated_sprite.hide()
	food_sprite.hide()
	dialogue_animated_sprite.show()
	dialogue_animated_sprite.play("fade_in")
	await dialogue_animated_sprite.animation_finished
	food_sprite.show()
	food_sprite.texture = food_output_resource.texture
	active = true

func submit_food(food: FoodOutputResource) -> bool:
	var output: bool = false
	food_sprite.hide()
	active = false
	emoji_animated_sprite.show()
	if food != null and food.name == food_output_resource.name:
		emoji_animated_sprite.play("happy")
		output = true
	else:
		emoji_animated_sprite.play("emo")
		output = false
	await get_tree().create_timer(1.0).timeout
	emoji_animated_sprite.hide()
	dialogue_animated_sprite.play("fade_out")
	await dialogue_animated_sprite.animation_finished
	dialogue_animated_sprite.hide()
	return output

func is_inside() -> bool:
	if not active:
		return false
	
	var distance: float = get_global_mouse_position().distance_to(global_position)
	
	return distance < 70.0

@export_dir var characters_dir: String

func foo() -> void:
	var dir: DirAccess = DirAccess.open(characters_dir)
	var files: PackedStringArray = dir.get_files()
	var sprite_frames: SpriteFrames = animated_sprite.sprite_frames
	var index: int = 0
	for file in files:
		if file.get_extension() != "png":
			continue
		var animation_name: String = str(index)
		var file_path: String = characters_dir.path_join(file)
		var texture: Texture2D = load(file_path) as Texture2D
		if sprite_frames.has_animation(animation_name):
			sprite_frames.clear(animation_name)
		else:
			sprite_frames.add_animation(animation_name)
		sprite_frames.add_frame(animation_name, texture)
		index += 1
	ResourceSaver.save(sprite_frames, "res://Resources/character_sprite_frames.tres")
