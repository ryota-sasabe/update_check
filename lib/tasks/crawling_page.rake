require 'faraday'
require 'faraday-encoding'
require 'faraday_middleware'

namespace :crawling_page do
  desc 'crawling page'

  task :run, ['site'] => :environment do |task, args|
    if args[:site].nil?
      puts "引数で site_id を指定してください。例: crawling_page:run[1]"
      exit
    end

    start_datetime = Time.zone.now
    site_id = args[:site].to_i

    CheckPage.where(site_id: site_id, enabled: 1).each do |page|
      begin
        result = http_get(page.url)
      rescue => e
        puts "URL取得エラー #{page.url} #{e.message}"
        next
      end
      body = page.apply_regexp_pattern(:delete_patterns, result.body.force_encoding('utf-8'))

      if page.duplicate_latest_revision?(body)
        puts "重複・リビジョン作成 #{page.url}"
      else
        puts "リビジョン作成 #{page.url}"
      end

      page.check_page_results.create!(
        status: result.status,
        body: body,
        length: result.body.length,
        checked_at: start_datetime,
      )
    end
  end

  task clear: :environment do |task|
    tables = %w[
      check_page_results
    ]
    ActiveRecord::Base.connection.execute("set foreign_key_checks = 0;")
    tables.each do |table|
      ActiveRecord::Base.connection.execute("truncate table #{table};")
    end
  end
end

def http_get(url, queries = nil)
  uri = URI(url)
  uri.query = queries.to_param

    conn = Faraday.new(uri.to_s) do |builder|
      builder.use FaradayMiddleware::FollowRedirects
      builder.adapter :net_http
      builder.options[:timeout] = 20
      builder.response :raise_error
    end
    conn.get
end
