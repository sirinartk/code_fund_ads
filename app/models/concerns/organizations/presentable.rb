module Organizations
  module Presentable
    def analytics_key
      [id, name].compact.join ": "
    end

    alias to_s analytics_key
  end
end
