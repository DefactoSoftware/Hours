module DeviseSetup
  require 'hours'

  extend ActiveSupport::Concern

  included do
    if ActiveRecord::Base.connection.table_exists? 'users'
      if User.count == 0
        devise :database_authenticatable,
               :recoverable,
               :rememberable,
               :trackable,
               :validatable,
               :confirmable,
               :registerable,
               :invitable
      else
        devise :database_authenticatable,
               :recoverable,
               :rememberable,
               :trackable,
               :validatable,
               :confirmable,
               :invitable
      end
    end
  end
end

