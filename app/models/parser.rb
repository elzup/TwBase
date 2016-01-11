class Parser

  def initialize()
    @parser = CaboCha::Parser.new
  end

  def where_go(text)
    tree = @parser.parse(text)
    Parser.go_targets(tree)
  end

  def self.go_targets(tree)
    go_chunk = Parser.go_chunk(tree)
    Parser.linked_chunks(tree, go_chunk).each do |chunk|
      if Parser.target_chunk?(tree, chunk)
        return Parser.linked_chunks(tree, chunk).map do |target_link_chunk|
          Parser.chunk_surface(tree, target_link_chunk)
        end.join + Parser.chunk_head_surface(tree, chunk)
      end
    end
    return nil
  end

  def self.go_chunk(tree)
    (0...tree.chunk_size).map{ |i| tree.chunk(i) }.select do |chunk|
      Parser.go_chunk?(tree, chunk)
    end[0]
  end

  def self.linked_chunks(tree, to_chunk)
    (0...tree.chunk_size).map{ |i| tree.chunk(i) }.select do |chunk|
      chunk.link >= 0 && tree.chunk(chunk.link).token_pos == to_chunk.token_pos
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

  def self.chunk_surface(tree, chunk)
    (chunk.token_pos...(chunk.token_pos + chunk.token_size)).map do |i|
      Parser.enc(tree.token(i).surface)
    end.join
  end

  def self.chunk_head_surface(tree, chunk)
    (chunk.token_pos...(chunk.token_pos + chunk.func_pos)).map do |i|
      Parser.enc(tree.token(i).surface)
    end.join
  end
end
