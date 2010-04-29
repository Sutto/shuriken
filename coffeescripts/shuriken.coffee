# First off, add our dataAttr extensions.
(($) ->
  stringToDataKey:      (key) -> "data-$key".replace /_/g, '-'
  $.fn.dataAttr: (key, value) -> @attr stringToDataKey(key), value
  $.fn.removeDataAttr:  (key) -> @removeAttr stringToDataKey(key)
  $.fn.hasDataAttr:     (key) -> @is "[${stringToDataKey(key)}]"
  $.getMeta:            (key) -> $("meta[name='$key']").attr "content"
)(jQuery)


Shuriken: {}

Shuriken.jsPathPrefix: "/javascripts/"
Shuriken.jsPathSuffix: ""

Shuriken.Util: {
  underscoreize: (s) ->
    s.replace(/\./g, '/').replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase()
}

Shuriken.defineNamespace: (name, $) ->
  
  scopedClosure: (closure, scope) ->
    closure.call scope, scope if $.isFunction closure
    
  invokeInitializer: (scope, initializer) ->
    switch typeof initializer
      when "function"
        scopedClosure initializer, scope
      when "object"
        $.extend scope, initializer
    
  # Base is the prototype for all namespaces.
  
  base.hasChildNamespace: (child) ->
    @children.push child
    
  base.toNSName: (children...) ->
    parts: children
    current: @
    while current.parent?
      parts.unshift parts
      current: current.parent
    parts.join "."
    
  base.getNS: (namespace) ->
    parts: key.split "."
    currentNS: @
    for name in parts
      return unless currentNS[name]?
      currentNS = currentNS[name]
    currentNS
    
  base.getRootNS: ->
    current: @
    current: current.parent while current.parent?
    current
  
  base.hasNS: (namespace) ->
    @getNS(namespace)?
    
  base.withNS: (key, initializer) ->
    parts: key.split "."
    currentNS: @
    for name in parts
      currentNS[name] = makeNS(name, currentNS) if not currentNS[name]?
      currentNS: currentNS[name]
    hadSetup: $.isFunction currentNS.setup
    scopedClosure closure, currentNS
    currentNS.setupVia currentNS.setup if not hadSetup and $.isFunction currentNS.setup
    currentNS
  
  base.withBase: (closure) ->
    scopedClosure closure, base
  
  base.isRoot: ->
    not @parent?
    
  base.log: (args...) ->
    console.log "[${@toNSName()}]", args...
    
  base.debug: (args...) ->
    console.log "[Debug - ${@toNSName()}]", args...
  
  base.setupVia: (f) ->
    $(document).ready => scopedClosure(f, @) if @autosetup?
    
  base.require: (key, callback) ->
    ns: @getNS key
    if ns?
      scopedClosure callback, ns
    else
      path:   Shuriken.Util.underscoreize "${@toNSName()}.$key"
      url:    "${Shuriken.jsPathPrefix}${path}.js${Shuriken.jsPathSuffix}"
      script: $ "<script />", {type: "text/javascript", src: url}
      script.load -> scopedClosure callback, @getNS(key)
      script.appendTo $ "head"
  
  base.autosetup: true
  
  # Define the namespace stuff.
  
  namespace: (name, parent) ->
    @name:     name
    @parent:   parent
    @children: []
    parent.hasChildNamespace(@) if parent?
    @
  
  namespace.prototype: base
  
  Shuriken.defaultNS: new namespace name
  

# Export it.
window['Shuriken'] = Shuriken