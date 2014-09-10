class RemainingCategory
  def initialize(categories)
    @categories = categories
  end

  def ids
    @categories.map(&:id)
  end

  def name
    GrayName.new(I18n.t("category.remaining"))
  end

  private

  class GrayName
    def initialize(name)
      @name = name
    end

    def to_s
      @name
    end

    def pastel_color
      "#BEBEBE"
    end
  end
end
