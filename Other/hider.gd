extends VisibleOnScreenNotifier2D
class_name Hider

#func _ready() -> void:
	#screen_entered.connect(func(): owner.visible= true)
	#screen_exited.connect(func(): 
		#owner.visible= false)
