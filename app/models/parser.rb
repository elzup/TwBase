class Parser

  def initialize()
    @parser = CaboCha::Parser.new
  end

  def where_go(text)
    tree = @parser.parse(text)
    target_chunk = Parser.go_targets(tree)
  end

  def self.go_targets(tree)
    Parser.go_link_chunk(tree).each do |chunk|
      if Parser.target_chunk?(tree, chunk)
        return chunk
      end
    end
    return nil
  end

  def self.go_link_chunk(tree)
    (0...tree.chunk_size).map{ |i| tree.chunk(i) }.select do |chunk|
      chunk.link >= 0 && Parser.go_chunk?(tree, tree.chunk(chunk.link))
    end
  end

  def self.go_chunk?(tree, chunk)
    Parser.enc(tree.token(chunk.token_pos).surface) == '行く'
  end

  def self.target_chunk?(tree, chunk)
    %w(に へ).include?(Parser.enc(tree.token(chunk.token_pos + chunk.token_size - 1).surface))
  end

  def self.enc(s)
    return s.force_encoding('UTF-8')
  end
end
