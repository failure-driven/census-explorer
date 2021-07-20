require "downloading_browser"

namespace :census_data do
  namespace :fetch do
    @download_path = File.expand_path(File.join(__dir__, "..", "..", "data"))

    desc "fetch DataPacks"
    task :data_packs do
      downloading_browser = DownloadingBrowser.new(@download_path)
      browser = downloading_browser.browser

      datapacks_url = "https://datapacks.censusdata.abs.gov.au/datapacks/"
      browser.visit datapacks_url

      browser
        .find("div.label", text: "Select Geography")
        .find(:xpath, "..")
        .find("select")
        .select("Statistical Area 4")

      exit 0 if /2016_GCP_SA4_for_Vic.*OK/.match?(`pushd data && md5sum --check files.md5`)

      browser
        .all("table#DataPacksDownloadTable span", wait: false)
        .filter { |span| span["title"].include?(".zip") }
        .find { |span| span["title"] =~ /VIC/i }
        .click

      sleep(5) # takes some time to find above, wait: false not working?
      downloading_browser.wait_till_downloaded
    end

    desc "fetch ASGS shape files"
    task :asgs_shape_files do
      downloading_browser = DownloadingBrowser.new(@download_path)
      browser = downloading_browser.browser

      [
        "https://www.abs.gov.au/ausstats/abs@.nsf/mf/1270.0.55.001",
        "https://www.abs.gov.au/ausstats/abs@.nsf/mf/1270.0.55.002",
        "https://www.abs.gov.au/ausstats/abs@.nsf/mf/1270.0.55.003",
        # last 003 release with
        "https://www.abs.gov.au/AUSSTATS/abs@.nsf/allprimarymainfeatures/68D3ABB051DCC591CA25816B00136D9F?opendocument",
        "https://www.abs.gov.au/ausstats/abs@.nsf/mf/1270.0.55.004",
        "https://www.abs.gov.au/ausstats/abs@.nsf/mf/1270.0.55.005",
        "https://www.abs.gov.au/ausstats/abs@.nsf/mf/1270.0.55.006",
        "https://www.abs.gov.au/ausstats/abs@.nsf/mf/1270.0.55.007",
      ].each do |url|
        browser.visit url
        browser
          .find_all("table")
          .find { |table| table.text =~ /Downloads/mi }
          .find("a", text: "Downloads")
          .click

        browser
          .find_all("table tr")
          .filter { |row| row.text =~ /ESRI/mi && row.all("table", wait: false).empty? }
          .each do |esri_row|
            esri_row.find("a").click
          end

        downloading_browser.wait_till_downloaded
      end
    end
  end
end
