require_dependency 'projects_helper'

module ProjectsHelperPatch

  def self.included(base)
    base.class_eval do

      # Renders the projects index
      def render_project_hierarchy(projects)
        res = stylesheet_link_tag 'projects_list_extra_fields', :plugin => 'kultig'
        res << render_project_nested_lists(projects) do |project|
          s = link_to_project(project, {}, :class => "#{project.css_classes} #{User.current.member_of?(project) ? 'my-project' : nil}")

          extra_fields = project.custom_values.map do |cv|
            next if cv.value.blank?
            content = ''
            content << content_tag('span', cv.custom_field.name, :class => 'field-title')
            content << ': '
            content << content_tag('span', cv.value, :class => 'field-value')
          end.compact.join ' | '
          s << content_tag('span', extra_fields.html_safe, :class => 'extra-fields')

          if project.description.present?
            s << content_tag('div', textilizable(project.short_description, :project => project), :class => 'wiki description')
          end

          s
        end
      end

    end
  end

end

ProjectsHelper.send(:include, ProjectsHelperPatch)
