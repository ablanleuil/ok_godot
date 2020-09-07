extends Control

func _ready():
	$VBoxContainer2/HBoxContainer/VBoxContainer/PB1.share($VBoxContainer2/HBoxContainer/VBoxContainer2/HSlider)
	$VBoxContainer2/HBoxContainer/VBoxContainer/PB2.share($VBoxContainer2/HBoxContainer/VBoxContainer2/HSlider2)
	$VBoxContainer2/HBoxContainer/VBoxContainer/PB3.share($VBoxContainer2/HBoxContainer/VBoxContainer2/HSlider3)
