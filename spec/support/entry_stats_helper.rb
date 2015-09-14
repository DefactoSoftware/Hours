def entry_with_hours_project(hours, project)
  create(:hour, value: hours, project: project)
end

def entry_with_hours_user(hours, user)
  create(:hour, value: hours, user: user)
end

def entry_with_hours(hours)
  create(:hour, value: hours)
end

def entry_with_hours_tag(hours, tag)
  create(:hour, value: hours).tags << tag
end

def entry_with_hours_project_tag(hours, project, tag)
  create(:hour, value: hours, project: project).tags << tag
end

def entry_with_hours_project_user(hours, project, user)
  create(:hour, value: hours, user: user, project: project)
end

def entry_with_hours_project_category(hours, project, category)
  create(:hour, value: hours, project: project, category: category)
end

def entry_with_hours_project_tag_user(hours, project, tag, user)
  create(:hour, value: hours, project: project, user: user).tags << tag
end
