configure :production, :development do
  db = URI.parse('postgres://localhost/kt_tips')
  ActiveRecord::Base.establish_connection(
                        :adapter => db.scheme == 'postgres' ? 'postgresql' :db.scheme,
                        :host => 'localhost',
                        :username => 'david',
                        :password => 'da1vdN1n08arca2011',
                        :database => "kt_tips",
                        :encoding => 'utf8'
  )
end