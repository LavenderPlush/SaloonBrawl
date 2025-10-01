# The event bus is a global script that allows multiple
# objects to send signals through / listen to.
extends Node

@warning_ignore_start("unused_signal")
# Adds amount of money
signal add_money(amount: int)

# Appends one mess
signal add_mess()
# Removes one mess
signal remove_mess()
# Game over
signal game_over()
# Player dies
signal player_dead()
