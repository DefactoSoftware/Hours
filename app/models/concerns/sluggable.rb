module Sluggable
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true, uniqueness: true
    before_validation :generate_slug
  end

  def to_param
    slug
  end

  private

  def generate_slug
    return unless slug_source
    self["slug"] ||= unless self.class.find_by_slug(slug_source.parameterize)
                       slug_source.parameterize
                     else
                       index = 0
                       loop do
                         index += 1
                         unique_slug = "#{slug_source}-#{index}".parameterize
                         break unique_slug unless self.class.where(slug: unique_slug).exists?
                       end
                     end
  end
end
