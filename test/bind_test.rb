require 'minitest/autorun'
require 'callchain'


class BindTest < Minitest::Test
  def test_calls_method
    chain_class = Class.new
    chain_class.extend(CallChain)
    chain_class.use CallChain[:to_i]
    assert_equal 1, chain_class.call('1')
  end

  def test_binds_args
    chain_class = Class.new
    chain_class.extend(CallChain)
    chain_class.use CallChain.bind(:+, 1)
    assert_equal 2, chain_class.call(1)
  end
end
