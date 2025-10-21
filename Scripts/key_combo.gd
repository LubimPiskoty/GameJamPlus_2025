class_name KeyCombo
extends Control
## Author: Piskotka

@export var correctColor: Color = Color.GREEN

@onready var label: RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel
# Progress bar for visualisation of remaining time
@onready var progress: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar
	
func doComboString(characters: String, time: float) -> int:
	self.visible = true
	
	label.text = characters
	progress.value=0
	await get_tree().create_timer(0.5).timeout
	
	var startTime = Time.get_ticks_msec()
	var last_char = ""
	var i = 0
	while i < characters.length() and (startTime + time*1000 - Time.get_ticks_msec()) > 0:
		var char = characters[i]
		if char == last_char:
			if not Input.is_key_pressed(char.unicode_at(0) as Key):
				last_char = ""
		elif Input.is_key_pressed(char.unicode_at(0) as Key):
			i += 1
			label.text = ""
			label.push_color(correctColor)
			label.append_text(characters.substr(0, i))
			label.pop()
			label.append_text(characters.substr(i))
			last_char = char
			
		
		# Update progress bar
		progress.value = (Time.get_ticks_msec() - startTime)/(time*10)
		await get_tree().process_frame # Await new frame
			
	

	await get_tree().create_timer(0.3).timeout
	label.text = str(i)
	await get_tree().create_timer(0.8).timeout

	self.visible = false
	return i # Return the number of correctly pressed keys 

func doComboLength(lenght: int, time: float):
	var string = ""
	for i in range(lenght):
		string += char(randi_range(ord("A"), ord("Z")))
	return await doComboString(string, time)
