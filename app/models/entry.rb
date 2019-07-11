class Entry < ActiveRecord::Base
  self.abstract_class = true

  include Twitter::Extractor

  validates :user, :project, :date, presence: true
  validates :value, presence: true, numericality: { greater_than: 0,
                                                    only_integer: true }
                                                
  validate :check_future_date
  audited allow_mass_assignment: true

  has_one :client, through: :project

  belongs_to :user, touch: true
  belongs_to :project, touch: true

  def check_future_date
    if date.present? && date.future?
      errors.add(:date, :future_date)
    end
  end
end
