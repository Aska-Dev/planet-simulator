if(state == plantState.growing)
{
	regrow_tick += regrow_speed;
}

if(regrow_tick >= regrow_time)
{
	state = plantState.grown;
	regrow_tick = 0;
}



if(state == plantState.grown && sprite_index != spr_env_berrybush)
{
	sprite_index = spr_env_berrybush
}
else if(state == plantState.growing && sprite_index != spr_env_berrybush_empty)
{
	sprite_index = spr_env_berrybush_empty
}