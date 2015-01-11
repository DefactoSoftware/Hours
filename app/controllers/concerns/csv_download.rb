module CSVDownload
  def send_csv(name:, entries:)
    send_data(
      EntryCSVGenerator.generate(entries),
      filename: "#{name}-entries-#{DateTime.now}.csv",
      type: "text/csv"
    )
  end
end
