require "spec_helper"

describe DateAgoHelper do
  describe "#date_ago_in_words", type: :helper do
    it "returns today for current date" do
      expect(helper.date_ago_in_words(Date.today)).to eq("today")
    end

    it "returns today for 5 hours ago" do
      Timecop.travel(2014, 01, 01, 10, 0, 0)
      expect(helper.date_ago_in_words(5.hours.ago)).to eq("today")
      Timecop.return
    end

    it "returns the time_ago's value for other dates" do
      expect(helper.date_ago_in_words(2.days.ago)).to eq("2 days ago")
    end
  end
end
