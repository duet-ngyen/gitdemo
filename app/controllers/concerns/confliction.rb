module Confliction
  def recoginze_conflict document, result, conflict
    document.split("\n").each do |line|
      match_line = /(.*){(.*)}(.*)/.match(line)
      if match_line
        result.concat(match_line[1]).concat("\n")
        line_change = /\"(.*)\" >> \"(.*)\"/.match(match_line[2])
        line_add = /[\+]\"(.*)\"/.match(match_line[2])
        line_remove = /[\-]\"(.*)\"/.match(match_line[2])
        if line_change
          result.concat("<<<<< HEAD \n").concat(line_change[1]).concat("\n =====\n").concat(line_change[2]).concat("\n >>>>> your change\n")
          conflict = true
        elsif line_add
          @result.concat(line_add[1])
        elsif line_remove
          @result.concat(line_remove[1])
        end
        # @result.concat(match_line[2]).concat("\n")
        result.concat(match_line[3])
      else
        result.concat(line)
      end
    end
    conflict
  end
end
