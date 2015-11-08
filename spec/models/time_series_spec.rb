describe TimeSeries do
  let(:user) { create(:user) }

  before(:each) do
    Timecop.freeze(DateTime.new(2014, 1, 4))
    create(:hour, value: 6, date: DateTime.new(2014, 1, 1), user: user)
    create(:hour, value: 2, date: DateTime.new(2014, 1, 1), user: user)
    create(:hour, value: 5, date: DateTime.new(2014, 1, 3), user: user)
    create(:hour, value: 5, date: DateTime.new(2013, 11, 3), user: user)
    create(:hour, value: 5, date: DateTime.new(2013, 12, 13), user: user)
  end

  let(:weekly_time_series) { TimeSeries.weekly(user) }
  let(:monthly_time_series) { TimeSeries.monthly(user) }
  let(:yearly_time_series) { TimeSeries.yearly(user) }

  describe '#serialize' do
    it "returns the sum of hours for each day" do
      expect(weekly_time_series.serialize).to eq({
        labels: [
          '29/12',
          '30/12',
          '31/12',
          '01/01',
          '02/01',
          '03/01',
          '04/01',
        ],

        datasets: [{
          data: [0, 0, 0, 8, 0, 5, 0]
        }]
      })
    end

    it "returns the sum of hours for each week" do
      expect(yearly_time_series.serialize).to eq({
        labels: [
          "01", "02", "03", "04", "05", "06",
          "07", "08", "09", "10", "11", "12",
          "13", "14", "15", "16", "17", "18",
          "19", "20", "21", "22", "23", "24",
          "25", "26", "27", "28", "29", "30",
          "31", "32", "33", "34", "35", "36",
          "37", "38", "39", "40", "41", "42",
          "43", "44", "45", "46", "47", "48",
          "49", "50", "51", "52", "01"
        ],

        datasets: [{
          data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 5, 0, 0, 0, 0, 5,
                 0, 0, 13]
        }]
      })
    end
  end

  describe "#days" do
    it "returns the number of days in the monthly series" do
      expect(monthly_time_series.days).to eq(30)
    end

    it "returns the number of days in the weekly series" do
      expect(weekly_time_series.days).to eq(7)
    end

    it "returns the number of days in the yearly series" do
      expect(yearly_time_series.days).to eq(365)
    end
  end

  describe "#chart" do
    it "returns a line_chart for yearly_time_series" do
      expect(yearly_time_series.chart).to eq("/charts/line_chart")
    end

    it "returns a bar_chart for weekly_time_series" do
      expect(weekly_time_series.chart).to eq("/charts/bar_chart")
    end

    it "returns a bar_chart for monthly_time_series" do
      expect(monthly_time_series.chart).to eq("/charts/bar_chart")
    end
  end
end
