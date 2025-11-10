@abstract
extends ItemList
class_name KeyMenu

var selectedIdx: int
var selectedVar: Variant
var list: Array[Variant]

@export var next: KeyMenu
@export var prev: KeyMenu

@export var nextAction = &"ui_accept"
@export var prevAction = &"ui_text_backspace"
@export var upAction = &"ui_up"
@export var downAction = &"ui_down"

signal _on_selected(selectedVar: Variant)

func _ready() -> void:
	set_process_input(false)

func update(items: Array, highlight: bool = true, showInspector: bool = true):
	self.list = items
	clear()
	for item in items:
		add(item)
	
	cycle(0, highlight, showInspector)

func cycle(dx: int, highlight: bool = true,  showInspector: bool = true):
	if not self.list.size():
		return

	var found = false
	for j in range(self.list.size()+1):
		self.selectedIdx = (self.selectedIdx + dx + j + self.list.size()) % self.list.size()
		if is_item_selectable(self.selectedIdx):
			self.selectedVar = self.list[self.selectedIdx]
			found = true
			break
		
	assert(found, "Could't find any selectable item!!")

	
	if showInspector:
		update_inspector(self.selectedVar)
	if highlight:
		select(self.selectedIdx)

func select_item(idx: int):
	self.deselect_all()
	self.select(idx)
	self.selectedIdx = idx
	self.selectedVar = self.list[idx]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(nextAction):
		if next:
			next.set_process_input(true)
			next.cycle(0)

		self.set_process_input(false)
		changeMenu(selectedVar)
	elif event.is_action_pressed(prevAction) and prev:
		deselect_all()
		prev.set_process_input(true)
		self.set_process_input(false)
		changeMenu(null)
	elif event.is_action_pressed(upAction):
		cycle(1)
	elif event.is_action_pressed(downAction):
		cycle(-1)

func changeMenu(selected: Variant):
	_on_selected.emit(selected)

@abstract
func add(item: Variant)

@abstract
func update_inspector(item: Variant)
