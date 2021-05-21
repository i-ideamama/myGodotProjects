extends Node2D


# All the different colors
const e_morning = [145.0, 205.0, 233.0]
const morning = [99.0, 168.0, 242.0]
const afternoon = [148.0, 31.0, 96.0]
const evening = [44.0, 5.0, 117.0]
const night = [4.0, 4.0, 4.0]
const smoothness = 15.0

var R = 145.0/255.0
var G = 225.0/255.0
var B = 233.0/255.0
var delta_r = 0
var delta_g = 0
var delta_b = 0

var time_timer = 0
var day_timer = 0
var times_of_day = [e_morning, morning, afternoon, evening, night, evening, morning]
var from_day = 0
var to_day = 1
var secs_per_time = 30.0/len(times_of_day)

# Initialize with early morning (light blue)
func _ready():
	VisualServer.set_default_clear_color(Color(e_morning[0]/255.0, e_morning[1]/255.0, e_morning[2]/255.0, 1))
	delta_r = _get_color_delta(e_morning, morning)[0]
	delta_g = _get_color_delta(e_morning, morning)[1]
	delta_b = _get_color_delta(e_morning, morning)[2]


func _process(delta):
	# timer for chaning color within set
	time_timer += delta
	# timer for changing sets
	day_timer += delta
	
	if day_timer >= secs_per_time:
		day_timer = 0
		from_day += 1
		to_day += 1
		if from_day > len(times_of_day) - 1:
			from_day = 0
		elif to_day > len(times_of_day) - 1:
			to_day = 0
		delta_r = _get_color_delta(times_of_day[from_day], times_of_day[to_day])[0]
		delta_g = _get_color_delta(times_of_day[from_day], times_of_day[to_day])[1]
		delta_b = _get_color_delta(times_of_day[from_day], times_of_day[to_day])[2]
	
	if time_timer >= 1 / smoothness:
		time_timer = 0
		R += delta_r / smoothness
		G += delta_g / smoothness
		B += delta_b / smoothness
		
		VisualServer.set_default_clear_color(Color(R, G, B, 1))
		
# creates a number which when multiplied with color 1, gives color 2 over time
func _get_color_delta(color1, color2):
	var R1 = color1[0]/255.0
	var G1 = color1[1]/255.0
	var B1 = color1[2]/255.0
	
	var R2 = color2[0]/255.0
	var G2 = color2[1]/255.0
	var B2 = color2[2]/255.0
	
	var delta_R = (R2 - R1) / secs_per_time # value to multiply R
	var delta_G = (G2 - G1) / secs_per_time # value to multiply G
	var delta_B = (B2 - B1) / secs_per_time # value to multiply B
	
	return [delta_R, delta_G, delta_B]
	
	
