#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Server
    module Adapters

      #
      # = Verisign Adapter
      #
      # Provides ability to query Verisign WHOIS interfaces.
      #
      # The following WHOIS servers are currently known
      # to require the Verisign adapter:
      #
      # - whois.nic.tv
      # - whois.crsnic.net
      # - jobswhois.verisign-grs.com
      # - whois.nic.cc
      #
      class Verisign < Base

        # Executes a WHOIS query to the Verisign WHOIS interface,
        # resolving any intermediate referral,
        # and appends the response to the client buffer.
        #
        # @param  [String] string
        # @return [void]
        #
        def request(string)
          response = query_the_socket("=#{string}", host, DEFAULT_WHOIS_PORT)
          buffer_append response, host

          if endpoint = extract_referral(response)
            begin
              response = query_the_socket(string, endpoint, DEFAULT_WHOIS_PORT)
              buffer_append response, endpoint
            rescue ConnectionError => error
              #do nothing, some whois servers will reset this query, just ignore it.
            end
          end
        end


        private

        def extract_referral(response)
          if response =~ /Domain Name:/
            endpoint = response.scan(/Whois Server: (.+?)$/).flatten.last
            endpoint.strip!
            endpoint = nil  if endpoint == "not defined"
            endpoint
          end
        end

      end

    end
  end
end
