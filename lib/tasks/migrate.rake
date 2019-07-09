require "csv"
require "open-uri"

KW_MAP = {
  "ABAP" => nil,
  "Ada" => nil,
  "Alice" => nil,
  "Android Development" => "Android",
  "Apex" => nil,
  "Assembly language" => nil,
  "Awk" => nil,
  "Backend Services" => "Backend",
  "Bash" => nil,
  "Blockchain" => "Blockchain",
  "C" => "C",
  "C#" => "C#",
  "C++" => "C++",
  "COBOL" => nil,
  "CSS & Design" => "CSS & Design",
  "Computer Science" => nil,
  "D" => "D",
  "Dart" => "Dart",
  "Database" => "Database",
  "Delphi/Object Pascal" => nil,
  "Dev Ops" => "DevOps",
  "Docker" => "DevOps",
  "Erlang" => "Erlang",
  "F#" => "F#",
  "Fortran" => "Fortran",
  "Frontend Concepts" => "Frontend",
  "Frontend Frameworks & Tools" => "Frontend",
  "Frontend Workflow & Tooling" => "Frontend",
  "Game Development" => "Game Development",
  "Git" => nil,
  "Go" => "Go",
  "Groovy" => "Groovy",
  "HTML5" => nil,
  "Haskell" => "Haskell",
  "Hybrid & Mobile Web" => "Hybrid & Mobile Web",
  "IOS Development" => "iOS",
  "Java" => "Java",
  "JavaScript" => "JavaScript",
  "Julia" => "Julia",
  "LabVIEW" => nil,
  "Ladder Logic" => nil,
  "Languages & Frameworks" => nil,
  "Lisp" => nil,
  "Logo" => nil,
  "Lua" => nil,
  "MATLAB" => nil,
  "MQL4" => nil,
  "Objective-C" => "Objective-C",
  "Other" => "Other",
  "PHP" => "PHP",
  "PL/SQL" => "PL/SQL",
  "Perl" => nil,
  "Prolog" => nil,
  "Python" => "Python",
  "Q" => "Q",
  "R" => "R",
  "RPG (OS/400)" => nil,
  "React" => "React",
  "Resources" => "Developer Resources",
  "Ruby" => "Ruby",
  "Rust" => "Rust",
  "SAS" => nil,
  "Scala" => "Scala",
  "Scheme" => nil,
  "Scratch" => nil,
  "Shell" => nil,
  "Swift" => "Swift",
  "Transact-SQL" => nil,
  "VHDL" => nil,
  "Visual Basic" => nil,
  "Visual Basic .NET" => ".NET",
}

namespace :migrate do
  task keywords: :environment do
    Property.all.each do |property|
      keywords = property.keywords.map { |kw|
        KW_MAP[kw]
      }
      property.update(keywords: keywords.uniq.compact.sort)
    end

    Campaign.all.each do |campaign|
      keywords = campaign.keywords.map { |kw|
        KW_MAP[kw]
      }
      campaign.update(keywords: keywords.uniq.compact.sort)
    end

    puts "Done!"
  end

  task invoices: :environment do
    puts "This is a destructive method. Do you want to delete all existing invoices and payments? [y/N]"
    puts "This cannot be undone!"

    exit_early "No action taken" unless yes?

    InvoicePayment.destroy_all
    Invoice.destroy_all

    print "Importing invoices "
    url = ENV["MIGRATE_INVOICE_CSV_URL"]
    return unless url.present?
    csv_text = open(url)
    csv = CSV.parse(csv_text, headers: true, encoding: "ISO-8859-1:UTF-8")
    csv.each do |row|
      user = User.find(row["user_id"])
      unless user
        print "User not found (#{row["email"]})"
        next
      end

      (Date.new(2018, 6)..Date.new(2019, 6)).select { |d| d.day == 1 }.each do |date|
        paid_amount = Monetize.parse(row["#{date.strftime("%F")}_paid"])
        if paid_amount > 0
          invoice_payment = InvoicePayment.create!(
            user_id: user.id,
            payment_date: Date.coerce(date) + 1.month,
            amount: paid_amount,
            payment_method: "Imported",
            details: row["#{date.strftime("%F")}_notes"]
          )
        end

        invoice = user.invoices.for_date(date).first
        invoice ||= Invoice.new

        invoice.user_id = user.id
        invoice.invoice_date = Date.coerce(date)
        invoice.ad_revenue = Monetize.parse(row["#{date.strftime("%F")}_earned"])
        invoice.ad_spend = Monetize.parse(row["#{date.strftime("%F")}_ads"])
        invoice.bonus_direct = Monetize.parse(row["#{date.strftime("%F")}_bonus"])
        invoice.bonus_referral = Monetize.parse(row["#{date.strftime("%F")}_referral"])
        invoice.invoice_payment_id = invoice_payment&.id

        unless invoice.save
          puts "UH OH! #{invoice.errors.inspect}"
          break
        end
      end

      print "."
    end
    puts " Done!"
  end

  private

  def yes?
    !!(STDIN.gets.strip =~ /\Ay\z/i)
  end

  def exit_early(message)
    puts message
    exit 0
  end
end
