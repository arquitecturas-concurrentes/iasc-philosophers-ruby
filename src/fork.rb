module Concurrency
  class Fork
    attr_reader :id, :mutex


    def initialize(id)
      @id = id
      @mutex = Mutex.new
    end

    def lock(_name)
      mutex.synchronize do
        yield if block_given?
      end
    end
  end
end
