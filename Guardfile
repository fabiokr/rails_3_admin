require 'guard/guard'

module ::Guard
  class TestsGuard < ::Guard::Guard
    def run_all
      UI.info "Running all tests", :reset => true
      system(test_all_command)
      true
    end

    def run_on_change(paths)
      UI.info "Running: #{paths.join(' ')}", :reset => true
      paths.each { |path| system(test_command(path)) if File.file?(path) }
      true
    end

    private

    def test_command(path)
      "bundle exec ruby -Itest -Ispec #{path}"
    end

    def test_all_command
      'bundle exec rake test'
    end
  end
end

group 'backend' do
  guard 'TestsGuard' do
    watch(%r{^test/.+_test\.rb})
    watch(%r{^app/controllers/(.+)\.rb}){|m| "test/functional/#{m[1]}_test.rb" }
    watch(%r{^lib/(.+)\.rb})            {|m| "test/unit/lib/#{m[1]}_test.rb" }
    watch(%r{^app/models/(.+)\.rb})     {|m| "test/unit/#{m[1]}_test.rb" }
    watch(%r{^app/helpers/(.+)\.rb})    {|m| "test/unit/helpers/#{m[1]}_test.rb" }
  end
end
