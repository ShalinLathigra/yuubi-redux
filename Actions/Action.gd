class_name Action extends Node
################################################################################
#
# Implementation of the Command pattern. Can be provided with functions (anonymous
# or otherwise) to handle checking if the action is valid or adding onstart/onfinish
# operations.
#
# By default, this is a dumb object and will just return. Subclasses provide
# actual functionality.
#
# See res://Actions/ActionFactory.gd for information on existing actions
# and some ways they are used currently.
#
################################################################################


var is_started: bool # indicates whether a state has started the "enter" steps
var is_finished: bool # indicates that the state has finished the "exit" steps

var valid_checker: Callable
var start_events: Callable
var finish_events: Callable


func _init(vc: Callable=Callable(func(): return false)\
		, se: Callable=Callable(func(): return false)\
		, fe: Callable=Callable(func(): return false)) -> void:
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

func abort() -> void:
	exit()

func is_valid() -> bool:
	return valid_checker.call()

func _to_string() -> String:
	return "Basic Action"
