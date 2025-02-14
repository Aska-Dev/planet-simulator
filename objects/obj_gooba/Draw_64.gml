if(global.selected == self)
{
	draw_text(x - 32, y + 30, "H: " + string(hunger));
	draw_text(x - 32, y + 50, "T: " + string(thirst));
	draw_text(x - 32, y - 40, string(activity_behaviour));
}