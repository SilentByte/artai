extends Reference
class_name CuratorItem

var id: String
var author: String
var title: String
var texture: Texture


func _init(id: String, author: String, title: String, texture: Texture) -> void:
	self.id = id
	self.author = author
	self.title = title
	self.texture = texture
