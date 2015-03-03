class ReportEntry < SimpleDelegator
  def user
    __getobj__.user.full_name
  end

  def date
    I18n.l __getobj__.date
  end

  def project
    __getobj__.project.name
  end

  def category
    __getobj__.category.name
  end

  def client
    __getobj__.project.client.try(:name)
  end

  def billable
    __getobj__.project.billable
  end
end
