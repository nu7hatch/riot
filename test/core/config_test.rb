require 'teststrap'

context "A config" do
  helper(:config) { Riot.config }
  setup { Riot.config.mock_with = :test }
  should("allow to set mock framework") { config }.assigns(:mock_with)
  should("allow to set repoter") { config }.assigns(:reporter)
  should("allow to set allone option") { config }.assigns(:alone)
  should("allow to choose middleware dir") { config }.assigns(:middleware_dir)
  should("allow to choose macros dir") { config }.assigns(:macros_dir)
  teardown { Riot.config.mock_with = nil }
end
