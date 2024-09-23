require_relative 'Logging.rb'

module Common
    def self.get_version(str, delimiter='.')
        versionSplit = str.split(delimiter)
        versionObj = {
        "major" => versionSplit[0],
        "minor" => versionSplit[1],
        "bug" => versionSplit[2]
        }

        return versionObj
    end
end