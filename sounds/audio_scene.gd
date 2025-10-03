extends AudioStreamPlayer

@onready var bill_music_delay = $billMusicDelay

const title_music = preload("res://sounds/music/titleSequence.wav")
const bill_music = preload("res://sounds/music/billTheme.wav")

const max_vol = -2.0
const min_vol = -25.0
var vol_diff
var theme_queued = false
var active_tweens = {}
var saved_vol = 0.0

func _ready():
	vol_diff = abs(min_vol - max_vol)
	volume_db = max_vol

func _play_music(music, vol = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = vol
	
	play()

func fade_out():
	var tween_key = "node_A_scale" # A unique key for this tween
	var tween_duration = 4 # seconds
	var tween_out = create_tween()
	tween_out.finished.connect(func(): _on_tween_finished(tween_key))

	tween_out.tween_property(self, "volume_db", -80.0, tween_duration)

# Optional: Connect to a signal to know when the fade is complete
func _on_tween_finished(key):
	self.stop()
	if active_tweens.has(key):
		active_tweens.erase(key)
	
	if theme_queued:
		play_music_title()

func queue_theme():
	theme_queued = true

func start_bill_delay_timer():
	bill_music_delay.start()

func _on_bill_music_delay_timeout():
	play_music_bill()

func play_music_bill():
	volume_db = saved_vol
	_play_music(bill_music)

func play_music_title():
	volume_db = saved_vol
	_play_music(title_music)

func updateVolume(value_percentage):
	saved_vol = min_vol + (vol_diff * value_percentage)
	if value_percentage == 0:
		volume_db = -80.0
		return
	volume_db = min_vol + (vol_diff * value_percentage)

func play_fx(stream: AudioStream, vol = 0.0):
	pass
