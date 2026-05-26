extends Control

@onready var sub_viewport_container1: SubViewportContainer = $HBoxContainer/SubViewportContainer1
@onready var sub_viewport1: SubViewport = $HBoxContainer/SubViewportContainer1/SubViewport1
@onready var sub_viewport2: SubViewport = $HBoxContainer/SubViewportContainer2/SubViewport2
@onready var viewport_size_label1: Label = $CanvasLayer/ViewportSizeLabel1
@onready var viewport_size_label2: Label = $CanvasLayer/ViewportSizeLabel2
@onready var camera1: Camera2D = $HBoxContainer/SubViewportContainer1/SubViewport1/Camera2D
@onready var camera2: Camera2D = $HBoxContainer/SubViewportContainer2/SubViewport2/Camera2D


func _ready() -> void:
    create_window_title_update_timer()
    update_window_title()


func _process(_delta: float) -> void:
    viewport_size_label1.text = "Viewport: %d×%d (stretch ×%d)" % [sub_viewport1.size.x, sub_viewport1.size.y, sub_viewport_container1.stretch_shrink]
    viewport_size_label2.text = "Viewport: %d×%d" % [sub_viewport2.size.x, sub_viewport2.size.y]

    camera1.position += Vector2(40, 0) * _delta
    camera2.position += Vector2(160, 0) * _delta


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_fullscreen"):
        toggle_fullscreen()
    elif event.is_action_pressed("quit"):
        get_tree().quit()


func create_window_title_update_timer() -> void:
    var timer := Timer.new()
    add_child(timer)
    timer.timeout.connect(update_window_title)
    timer.start(1.0)


func update_window_title() -> void:
    get_window().title = "%s [%d FPS]" % [ProjectSettings.get_setting("application/config/name"), Performance.get_monitor(Performance.TIME_FPS)]


func toggle_fullscreen() -> void:
    if DisplayServer.window_get_mode() != DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
        DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
    else:
        DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
