# A linked list is a **Enumerable** (see the `Enumerable` module) data structure
# that stores multiple pieces of data in non contiguous locations in memory.
#
# To create a linked list:
#
# ```
# list = LinkedList(Int32).new
# list.push(2)
# puts list.pop
# ```
#
# The above produces:
#
# ```text
# 2
# ```
class LinkedList(A)
  include Enumerable(A | Nil)

  # Creates an empty linked list.
  def initialize
    @head = Node(A).new
    @tail = @head
  end

  # Creates a linked list with the *values* as the values of the nodes.
  def initialize(*values)
    initialize(values)
  end

  # ditto
  def initialize(values : Enumerable(A))
    @head = Node(A).new
    @tail = @head
    values.each do |value|
      append(value)
    end
  end

  # Adds a *value* to the end of a linked list.
  #
  # ```
  # list = LinkedList(Int32).new
  # list.append(1)
  # list.push(2)
  # list.pop() # => 2
  # list.pop() # => 1
  # ```
  def append(value : A)
    new_node = Node(A).new(value)
    @tail.next = new_node
    @tail = new_node
    new_node.value
  end

  # ditto
  def push(value : A)
    append(value)
  end

  # Override the << (shift) operator to add a *value* to the end of a
  # linked list. This method returns itself so it can be chained.
  #
  # ```
  # list = LinkedList(Int32).new(1)
  # list << 2 << 3
  # list.pop() # => 3
  # list.pop() # => 2
  # list.pop() # => 1
  # ```
  def <<(value : A)
    append(value)
    self
  end

  # Adds a list of *values* to the end of a linked list.
  #
  # ```
  # list = LinkedList(Int32 | String).new
  # list.append(1, "foo")
  # list.pop() # => "foo"
  # list.pop() # => 1
  # ```
  def append(*values)
    values.each do |value|
      append(value)
    end
  end

  # Adds a *value* to the beginning of a linked list.
  #
  # ```
  # list = LinkedList(Int32).new(1)
  # list.unshift(2)
  # list.pop() # => 1
  # list.pop() # => 2
  # ```
  def unshift(value : A)
    new_top = Node(A).new(value)
    if @tail == @head
      @tail = new_top
    end
    new_top.next = @head.next
    @head.next = new_top
    new_top.value
  end

  # Returns the first `Node` from the list and removes it.
  #
  # ```
  # list = LinkedList(Float64).new(1.23)
  # list.push(4.56)
  # list.shift() # => 1.23
  # list.peek() # => 4.56
  # ```
  def shift
    return if @head.next.nil?

    first = @head.next.not_nil!
    @head.next = first.next
    first.value
  end

  # Returns the value of the tail of the linked list,
  # or nil if no value was supplied.
  #
  # ```
  # list = LinkedList(Float64).new(1.23)
  # list.push(4.56)
  # list.peek() # => 4.56
  # ```
  def peek
    @tail.value
  end

  # Returns the last `Node` from the list and removes it.
  #
  # ```
  # list = LinkedList(Float64).new(1.23)
  # list.push(4.56)
  # list.pop() # => 4.56
  # list.peek() # => 1.23
  # ```
  def pop
    return nil if @head == @tail

    last = @tail
    current = @head
    while current.next != last
      current = current.next.not_nil!
    end

    current.next = nil
    @tail = current
    last.value
  end

  # Iterates over all the values in the linked list.
  #
  # ```
  # values = [1, 2, 3]
  # list = LinkedList(Int32).new(values)
  # list.each do |elem|
  #   puts elem
  # end
  #
  # The above produces:
  #
  # ```text
  # 1
  # 2
  # 3
  # ```
  def each
    each_node do |node|
      yield node.value
    end
    self
  end

  # Returns a new `LinkedList` with all of the elements from the first list
  # followed by all of the elements in the second *list*.
  #
  # ```
  # first_list = LinkedList(Int32).new(1, 2)
  # second_list = LinkedList(String).new("foo", "bar")
  # combined_list = first_list + second_list
  # combined_list.peek() # => "bar"
  # combined_list.shift() # => 1
  # ```
  def +(list : Enumerable(C)) forall C
    LinkedList(A | C).new.tap do |new_list|
      each do |value|
        new_list.append(value)
      end
      list.each do |value|
        new_list.append(value)
      end
    end
  end

  # Adds all the elemenets of the *list* to the end of the current linked list.
  #
  # ```
  # first_list = LinkedList(Int32).new(1, 2)
  # second_list = LinkedList(Int32).new(3, 4)
  # combined_list = first_list.concat(second_list)
  # combined_list.peek() # => 4
  # combined_list.shift() # => 1
  # ```
  def concat(list : LinkedList(A))
    @tail.next = list.head.next
    @tail = list.tail
    self
  end

  # Returns true if and only if there are no elements in the list.
  #
  # ```
  # list = LinkedList(Int32).new
  # list.empty? # => true
  # list.push(1)
  # list.empty? # => false
  # ```
  def empty?
    @head == @tail
  end

  # Creates a copy of the `LinkedList` with the order reversed.
  #
  # ```
  # list = LinkedList(Int32).new(1, 2, 3)
  # reversed_list = list.reverse
  # list.pop() # => 1
  # list.pop() # => 2
  # list.pop() # => 3
  # ```
  def reverse
    LinkedList(A).new.tap do |new_list|
      each do |value|
        new_list.unshift(value.not_nil!)
      end
    end
  end

  # Returns the first node in the list, or nil if the list is empty.
  #
  # ```
  # list = LinkedList(Int32).new(1, 2, 3)
  # list.head.value # => 1
  # ```
  protected def head
    @head
  end

  # Returns the last node in the list, or nil if the list is empty.
  #
  # ```
  # list = LinkedList(Int32).new(1, 2, 3)
  # list.tail.value # => 3
  # ```
  protected def tail
    @tail
  end

  # Iterates over all the nodes in the linked list.
  #
  # ```
  # values = [1, 2, 3]
  # list = LinkedList(Int32).new(values)
  # list.each_node do |elem|
  #   puts elem.value
  # end
  #
  # The above produces:
  #
  # ```text
  # 1
  # 2
  # 3
  # ```
  private def each_node
    current = @head
    until current.next.nil?
      current = current.next.not_nil!
      yield current
    end
  end

  # A node is the building block of linked lists consisting of a values
  # and a pointer to the next node in the linked list.
  #
  # To create a node:
  #
  # ```
  # node = Node.new(5)
  # puts node.value
  # ```
  #
  # The above produces:
  #
  # ```text
  # 5
  # ```
  #
  # Check the value of the node with `#value`.
  # Get the next node in the list with `#next`.
  class Node(T)
    @next = nil
    @value = nil

    # Creates a node with no value.
    def initialize
    end

    # Creates a node with the specified *value*.
    def initialize(@value : T)
    end

    # Returns the value of the node, or nil if no value was supplied
    #
    # ```
    # Node.new(1).value # => 1
    # ```
    def value
      @value
    end

    # Returns the next node in the linked list, or nil if it is the tail.
    #
    # ```
    # node = Node.new(1)
    # node.next = Node.new(2)
    # node.next.value # => 2
    # ```
    def next
      @next
    end

    # Sets the next node in the linked list to *next_node*
    #
    # ```
    # node = Node.new(1)
    # node.next = Node.new(2)
    # node.next.value # => 2
    # ```
    def next=(next_node : Node(T) | Nil)
      @next = next_node
    end
  end
end
