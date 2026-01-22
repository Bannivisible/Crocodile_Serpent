@abstract
extends Resource
class_name Statistics

const BASE_STAT_PREFIX: String= "base_"
const MAX_STAT_PREFIX: String= "max_"

var statistics: Dictionary[String, float]:
	get =  get_statistics

var buffs: Array[Buff]

signal buff_added(buff: Buff)
signal buff_removed(buff: Buff)

signal stat_updated(stat_name: String)

signal stat_upgraded_permanently(stat_name: String, value: float)

signal variable_stat_changed(stat_name: String, value: float)

@abstract
func get_statistics() -> Dictionary[String, float]

func get_stat_buffs(stat_name: String, buff_array: Array[Buff]= buffs) -> Array[Buff]:
	var stat_buffs: Array[Buff]
	
	for buff in buff_array:
		if buff.stat_name == stat_name:
			stat_buffs.append(buff)
	
	return stat_buffs


func get_buffs_type(type: Buff.BUFFS_TYPES, buff_array: Array[Buff]= buffs) -> Array[Buff]:
	var buffs_type: Array[Buff]
	
	for buff in buff_array:
		if buff.type == type: buffs_type.append(buff)
	
	return buffs_type


func get_good_buffs(buff_array: Array[Buff]= buffs) -> Array[Buff]:
	var good_buffs: Array[Buff]
	
	for buff in buff_array:
		if buff.type == Buff.BUFFS_TYPES.ADD and buff.amount >= 0.0:
			good_buffs.append(buff)
		
		elif buff.type == Buff.BUFFS_TYPES.MULTIPLY and buff.amount >= 1.0:
			good_buffs.append(buff)
	
	return good_buffs


func get_debuffs(buff_array: Array[Buff]= buffs) -> Array[Buff]:
	var debuffs: Array[Buff]
	
	for buff in buff_array:
		if buff.type == Buff.BUFFS_TYPES.ADD and buff.amount < 0.0:
			debuffs.append(buff)
		
		elif buff.type == Buff.BUFFS_TYPES.MULTIPLY and buff.amount < 1.0:
			debuffs.append(buff)
	
	return debuffs


func get_add_buff_total(stat_name: String) -> float:
	var total: float= 0.0
	
	for buff in get_buffs_type(Buff.BUFFS_TYPES.ADD, get_stat_buffs(stat_name)):
		total += buff.amount
	
	return total


func get_mult_coef(stat_name: String) -> float:
	var coef: float= 1.0
	
	for buff in get_buffs_type(Buff.BUFFS_TYPES.MULTIPLY, get_stat_buffs(stat_name)):
		coef += buff.amount
		
	return coef


func append_buff(buff: Buff) -> void:
	var stat_name: String= buff.stat_name
	
	if get_statistics().has(stat_name):
		buffs.append(buff)
		update_stat(stat_name)
		buff_added.emit(buff)


func remove_buff(buff: Buff) -> void:
	if buff in buffs:
		buffs.erase(buff)
		update_stat(buff.stat_name)
		buff_removed.emit(buff)


func remove_all_occurence_of_buff(buff: Buff) -> void:
	while buff in buffs:
		remove_buff(buff)


func remove_all_buffs_of_stat(stat_name: String) -> void:
	for buff in buffs:
		if buff.stat_name == stat_name:
			remove_buff(buff)


func remove_all_buffs() -> void:
	for buff in buffs:
		remove_buff(buff)


func upgrade_permanently(stat_name: String, amount: float) -> void:
	var stat: float= get(stat_name)
	if not stat: return
	
	set(BASE_STAT_PREFIX + stat_name, stat + amount)
	stat_upgraded_permanently.emit(stat_name, amount)
	
	update_stat(stat_name)


func get_min_value(stat_name: String) -> float:
	var min_value = get("min_" + stat_name)
	if not min_value is float: min_value = 0.0
	
	return min_value


func update_stat(stat_name: String) -> void:
	var base_stat: float= get(BASE_STAT_PREFIX + stat_name)
	if not base_stat: return
	
	var new_value: float= (base_stat + get_add_buff_total(stat_name)) * get_mult_coef(stat_name)
	var min_value = get_min_value(stat_name)
	
	var stat: float= max(min_value ,new_value)
	
	set(stat_name, stat)
	stat_updated.emit(stat_name)


func update_all_stat() -> void:
	for stat_name in statistics.keys():
		update_stat(stat_name)


func get_max_variable_stats() -> Dictionary[String, float]:
	var stat_name_dict: Dictionary[String, float]= {}
	
	for stat_name in statistics.keys():
		if stat_name.begins_with(MAX_STAT_PREFIX):
			stat_name_dict[stat_name] = statistics[stat_name]
	
	return stat_name_dict


func get_variable_stats() -> Dictionary[String ,float]:
	var stat_dict: Dictionary[String ,float]
	
	for max_stat_name in get_max_variable_stats():
		var stat_name = max_stat_name.substr(len(MAX_STAT_PREFIX))
		stat_dict[stat_name] = get(stat_name)
	
	return stat_dict


func get_current_value(max_stat_name: String) -> float:
	return get(max_stat_name.substr(len(MAX_STAT_PREFIX)))


func is_max_stat(stat_name: String) -> bool:
	return stat_name.begins_with(MAX_STAT_PREFIX)


func set_variable_stat(stat_name: String, value: float) -> void:
	if value == get(stat_name): return
	
	var max_stat: float= get(MAX_STAT_PREFIX + stat_name)
	set(stat_name, clamp(value, 0.0, max_stat))
	
	variable_stat_changed.emit(stat_name, value)
