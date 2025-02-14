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
}

#endregion

#region Survival conroller

hunger += hunger_buildup;
thirst += thirst_buildup;

if(hunger >= hunger_death || thirst >= thirst_death)
{
	instance_destroy(self);
}

#endregion