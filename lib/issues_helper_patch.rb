module IssuesHelperPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
    end
  end

  module InstanceMethods
    def render_custom_relations_rows(issue)

      fields = issue.project.custom_relations_fields
      return if fields.empty?
      values = Hash[issue.custom_relations_values.map{|v| [v.custom_relations_field.id, v.related_issue]}]
      ordered_fields = []
      half = (fields.size / 2.0).ceil
      half.times do |i|
        ordered_fields << fields[i]
        ordered_fields << fields[i + half]
      end
      #s = "issues helper patch <br />\n"
      s = "<tr>\n"
      n = 0
      ordered_fields.compact.each do |field|
        s << "</tr>\n<tr>\n" if n > 0 && (n % 2) == 0
        related_issue = values[field.id] ? values[field.id] : nil

        # related_issue = nil # toggle_link l(:button_add), 'new-custom_relation-form', {:focus => 'relation_issue_to_id'}
        # link_to(t(:button_add), "javascript:;", :class => 'icon icon-add')
        #
        s << "\t<th>#{ h(field.name) }:</th><td>"
        s << render(:partial => 'issues/custom_related_issue', :locals => {:related_issue => related_issue, :custom_relations_field => field, :issue => issue})
        s << "</td>\n"
        #{ simple_format_without_paragraph(h(show_value(field))) }
        n += 1
      end
      s << "</tr>\n"
      s.html_safe
    end
  end
end

IssuesHelper.send(:include, IssuesHelperPatch)
