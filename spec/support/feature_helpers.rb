module FeatureHelpers

  def login_user(user)

    visit root_path

    if current_path != root_path
      page.execute_script("localStorage.clear()")
      visit root_path
    end

    expect(find("h1")).to have_content("ログイン")

    find("#user_email").set user.email
    find("#user_password").set "password"
    find("#new_user input[type=submit]").click
    until current_path == tasks_path; end
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
      sleep(0.5)
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

end

module CapybaraExt
  def visit(url)
    url = "http://#{ENV["CLIENT_HOST"]}" + url if ENV["CLIENT_HOST"].present?
    super(url)
  end
end

module Capybara
  class Session
    prepend CapybaraExt
  end
end
