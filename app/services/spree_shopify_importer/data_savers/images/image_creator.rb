module SpreeShopifyImporter
  module DataSavers
    module Images
      class ImageCreator < ImageBase
        def initialize(shopify_data_feed, spree_object)
          super(shopify_data_feed)
          @spree_object = spree_object # can be product or variant
        end
        
        def create!
          Spree::Image.transaction do
            return unless valid_path?
            return if @spree_object.images.pluck(:attachment_file_name).include?(name)
            
            create_spree_image
            assign_spree_image_to_data_feed
          end
          update_timestamps
        end
        
        private
          
          def create_spree_image
            @spree_image = @spree_object.images.new(attributes_with_attachement.except(:attachment))
            @spree_image.attachment.attach(
              io:       attributes_with_attachement[:attachment],
              filename: attributes_with_attachement[:alt]
            )
            @spree_image.save!
          end
      end
    end
  end
end
