extends Script



var traits = ["None","None","None"]
var count = 0
# Called when the node enters the scene tree for the first time.
func _change_traits(argument: String):
	if count < len(traits) and traits[count] == "None":
		traits[count] = argument
		count += 1
		print(traits)

func _get_traits() -> Array:
	return traits
 
