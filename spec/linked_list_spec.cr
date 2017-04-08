require "./spec_helper"

describe LinkedList do
  describe "#initialize" do
    it "initializes the list" do
      LinkedList(Nil).new
    end

    it "initializes the list with the given values" do
      list = LinkedList(Nil | Int32 | String).new(nil, 13, "foo")
      list_array = list.to_a
      list_array[0].should eq nil
      list_array[1].should eq 13
      list_array[2].should eq "foo"
    end
  end

  describe "#size" do
    it "returns 0 when the list is newly initialized" do
      list = LinkedList(Nil).new
      list.size.should eq 0
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
  end

  describe "#<<" do
    it "increases the size of the list by 1" do
      list = LinkedList(Nil).new(nil)
      list << nil

      list.peek.should eq nil
      list.size.should eq 2
    end
  end

  describe "#peek" do
    it "returns the last element of the list without removing it" do
      list = LinkedList(Int32).new(100, 12)
      list.peek.should eq 12
      list.size.should eq 2
    end
  end

  describe "#pop" do
    it "returns the last element of the list and removes it" do
      list = LinkedList(Int32).new(100, 12)
      list.pop.should eq 12
      list.size.should eq 1
    end

    it "returns nil when the list is empty" do
      list = LinkedList(Int32).new(100)
      list.pop
      list.size.should eq 0
      list.pop.should eq nil
    end
  end

  describe "#unshift" do
    it "prepends an element to the list" do
      list = LinkedList(String).new
      list.unshift("foo")
      list.peek.should eq "foo"
    end
  end

  describe "#shift" do
    it "returns the first element from the list and removes it" do
      list = LinkedList(Float64).new(32.1)
      list.shift.should eq 32.1
    end
  end

  describe "#+" do
    it "concatenates two lists and returns a new list" do
      first_list = LinkedList(Int32).new(1, 2)
      second_list = LinkedList(String).new("foo", "bar")

      result = first_list + second_list
      result_array = result.to_a

      result_array[0].should eq 1
      result_array[-1].should eq "bar"
    end

    it "concatenates an array with a list and retuns a new list" do
      first_list = LinkedList(Int32).new(1, 2)
      array = ["foo", "bar"]

      result = first_list + array
      result_array = result.to_a

      result_array[0].should eq 1
      result_array[-1].should eq "bar"
    end
  end

  describe "#concat" do
    it "concatenates two lists modifying the first list" do
      first_list = LinkedList(Int32).new(1, 2)
      second_list = LinkedList(Int32).new(3, 4)

      first_list.concat(second_list)
      result_array = first_list.to_a

      result_array[0].should eq 1
      result_array[-1].should eq 4
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
  end
end
