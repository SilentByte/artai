extends Reference
class_name CuratorItem

var author: String
var title: String
var texture: StreamTexture


func _init(author: String, title: String, texture: StreamTexture) -> void:
	self.author = author
	self.title = title
	self.texture = texture
