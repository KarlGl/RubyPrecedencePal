require 'ruby_parser'
require 'pry'
class Parser
  attr_accessor :current_output, :root_node, :debug_mode

  def initialize(input, debug_mode=false)
    self.current_output = ""
    self.root_node = RubyParser.new.parse(input)
    self.debug_mode = debug_mode
  end

  def call
    resolve(root_node)
  end

  def is_lit?(node)
    !node.is_a?(Symbol) && (node.head == :lit)
  end

  def is_method_name(node)
    node.head == :call and node.rest.head == nil
  end

  def get_lit_value(node)
    node.rest.head
  end

  def cleanup_notation(sym)
    {
      :lasgn => '='
    }[sym] || sym
  end

  def log(msg)
    puts msg if debug_mode
  end

  def resolve(node)
    log "main calling with #{node}"
    # Case where we terminate because there are no more sub expressions.
    # we just called resolve on a symbol itself
    unless node.is_a? Sexp
      return cleanup_notation(node)
    end
    if node.head == :call and node.rest.head == nil
      # This is a method call.
      return node.rest.rest.head
    end

    # ignore the call node. we dont need to know about it in cases with calling literals.
    if node.head == :call
      node = node.rest
    end

    # Terminate if we are resolving a literal
    if is_lit? node
      return get_lit_value(node) # e.g. 1
    end

    # If not, we probably have as s expression with 3 parts. ( I hope )
    raise if !node.size == 3

    # if the first part is a lit, it means the middle is the second part of the
    # s expressoin not the first (it's not RPN).
    if !node.head.is_a?(Symbol)# the middle is the command, its not RPN #is_lit? node.head
      log "not rpn"
      # NOT RPN
      # this is our smbol since its not RPN e.g. :+
      middle = node.rest.head # an actual symbol
      left = resolve(node.head)
      right = resolve(node.rest.rest.head)
    else
      # RPN
      log "rpn"
      middle = node.head # an actual symbol
      left = resolve(node.rest.head)
      right = resolve(node.rest.rest.head)
    end

    middle = cleanup_notation(middle)
    if right.nil?
      return "(#{middle} #{left})"
    end
    if middle == :[]
      "#{left}[#{right}]"
    else
      "(#{left} #{middle} #{right})"
    end
  end
end
