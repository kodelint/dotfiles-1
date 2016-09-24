if defined?(PryByebug)
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'c', 'continue'
end

if defined?(PryStackExplorer)
  Pry.commands.alias_command 'bt', 'show-stack'
end

Pry.prompt = [
  proc { |target_self, nest_level, pry|
        "[#{pry.input_array.size}]\001\e[0;32m\002#{Pry.config.prompt_name}\001\e[0m\002(\001\e[0;33m\002#{Pry.view_clip(target_self)}\001\e[0m\002)#{":#{nest_level}" unless nest_level.zero?}> "
       },
  proc { |target_self, nest_level, pry|
        "[#{pry.input_array.size}]\001\e[1;32m\002#{Pry.config.prompt_name}\001\e[0m\002(\001\e[1;33m\002#{Pry.view_clip(target_self)}\001\e[0m\002)#{":#{nest_level}" unless nest_level.zero?}* "
       }
  ]
