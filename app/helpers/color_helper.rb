module ColorHelper
  def pastel_color(string)
    start_color = 100
    total_offset = 164
    hex_value = [
      0,
      string.hash % total_offset,
      string.hash & total_offset,
      total_offset
    ].sort.each_cons(2).map do |a, b|
      "%02x" % (start_color + b - a)
    end.join
    "#" + hex_value
  end
end
