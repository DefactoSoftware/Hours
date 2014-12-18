# == Schema Information
#
# Table name: clients
#
#  id                :integer          not null, primary key
#  name              :string(255)      default(""), not null
#  description       :string(255)      default("")
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class Client < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  scope :by_name, -> { order("lower(name)") }
  has_many :projects

  has_attached_file :logo,
                    styles: { original: "100x100#" },
                    default_url: ""
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  def logo_url
    logo.url(:original)
  end
end
