class Signup
  include ActiveModel::Model

  attr_accessor :first_name,
    :last_name,
    :email,
    :password,
    :password_confirmation,
    :subdomain,
    :user,
    :account

  validate :validate_children

  def initialize(*)
    super
    build_children
  end

  def save
    if valid?
      ActiveRecord::Base.transaction do
        account.save!
        user.save!
      end
    end
  end

  private

  def build_children
    @user = User.new(first_name: first_name,
                     last_name: last_name,
                     email: email,
                     password: password,
                     password_confirmation: password_confirmation)
    @account = Account.new(subdomain: subdomain, owner: @user)
  end

  def validate_children
    if user.invalid?
      promote_errors(user)
    end

    if account.invalid?
      promote_errors(account)
    end
  end

  def promote_errors(child)
    child.errors.each do |attr, val|
      errors.add(attr, val)
    end
  end
end
