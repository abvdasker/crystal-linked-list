require "./spec_helper"

describe LinkedList do
  describe "#initialize" do
    it "initializes the list" do
      list = LinkedList(Nil).new
      list.size.should eq 0
    end

    it "initializes the list with the given values" do
      list = LinkedList(Nil | Int32 | String).new(1, 13, "foo")

      list_array = list.to_a
      list_array[0].should eq 1
      list_array[1].should eq 13
      list_array[2].should eq "foo"
    end
  end

  describe "#size" do
    it "returns 0 when the list is newly initialized" do
      list = LinkedList(Nil).new
      list.size.should eq 0
    end

    it "returns 1 when the list is newly initialized with a single value" do
      list = LinkedList(Int32).new(1)
      list.size.should eq 1
    end
  end

  describe "#append" do
    it "increases the size of the list by 1" do
      list = LinkedList(Nil).new(nil)

      list.append(nil)

      list.peek.should eq nil
      list.size.should eq 2
    end

    it "appends multiple elements to the list" do
      list = LinkedList(Int32 | String).new

      list.append(1, "foo")

      list.peek.should eq "foo"
      list.size.should eq 2
    end
  end

  describe "#push" do
    it "increases the size of the list by 1" do
      list = LinkedList(Nil).new(nil)

      list.push(nil)

      list.peek.should eq nil
      list.size.should eq 2
    end

    it "adds the element to the end of the list" do
      list = LinkedList(Int32).new(1)
      list.peek.should eq 1

      list.push(2)

      list.peek.should eq 2
      list.size.should eq 2
    end

    it "push multiple elements to the list" do
      list = LinkedList(Int32).new
      list.peek.should eq nil

      list.push(1, 2)

      list.peek.should eq 2
      list.size.should eq 2
    end
  end

  describe "#insert_at" do
    it "insert into an empty list at index 0" do
      list = LinkedList(Int32).new
      list.insert_at(1, 0)

      list.size.should eq 1

      list[0].should eq 1
    end

    it "insert fails if not contiguous" do
      list = LinkedList(Int32).new
      list.insert_at(1, 1)
      list.size.should eq 0
    end

    it "insert into a populated list at index 0 ( unshift )" do
      list = LinkedList(Int32).new(1, 2)
      list.insert_at(3, 0)

      list.size.should eq 3

      list[0].should eq 3
      list[1].should eq 1
      list[2].should eq 2
    end

    it "insert into a populated list at index n" do
      list = LinkedList(Int32).new(1, 2)
      list.insert_at(3, 1)

      list.size.should eq 3

      list[0].should eq 1
      list[1].should eq 3
      list[2].should eq 2
    end
  end

  describe "#insert_at" do
    it "insert into an empty list at index 0" do
      list = LinkedList(Int32).new
      list.insert_at(1, 0)

      list.size.should eq 1

      list_a = list.to_a

      list_a[0].should eq 1
    end

    it "insert fails if not contiguous" do
      list = LinkedList(Int32).new
      list.insert_at(1, 1)
      list.size.should eq 0
    end

    it "insert into a populated list at index 0 ( unshift )" do
      list = LinkedList(Int32).new(1, 2)
      list.insert_at(3, 0)

      list.size.should eq 3

      list_a = list.to_a

      list_a[0].should eq 3
      list_a[1].should eq 1
      list_a[2].should eq 2
    end

    it "insert into a populated list at index n" do
      list = LinkedList(Int32).new(1, 2)
      list.insert_at(3, 1)

      list.size.should eq 3

      list_a = list.to_a

      list_a[0].should eq 1
      list_a[1].should eq 3
      list_a[2].should eq 2
    end
  end

  describe "#<<" do
    it "increases the size of the list by 1" do
      list = LinkedList(Nil).new(nil)
      list << nil

      list.peek.should eq nil
      list.size.should eq 2
    end

    it "adds the element to the end of the list" do
      list = LinkedList(Int32).new(1)
      list << 2 << 3

      list.peek.should eq 3
      list.size.should eq 3
    end
  end

  describe "#peek" do
    it "returns nil when list is empty" do
      list = LinkedList(Int32).new
      list.peek.should eq nil
      list.size.should eq 0
    end

    it "returns the last element of the list without removing it" do
      list = LinkedList(Int32).new(100, 12)
      list.peek.should eq 12
      list.size.should eq 2
    end
  end

  describe "#pop" do
    it "returns nil when list is empty" do
      list = LinkedList(Int32).new
      list.pop.should eq nil
      list.size.should eq 0
    end

    it "returns the last element of the list and removes it" do
      list = LinkedList(Int32).new(100, 12)
      list.pop.should eq 12
      list.peek.should eq 100
      list.size.should eq 1
    end

    it "returns nil when the list is empty" do
      list = LinkedList(Int32).new(100)
      list.pop()
      list.size.should eq 0
      list.pop().should eq nil
    end
  end

  describe "#empty?" do
    it "returns true when there are no elements in the list" do
      list = LinkedList(Int32).new

      list.empty?.should be_true
    end

    it "returns false" do
      list = LinkedList(Int32).new(1, 2)

      list.empty?.should be_false
    end

    it "returns true when all elements have been removed from the list" do
      list = LinkedList(Int32).new(1, 2)
      list.empty?.should be_false

      list.pop()
      list.empty?.should be_false

      list.pop()
      list.empty?.should be_true
    end
  end

  describe "#unshift" do
    it "prepends an element to the list" do
      list = LinkedList(String).new
      list.size.should eq 0
      list.unshift("foo")
      list.size.should eq 1
      list.peek.should eq "foo"
    end

    it "prepends an element to the list multiple times" do
      list = LinkedList(String).new
      list.size.should eq 0
      list.unshift("foo")
      list.size.should eq 1
      list.unshift("bar")
      list.size.should eq 2
      list.peek.should eq "foo"
    end

    it "prepends an element to populated list" do
      list = LinkedList(String).new("blah")
      list.size.should eq 1
      list.unshift("foo")
      list.size.should eq 2
      list.unshift("bar")
      list.size.should eq 3
      list.peek.should eq "blah"
    end
  end

  describe "#shift" do
    it "returns nil when list is empty" do
      list = LinkedList(Float64).new
      list.shift.should eq nil
    end

    it "returns the first element from the list and removes it" do
      list = LinkedList(Float64).new(32.1)
      list.shift.should eq 32.1
      list.shift.should eq nil
    end

    it "returns the first element from the list and removes it, multiple values" do
      list = LinkedList(Float64).new(32.1, 64.2)
      list.shift.should eq 32.1
      list.shift.should eq 64.2
      list.shift.should eq nil
    end
  end

  describe "#index_operator" do
    it "get multiple elements via the index" do
      list = LinkedList(Int32).new
      list.append(1)
      list.append(2)
      list[0].should eq 1
      list[1].should eq 2
    end
  end

  describe "#to_a" do
    it "linked list converted into an array" do
      list = LinkedList(Int32).new(1, 2)

      list_a = list.to_a

      list_a[0] = 1
      list_a[1] = 2
    end
  end

  describe "#+" do
    it "concatenates two lists and returns a new list" do
      first_list = LinkedList(Int32).new(1, 2)
      second_list = LinkedList(String).new("foo", "bar")

      result = first_list + second_list
      result.size.should eq 4

      result_array = result.to_a

      result_array[0].should eq 1
      result_array[1].should eq 2
      result_array[-1].should eq "bar"
      result_array[-2].should eq "foo"
    end

    it "concatenates an array with a list and retuns a new list" do
      first_list = LinkedList(Int32).new(1, 2)
      array = ["foo", "bar"]

      result = first_list + array
      result.size.should eq 4

      result[0].should eq 1
      result[1].should eq 2
      result[2].should eq "foo"
      result[3].should eq "bar"
    end
  end

  describe "#concat" do
    it "concatenates two lists modifying the first list" do
      first_list = LinkedList(Int32).new(1, 2)
      second_list = LinkedList(Int32).new(3, 4)

      first_list.concat(second_list)
      first_list.size.should eq 4

      first_list[0].should eq 1
      first_list[1].should eq 2
      first_list[2].should eq 3
      first_list[3].should eq 4
    end
  end

  describe "#reverse" do
    it "creates a copy of the linked list with the order reversed" do
      list = LinkedList(Int32).new(1, 2, 3)
      reversed_list = list.reverse

      reversed_list.shift.should eq 3
      reversed_list.shift.should eq 2
      reversed_list.shift.should eq 1
    end
  end

  describe "#each" do
    it "iterates over each value" do
      values = [1, 2, "test"]
      list = LinkedList(Int32 | String).new(values)

      list.each do |elem|
        values.shift.should eq elem
      end
    end

    it "iterates over nothing" do
      list = LinkedList(Int32 | String).new

      list.each do |_|
        false.should be_true
      end
    end
  end

  describe "#to_s" do
    it "confirm the string output for a linked list" do
      list = LinkedList(Int32 | String).new
      list.append(1)
      list.append(2)
      list.append("test")
      list.to_s.should eq "[ 1, 2, test ]"
    end
  end

  describe "continuously populate and empty" do
    # testing that pop sets the list to nil
    it "init and pop" do
      list = LinkedList(Int32).new(1,2,3)

      list.pop()
      list.pop()
      list.pop()

      list.append(4)
      list.size.should eq 1

      list[0].should eq 4

    end

    it "init and shift" do
      list = LinkedList(Int32).new(1,2,3)

      list.shift()
      list.shift()
      list.shift()

      list.append(4)
      list.size.should eq 1

      list[0].should eq 4

    end

    it "init and reverse and shift" do
      list = LinkedList(Int32).new(1,2,3)

      reversed_list = list.reverse

      reversed_list.shift()
      reversed_list.shift()
      reversed_list.shift()

      reversed_list.append(4)
      reversed_list.size.should eq 1

      reversed_list[0].should eq 4
    end
  end

end
