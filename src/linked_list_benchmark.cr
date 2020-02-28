# TODO: Write documentation for `Benchmark`

require "./linked_list"
require "benchmark"

module LinkedListBenchmark
  VERSION = "0.1.0"

  # TODO: Put your code here

  # ========================================
  # benchmark appending
  list1 = LinkedList(Int32).new
  list2 = LinkedList(Int32).new
  list3 = LinkedList(Int32).new
#   Benchmark.ips do |x|
#     x.report("append") { 1000.times{ list.append(1) } }
#   end

  puts Benchmark.measure { 100.times{ list1.append(1) } }
  puts Benchmark.measure { 10_000.times{ list2.append(1) } }
  puts Benchmark.measure { 1_000_000.times{ list3.append(1) } }

  puts Benchmark.measure { list1.insert_at(1, 1) }
  puts Benchmark.measure { list2.insert_at(1, 1) }
  puts Benchmark.measure { list3.insert_at(1, 1) }
  # ========================================

end