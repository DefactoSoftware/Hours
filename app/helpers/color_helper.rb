module ColorHelper
  def pastel_color(string)
    start_color = 100
    total_offset = 140
    hex_value = [
      0,
      string_to_integer_hash(string) % total_offset,
      string_to_integer_hash(string.reverse) % total_offset,
      total_offset
    ].sort.each_cons(2).map do |a, b|
      "%02x" % (start_color + b - a)
    end.join
    "#" + hex_value
  end

  private

  def string_to_integer_hash(string)
    [Digest::SHA256.hexdigest(string)].pack("H*").unpack("l>").first
  end
end
