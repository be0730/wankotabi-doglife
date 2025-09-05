class Prefecture < ApplicationRecord
  has_many :facilities, dependent: :restrict_with_exception

  def self.ransackable_attributes(_ = nil)
    %w[id code name created_at updated_at]
  end

  def self.ransackable_associations(_ = nil)
    %w[facilities]
  end
end
