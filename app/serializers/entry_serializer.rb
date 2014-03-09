class EntrySerializer < ActiveModel::Serializer
  attributes :project, :category, :user, :hours, :date, :created_at, :tags

  def project
    entry.project.name
  end

  def category
    entry.category.name
  end

  def user
    entry.user.full_name
  end

  def tags
    entry.tags.map(&:name)
  end

  private

  def entry
    object
  end
end
