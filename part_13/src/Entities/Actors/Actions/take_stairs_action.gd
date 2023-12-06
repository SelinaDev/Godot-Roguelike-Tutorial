class_name TakeStairsAction
extends Action


func perform() -> bool:
	if entity.grid_position == get_map_data().down_stairs_location:
		SignalBus.player_descended.emit()
		MessageLog.send_message("You descend the staircase.", GameColors.DESCEND)
	else:
		MessageLog.send_message("There are no stairs here.", GameColors.IMPOSSIBLE)
	return false
