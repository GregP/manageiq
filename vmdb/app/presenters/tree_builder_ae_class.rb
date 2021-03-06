class TreeBuilderAeClass  < TreeBuilder
  attr_reader :tree_nodes

  private

  def tree_init_options(tree_name)
    {:leaf => "datastore"}
  end

  def set_locals_for_render
    locals = super
    locals.merge!(:autoload => true)
  end

  # Get root nodes count/array for explorer tree
  def x_get_tree_roots(options)
    objects = MiqAeDomain.all
    count_only_or_objects(options[:count_only], objects, [:priority]).reverse
  end

  def x_get_tree_class_kids(object, options)
    instances = count_only_or_objects(options[:count_only], object.ae_instances, [:display_name, :name])
    # show methods in automate explorer tree
    if x_active_tree == :ae_tree
      methods = count_only_or_objects(options[:count_only], object.ae_methods, [:display_name, :name])
      instances + methods
    else
      instances
    end
  end

  def x_get_tree_ns_kids(object, options)
    objects = MiqAeNamespace.all(:conditions => {:parent_id => object.id.to_i})
    ns_classes = object.ae_classes
    objects += ns_classes.flatten unless ns_classes.blank?
    count_only_or_objects(options[:count_only], objects, [:display_name, :name])
  end
end
