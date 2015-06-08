require 'xcode_server/server/networking'
require 'net/http'
require 'SecureRandom'

module XcodeServer
  class Server
    include Networking

    module TestingSchedule
      module Type
        PERIODIC = 1
        ON_COMMIT = 2
        MANUAL = 3
      end

      module Period
        HOURLY = 1
        DAILY = 2
        WEEKLY = 3
      end
    end

    attr_reader :scheme
    attr_reader :host

    ##
    # Initialize a new Xcode Server.
    # @param host [String] The host of the server.
    # @param scheme [String] The scheme to connect on. Default is `https`.
    # @param verify_mode SSL verify mode. Default is `OpenSSL::SSL::VERIFY_PEER`. If you are using a self-signed cert, use `OpenSSL::SSL::VERIFY_NONE`
    def initialize(host, scheme: 'https', verify_mode: OpenSSL::SSL::VERIFY_PEER)
      @host = host
      @scheme = scheme.downcase
      @verify_mode = verify_mode
    end

    ##
    # Retrieve a list of all bots on the server
    def bots
      get_json('bots')['results'].map { |result| Bot.new(self, result) }
    end

    ##
    # Delete an existing bot based on the bot id
    # @param id [String] The bot's id as returned by Bot#id
    def destroy_bot(id, rev = nil)
      rev ||= get_json("bots/#{id}")['_rev']
      delete("bots/#{id}/#{rev}").code.to_i == 204
    end

    ##
    # Create a new bot on the server
    #
    # @param bot_name [String] The human name of the bot (e.g. "venmo/venmo-iphone#99 (feature/ci)")
    # @param branch_name [String] The name of the branch to integrate
    # @param performs_analyze_action [Boolean] Whether or not to analyze during integration
    # @param performs_archive_action [Boolean] Whether or not to archive during integration
    # @param performs_test_action [Boolean] Whether or not to test during integration
    # @param project_path [String] The path to the project or workspace within the working directory
    # @param repo_url [String] The git URL for a repo containing the project to integrate
    # @param scheme_name [String] The name of the Xcode scheme to integrate
    # @param testing_schedule [Integer] See TestingSchedule
    # @param working_copy_path [String] The name of the working copy directory, usually the name of the repo (e.g. venmo/venmo-iphone)
    def create_bot(bot_name:,
                   branch_name: "master",
                   performs_analyze_action: true,
                   performs_archive_action: false,
                   performs_test_action: true,
                   project_path:,
                   repo_url:,
                   scheme_name:,
                   testing_schedule: TestingSchedule::Type::ON_COMMIT,
                   working_copy_path:)
      repo_identifier = SecureRandom.uuid
      res = post('bots',
        group: {
          name: SecureRandom.uuid
        },
        configuration: {
          builtFromClean: 1, # Always
          periodicScheduleInterval: 0, # Run manually
          performs_test_action: performs_test_action,
          performs_analyze_action: performs_analyze_action,
          scheme_name: scheme_name,
          sourceControlBlueprint: {
            DVTSourceControlWorkspaceBlueprintLocationsKey: {
              repo_identifier => {
                DVTSourceControlBranchIdentifierKey: branch_name,
                DVTSourceControlBranchOptionsKey: 156, # Mystery meat
                DVTSourceControlWorkspaceBlueprintLocationTypeKey: "DVTSourceControlBranch" # "Pull a git branch"
              }
            },
            DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey: repo_identifier,
            DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey: {
              repo_identifier => {
                DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationTypeKey: "DVTSourceControlAuthenticationStrategy"
              }
            },
            DVTSourceControlWorkspaceBlueprintWorkingCopyStatesKey: {
              repo_identifier => 0
            },
            DVTSourceControlWorkspaceBlueprintIdentifierKey: repo_identifier,
            DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey: {
              repo_identifier => working_copy_path
            },
            DVTSourceControlWorkspaceBlueprintNameKey: project_path,
            DVTSourceControlWorkspaceBlueprintVersion: 203, # Mystery meat
            DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey: project_path,
            DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey: [{
              DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey: project_url,
              DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey: "com.apple.dt.Xcode.sourcecontrol.Git",
              DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey: repo_identifier
            }]
          },
          hourOfIntegration: 0,
          scheduleType: testing_schedule,
          performs_archive_action: performs_archive_action,
          testingDestinationType: 0 # "iOS All Devices and All Simulators"
        },
        requiresUpgrade: false, # Mystery meat
        name: bot_name,
        type: 1 # Mystery meat
      )

      Bot.new(self, JSON.load(res.body))
    end
  end
end
