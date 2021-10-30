module SpreeShopifyImporter
  module DataSavers
    module Images
      class ImageUpdater < ImageBase
        def initialize(shopify_data_feed, spree_image, spree_object)
          super(shopify_data_feed)
          @spree_image = spree_image
          @spree_object = spree_object # can be product or variant
        end

        def update!
          Spree::Image.transaction do
            return unless valid_path?

            update_spree_image
            assign_spree_image_to_data_feed
          end
          update_timestamps
        end

        private

        def update_spree_image
          @_spree_image = @spree_image.is_a?(Spree::Asset) ? @spree_image.viewable.images.new : @spree_image
          
          @_spree_image.assign_attributes(attributes_with_attachement.except(:attachment))
          
          @_spree_image.attachment.attach(
            io:       attachment,
            filename: attributes_with_attachement[:alt]
          )
          @_spree_image.save!
        end
      end
    end
  end
end
