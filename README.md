# Linked List
[![CircleCI](https://circleci.com/gh/abvdasker/crystal-linked-list.svg?style=svg)](https://circleci.com/gh/abvdasker/crystal-linked-list)
A simple linked list implementation in Crystal

# Installation

# Usage
```
require "linked_list"

list = LinkedList(Int32 | String).new
list.append(1)
list.push(2)
list << "foo"

list.peek        # "foo"
list.pop         # "foo"
list.pop         # 2
list.unshift(1)
list.shift       # 1
```
