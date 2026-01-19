@abstract
extends Resource
class_name Statistics

var statistics: Dictionary[String, float]:
	get =  get_statistics

var buffs: Array[Buff]

signal buff_added(buff: Buff)
signal buff_removed(buff: Buff)

signal stat_updated(stat_name: String)

signal stat_upgraded_permanently(stat_name: String, amount: float)

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
		_update_stat(stat_name)
		buff_added.emit(buff)


func remove_buff(buff: Buff) -> void:
	if buff in buffs:
		buffs.erase(buff)
		_update_stat(buff.stat_name)
		buff_removed.emit(buff)

func upgrade_permanently(stat_name: String, amount: float) -> void:
	var stat: float= get(stat_name)
	if not stat: return
	
	set("base_" + stat_name, stat + amount)
	stat_upgraded_permanently.emit(stat_name, amount)
	
	_update_stat(stat_name)

func _update_stat(stat_name: String) -> void:
	var base_stat_name: String= "base_" + stat_name
	var base_stat: float= get(base_stat_name)
	if not base_stat: return
	
	var stat: float= (base_stat + get_add_buff_total(stat_name)) * get_mult_coef(stat_name)
	
	set(base_stat_name, stat)
	stat_updated.emit(stat_name)
