module SpreeShopifyImporter
  module Connections
    class Base
      class << self
        def count(**opts)
          api_class.get(:count, opts)
        end

        def all(**opts)
          results = []
          find_in_batches(**opts) do |batch|
            break if batch.blank?
            results += batch
          end
          results
        end

        private

        def find_in_batches(**opts)
          params = { limit: 10 }.merge!(opts)
          batch = api_class.find(:all, params: params)

          loop do
            break unless batch.next_page?
            batch = batch.fetch_next_page
            yield batch
          end
        end

        def api_class
          "ShopifyAPI::#{name.demodulize}".constantize
        end
      end
    end
  end
end
