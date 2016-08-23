class LinkedList(A)
  include Enumerable(A)

  def initialize
    @head = Node(A).new
    @tail = @head
  end

  def initialize(*values)
    @head = Node(A).new
    @tail = @head
    values.each do |value|
      append(value)
    end
  end

  def append(value : A)
    new_node = Node(A).new(value)
    @tail.next = new_node
    @tail = new_node
    new_node.value
  end

  def push(value : A)
    append(value)
  end

  def <<(value : A)
    append(value)
  end

  def unshift(value : A)
    new_top = Node(A).new(value)
    if @tail == @head
      @tail = new_top
    end
    new_top.next = @head.next
    @head.next = new_top
    new_top.value
  end

  def shift
    return if @head.next.nil?

    first = @head.next.not_nil!
    @head.next = first.next
    first.value
  end

  def peek
    @tail.value
  end

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

  def each
    current = @head
    until current.next.nil?
      current = current.next.not_nil!
      yield current.value
    end
    self
  end

  # def +(list : LinkedList(C))
  #   LinkedList(A | C).new.tap do |new_list|
  #     list.each do |value|
  #       new_list.append(value)
  #     end
  #   end
  # end

  def empty?
    @head == @tail
  end

  protected def head
    @head
  end

  protected def tail
    @tail
  end

  class Node(T)
    @next = nil
    @value = nil

    def initialize
    end

    def initialize(@value : T)
    end

    def value
      @value
    end

    def next
      @next
    end

    def next=(next_node : Node(T) | Nil)
      @next = next_node
    end
  end
end
