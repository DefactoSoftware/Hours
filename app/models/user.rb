# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      default(""), not null
#  last_name              :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  organization_id        :integer
#  slug                   :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invitations_count      :integer          default(0)
#

class User < ActiveRecord::Base
  include Sluggable

  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :invitable

  validates_presence_of :first_name, :last_name

  has_one :account, foreign_key: "owner_id", inverse_of: :owner
  belongs_to :organization, class_name: "Account", inverse_of: :users
  has_many :entries
  has_many :projects, -> { uniq }, through: :entries

  scope :by_name, -> { order("lower(last_name)") }

  def full_name
    "#{first_name} #{last_name}"
  end
  alias_method :slug_source, :full_name
  alias_method :label, :full_name
  alias_method :name, :full_name

  def email_domain
    email.split("@").last
  end

  def color
    (first_name + last_name).pastel_color
  end

  def acronyms
    first_name[0] + last_name[0]
  end
end

