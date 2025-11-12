extends Object
class_name Utiles

static func reduce_string(origine: String, reducer: String, bonus_len := 0) -> String:
	if reducer.is_subsequence_of(origine):
		origine = origine.substr(len(reducer) + bonus_len)
	return origine

static func call_if_component(owner: Node, component_name: String, callable: Callable):
	var component = owner.get_node_or_null(component_name)
	
	if component:
		callable.call()

static func has_property(node: Node, prop_name: String) -> bool:
	var property_list: Array[Dictionary] = node.get_property_list()
	
	for property in property_list:
		if property.name == prop_name:
			return true
	
	return false

static func get_value_if_exist(dict: Dictionary, key: String) -> Variant:
	if dict.has(key):
		return dict[key]
	return null

static  func setup_grid_child_neighbour(grid: GridContainer) -> void:
	var columns: int= grid.columns
	var child_count: int= grid.get_child_count()
	
	if columns <= 1 or child_count < 2: return
	
	for i in child_count:
		var button: Button= grid.get_child(i)
		
		if i in range(columns): #En haut
			button.focus_neighbor_top = grid.get_child(child_count - columns + i).get_path()
		elif i in range(child_count - columns , child_count): #En bas
			button.focus_neighbor_bottom = grid.get_child(columns  -(child_count - i)).get_path()
		
		if i % columns == 0: #A gauche
			button.focus_neighbor_left = grid.get_child(i + columns - 1).get_path()
		elif (i + 1) % columns == 0: #A droite
			button.focus_neighbor_right = grid.get_child(i - columns + 1).get_path()

static func free_all_children(node: Node) -> void:
	for child in node.get_children():
		child.free()

static func count_bits(n: int) -> int:
	var count = 0
	while n:
		n &= n - 1
		count += 1
	return count

#static func get_property_name_from_value(object: Object, value: Variant) -> String:
	#for property in object.get_property_list():
		#var property_name = property.name
		#print(value)
		#print(object, " -> ", object.get(property_name))
		#if value != object.get(property_name):
			#return property_name
	#return ""

static func get_property_name_from_value(obj: Object, value_to_find) -> String:
	for property_info in obj.get_property_list():
		var prop_name = property_info.name
		var prop_value = obj.get(prop_name)

		# Comparaison robuste selon le type
		if typeof(prop_value) == typeof(value_to_find):
			if typeof(prop_value) in [TYPE_OBJECT]:
				# Si ce sont des objets, on compare leurs références (si valides)
				if is_instance_valid(prop_value) and is_instance_valid(value_to_find) and prop_value == value_to_find:
					return prop_name
			else:
				# Sinon, comparaison classique
				if prop_value == value_to_find:
					return prop_name
	return ""

static func uppercase_first_letter(text: String) -> String:
	if text.is_empty():
		return text
	return text[0].to_upper() + text.substr(1)

static func compute_collision_height(collision: Node2D) -> float:
	if collision is CollisionShape2D:
		var shape: Shape2D= collision.shape
		if shape is CircleShape2D: return shape.radius
		if shape is RectangleShape2D: return shape.size.y
		if shape is CapsuleShape2D: return shape.height
	
	return 0.0

static func compute_collision_lenght(collision: Node2D) -> float:
	if collision is CollisionShape2D:
		var shape: Shape2D= collision.shape
		if shape is CircleShape2D: return shape.radius
		if shape is RectangleShape2D: return shape.size.x
		if shape is CapsuleShape2D: return shape.radius/2
	
	return 0.0
