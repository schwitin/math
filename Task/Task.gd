extends MarginContainer

var myTasks = []
var correctAnsweredTasks = []
var currentTask = null

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
	sceneLabel = preload("res://Task/Label.tscn")
	sceneQuestionMark = preload("res://Task/QuestionMark.tscn")
	sceneAnswer = preload("res://Task/Answer.tscn")
	questionContainer = get_node("VBox/Question")
	answersContainer = get_node("VBox/Answers")
	get_node("VBox/Answers").add_constant_override("separation", 20)
	
	correctAnsweredTasks = _load_correct_answered_tasks()
	
	var generatedTasks = []
	
	_generate_tasks(0,5,"+","result",  generatedTasks)
	_randomize(generatedTasks, myTasks)	
	_generate_tasks(0,5,"+","operand2", generatedTasks)
	_randomize(generatedTasks, myTasks)
	_generate_tasks(0,5,"+","operand1", generatedTasks)
	_randomize(generatedTasks, myTasks)
	
	_generate_tasks(0,5,"-","result",  generatedTasks)
	_randomize(generatedTasks, myTasks)	
	_generate_tasks(0,5,"-","operand2", generatedTasks)
	_randomize(generatedTasks, myTasks)
	_generate_tasks(0,5,"-","operand1", generatedTasks)
	_randomize(generatedTasks, myTasks)
	
	_generate_tasks(5,10,"+","result",  generatedTasks)
	_randomize(generatedTasks, myTasks)	
	_generate_tasks(5,10,"+","operand2", generatedTasks)
	_randomize(generatedTasks, myTasks)
	_generate_tasks(5,10,"+","operand1", generatedTasks)
	_randomize(generatedTasks, myTasks)
	
	_generate_tasks(5,10,"-","result",  generatedTasks)
	_randomize(generatedTasks, myTasks)	
	_generate_tasks(5,10,"-","operand2", generatedTasks)
	_randomize(generatedTasks, myTasks)
	_generate_tasks(5,10,"-","operand1", generatedTasks)
	_randomize(generatedTasks, myTasks)
	
	_generate_tasks(10,15,"+","result",  generatedTasks)
	_randomize(generatedTasks, myTasks)	
	_generate_tasks(10,15,"+","operand2", generatedTasks)
	_randomize(generatedTasks, myTasks)
	_generate_tasks(10,15,"+","operand1", generatedTasks)
	_randomize(generatedTasks, myTasks)
	
	_generate_tasks(10,15,"-","result",  generatedTasks)
	_randomize(generatedTasks, myTasks)	
	_generate_tasks(10,15,"-","operand2", generatedTasks)
	_randomize(generatedTasks, myTasks)
	_generate_tasks(10,15,"-","operand1", generatedTasks)
	_randomize(generatedTasks, myTasks)
	
	
	_generate_tasks(15,20,"+","result",  generatedTasks)
	_randomize(generatedTasks, myTasks)	
	_generate_tasks(15,20,"+","operand2", generatedTasks)
	_randomize(generatedTasks, myTasks)
	_generate_tasks(15,20,"+","operand1", generatedTasks)
	_randomize(generatedTasks, myTasks)
	
	_generate_tasks(15,20,"-","result",  generatedTasks)
	_randomize(generatedTasks, myTasks)	
	_generate_tasks(15,20,"-","operand2", generatedTasks)
	_randomize(generatedTasks, myTasks)
	_generate_tasks(15,20,"-","operand1", generatedTasks)
	_randomize(generatedTasks, myTasks)
	
	
	
	
	
	# restore_state()
	set_next_task()
	
	print(myTasks.size(), ", ", correctAnsweredTasks.size())




func set_next_task():	
	var i = 0
	while i < myTasks.size():
		var task = myTasks[i]
		if _is_task_answered(task):
			i+=1
		else:
			currentTask = task
			_init_question()
			_init_answers()
			return
	# game_over

func _is_task_answered(task):
	var taskStr = _task_to_string(task)
	return correctAnsweredTasks.find(taskStr) != -1

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

func _on_answered(answer):	
	if(answer == currentTask.correctAnswer):
		questionMarkNode.text = answer
		questionMarkNode.disable_drop()
		_disable_answers()
		correctAnsweredTasks.append(_task_to_string(currentTask))		
		_save_correct_answered_tasks(correctAnsweredTasks)	
		_solve_current_task()
		emit_signal("answer_correct", currentTask)
	else: 
		emit_signal("answer_wrong", currentTask)

func _disable_answers():
	for c in answersContainer.get_children():
		c.disabled = true	

func _solve_current_task():
	var task = currentTask.duplicate()
	if(task.operand1 == '?'):
		task.operand1 = task.correctAnswer
	if(task.operand2 == '?'):
		task.operand2 = task.correctAnswer
	if(task.result == '?'):
		task.result = task.correctAnswer
	
	currentTask = task

func _create_node(text):
	
	if text == "?" :
		return _create_node_from_scene(text, sceneQuestionMark)
	else:
		return _create_node_from_scene(text, sceneLabel)

func _create_node_from_scene(text, scene):	
	var node = scene.instance()
	node.text = text
	if(scene == sceneQuestionMark):
		node.connect("answered", self, "_on_answered")
		questionMarkNode = node
	return node

func _generate_tasks(start, end, operator, questioinOn, tasks):
	var o2 = 0
	while o2 <= end:
		var o1 = start
		while o1 <= end:
			var result = _calculate_result(o1,o2,operator)			
			
			if(operator == "+" && result > end || operator == '-' && result < 0):
				o1+=1
				continue
				
			var task = {
				operand1=str(o1),
				operator=operator,
				operand2=str(o2),
				result=str(result)
			}
			
			_set_question_mark(task, questioinOn)
			_set_answers(task, start, end)
			tasks.append(task)
			#_print_task(task)
			o1+=1
		o2+=1

func _calculate_result(operand1, operand2, operator):
	match operator:
		"+":
			return operand1 + operand2
		"-":
			return operand1 - operand2

func _set_question_mark(task, questionOn):
	match questionOn:
		"operand1":
			task.correctAnswer = task.operand1
			task.operand1 = "?"
		"operand2":
			task.correctAnswer = task.operand2
			task.operand2 = "?"
		_: #result
			task.correctAnswer = task.result
			task.result = "?"

func _set_answers(task, start, end):
	var answers = []
	var answer1 = int(task.correctAnswer)
	var answer2 = answer1-1
	var answer3 = answer1+1

	match answer1:
		start, 0:
			answer2 = answer1 + 1
			answer3 = answer1 + 2
		end:
			answer2 = answer1 - 1
			answer3 = answer1 - 2
	
	answers.append(str(answer1))
	answers.append(str(answer2))
	answers.append(str(answer3))
	task.answers = answers

func _randomize(source, target):
	while source.size() > 0:
		randomize()
		var randomIndex = randi() % source.size()
		var randomElement = source[randomIndex]
		target.append(randomElement)
		source.remove(randomIndex)
		
	return target

func _save_correct_answered_tasks(correctAnsweredTasks):
	var f = File.new()
	f.open("user://math.save", File.WRITE)
	for i in range(correctAnsweredTasks.size()):
		var line = correctAnsweredTasks[i]
		f.store_line(line)
	f.close()

func _load_correct_answered_tasks():
	var tasks = []
	var f = File.new()
	f.open("user://math.save", File.READ)
	if(!f.is_open()):
		return tasks
	
	while !f.eof_reached():
		var taskStr = f.get_line()
		if !taskStr.empty():
			tasks.append(taskStr)
	f.close()
	return tasks

func _print_task(task):
	print(_task_to_string(task))

func _task_to_string(task):
	var answers = ""
	for i in range(0, task.answers.size()):
    	answers += task.answers[i] + ","
		
	return task.operand1 + task.operator + task.operand2 + "=" + task.result + "=>" + task.correctAnswer + "(" + answers + ")"

