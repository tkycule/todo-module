RSpec::Matchers.define :have_task_count do |inbox_count, completed_count, deleted_count|

  match do |page|
    expect(page).to have_css("#sidebar .inbox-count", text: inbox_count)
    expect(page).to have_css("#sidebar .completed-count", text: completed_count)
    expect(page).to have_css("#sidebar .deleted-count", text: deleted_count)
  end

  failure_message do |page|
    "expected to #{get_counts(page)}"
  end
  
  description do |page|
    "have #{get_counts(page)}"
  end

  private 

  def get_counts(page)
    %w(inbox-count completed-count deleted-count).map do |value|
      page.find("#sidebar .#{value}").text.to_i
    end
  end


end
