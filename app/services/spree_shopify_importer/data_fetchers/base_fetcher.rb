module SpreeShopifyImporter
  module DataFetchers
    class BaseFetcher
      def initialize(params = {})
        @params = params
      end
      
      def import!
        resources.each do |resource|
          job.set(wait: wait_time).perform_later(resource.to_json)
        end
      end
      
      private
        
        def wait_time
          %w[5 10 15 20 25 30 35 40 45 50 55 60].map(&:to_i).sample.seconds
        end
        
        def resources
          raise NotImplementedError, I18n.t('errors.not_implemented.resources')
        end
        
        def job
          raise NotImplementedError, I18n.t('errors.not_implemented.job')
        end
    end
  end
end
