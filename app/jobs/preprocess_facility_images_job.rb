class PreprocessFacilityImagesJob < ApplicationJob
  queue_as :default

  VARIANTS = [
    { resize_to_limit: [1600, 1200] },
    { resize_to_limit: [1280,  960] },
    { resize_to_limit: [ 768,  576] }
  ].freeze

  def perform(facility_id, attachment_ids)
    facility = Facility.find(facility_id)

    ids = Array(attachment_ids).map(&:to_i).uniq
    return if ids.empty?

    facility.images.attachments.where(id: ids).find_each do |att|
      next unless att.blob&.image?

      VARIANTS.each { |v| att.variant(**v).processed }
    rescue => e
      Rails.logger.warn "[PreprocessFacilityImagesJob] #{att.blob&.key}: #{e.class} #{e.message}"
      raise
    end
  end
end
