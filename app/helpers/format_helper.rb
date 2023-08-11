module FormatHelper

    def format_numeric(obj, field)
        return nil if obj.errors[field].count.positive? || obj.send(field).blank?
    
        obj.send(field).to_i == obj.send(field) ? obj.send(field).to_i : sprintf("%.2f", obj.send(field))
    end

end
