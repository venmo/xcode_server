require 'xcode_server/server/networking'
require 'SecureRandom'

module XcodeServer
  class Server
    include Networking

    attr_reader :scheme
    attr_reader :host

    def initialize(host, scheme = 'https')
      @host = host
      @scheme = scheme
    end

    def bots
      get_json('bots')['results'].map { |result| Bot.new(self, result) }
    end

    def destroy_bot(id, rev = nil)
      rev ||= get_json("bots/#{id}")['_rev']
      delete("bots/#{id}/#{rev}").code.to_i == 204
    end

    def create_bot(performs_test_action: true,
                   performs_archive_action: false,
                   performs_analyze_action: true,
                   scheme_name: nil,
                   branch_name: "master",
                   repo_identifier: nil,
                   working_copy_path: nil,
                   project_path: nil,
                   project_url: nil)
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
          scheduleType: 2, # "On Commit" schedule
          performs_archive_action: performs_archive_action,
          testingDestinationType: 0 # "iOS All Devices and All Simulators"
        },
        requiresUpgrade: false, # Mystery meat
        name: "#{working_copy_path} - #{scheme_name} @ #{branch_name}",
        type: 1 # Mystery meat
      )

      Bot.new(self, JSON.load(res.body))
    end
  end
end
