require "sinatra"
require "sinatra/reloader" if development?

set :root, File.dirname(__FILE__)

get "/" do
  @data = {
    aus_code_2016: { # rubocop:disable Naming/VariableNumber
      geography: "AUS_CODE_2016",
      region_id: 36,
      statistic: "M_InfoTech_35_44",
      value: 82_634,
    },
    sa1_7digitcode_2016: { # rubocop:disable Naming/VariableNumber
      geography: "SA1_7DIGITCODE_2016",
      region_id: "21245:2111120",
      statistic: "M_InfoTech_35_44",
      value: 3,
    },
  }
  erb :index
end
