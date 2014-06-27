require "spec_helper"

describe TimeSeries do
  describe '#serialize' do
    it "returns the sum of hours for each day" do
      Timecop.freeze(DateTime.new(2014, 1, 4))
      user = create(:user)
      create(:entry, hours: 6, date: DateTime.new(2014, 1, 1), user: user)
      create(:entry, hours: 2, date: DateTime.new(2014, 1, 1), user: user)
      create(:entry, hours: 5, date: DateTime.new(2014, 1, 3), user: user)

      time_series = TimeSeries.new(entries: user.entries, time_span: ((Date.new(2014, 1, 1))..Date.today))
      expect(time_series.serialize).to eq({
        labels: [
          '01/01',
          '02/01',
          '03/01',
          '04/01'
        ],

        datasets: [{
          data: [8, 0, 5, 0],
          fillColor: '#bbbbbb'
        }]
      })
    end
  end
end
