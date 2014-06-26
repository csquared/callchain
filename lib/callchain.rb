require "callchain/version"

module CallChain
  # CallChain implementations
  #
  # Individual filters do work with ::call(object)
  #
  # Compose a CallChain with the ::use method
  #
  # Compose a CallChain of call chains because it exports ::call(object)
  #
  # Example:
  #
  #   Pricer = Class.new(CallChain)
  #
  #   class AppTierPricer < Pricer
  #     use PlanScoper, Quantizer, AppGrouper
  #     use UserGrouper
  #   end

  def use(*args)
    @chain ||= []
    @chain.push(*args)
  end

  def chain
    @chain
  end

  def call(thing)
    return thing unless chain
    chain.each do |filter|
      thing = filter.call(thing)
      yield thing, filter if block_given?
    end
    thing
  end
end
