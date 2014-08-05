# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      default(""), not null
#  last_name              :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
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
#

class User < ActiveRecord::Base
  include Sluggable

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
          :registerable, :confirmable

  validates_presence_of :first_name, :last_name
  validate :email_matches_account_owners

  has_one :account, foreign_key: "owner_id", inverse_of: :owner
  belongs_to :organization, class_name: "Account", inverse_of: :users
  has_many :entries
  has_many :projects, -> { uniq }, through: :entries


  def full_name
    "#{first_name} #{last_name}"
  end
  alias_method :slug_source, :full_name

  def hours_spent_on(project)
    entries.where(project: project).sum(:hours)
  end

  def percentage_spent_on(project)
    hours_spent_on(project).to_f / hours_spent.to_f * 100
  end

  def hours_spent
    entries.sum(:hours)
  end

  def hours_per_project
    projects.map do |project|
      { value: hours_spent_on(project), color: project.name.pastel_color, highlight: "gray", label: project.name }
    end
  end

  private

  def email_matches_account_owners
    return unless organization
    owner_email_domain = organization.owner.email.split("@").last
    user_email_domain = email.split("@").last
    unless user_email_domain == owner_email_domain
      errors.add(:email, :invalid_email)
    end
  end
end

