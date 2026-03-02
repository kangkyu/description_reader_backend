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
end
