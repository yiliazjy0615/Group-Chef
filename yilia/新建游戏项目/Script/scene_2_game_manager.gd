class_name Scene2GameManager
extends Node2D

@export var character_animation_player: AnimationPlayer
@export var character_timer: Timer
@export var character_entity: CharacterEntity

@export var output_food_entity: FoodEntity
@export var output_food_default_position: Marker2D

@export var foods: Node2D

@export var output_dish: DishEntity

@export var food_output_list: Array[FoodOutputResource]

@export var clear_button: TextureButton
@export var progress_bar: ColorProgressBar

@export var health_bar: HealthBar

@export var faild_scene: PackedScene

var current_health: int = 3

var current_food_resource: FoodResource
var current_sprite: Sprite2D

var food_list: Array[FoodResource]

func _ready() -> void:
	output_food_entity.submit.connect(_on_food_output_entity_submit)
	clear_button.pressed.connect(_on_clear_button_pressed)
	randomize()
	character_entity.random_look()
	character_entity.set_food_output_resource(get_random_food())
	character_animation_player.play("character_in")
	await character_animation_player.animation_finished
	await character_entity.show_food()
	character_timer.timeout.connect(_on_character_timer_timeout)
	character_timer.start(10.0)

func _on_clear_button_pressed() -> void:
	for n in get_children():
		n.queue_free()
	food_list.clear()

func _on_character_timer_timeout() -> void:
	current_health -= 1
	health_bar.set_health(current_health)
	if current_health <= 0:
		get_tree().change_scene_to_packed(faild_scene)
	await character_entity.submit_food(null)
	character_loop()
	

func character_loop() -> void:
	character_animation_player.play("character_out")
	await character_animation_player.animation_finished
	character_entity.random_look()
	character_entity.set_food_output_resource(get_random_food())
	character_animation_player.play("character_in")
	await character_animation_player.animation_finished
	await character_entity.show_food()
	character_timer.start(10)

func _on_food_output_entity_submit() -> void:
	if character_entity.is_inside():
		character_timer.stop()
		var resource: FoodOutputResource = output_food_entity.food_resource
		output_food_entity.set_resource(null)
		var output: bool = await character_entity.submit_food(resource)
		if output == false:
			current_health -= 1
			health_bar.set_health(current_health)
			if current_health <= 0:
				get_tree().change_scene_to_packed(faild_scene)
		character_loop()
	
	output_food_entity.position = output_food_default_position.position
		

func _process(_delta: float) -> void:
	progress_bar.value = character_timer.time_left
	
	if is_instance_valid(current_sprite):
		current_sprite.global_position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and not output_food_entity.is_active():
		var dish_entity: DishEntity = get_click_dish()
		if dish_entity != null and dish_entity.food_resource != null:
			current_food_resource = dish_entity.food_resource
			if current_sprite != null:
				current_sprite.queue_free()
			current_sprite = Sprite2D.new()
			current_sprite.scale = dish_entity.sprite_scale
			add_child(current_sprite)
			current_sprite.texture = current_food_resource.texture
	elif event.is_action_released("click"):
		if current_food_resource == null:
			return
		if output_dish.is_inside():
			food_list.append(current_food_resource)
			
			current_food_resource = null
			current_sprite = null
			
			var food_output_resource: FoodOutputResource = can_craft()
			if food_output_resource != null:
				output_food_entity.set_resource(food_output_resource)
				for n in get_children():
					n.queue_free()
				food_list.clear()
		else:
			current_food_resource = null
			current_sprite.queue_free()

func can_craft() -> FoodOutputResource:
	for output: FoodOutputResource in food_output_list:
		if output.can_crafte(food_list):
			return output
	return null

func get_click_dish() -> DishEntity:
	for dish: DishEntity in foods.get_children():
		if dish.is_inside():
			return dish
	
	return null

func get_random_food() -> FoodOutputResource:
	return food_output_list.pick_random()
