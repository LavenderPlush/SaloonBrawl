# The event bus is a global script that allows multiple
# objects to send signals through / listen to.
extends Node

@warning_ignore("unused_signal")
signal add_money(amount: int)
