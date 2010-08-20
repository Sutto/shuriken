Shuriken.defineExtension (baseNS) ->
  baseNS.withNS 'Mixins', (ns) ->
  
    root =        @getRootNS()
    ns.mixins =   {}
    root.mixins = {}

    root.withBase (base) ->
      base.mixin = (mixins) -> ns.mixin @, mixins

    defineMixin = (key, mixin) ->
      @mixins[key] = mixin

    root.defineMixin = defineMixin
    ns.define =        defineMixin

    ns.lookupMixin = (mixin) ->
      switch typeof mixin
        when "string"
          if ns.mixins[mixin]?
            ns.mixins[mixin]
          else if root.mixins[mixin]?
            root.mixins[mixin]
          else
            {} # unknown mixin, return a blank object.
        else
          mixin

    ns.invokeMixin = (scope, mixin) ->
      switch typeof mixin
        when "string"
          ns.invokeMixin scope, ns.lookupMixin(mixin)
        when "function"
          mixin.call scope, scope
        when "object"
          $.extend scope, mixin

    ns.mixin = (scope, mixins) ->
      mixins = [mixins] unless $.isArray mixins
      ns.invokeMixin scope, ns.lookupMixin(mixin) for mixin in mixins
      true