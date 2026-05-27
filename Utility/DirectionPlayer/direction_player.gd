extends AnimationPlayer


func fade_in(dir: String):
	self.play(dir + "_fade_in")
	self.queue(dir + "_float_loop")

func fade_out(dir: String):
	self.play(dir + "_fade_out")


func r_in():
	fade_in("r")
func r_out():
	fade_out("r")

func l_in():
	fade_in("l")
func l_out():
	fade_out("l")

func t_in():
	fade_in("t")
func t_out():
	fade_out("t")

func b_in():
	fade_in("b")
func b_out():
	fade_out("b")


func l2b():
	l_out()
	await animation_finished
	b_in()

func b2r():
	b_out()
	await animation_finished	
	r_in()

func r2b():
	r_out()
	await animation_finished
	b_in()

func b2l():
	b_out()
	await animation_finished
	l_in()
