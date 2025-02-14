function check_for_tiletype(point_x, point_y, tile)
{
	tile_x = point_x - (point_x % 64);
	tile_y = point_y - (point_y % 64);

	var tile_at_pixel = tilemap_get_at_pixel(GroundMap, tile_x, tile_y)
	return tile_at_pixel == tile;
}

function gooba_decide_random_activity()
{
	var activity_roll = random_range(0, 100)

	if(activity_roll <= activity_chance)
	{
		gooba_move_random();
	}
}

function gooba_stop_if_at_destination()
{
	if(point_in_circle(destination_x, destination_y, x, y, 32))
	{
		speed = 0;
		activity_behaviour = behaviours.idle;
	}
}

function gooba_move_random()
{	
	do
	{
		var vision_x = random_range(vision * -1, vision);
		var vision_y = random_range(vision * -1, vision);
		
		destination_x = round(random_range(x, x+vision_x));
		destination_y = round(random_range(y, y+vision_y));
	}
	until(
		check_for_tiletype(destination_x, destination_y, tiles.land)
		&& distance_to_point(destination_x, destination_y) > minimum_move_distance)
	
	gooba_move_to_destination();
}

function gooba_move_to_destination()
{
	direction = point_direction(x, y, destination_x, destination_y);
	speed = move_speed;
	activity_behaviour = behaviours.moving;
}

function gooba_check_body()
{
	if(hunger <= 0)
	{
		activity_behaviour = behaviours.idle;
		hunger = 0;
	}
	
	if(hunger < becomes_hungry && reproduction_tick == 0)
	{
		ready_to_reproduce = true;
		activity_behaviour = behaviours.searchMate;
	}
	
	if(hunger >= becomes_hungry)
	{
		activity_behaviour = behaviours.searchFood;
	}
}

function gooba_search_food()
{
	var closest_food_sources = ds_list_create();
	collision_circle_list(x, y, vision, obj_env_berrybush, false, true, closest_food_sources, true);
	
	var food_source = undefined;
	
	for(var i = 0; i < ds_list_size(closest_food_sources); i++)
	{
		if(closest_food_sources[| i].state == plantState.grown)
		{
			food_source = closest_food_sources[| i]
			break;
		}
	}
	
	if(instance_exists(food_source))
	{
		if(distance_to_object(food_source) <= 20)
		{
			gooba_eat(food_source);
		}
		else
		{
			destination_x = food_source.x;
			destination_y = food_source.y;
			gooba_move_to_destination();
		}
	}
	else
	{
		gooba_move_random();
	}
}

function gooba_eat(food_source)
{
	food_source.state = plantState.growing;
	
	hunger -= food_source.nutrition;
	activity_behaviour = behaviours.idle;
}

function gooba_search_mate()
{
	var closest_goobas = ds_list_create();
	collision_circle_list(x, y, vision, obj_gooba, false, true, closest_goobas, true);
	
	var possible_mate = undefined;
	
	for(var i = 0; i < ds_list_size(closest_goobas); i++)
	{
		if(closest_goobas[| i].ready_to_reproduce)
		{
			possible_mate = closest_goobas[| i]
			break;
		}
	}
	
	if(instance_exists(possible_mate))
	{
		if(distance_to_object(possible_mate) <= 50)
		{
			gooba_reproduce(possible_mate);
		}
		else
		{
			destination_x = possible_mate.x;
			destination_y = possible_mate.y;
			gooba_move_to_destination();
		}
	}
	else
	{
		gooba_move_random();
	}
}

function gooba_reproduce(mate)
{
	activity_behaviour = behaviours.idle;
	mate.activity_behaviour = behaviours.idle;
	
	ready_to_reproduce = false;
	mate.ready_to_reproduce = false;
	
	reproduction_tick = reproduction_cooldown;
	mate.reproduction_tick = mate.reproduction_cooldown;
	
	instance_create_layer(x, y, "Instances", obj_gooba);
}