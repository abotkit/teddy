# Generating bots -- Helper functions

import random

import ruamel.yaml

import json_lines

folded = ruamel.yaml.scalarstring.FoldedScalarString
literal = ruamel.yaml.scalarstring.LiteralScalarString

yaml = ruamel.yaml.YAML()


def read_json_lines(file_name):
    with json_lines.open(file_name) as f:
        return list(f)


def export_yaml(config, file_name):
    with open(file_name, "w") as f:
        yaml.dump(config, f)


def new_nlu():
    return {"version": "2.0", "nlu": []}


def add_lookup(nlu, name, examples):
    lookup = {"lookup": name, "examples": literal("\n".join(examples))}
    nlu["nlu"].append(lookup)


def add_intent(nlu, intent_name, examples):
    intent = {"intent": intent_name, "examples": literal("\n".join(examples))}
    nlu["nlu"].append(intent)


def sample(examples, num=10):
    return random.choices(examples, k=10)
