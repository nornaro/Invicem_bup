extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_polygon_area_transparent($Main/Area.polygon)

func make_polygon_area_transparent(polygon: PackedVector2Array) -> void:
	var texture = $VillageMt.texture as ImageTexture
	var image = textur	e.get_data()
	image.lock()

	# Convert image to RGBA8 if not already
	if image.get_format() != Image.FORMAT_RGBA8:
		image.convert(Image.FORMAT_RGBA8)

	# Modify the image based on polygon
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var point = Vector2(x, y)
			if is_point_in_polygon(point, polygon):
				var color = image.get_pixel(x, y)
				color.a = 0  # Make the pixel fully transparent
				image.set_pixel(x, y, color)

	image.unlock()

	# Create a new texture from the modified image
	var new_texture = ImageTexture.new()
	new_texture.create_from_image(image)
	self.texture = new_texture  # Apply the new texture to this Sprite
	self.modulate = Color(1, 1, 1, 1)  # Ensure full visibility with default modulate

func is_point_in_polygon(point: Vector2, polygon: PackedVector2Array) -> bool:
	var count = polygon.size()
	var inside = false
	for i in range(count):
		var a = polygon[i]
		var b = polygon[(i + 1) % count]
		if (a.y > point.y) != (b.y > point.y) and (point.x < (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x):
			inside = not inside
	return inside
