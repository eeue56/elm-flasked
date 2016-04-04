from collections import defaultdict
from utils import collect_args

def logger(action, model):
    print(model)
    return model

def add(action, model):
    numbers = sum(collect_args(action))
    return model + numbers

def record_add(action, model):
    stuff = collect_args(action)
    print(stuff)

    return model + stuff[0]['add']

def sub(action, model):
    numbers = sum(collect_args(action))
    return model - numbers

def default_action(action, model):
    return model


actions = {
    "ConsoleLog": logger,
    "Add": add,
    "Sub": sub,
    "RecordAdd": record_add
}

def update(action, model):
    action_name = action['ctor']

    if action_name not in actions:
        return model

    return actions[action_name](action, model)
