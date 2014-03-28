namespace :import do
  desc 'Adds example subjects'
  task :subjects, [:path] => :environment do |t, args|
    args.with_defaults(path: Rails.root.join('data/subjects.csv.example'))
    importer = SubjectImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end

  desc 'Adds example questions'
  task :questions, [:path] => :environment do |t, args|
    args.with_defaults(path: Rails.root.join('data/questions.csv.example'))
    importer = QuestionImporter.import_file(args[:path])
    importer.errors.each { |e| Kernel.puts(e) } unless importer.valid?
  end
end
