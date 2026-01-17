extends ColorRect

@onready var popup_label: Label = $"../Style Label"
@onready var style_sound: AudioStreamPlayer = $"../../Style_Switch"

@export var max_styles := 7
var current_style := 0

var style_names := [
	"Default",
	"Monochrome",
	"Ultra Saturated",
	"Sepia",
	"Filmic",
	"Rio",
	"VHS"
]

var popup_tween: Tween

func _ready() -> void:
	material.set_shader_parameter("style", current_style)
	popup_label.modulate.a = 0.0

func _unhandled_input(event):
	if event.is_action_pressed("StyleSwitch"):
		cycle_style()

func cycle_style():
	current_style = (current_style + 1) % max_styles
	material.set_shader_parameter("style", current_style)
	_show_style_popup(style_names[current_style])
	_play_switch_sound()

func _show_style_popup(text: String):
	popup_label.text = text
	popup_label.modulate.a = 1.0

	if popup_tween and popup_tween.is_valid():
		popup_tween.kill()

	popup_tween = popup_label.create_tween()
	popup_tween.tween_property(
		popup_label,
		"modulate:a",
		0.0,
		1.0
	).set_delay(1.0)

func _play_switch_sound():
	if not style_sound.playing:
		style_sound.play()
