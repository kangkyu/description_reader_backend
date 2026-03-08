namespace :channels do
  desc "Fetch channel UUID from YouTube for all videos missing one"
  task backfill: :environment do
    videos = Video.where(channel_id: nil).where.not(youtube_id: nil)
    puts "Found #{videos.count} video(s) without a channel"

    videos.find_each do |video|
      print "#{video.youtube_id}... "
      FetchChannelJob.perform_now(video.id)
      video.reload
      if video.channel
        puts video.channel.uuid
      else
        puts "no channel found"
      end
    end
  end

  desc "Backfill title and handle from YouTube for channels missing them"
  task backfill_details: :environment do
    channels = Channel.where(title: nil).or(Channel.where(handle: nil))
    puts "Found #{channels.count} channel(s) missing title or handle"

    channels.find_each do |channel|
      print "#{channel.uuid}... "
      yt_channel = Yt::Channel.new(id: channel.uuid)
      channel.title ||= yt_channel.title
      channel.handle ||= yt_channel.username
      channel.save!
      puts "#{channel.title} (@#{channel.handle})"
    rescue Yt::Errors::NoItems, Yt::Errors::RequestError => e
      puts "failed: #{e.message}"
    end
  end
end
