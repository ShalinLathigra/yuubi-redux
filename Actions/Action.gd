class_name Action extends Node

var is_started: bool # indicates whether a state has started the "enter" steps
var is_finished: bool # indicates that the state has finished the "exit" steps

var valid_checker: Callable
var start_events: Callable
var finish_events: Callable


func _init(vc: Callable=Callable(func(): return)\
		, se: Callable=Callable(func(): return)\
		, fe: Callable=Callable(func(): return)) -> void:
	is_started = false
	is_finished = false
	valid_checker = vc
	start_events = se
	finish_events = fe

func reset() -> void:
	is_started = false
	is_finished = false

func enter() -> void:
	is_started = true
	start_events.call()

func do() -> void:
	exit()

func exit() -> void:
	is_finished = true
	finish_events.call()

func is_valid() -> bool:
	return valid_checker.call()

func _to_string() -> String:
	return "Basic Action"
