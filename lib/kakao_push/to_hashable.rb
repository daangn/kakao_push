module KakaoPush
  module ToHashable
    def to_hash
      Hash[
        instance_variables.map { |var_name|
          [var_name.to_s.gsub('@',''), instance_variable_get(var_name)]
        }.select {|el| el.last }
      ]
    end
  end
end
