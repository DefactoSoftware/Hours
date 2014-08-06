module CacheHelper
  def cache_key_for_all(klass_name)
    klass = klass_name.to_s.singularize.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{current_subdomain}/#{klass_name}/all-#{count}-#{max_updated_at}"
  end
end
