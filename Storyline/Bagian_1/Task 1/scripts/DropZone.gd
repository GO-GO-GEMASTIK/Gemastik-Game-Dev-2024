extends Marker2D


func _draw():
	var color = Color(Color.BLANCHED_ALMOND.r, Color.BLANCHED_ALMOND.g, Color.BLANCHED_ALMOND.b, 0)
	draw_circle(Vector2.ZERO, 100, color)

