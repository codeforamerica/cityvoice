class Call::ScopeIterator < Struct.new(:relation, :index_value)
  def empty?
    count == 0
  end

  def has_more?
    index < count
  end

  def current
    relation[index]
  end

  def next_index
    index + 1
  end

  protected

  def index
    index_value.to_i
  end

  def count
    @count ||= relation.count
  end
end
