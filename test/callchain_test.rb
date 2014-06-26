require 'minitest/autorun'
require 'callchain'

module CallChainTestTemplate
  def chain
    @chain ||= new_chain
  end

  # create a Module, Class, and lambda
  def setup
    super
    @chain = nil
    @append_a = Module.new
    @append_a.define_singleton_method(:call) do |thing|
      thing << 'a'
      thing
    end

    @append_b = Class.new
    @append_b.define_singleton_method(:call) do |thing|
      thing << 'b'
      thing
    end

    @append_c = lambda do |thing|
      thing << 'c'
      thing
    end
  end

  # No shirt, no shoes, no problem
  def test_noops_with_no_composites
    result = chain.call([])
    assert_equal([], result)
  end

  # #chain returns the chain
  def test_chain_accessor
    chain.use @append_a, @append_b
    assert_equal([@append_a, @append_b], chain.chain)
  end

  # Single call to ::use
  def test_with_one_composite
    chain.use @append_a
    result = chain.call([])
    assert_equal(['a'], result)
  end

  # Single call to ::use with multiple classes
  # are chained in the order they are added
  def test_with_multiple_composites
    chain.use @append_a, @append_b
    result = chain.call([])
    assert_equal(['a', 'b'], result)
  end

  # Multiple calls to ::use are chained in
  # the order they are added
  def test_with_multiple_compositions
    chain.use @append_a, @append_b
    chain.use @append_c
    result = chain.call([])
    assert_equal(['a', 'b', 'c'], result)
  end

  def test_composite_chain
    chain2 = new_chain
    chain2.use @append_a, @append_b, @append_c
    chain.use chain2, @append_c
    result = chain.call([])
    assert_equal(['a', 'b', 'c', 'c'], result)
  end
end

# Test to the two different ways of mixin-in
# extend for class-level methods
# include for instance-level methods
# exposes the same interface
class CallChainExtendTest < Minitest::Test
  include CallChainTestTemplate

  def new_chain
    chain_class = Class.new
    chain_class.extend(CallChain)
    chain_class
  end
end

class CallChainIncludeTest < Minitest::Test
  include CallChainTestTemplate
  def new_chain
    chain_class = Class.new
    chain_class.include(CallChain)
    chain_class.new
  end
end
