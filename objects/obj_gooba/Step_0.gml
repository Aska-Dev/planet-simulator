if(x > room_width || x < 0 || y > room_height || y < 0) 
{
	instance_destroy(self);
}

#region Behaviour controller

switch(activity_behaviour)
{
	case behaviours.idle:
		gooba_check_body();
		if(activity_behaviour == behaviours.idle) gooba_decide_random_activity();
		break;
	case behaviours.moving:
		gooba_stop_if_at_destination();
		break;
	case behaviours.searchFood:
		gooba_search_food();
		break;
	case behaviours.searchMate:
		gooba_search_mate();
		break;
}

#endregion

#region Survival conroller

if(reproduction_tick > 0)
{
	reproduction_tick -= 1;
}

hunger += hunger_buildup;
thirst += thirst_buildup;

if(hunger >= hunger_death || thirst >= thirst_death)
{
	instance_destroy(self);
}

#endregion