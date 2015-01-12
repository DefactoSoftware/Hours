class ClientBillableValidator < ActiveModel::Validator
  def validate(record)
    if record.billable && !record.client
      record.errors[:client] << I18n.t("project.errors.client_missing")
    end
  end
end
