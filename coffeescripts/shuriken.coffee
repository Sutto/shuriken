# First off, add our dataAttr extensions.
if jQuery?
  (($) ->
    stringToDataKey:      (key) -> "data-$key".replace /_/g, '-'
    $.fn.dataAttr: (key, value) -> @attr stringToDataKey(key), value
    $.fn.removeDataAttr:  (key) -> @removeAttr stringToDataKey(key)
    $.fn.hasDataAttr:     (key) -> @is "[${stringToDataKey(key)}]"
    $.getMeta:            (key) -> $("meta[name='$key']").attr "content"
  )(jQuery)


Shuriken: {
  Base:         {}
  Util:         {}
  jsPathPrefix: "/javascripts/"
  jsPathSuffix: ""
  namespaces:   {}
}

Shuriken.Util.underscoreize: (s) ->
  s.replace(/\./g, '/').replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase()
    
# Base is the prototype for all namespaces.
base: Shuriken.Base

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
    currentNS[name] = makeNS(name, currentNS, @baseNS) if not currentNS[name]?
    currentNS: currentNS[name]
  hadSetup: $.isFunction currentNS.setup
  scopedClosure closure, currentNS
  currentNS.setupVia currentNS.setup if not hadSetup and $.isFunction currentNS.setup
  currentNS

base.withBase: (closure) ->
  scopedClosure closure, @baseNS

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

# Used as a part of the prototype chain.
Shuriken.Namespace: ->  
Shuriken.Namespace.prototype = Shuriken.Base;

makeNS: (name, parent, sharedPrototype) ->
   sharedPrototype?= new Shuriken.Namespace()
   namespace: ->
     @name:     name
     @parent:   parent
     @baseNS:   sharedPrototype
     @children: []
     parent.hasChildNamespace(@) if parent?
     @
    namespace.prototype: sharedPrototype
    new namespace name, parent
    
Shuriken.eachNS: (closure) ->
  scopedClosure closure, namespace for namespace in Shuriken.namespaces

Shuriken.as: (name) ->
  ns: makeNS name
  Shuriken.namespaces[name]: ns
  ns

@['Shuriken'] = Shuriken
