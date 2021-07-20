require "capybara"
require "selenium-webdriver"
require "webdrivers"

class DownloadingBrowser
  def initialize(download_save_path)
    @download_save_path = download_save_path
  end

  def browser
    Capybara.register_driver :selenium do |app|
      options = Selenium::WebDriver::Chrome::Options.new

      # download.default_directory seems to work better than :download, default_directory: ...
      options.add_preference("download.default_directory", @download_save_path)
      options.add_preference(
        :download,
        directory_upgrade: true,
        prompt_for_download: false,
        default_directory: @download_save_path,
      )

      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        options: options,
      )
    end

    Capybara.javascript_driver = :chrome
    Capybara.configure do |config|
      config.default_max_wait_time = 10 # seconds
      config.default_driver = :selenium
    end

    Capybara.current_session
  end

  def wait_till_downloaded
    Timeout.timeout(3600) do # wait up to 1 hour for downloads to complete
      sleep 1 until Dir[File.join(@download_save_path, "*.*")].count { |f| f =~ /\.crdownload$/ }.zero?
    end
  rescue Timeout::Error
    raise "Could not find a newly completed download after waiting for #{timeout} seconds"
  end
end
