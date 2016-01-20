module Confliction
  def recoginze_conflict document, description
    result = ""
    conflict = false
    description.split("\n").each do |line|
      match_line = /(.*){(.*)}(.*)/.match(line)
      binding.pry
      if match_line
        result.concat(match_line[1]).concat("\n")
        line_change = /\"(.*)\" >> \"(.*)\"/.match(match_line[2])
        line_add = /[\+]\"(.*)\"/.match(match_line[2])
        line_remove = /[\-]\"(.*)\"/.match(match_line[2])
        if line_change
          result.concat("<<<<< HEAD \n").concat(line_change[1]).concat("\n =====\n").concat(line_change[2]).concat("\n >>>>> your change\n")
          conflict = true
        elsif line_add
          result.concat(line_add[1])
        elsif line_remove
          result.concat(line_remove[1])
        end
        result.concat(match_line[3])
      else
        result.concat(line)
      end
    end

    if conflict == true
      description = result
      result = result.gsub("\\r","\r").gsub("\\n","\n")
      document.update_attributes(lastest_revision: document.revisions.last.version_id)
      flash[:warning] = "Conflicted"
      render :edit
    else
      result = result.gsub("\\r","\r").gsub("\\n","")
      document.update_attributes(description: result)
      version_id = document.revisions.last.version_id
      new_version_id = version_id + 1
      create_revision(revision_params, new_version_id, params[:id])
      document.update_attributes(lastest_revision: Revision.last.version_id)
      redirect_to document
      flash[:warning] = "Auto merged"
    end
  end
end
