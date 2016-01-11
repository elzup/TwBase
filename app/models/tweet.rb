# == Schema Information
#
# Table name: tweets
#
#  id           :integer          not null, primary key
#  tweet_id     :string
#  text         :string
#  user_id      :integer
#  lat          :float
#  long         :float
#  for_sq       :boolean
#  text_keyword :string
#  search_word  :string
#  tweeted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_tweets_on_search_word  (search_word)
#  index_tweets_on_tweeted_at   (tweeted_at)
#  index_tweets_on_user_id      (user_id)
#

class Tweet < ActiveRecord::Base
  belongs_to :user

  scope :geo, -> { where.not(lat: nil) }
  scope :forsq, -> { where(search_word: '4sq') }
  scope :going, -> { where(search_word: '行く') }
  scope :oldest, -> { order(:tweeted_at).first }

  def self.new_4sq(user, tw)
    Tweet.new(
        user_id: user.id,
        tweet_id: tw.id,
        text: tw.text,
        search_word: '4sq',
        tweeted_at: tw.created_at
    )
  end

  def self.new_geo(user, tw)
    Tweet.new(
        tweet_id: tw.id,
        user_id: user.id,
        text: tw.text,
        tweeted_at: tw.created_at,
        lat: tw.geo.lat,
        long: tw.geo.long
    )
  end

  def self.new_tw(user, tw, word)
    Tweet.new(
        user_id: user.id,
        tweet_id: tw.id,
        text: tw.text,
        search_word: word,
        tweeted_at: tw.created_at
    )
  end

  def self.day_count
    tweets = Tweet.order(:tweeted_at)
    start_time = tweets.first.tweeted_at
    last_time = tweets.last.tweeted_at
    (start_time.to_date..last_time.to_date).map do |date|
      count = tweets.where(tweeted_at: date.beginning_of_day..date.end_of_day).count
      [date, count]
    end.to_h
  end

  def self.hour_count(where={})
    tweets = Tweet.where(where).order(:tweeted_at)
    start_time = tweets.first.tweeted_at
    last_time = tweets.last.tweeted_at
    (start_time.to_date..last_time.to_date).map do |date|
      [date, (0...24).map do |h|
        tweets.where(tweeted_at: (date + h.hour)...(date + h.hour + 1.hour)).count
      end]
    end.to_h
  end

  def self.hour_count_geo
    hour_count('lat IS NOT NULL')
  end

  def self.hour_count_word(word)
    hour_count(search_word: word)
  end

  def self.data_terms_all
    tweets = Tweet.order(:tweeted_at)
    {
        'geo' => [tweets.geo.first, tweets.geo.last],
        '4sq' => [tweets.forsq.first, tweets.geo.last],
        'going' => [tweets.going.first, tweets.going.last]
    }
  end
end
