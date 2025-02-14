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
	until(!check_for_tiletype(destination_x, destination_y, tiles.water));
	
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
	
	if(hunger >= becomes_hungry)
	{
		activity_behaviour = behaviours.searchFood;
	}
}

function gooba_search_food()
{
	var closest_food_source = collision_circle(x, y, vision, obj_env_berrybush, false, true);
	
	if(instance_exists(closest_food_source))
	{
		if(distance_to_object(closest_food_source) <= 20)
		{
			hunger -= closest_food_source.nutrition;
		}
		else
		{
			destination_x = closest_food_source.x;
			destination_y = closest_food_source.y;
			gooba_move_to_destination();
		}
	}
	else
	{
		gooba_move_random();
	}
}