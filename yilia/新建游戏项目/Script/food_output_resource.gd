class_name FoodOutputResource
extends Resource

@export var name: String
@export var texture: Texture2D
@export var crafting_list: Array[FoodResource]

func can_crafte(list: Array[FoodResource]) -> bool:
	if list.size() != crafting_list.size():
		return false
	
	var arr1: Array[FoodResource] = crafting_list.duplicate()
	var arr2: Array[FoodResource] = list.duplicate()
	
	for food_resource: FoodResource in arr1:
		var index: int = find(arr2, food_resource)
		if index < 0:
			return false
		arr2.remove_at(index)
	
	return true

func find(from: Array[FoodResource], what: FoodResource) -> int:
	for i in from.size():
		if from[i].name == what.name:
			return i
	return -1
