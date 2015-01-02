require "apartment/elevators/subdomain"

module Apartment
  module Elevators
    class RescuedSubdomain < Subdomain
      def call(env)
        super
      rescue ::Apartment::SchemaNotFound
        [302, {"Location" => root_url(env)}, []]
      end

      private

      def root_url(env)
        host = env["HTTP_HOST"]
        scheme = env["rack.url_scheme"]
        root_url = host.gsub("#{subdomain(host)}.", "")
        [scheme, root_url].join("://")
      end
    end
  end
end
