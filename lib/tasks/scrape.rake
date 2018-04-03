# NOTE: All commands need to be run in this format:
# rails 'scrape:scraper_name[:action, page_number, studio name]'
# For example: rails 'scrape:blacksonblondes[:download, 5, Blacks on Blondes]'
#
# Valid actions are: scrape, download, and populate

namespace :scrape do

  task :blacksonblondes, [:action, :page, :name] => [:environment] do |task, args|
    args.with_defaults(action: 'scrape', page: 1, name: 'Blacks on Blondes')

    studio = scrape_task_get_studio(args)
    scraper = Stash::Scraper::Dogfart.new(studio: studio, page: args[:page].to_i, action: args[:action])
    scrape_task_start_scrape(scraper, args)
  end

  task :pervmom, [:action, :page, :name] => [:environment] do |task, args|
    args.with_defaults(action: 'scrape', page: 1, name: 'PervMom')

    studio = scrape_task_get_studio(args)
    scraper = Stash::Scraper::Pervmom.new(studio: studio, page: args[:page].to_i, action: args[:action])
    scrape_task_start_scrape(scraper, args)
  end

  task :faketaxi, [:action, :page, :name] => [:environment] do |task, args|
    scrape_task_start(args, 'Fake Taxi', Stash::Scraper::Fakehub)
  end

  task :publicagent, [:action, :page, :name] => [:environment] do |task, args|
    scrape_task_start(args, 'Public Agent', Stash::Scraper::Fakehub)
  end

  def scrape_task_get_studio(args)
    studio = Studio.find_by(name: args[:name])
    raise "Invalid studio!" if studio.nil?
    studio
  end

  def scrape_task_start(args, default_studio_name, scraper_klass)
    args.with_defaults(action: 'scrape', page: 1, name: default_studio_name)
    studio = scrape_task_get_studio(args)
    scraper = scraper_klass.new(studio: studio, page: args[:page].to_i, action: args[:action])
    Stash::Manager.instance.scrape(job_id: 'rake', scraper: scraper)
  end
end