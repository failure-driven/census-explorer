require "capybara/rspec"
require "capybara-inline-screenshot/rspec"
require "selenium-webdriver"
require "webdrivers"

# Make browser slow down execution to see what's going on
# in the browser (when running non-Headless)
module SlomoBridge
  TIMEOUT = ENV.fetch("SLOMO_MS", "0").to_i / 1000.0

  def execute(*)
    sleep TIMEOUT if TIMEOUT > 0
    super
  end
end

# Don't wait too long in `have_xyz` matchers
Capybara.default_max_wait_time = 2 # the default is 2

Capybara.register_driver :selenium_chrome do |app|
  # increase default http timeout to prevent timeouts in CI
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = 120
  client.read_timeout = 120

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument "--window-size=1024,768"
  options.add_argument "--headless" if ENV.fetch("HEADLESS", "false") == "true"
  options.add_argument "--ssl-key-log-file=tmp/chrome.sslkeylog"
  options.add_argument "--disable-quic"

  download_save_path = File.join(__dir__, "tmp")
  options.add_preference("download.default_directory", download_save_path)
  options.add_preference(
    :download,
    directory_upgrade: true,
    prompt_for_download: false,
    default_directory: download_save_path,
  )

  Capybara::Selenium::Driver.new(
    app,
    http_client: client,
    browser: :chrome,
    clear_local_storage: true,
    clear_session_storage: true,
    options: options,
  ).tap do |driver|
    # Enable slomo mode
    driver.browser.send(:bridge).singleton_class.prepend(SlomoBridge)
  end
end

Capybara.javascript_driver = :selenium_chrome unless ENV.fetch("NOT_CHROME", false)
Capybara.configure do |config|
  config.save_path = File.join("..", "..", "tmp")
end

Capybara.app = Sinatra::Application

Capybara::Screenshot.webkit_options = {
  width: 1024,
  height: 768,
}

Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.register_driver(:selenium_chrome) do |driver, path|
  needed_height = Capybara.current_session.evaluate_script("document.documentElement.scrollHeight")
  current_width = driver.browser.manage.window.size[0]
  driver.browser.manage.window.resize_to(current_width, needed_height)

  driver.browser.save_screenshot(path)
end

Capybara::Screenshot.prune_strategy = :keep_last_run
