extends MarginContainer

var myTasks = []
var currentTask = null
var nextTaskIndex = 0

var regexPattern = RegEx.new()
var regexAntipattern = RegEx.new()

var sceneLabel = null
var sceneQuestionMark = null
var sceneAnswer = null

var questionContainer = null
var answersContainer = null

var questionMarkNode = null

const TASK_PATTERN = "^(\\d{1,2}|\\?)([+|-])(\\d{1,2}|\\?)=(\\d{1,2}|\\?)\\s(\\d{1,2},\\d{1,2},\\d{1,2})$"
const TASK_ANTIPATTERN= "^.*\\?.*\\?.*$"

signal answer_correct(task)
signal answer_wrong(task)

func _init():
	regexPattern.compile(TASK_PATTERN)
	regexAntipattern.compile(TASK_ANTIPATTERN)

func _ready():
	sceneLabel = preload("res://Label.tscn")
	sceneQuestionMark = preload("res://QuestionMark.tscn")
	sceneAnswer = preload("res://Answer.tscn")
	questionContainer = get_node("VBox/Question")
	answersContainer = get_node("VBox/Answers")
	get_node("VBox/Answers").add_constant_override("separation", 20)


func set_next_task():	
	if(myTasks.size() <= nextTaskIndex):
		nextTaskIndex = 0
		
	currentTask = myTasks[nextTaskIndex]
	nextTaskIndex+=1
		
	_init_question()
	_init_answers()

func _init_question():
	for c in questionContainer.get_children():
		questionContainer.remove_child(c)
		
	questionContainer.add_child(_create_node(currentTask.operand1))
	questionContainer.add_child(_create_node(currentTask.operator))
	questionContainer.add_child(_create_node(currentTask.operand2))
	questionContainer.add_child(_create_node("="))
	questionContainer.add_child(_create_node(currentTask.result))
	
	
func _init_answers():
	for c in answersContainer.get_children():
		answersContainer.remove_child(c)	
	
	var answers = Array(currentTask.answers).duplicate()
	while answers.size() > 0:
		var idx = randi() % answers.size()
		var answer = answers[idx]
		answersContainer.add_child(_create_node_from_scene(answer, sceneAnswer))
		answers.remove(idx)

func _create_node(text):
	
	if text == "?" :
		return _create_node_from_scene(text, sceneQuestionMark)
	else:
		return _create_node_from_scene(text, sceneLabel)
	

func _on_answered(answer):	
	if(answer == currentTask.correctAnswer):
		questionMarkNode.text = answer
		emit_signal("answer_correct", currentTask)
	else: 
		emit_signal("answer_wrong", currentTask)
		
	
func _create_node_from_scene(text, scene):	
	var node = scene.instance()
	node.text = text
	if(scene == sceneQuestionMark):
		node.connect("answered", self, "_on_answered")
		questionMarkNode = node
	return node
	

func load_tasks(resource):
	var file = File.new()
	file.open(resource, file.READ)
	while not file.eof_reached():
		var taskStr = file.get_line()
		
		var task = _load_task(taskStr)
		if task:
			myTasks.append(task)
		
	file.close()
	set_next_task()
	
func _load_task(taskStr):
	if regexAntipattern.search(taskStr):
		return null
		
	var task = null
	var searchResult = regexPattern.search(taskStr)
	if searchResult:
		task = {
			operand1 = searchResult.get_string(1),
			operator = searchResult.get_string(2),
			operand2 = searchResult.get_string(3),
			result = searchResult.get_string(4),
			answers = searchResult.get_string(5).split(","),
			
		}
		task.correctAnswer = task.answers[0]
	return task
	