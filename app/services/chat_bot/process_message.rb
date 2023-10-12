module ChatBot
  class ProcessMessage
    include Service

    def call
      "This is what you said: \"#{@body}\""
    end

    attr_accessor :body
  end
end
