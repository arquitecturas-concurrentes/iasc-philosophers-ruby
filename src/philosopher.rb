module Concurrency
  class Philosopher
    attr_reader :name, :left, :right

    EAT_INTERVAL = 1..3 #seconds
    THINK_INTERVAL = 1..5 #seconds


    def initialize(name, left, right)
      validate_type(left, right)
      @name = name
      @left, @right = left.id < right.id ? [left, right] : [right, left]
    end

    def run_loop
      loop do
        eat
        left.lock(name) do
          right.lock(name) { eat }
        end
      end
    end

    def think
      rand_sleep(THINK_INTERVAL)
    end

    def eat
      rand_sleep(EAT_INTERVAL)
    end

    private

    def validate_type(*values)
      filtered = values.reject { |value| value.is_a? Fork }
      raise TypeError.new "values do not belong to Fork type: #{filtered}" unless filtered.empty?
    end

    def rand_sleep(secs_interval)
      sleep(rand(secs_interval))
    end
  end
end