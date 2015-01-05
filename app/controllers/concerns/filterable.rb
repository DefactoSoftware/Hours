module Filterable
  def filter_collection(resource)
    filter_params(params).each do |filter, value|
      resource = resource.public_send(filter, value) if value.present?
    end
    resource
  end
end
