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
  @head : Node(A) | Nil
  @tail : Node(A) | Nil

  include Enumerable(A | Nil)

  # Creates an empty linked list.
  def initialize
    @head = nil
    @tail = @head
  end

  # Creates a linked list with the *values* as the values of the nodes.
  def initialize(*values)
    initialize(values)
  end

  # ditto
  def initialize(values : Enumerable(A))
    @head = nil
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
    if @head.nil?
      @head = Node(A).new(value)
      @tail = @head
    else
      new_node = Node(A).new(value)
      @tail.not_nil!.next = new_node
      @tail = new_node
      new_node.value
    end
  end

  # ditto
  def push(value : A)
    append(value)
  end

  # Adds a *value* to the linked list at a specified index.
  #
  # ```
  # list = LinkedList(Int32).new
  # list.append(1)
  # list.append(2)
  # list.insert_at(3, 1)
  # ```
  def insert_at(value : A, index : Int32)
    # non-contiguous
    return nil if index > size

    # inserting at the beginning is the unshift function
    if index == 0
      unshift(value)
      return
    end

    # not index 0, but list is empty
    # non-contiguous
    if @head.nil?
      return nil
    end

    # start at head and move to the index
    last = @tail
    previous = @head
    current = @head.not_nil!.next.not_nil!

    search = 1

    while current != last && search < index
      previous = current
      current = current.next.not_nil!
      search += 1
    end

    # made it to the desired index
    if search != index
      return nil
    end

    new_node = Node(A).new(value)

    previous.not_nil!.next = new_node
    new_node.next = current
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

  # same as append
  def push(*values)
    values.each do |value|
      push(value)
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
    if @head.nil?
      append(value)
      return
    end
    new_top = Node(A).new(value)
    new_top.next = @head
    @head = new_top
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
    return if @head.nil?

    first = @head.not_nil!
    @head = head.not_nil!.next
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
    return nil if @tail.nil?
    @tail.not_nil!.value
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
    return nil if @head.nil?

    if @head == @tail
      current = @head
      @head = nil
      @tail = nil
      return current.not_nil!.value
    end

    last = @tail
    current = @head
    while current.not_nil!.next != last
      current = current.not_nil!.next.not_nil!
    end

    current.not_nil!.next = nil
    @tail = current
    last.not_nil!.value
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

  def [](index : Int32)
    return nil if @head.nil?

    search = 0
    each_node do |node|
      if search == index
        return node.value
      end

      search += 1
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
    @tail.not_nil!.next = list.head
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
    @head.nil?
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
    return nil if @head.nil?

    current = @head
    loop do
      yield current.not_nil!
      current = current.not_nil!.next
      break if current.nil?
    end
  end

  # Overloading the to_s function to print the contents
  # of the linked list
  # This calls the to_s function of each node in the
  # linked list
  #
  # ```
  # values = [1, 2, 3]
  # puts values
  #
  # The above produces:
  #
  # ```text
  # [ 1, 2, 3 ]
  # ```
  def to_s(io)
    io << "[ "

    # iterate through the nodes in the linked list
    each_node do |elem|
      io << elem.value
      # kind of clunky, if this is the tail node
      # don't print the comma
      if elem != @tail
        io << ", "
      end
    end

    io << " ]"
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

    # Overloading the to_s function to print the contents
    # of the node
    def to_s(io)
      io << @value
    end
  end
end
