require "spec_helper"

feature "Load and dispaly IT workers", js: true do
  scenario "Load related data for II workers `M_InfoTech_35_44` and display it" do
    When "data is downloaded"
    Then "downloaded data can be confirmed"
    When "data is imported into the database"
    Then "database data can be confirmed"

    When "the user looks at location -37.783,144.996" do
      visit "/?latitude=-37.783153116511784&longitude=144.996479117923"
    end

    Then "the correct M_InfoTech35_44 stat is displayed" do
      expect(
        page.all("[data-testid=\"region-36\"] div").map(&:text),
      ).to eq(%w[M_InfoTech_35_44 82634])
      expect(
        page.all("[data-testid=\"region-21245:2111120\"] div").map(&:text),
      ).to eq(%w[M_InfoTech_35_44 3])
    end
  end
end
