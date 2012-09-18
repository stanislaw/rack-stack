class RackStack

  # TODO add RequestMatcher documentation to this!
  # @api private
  class RequestMatcher
    include IndifferentEval

    # @return [Proc, Hash<>, Array()] Either a Proc or a Hash or Array of pairs. # TODO yardoc-ify
    attr_accessor :matcher
    
    # Boolean for whether or not this matcher should be 
    # included in {RackStack#trace}.
    attr_accessor :trace

    def initialize(matcher, trace = true)
      self.matcher = matcher
      self.trace = trace
    end

    def matches?(env)
      request = Rack::Request.new(env)

      if @matcher.respond_to?(:call)
        indifferent_eval request, &@matcher
      else
        @matcher.all? do |request_attribute, value|
          case value
          when String
            value === request.send(request_attribute)
          when Array
            value.include? request.send(request_attribute)
          when Regexp
            request.send(request_attribute) =~ value
          end
        end
      end
    end
  end
end
