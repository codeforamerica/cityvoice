namespace :import do
  desc 'Adds example locations'
  task :locations, [:path] => :environment do |t, args|
    args.with_defaults(path: Rails.root.join('data/locations.csv'))
    importer = LocationImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Adds example questions'
  task :questions, [:path] => :environment do |t, args|
    args.with_defaults(path: Rails.root.join('data/questions.csv'))
    importer = QuestionImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end
end
