Redmine::Plugin.register :redhub_sync do
  name 'Redhub Sync plugin'
  author 'Mohamad Sulaiman'
  description 'This is a plugin for Redmine to sync with Github'
  version '0.0.1'
  # url 'http://example.com/path/to/plugin'
  author_url 'https://www.medo98.com'
  requires_redmine version_or_higher: '5.0.0'
end
