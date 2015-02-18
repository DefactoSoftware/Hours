# == Schema Information
#
# Table name: clients
#
#  id                :integer          not null, primary key
#  name              :string           default(""), not null
#  description       :string           default("")
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class Client < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  scope :by_name, -> { order("lower(name)") }
  scope :by_last_updated, -> { order("clients.updated_at DESC") }
  has_many :projects

  has_many :hours, through: :projects
  has_many :mileages, through: :projects

  has_attached_file :logo,
                    styles: { original: "100x100#" },
                    default_url: "",
                    s3_protocol: ""
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  def logo_url
    logo.url(:original)
  end
end
