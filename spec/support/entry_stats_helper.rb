require "spec_helper"

def entry_with_hours_project(hours, project)
  create(:entry, hours: hours, project: project)
end

def entry_with_hours_user(hours, user)
  create(:entry, hours: hours, user: user)
end

def entry_with_hours(hours)
  create(:entry, hours: hours)
end

def entry_with_hours_tag(hours, tag)
  create(:entry, hours: hours).tags << tag
end

def entry_with_hours_project_tag(hours, project, tag)
  create(:entry, hours: hours, project: project).tags << tag
end

def entry_with_hours_project_user(hours, project, user)
  create(:entry, hours: hours, user: user, project: project)
end

def entry_with_hours_project_category(hours, project, category)
  create(:entry, hours: hours, project: project, category: category)
end

def entry_with_hours_project_tag_user(hours, project, tag, user)
  create(:entry, hours: hours, project: project, user: user).tags << tag
end
