class Supports::Admin::PostSupport
  def all_modes
    Post.modes
  end

  def all_arenas
    Post.arenas
  end

  def all_child_categories
    Category.isnot_parent
  end
end
