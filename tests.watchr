def compile!
  system "rake test"
end

watch('coffeescripts/(.*)\.coffee') { compile! }
watch('tests/(.*)\.coffee')         { compile! }