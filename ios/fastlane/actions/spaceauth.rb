module Fastlane
  module Actions
    module SharedValues
      SPACEAUTH_COOKIE = :SPACEAUTH_COOKIE
    end

    class SpaceauthAction < Action
      def self.run(params)
        is_ci = params[:is_ci]
        cmd = "bundle exec fastlane spaceauth"

        if is_ci then
            cmd = "fastlane spaceauth"
        end

        result, status = Open3.capture2e(cmd)

        return unless result

        puts result
        cookie_export_cmd = result.split("Example:")[1].strip!
        puts cookie_export_cmd
        cookie = cookie_export_cmd.split("export FASTLANE_SESSION=")[1]
        puts cookie

        Actions.lane_context[SharedValues::SPACEAUTH_COOKIE] = cookie
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "This action provides a shared value that is the cookie parsed form the output of $ fastlane spaceauth, to be set as the FASTLANE_SESSION environment variable."
      end

      def self.available_options
        # Define all options your action supports. 
        [
            FastlaneCore::ConfigItem.new(key: :is_ci,
                description: "Flag that indicates whether action is being run in a CI environement",
                default_value: false,
                type: Boolean),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        [
          ['SPACEAUTH_COOKIE', 'The cookie parsed form the output of $ fastlane spaceauth, to be set as the FASTLANE_SESSION environment variable.']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["mjinkens1"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
