#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Record
    class Parser
      module Scanners

        class Base

          def initialize(content)
            @input = StringScanner.new(content)
          end

          def parse
            @ast = {}
            while !@input.eos?
              parse_content
            end
            @ast
          end

          # This method is the core of the parser.
          #
          # It should include the parser logic
          # to analyze, trim or consume a line.
          #
          # @abstract Implement in your parser.
          def parse_content
            raise NotImplementedError
          end


          def trim_empty_line
            @input.skip(/^\n/)
          end

          def trim_newline
            @input.skip(/\n/)
          end

          def error!(message)
            if @input.eos?
              raise ParserError, "Unexpected end of input."
            else
              raise ParserError, "#{message}: #{@input.peek(@input.string.length)}"
            end
          end

        end

      end
    end
  end
end