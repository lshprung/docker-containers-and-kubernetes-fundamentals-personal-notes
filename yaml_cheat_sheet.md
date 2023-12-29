# YAML Cheat Sheet

### YAML example

```yaml
# Comments in YAML look like this

key: value
another_key: Another value goes here.
a_number_value: 100

# Nesting uses indentation. 2 space indent is preferred (but not required).
a_nested_map:
  key: value
  another_key: Another Value
  another_nested_map:
    hello: hello

# Sequences (equivalent to lists or arrays) look like this
# (note that the '-' counts as indentation):
a_sequence:
  - Item 1
  - Item 2

# Since YAML is a superset of JSON, you can also write JSON-style maps and sequences:
json_map: {"key": "value"}
json_seq: [3, 2, 1, "takeoff"]
```

Checking YAML files' formatting can be done using `yamllint`
