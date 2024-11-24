extends Node
class_name Util

static func create_surface_transform(origin : Vector3, incoming_vector : Vector3, surface_normal : Vector3) -> Transform3D:
	var y = surface_normal
	var z = incoming_vector.cross(surface_normal)
	var x = surface_normal.cross(z)
	var tf := Transform3D(x.normalized(), y.normalized(), z.normalized(), origin).rotated_local(Vector3.UP, PI/2)
	return tf