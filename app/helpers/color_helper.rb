module ColorHelper
  def pastel_color(string)
    start_color = 92
    total_offset = 156
    hex_value = [
      0,
      hash_code(string) % total_offset,
      hash_code(string) & total_offset,
      total_offset
    ].sort.each_cons(2).map do |a, b|
      "%02x" % (start_color + b - a)
    end.join
    "#" + hex_value
  end

  private

  def hash_code(string)
    string.split("").reduce do |memo, obj|
      hash = ((memo.ord << 3) - memo.ord) + obj.ord
      (hash & hash).abs
    end
  end
end
