class Analyze
  def self.parse(text)
    Natto::MeCab.new(node_format: '%m\s%f[7]\s', unk_format: '%m\s', eos_format: '').parse(text).strip
  end
end