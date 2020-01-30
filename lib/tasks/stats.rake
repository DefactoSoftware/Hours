namespace "stats" do
  desc "Shows an overview of the existing accounts"
  task :accounts do
    puts "      Account       |    Users    |    Entries    | Last Entry"
    puts "----------------------------------------------------------------------------"
    Account.all.map(&:subdomain).each do |account|
      Apartment::Tenant.switch!(account)
      puts format("%-18s  | %5s users | %5s entries | %s", account, User.count, Entry.count, (if Entry.any?
                                                                                                Entry.last.created_at
                                                                                              end))
    end
  end
end
