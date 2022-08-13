# Gemfile
source_paths.unshift(File.dirname(__FILE__))
template "Gemfile.tt", 'Gemfile', force: true

# Annotate gems in Gemfile an installing gems via bundle
run 'gem install annotate_gem'
run 'annotate-gem --new-comments-only'
run 'bundle install'

# Initial generation for gems
generate 'simple_form:install'
generate 'rspec:install'
generate 'devise:install'

if yes? 'Init devise user?(yes/no)'
  # generate(:scaffold, 'user', 'first_name:string', 'last_name:string', 'email:string', 'role:integer')
  generate 'devise user', 'first_name:string', 'last_name:string', 'email:string', 'role:integer'
  copy_file './spec/factories/users.rb', force: true
end

if yes? 'Do you wish to generate a root controller? (y/n)'
  name = ask('What do you want to call it? [dashboard]').to_s.underscore
  name = 'dashboard' if name.blank?
  generate :controller, "#{name} index"
  route "root to: '#{name}\#index'"
  route "resource :#{name}, controller: :#{name}, only: :index"
end

if yes? 'Do you wanna init ServiceObject? (yes/no)'
  # Add BaseService
  file 'app/services/base_service.rb', <<-CODE
  class BaseService
    class << self
      def call(*args)
        new(*args).call
      end
    end
  end
  CODE
end

#
# after_bundle do
#   git :init
#   git add: "."
#   git commit: %Q{ -m 'Initial commit' }
# end
