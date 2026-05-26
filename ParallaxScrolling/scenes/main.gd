extends Control

@onready var sub_viewport_container1: SubViewportContainer = $HBoxContainer/SubViewportContainer1
@onready var sub_viewport1: SubViewport = $HBoxContainer/SubViewportContainer1/SubViewport1
@onready var sub_viewport2: SubViewport = $HBoxContainer/SubViewportContainer2/SubViewport2
@onready var viewport_size_label1: Label = $CanvasLayer/ViewportSizeLabel1
@onready var viewport_size_label2: Label = $CanvasLayer/ViewportSizeLabel2
@onready var helo1: Sprite2D = $HBoxContainer/SubViewportContainer1/SubViewport1/Helo
@onready var helo2: Sprite2D = $HBoxContainer/SubViewportContainer2/SubViewport2/Helo


func _ready() -> void:
    create_window_title_update_timer()
    update_window_title()


func _process(delta: float) -> void:
    viewport_size_label1.text = "Viewport: %d×%d (stretch ×%d)" % [sub_viewport1.size.x, sub_viewport1.size.y, sub_viewport_container1.stretch_shrink]
    viewport_size_label2.text = "Viewport: %d×%d" % [sub_viewport2.size.x, sub_viewport2.size.y]

    var movement := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var movement_speed := 0.1 if Input.is_physical_key_pressed(Key.KEY_SHIFT) else 1.0

    handle_helo_movement(helo1, movement, movement_speed * 0.25, delta)
    handle_helo_movement(helo2, movement, movement_speed, delta)


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_fullscreen"):
        toggle_fullscreen()
    elif event.is_action_pressed("quit"):
        get_tree().quit()


func handle_helo_movement(helo: Sprite2D, movement: Vector2, movement_speed: float, delta: float) -> void:
    if !movement.is_zero_approx():
        helo.position += 500.0 * delta * movement * movement_speed
        if movement.x > 0.5 && !helo.flip_h:
            helo.flip_h = true
        elif movement.x < -0.5 && helo.flip_h:
            helo.flip_h = false


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
